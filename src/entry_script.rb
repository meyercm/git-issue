#!/usr/bin/env ruby
require_relative 'git_issue'

# note the ENV bailout so we can load the code without running the app, e.g.:
#  `GIT_ISSUE_TEST=true irb`, and then `irb> load 'git-issue'`
GitIssue.parse_and_run(ARGV) unless ENV['GIT_ISSUE_TEST']