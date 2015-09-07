require_relative 'base_command'

module GitIssue
  class CloseCommand < BaseCommand
    def parse(args)
      options = OpenStruct.new()
      options.sha = validate_sha(args.shift)
      options.message = ""
      options.tags = {}
      parser = OptionParser.new do |opts|
        opts.on("-m", "--message MESSAGE", "notes on closing this issue") do |message|
          options.message = message
        end
        opts.on("-t", "--tag TAGS", "tags to place on this Issue") do |tags|
          options.tags = Tag.parse(tags)
        end
        opts.on("-e", "--editor", "opens an editor for a closing comment") do
          options.editor = true
        end
      end
      parser.parse!(args)

      options
    end

    def run(options)
      issue = get_issue(options.sha)
      title = ""
      message = options.message or ""
      message += @@default_message
      if options.editor then
        title, message = get_message_from_editor(message)
      end
      GitWorker.work_on_issues_branch do
        Tag.create(issue, {:status => "closed"}.merge(options.tags))
        if message != ""
          Event.create(issue, {:event_type => :close,
                               :title => title,
                               :description => message})
        end
      end
      write_output "#{issue.short_id} successfully closed"

    end
@@default_message = '

#$# Add a reason for closing this issue.
#$# Lines beginning with a "#$#"" are ignored, and an empty message aborts the
#$# operation.
'
@@help_message ='Closes an issue.  Closed issues have a status of \"closed\", and do not appear
in the query results of `git issue list`, unless `--all` is passed to that
command.  Currently, the only way to re-open an issue is with the `tag`
command, e.g. `git issue tag <issue_id> status:open`

Usage:   git issue close <issue_id> [options]

Options:
  -t, --tag TAGSTR
    applies the tags given in TAGSTR to the issue.  This may be useful, for
    example, to tag an issue with a common reason for closure, like deferral.
  -m, --message, MESSAGE
    specifies a message for a closing comment.
  -e, --editor
    opens an editor to accept a closing comment.

Examples:
  git issue close cc4
  git issue close 3cf91 -t deferred:true
  git issue close a3e --editor
'
  end
end