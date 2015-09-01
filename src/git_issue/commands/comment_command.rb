require_relative 'base_command'
require_relative '../models/event'

module GitIssue
  class CommentCommand < BaseCommand
    def parse(args)
      options = OpenStruct.new()
      options.message = ""
      options.tags = {}
      parser = OptionParser.new do |opts|
        opts.on("-m", "--message MESSAGE", "notes on closing this issue") do |message|
          options.message = message
        end
        opts.on("-d", "--delete COMMENT_ID", "delete comment") do |comment_id|
          options.delete = comment_id
        end
      end
      parser.parse!(args)
      unless options.delete then
        options.sha = validate_sha(args.shift)
      end
      options
    end

    def run(options)
      if options.delete then
        Event.delete(options.delete)
      else
        issue = get_issue(options.sha)
        title = options.message
        if title == "" then
          title, description = get_message_from_editor(@@default_message)
        end
        event = Event.create(issue, {:event_type => :comment,
                                     :title => title,
                                     :text => description})
        write_output "comment #{event.short_id} successfully created"
      end

    end
@@default_message = "

#$# Add a comment above.  The first line will be treated as the title of the
#$# comment, remaining lines as the body.
#$# Lines beginning with a '#$#' are ignored, and an empty message aborts the
#$# operation.
"
@@help_message ="\
Adds a comment to an issue.  Comments can be viewed using the `git issue show`
command.

Usage:   git issue comment <issue_id> [options]
         git issue command --delete <comment_id>

Options:
  -m, --message, MESSAGE
    specifies a message for the comment.
  -d, --delete, COMMENT_ID
    deletes the specified comment.

Examples:
  git issue comment cc4
  git issue comment 3cf91 -m \"I love git-issue\"
  git issue comment -d ae
"
  end
end