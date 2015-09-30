if RUBY_VERSION !~ /^1\.8/ then
  require 'coveralls'
  Coveralls.wear!
end
ENV['GIT_ISSUE_TEST'] = 'true'
load File.expand_path("../target.rb", __FILE__)
ENV.delete('GIT_ISSUE_TEST')
require 'shellwords'
#travis has git 1.8.5.6 as of 7Sep2015

def suppress_output &block
  GitIssue::Helper.suppress_output do
    block.call
  end
end

def check_execute(cmd_ary)
  suppress_output do
    cmd_ary.each do |cmd|
      result = system(cmd)
      expect(result).to eq(true)
    end
  end
end

def setup_git_dir
  check_execute([
    "git init",
    "git config user.name blah",
    "git config user.email blah@blah.blah",
    "git commit --allow-empty -m init",
    "git checkout --orphan publish_branch",
    "git commit --allow-empty -m init",
    "git checkout master"
  ])
end

def git_issue(command, check_result = true)
  args = Shellwords.shellwords(command)
  result = GitIssue.parse_and_run(args)
  expect(result).to eq(0) if check_result
  result
end