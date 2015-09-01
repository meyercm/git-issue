require 'yaml'
module GitIssue
  class Event
    attr_reader :creator,
                :title,
                :text,
                :created_at,
                :event_type,
                :event_id

    def initialize(hash)
      @creator = (hash[:creator] or GitWorker.user_str)
      @title = (hash[:title])
      @text = (hash[:text])
      @created_at = (hash[:created_at] or Time.now.to_f)
      @event_type = (hash[:event_type])
      @event_id = (hash[:event_id] or GitWorker.hash_str("#{@created_at} #{@creator} #{@event_type} #{@title} #{@text}"))
    end

    def short_id
      event_id[0..7]
    end

    def yaml
      {
        :creator => creator,
        :title => title,
        :text => text,
        :created_at => created_at,
        :event_type => event_type,
        :event_id => event_id
      }.to_yaml
    end

    def write(folder)
      events_folder = "#{folder}/events"
      FileUtils.mkdir_p(events_folder)
      File.open("#{events_folder}/#{event_id}.event", 'w') do |f|
        f.write(self.yaml)
      end
    end

    def detail_string
      create_time = Time.at(self.created_at)
      summary_str = "#{creator} #{type_string}"
      desc = ("#{self.text}" == "") ? "" : "\n#{self.text}"
      "#{create_time}: #{summary_str} - #{self.title}#{desc}"
    end

    def self.create(issue, new_event_args)
      event_obj = nil
      GitWorker.work_on_issues_branch do |issues_folder|
        issue_folder = "#{issues_folder}/#{issue.issue_id}"
        FileUtils.mkdir_p(issue_folder)
        event_obj = self.send(:new, new_event_args)
        event_obj.write(issue_folder)
        GitWorker.add(issue_folder)
        GitWorker.commit("#{issue.short_id} add event: #{event_obj.title}")
      end
      event_obj
    end

    def self.delete(event_id)
      files = GitWorker.list_issues
      files.delete_if{|f| !f.include?(event_id)}
      case files.length
      when 0
        raise IssueError.new "no matching id for #{event_id}"
      when 1
        m = files[0].match(/^100644\s+blob\s+([a-f0-9]{40})\s+(.*?\/#{id}\.event)$/)
        # remove the base issue folder from the path
        path = m[1].split("/")[1..-1].join("/")
        GitWorker.work_on_issues_branch do |issues_folder|
          File.delete("#{issues_folder}/#{path}")
          GitWorker.add(issues_folder)
          GitWorker.commit("deleted comment #{event_id[0..7]}")
        end
      else
        raise IssueError.new "non-distinct id. Please specify more characters."
      end
    end

    def type_string
      case self.event_type
      when nil
        ""
      when :comment
        "commented"
      when :set_tag
        "set tag"
      when :delete_tag
        "removed tag"
      when :close
        "closed"
      when :create
        "created"
      end
    end


  end
end