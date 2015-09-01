require_relative 'base_command'

module GitIssue
  class DeleteCommand < BaseCommand
    def parse(args)
      options = OpenStruct.new()
      options.sha = validate_sha(args.shift)
      parser = OptionParser.new do |opts|
        #no switches defined
      end
      parser.parse!(args)

      options
    end

    def run(options)
      issue = get_issue(options.sha)
      issue.delete
    end

    @@help_message ="\
Deletes an issue.  While deleted issues will no longer appear in
`git issue list` results, they will still exist in the history of the git
repository.

Usage:   git issue delete <issue_id>

Examples:
  git issue delete cc4
"
  end
end