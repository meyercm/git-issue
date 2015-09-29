require_relative 'git_issue/all'

module GitIssue
  @@version = "0.0.3"
  def self.parse_and_run(args)
    result = 1 # pessimistic- assume the script will fail somewhere
    begin
      GitWorker.validate_repo_state
      command = parse_command(args.shift)
      runner = command.new
      args = runner.parse(args)
      runner.run(args)
      result = 0
    rescue GitError => ge
      warn "error in git command: #{ge.message}\n#{ge.backtrace}"
    rescue IssueError => ie
      warn ie.message
    end
    result
  end

  def self.parse_command(str)
    classname = "#{str}".capitalize + "Command"
    # dynamically find the class GitIssue::<command>Command, e.g.
    # GitIssue::NewCommand
    if const_defined?(classname) then
      const_get(classname)
    elsif "#{str}" == "" then
      raise IssueError.new("git-issue version #{@@version}.  Try 'git issue help'.")
    else
      raise IssueError.new("unknown command #{str}")
    end
  end
end