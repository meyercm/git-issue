require_relative 'base_command'
require_relative '../models/issue'

module GitIssue
  class NewCommand < BaseCommand
    def parse(args)
      options = OpenStruct.new()
      options.message = ""
      options.tags = []
      parser = OptionParser.new do |opts|
        opts.on("-m", "--message MESSAGE", "Title for this Issue") do |message|
          options.message = message
        end
        opts.on("-t", "--tag TAGS", "tags to place on this Issue") do |tags|
          options.tags = Helper.validate_tagstr(tags)
        end
      end
      parser.parse!(args)

      cl_tag = args.shift
      if cl_tag then
        options.tags << [GitWorker.default_tag, cl_tag]
      end
      options
    end

    def run(options)
      title = options.message
      if title == "" then
        title, description = get_message_from_editor(@@default_message)
      end

      issue = Issue.create_new(title, description, options.tags)
      write_output "#{issue.short_id} successfully created"
    end

@@default_message = '

#$# Add a title and description for this Issue.  The title should occupy the
#$# first line of the file, and be followed by a blank line.  On the lines
#$# following that blank line, feel free to add a more detailed description.
#$# Lines beginning with a "#$#" are ignored, and an empty message aborts the
#$# operation.
'
@@help_message ='
Creates a new issue.

Usage:   git issue new [default_tag_specifier] [options]

Default tag specifier:
  When present, the default tag will be set on the new issue with the provided
  value.  For instance, `git issue new feature` is a shorthand equivalent to
  `git issue new -t kind:feature`.  The default tag may be configured using git
  config to set the issue.default-tag key to another value.

Options:
  -t, --tag TAGSTR
    applies the tags given in TAGSTR to the issue.
  -m, --message, MESSAGE
    specifies a message. If a message is not specified, an editor will be
    opened to solicit a title and description for the issue.  The first line of
    the result will be interpreted as the title, and the remaining lines as the
    description.

Examples:
  git issue new
  git issue new feature -t milestone:2.0.5,priority:high
  git issue new bug -m "login screen broken"
'
  end
end