require 'spec_helper'

describe 'blind test- just check result codes' do
  it "can run through the general paces" do
    GitIssue::Helper.suppress_output do
      git_issue = File.expand_path('../../git-issue', __FILE__)
      orig_dir = Dir.pwd
      begin
        Dir.mktmpdir do |d|

          Dir.chdir(d)
          setup_git_dir
          check_execute(["#{git_issue} new -m 'new_issue'"])

          issue_id = GitIssue::Issue.all.first.issue_id
          check_execute([
            "#{git_issue} list bug",
            "#{git_issue} show #{issue_id}",
            "#{git_issue} tag #{issue_id} blah:bleh",
            "#{git_issue} publish -b publish_branch",
            "#{git_issue} close #{issue_id} -t deferred",
            "#{git_issue} delete #{issue_id}"])
        end
      ensure
        Dir.chdir(orig_dir)
      end
    end
  end

  it "can show help" do
    GitIssue::Helper.suppress_output do
      git_issue = File.expand_path('../../git-issue', __FILE__)
      orig_dir = Dir.pwd
      begin
        Dir.mktmpdir do |d|

          Dir.chdir(d)
          setup_git_dir
          check_execute(["#{git_issue} help list"])
        end
      ensure
        Dir.chdir(orig_dir)
      end
    end
  end
end