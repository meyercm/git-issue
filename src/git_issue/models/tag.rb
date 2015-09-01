require 'yaml'
module GitIssue
  class Tag
    attr_reader :key, :value
    def initialize(hash)
      @key = hash[:key]
      @value = hash[:value]
    end

    def detail_string
      "#{key}:#{value}"
    end

    def yaml
      {:key => key,
       :value => value}.to_yaml
    end

    def write(folder)
      tags_folder = "#{folder}/tags"
      FileUtils.mkdir_p(tags_folder)
      File.open("#{tags_folder}/#{key}.tag", 'w') do |f|
        f.write(self.yaml)
      end
    end

    def self.create(issue, tags, opts = {:events => true})
      res = []
      GitWorker.work_on_issues_branch do |issues_folder|
        issue_folder = "#{issues_folder}/#{issue.issue_id}"
        FileUtils.mkdir_p(issue_folder)
        tags.each do |k, v|
          tag_obj = self.new({:key => k, :value => v})
          if v.class == self then
            tag_obj = v
          end
          tag_obj.write(issue_folder)
          res << tag_obj
          if opts[:events] then
            event_obj = Event.new({:event_type =>:set_tag,
                                   :title => k.to_s,
                                   :text => "#{k.inspect} => #{tag_obj.value.inspect}"})
            event_obj.write(issue_folder)
          end
        end
        GitWorker.add(issue_folder)
        GitWorker.commit("add tags #{tags.keys.inspect}")
      end
      res
    end

    def self.delete(issue, tags)
      keys = tags.keys
      GitWorker.work_on_issues_branch do |issues_folder|
        tags_folder = "#{issues_folder}/#{issue.issue_id}/tags"
        tags.each do |k, t|
          filename = "#{tags_folder}/#{k}.tag"
          if File.exists?(filename) then
            File.delete(filename)
          else
            raise IssueError.new "issue #{issue.short_id} does not have tag #{k}"
          end
        end
        GitWorker.add(issues_folder)
        GitWorker.commit("#{issue.short_id}: remove tags: #{keys}")
      end
    end

    def self.tag_string(tags)
      tags.map{|t| "#{t.key}:#{t.value}"}.join("  ")
    end

    def self.all
      result = []
      all = GitWorker.list_issues
      all.each do |i|
        m = i.match(/^100644\s+blob\s+([a-f0-9]{40})\s+.*?\/([a-f0-9]{40})\/tags\/.*?\.tag$/)
        if m then
          text = GitWorker.get_obj(m[1  ])
          obj = YAML::load(text)
          result << self.new(obj)
        end
      end
      result
    end

    def self.parse(tag_str)
      result = {}
      raw_tags = "#{tag_str}".split(",")
      raw_tags.each do |raw|
        if Helper.is_tag_spec(raw) then
          split = raw.split(":")
          result[split[0]] = self.new({:key =>split[0],:value => split[1]})
        else
          raise IssueError "#{raw} does not appear to be a valid tag. Try '<tagname>:<value>' or just '<tagname>'"
        end
      end
      result
    end
  end
end