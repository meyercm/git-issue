require_relative 'base_command'

module GitIssue
  class EditCommand < BaseCommand
    def parse(args)
      options = OpenStruct.new()
      options.sha = validate_sha(args.shift)
      parser = OptionParser.new do |opts|

      end
      parser.parse!(args)

      options
    end

    def run(options)
      issue = get_issue(options.sha)

      initial_text = "\
#{issue.title}

#{issue.description}

#{@@default_message}
"
      title, description = get_message_from_editor(initial_text)
      if issue.title != title or issue.description!= description then
        issue.update({:title => title, :description => description})
      end
      write_output "#{issue.short_id} successfully updated"
    end

@@default_message ='
#$# Edit the title and description for this Issue.  The title should occupy the
#$# first line of the file, and be followed by a blank line.  On the lines
#$# following that blank line, feel free to add a more detailed description.
#$# Lines beginning with a "#$#" are ignored, and an empty message aborts the
#$# operation.
'
@@help_message ='Opens an editor to edits the title and description of an issue. The first line
of the editor result will be interpreted as the new title, and the remaining
lines as the description of the issue.

Usage:   git issue edit <issue_id>

Examples:
  git issue edit cc4
'
  end
end