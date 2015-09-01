require_relative 'base_command'

module GitIssue
  class ShowCommand < BaseCommand
    def parse(args)
      options = OpenStruct.new()
      parser = OptionParser.new do |opts|
        opts.on("-c", "--config", "show git config keys") do
          options.config = true

        end
      end
      parser.parse!(args)
      options.sha = validate_sha(args.shift) unless options.config

      options
    end

    def run(options)
      if options.config then
        write_output config_string
      else
        issue = get_issue(options.sha)
        write_output issue.detail_string
      end
    end

    def config_string
      output = ["`git config` key       Value", ("-" * 79)] +
      {"issue.user" =>
         "Custom user identifier. Defaults to \"`user.name` (`user.email`)\"",
       "issue.branch" =>
         "Branch to store issue information. Defaults to \"issue\"",
       "issue.folder" =>
         "Folder to store issue information. Defaults to \".issue\"",
       "issue.default-tag" =>
         "Default tag for convenience syntax. Defaults to \"kind\""
      }.map do |k, desc|
        value = GitWorker.config(k)
        if value.nil? then
          value = "<default>"
        end
        "#{k.ljust(17)}  =>  #{value}\n      #{desc}"
      end
      output.join("\n")
    end
  end
  @@help_message ="\
Shows the full detail of an issue, including all tags, comments and events.
Can also be used to show the current git-issue configuration.

Usage:   git issue show <issue_id>
         git issue show --config

Options:
  -c, --config
    Lists the currently configuration for git-issue.

Examples:
  git issue show cc4
"
end