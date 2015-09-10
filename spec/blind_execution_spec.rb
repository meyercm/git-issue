require 'spec_helper'

def check_execute(cmd_ary)
  cmd_ary.each do |cmd|
    result = system(cmd)
    expect(result).to eq(true)
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
  ])
end

describe 'blind test- just check result codes' do
  it "can run through the general paces" do
    suppress_output do
      git_issue = File.expand_path('../../git-issue', __FILE__)
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
          "#{git_issue} delete #{issue_id}",
        ])
      end
    end
  end
end