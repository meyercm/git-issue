require_relative 'tag'
require_relative 'event'
require 'yaml'
module GitIssue
  class Issue
    attr_writer :tags, :events
    attr_reader :issue_id
    def initialize(issue_id)
      @issue_id = issue_id
    end

    def tags; @tags ||= {}; end
    def events; @events ||= [] end

    def title; tags[:title].value or ""; end
    def status; tags[:status].value or ""; end
    def creator; tags[:creator].value; end
    def created_at; tags[:created_at].value end
    def description; tags[:description].value or "" end


    def short_id; issue_id[0..7]; end
    def custom_tags
      res = tags.dup
      Issue.standard_tags.each do |f|
        res.delete(f)
      end
      res
    end

    def update(hash)
      GitWorker.work_on_issues_branch do
        hash.each do |k,v|
          if (self.tags[k] and self.tags[k].value == v) then
            hash.delete(k)
          end
        end
        Tag.create(self, hash)
      end
    end

    def delete
      GitWorker.work_on_issues_branch do |issues_folder|
        issue_folder = "#{issues_folder}/#{self.issue_id}"
        GitWorker.remove_folder(issue_folder)
        GitWorker.commit("deleted #{short_id}: #{title}")
      end
    end

    def as_table_row(formatter)
      case formatter
      when "withtags"
        ctags = custom_tags
        pad_status = status.ljust(6).capitalize
        tag_str = ctags.none? ? "" : "\n  Tags: #{ctags.map{|k,v| v.detail_string}.join("  ")}"
        "#{pad_status}  #{short_id}  #{title}#{tag_str}"
      when "oneline"
        short_status = "#{status[0..0]}".capitalize
        def_tag = tags[GitWorker.default_tag]
        kind = (def_tag.nil? ? "  " : def_tag.value)
        "#{short_status} #{short_id} #{kind}: #{title}"
      when "detail"
        detail_string
      end
    end


    def self.table_header(formatter)
      case formatter
      when "withtags"
"Status  ID        Title
-------------------------------------------------------------------------------"
#Open    deadbeef  The real problem with this app is that the cows are alive.
#    Tags: kind:bug  assigned_to:chris
#Closed  cafefeed  We need a way to get the devs to eat non-pizza food.
#    Tags: kind:feature  priority:low
#
      when "oneline"
"S ID       Title
-------------------------------------------------------------------------------"
      end
    end

    def self.all
      raw_issues = GitWorker.list_issues
      ids_from_list(raw_issues).map{|i| create_from_list(i, raw_issues)}
    end

    def self.find(partial_id)
      raw_issues = GitWorker.list_issues
      ids = ids_from_list(raw_issues)
      ids.delete_if{|i| !i.start_with?(partial_id)}
      ids.map{|i| create_from_list(i, raw_issues)}
    end

    def self.ids_from_list(list)
      list.map{|i| i.match(/\/([a-f0-9]{40})\//)[1]}.uniq
    end

    def self.create_new(title, description, tags)
      time = Time.now.to_f
      creator = GitWorker.user_str
      issue_id = GitWorker.hash_str("#{time} #{creator} #{title} #{description}")
      issue = self.new(issue_id)
      tag_hash = {}
      tags.each do |k,v|
        tag_hash[k] = v
      end
      GitWorker.work_on_issues_branch do
        Tag.create(issue, {:created_at=> time,
                           :creator => creator,
                           :assigned_to => creator,
                           :title => title,
                           :status => "open",
                           :description => description}, :events => false)
        if tag_hash.any? then
          Tag.create(issue, tag_hash)
        end
        Event.create(issue, {:event_type => :create})
      end
      issue
    end

    def self.create_from_list(issue_id, list)
      list = list.dup
      new_obj = self.new(issue_id)
      list.delete_if{|i| !i.include?(issue_id)}

      parts = list.map do |i|
        m = i.match(/^100644\s+blob\s+([a-f0-9]{40})\s+.*?\/#{issue_id}\/(.*)$/)
        {:sha => m[1], :path => m[2]}
      end
      parts.each do |i|
        piece = YAML::load(GitWorker.get_obj(i[:sha]))

        split = i[:path].split("/")
        if split[0] == "events" then
          new_obj.events << Event.new(piece)
        elsif split[0] == "tags" then
          piece[:key] = piece[:key].to_sym
          new_obj.tags[piece[:key]] = Tag.new(piece)
        end
      end
      new_obj
    end

    def detail_string
      history = events.sort_by{|e| e.created_at}
      tag_string = custom_tags.map{|k,t| t.detail_string}.join("  ")
"\
#{issue_id}
Title:      #{tags[:title].value}
Created by: #{tags[:creator].value} at #{Time.at(tags[:created_at].value)}
Tags:       #{tag_string}

#{tags[:description].value}

History:
#{history.map{|h| h.detail_string}.join("\n\n")}
"
    end

    def self.standard_tags
      [:title, :description, :status, :creator, :created_at]
    end
  end
end