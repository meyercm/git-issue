require_relative 'base_command'

module GitIssue
  class HelpCommand < BaseCommand
    def parse(args)
      options = OpenStruct.new()
      parser = OptionParser.new do |opts|
        opts.on("-s", "--summary", "summarize commands and options") do
          options.summary = true
        end
      end
      parser.parse!(args)
      options.sub_command = args.shift
      options
    end

    def run(options)
      if options.summary then
        write_output @@summary_help
      else
        command = HelpCommand
        begin
          command = GitIssue.parse_command(options.sub_command)
        rescue IssueError
        end
        write_output command.class_variable_get :@@help_message
      end
    end
@@help_message = "\
'git issue' is a series of commands providing lightweight project managment
features, such as feature, bug, and todo list tracking, while storing such
data within the repository.

Available commands:
  git issue help            - help for git-issue and sub commands
  git issue list            - list existing issues
  git issue new             - create a new issue
  git issue edit            - edit an existing issue
  git issue tag             - manipulate issue tags
  git issue comment         - comment on an issue
  git issue close           - close an issue
  git issue delete          - delete an issue

Type 'git issue help <command>' for more information on any of these commands,
or 'git issue help -s' for a short summary of all commands.
"
@@summary_help = "\
git issue new
          new feature
          new -m|--message MESSAGE
          new -t|--tag priority:high
git issue close <id>
          close <id> -m|--message MESSAGE
          close <id> -t|--tag deferred:true
          close <id> -e|--editor
git issue tag <id> kind:feature
          tag <id> kind:bug,priority:high
          tag <id> -d|--delete worthless_tag
          tag -l|--list
git issue delete <id>
git issue comment <id>
          comment <id> -m|--message MESSAGE
          comment -d|--delete <comment_id>
git issue list
          list feature
          list -a|--all
          list -t|--tag priority
          list -t|--tag priority:high
          list -t|--tag milestone:2.*
          list -f|--find <search_string>
          list -n|--not-tag milestone
          list -p|--pretty with-tags|oneline
git issue show <id>
          show -c|--config
git issue edit <id>
git issue help
          help <command>
          help -s|--summary
"
  end
end