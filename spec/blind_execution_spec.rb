require 'spec_helper'


describe 'blind test- just check result codes' do
  it "is a test" do
    suppress_output do
      git_issue_loc = File.expand_path('../../git-issue', __FILE__)
      Dir.mktmpdir do |d|

        Dir.chdir(d)
        result = system("git init")
        expect(result).to eq(true)
        result = system("git commit --allow-empty -m init")
        expect(result).to eq(true)
        warn git_issue_loc
        result = system("#{git_issue_loc} new -m 'new_issue'")
        expect(result).to eq(true)

        issue_id = GitIssue::Issue.all.first.issue_id

        result = system("#{git_issue_loc} list bug")
        expect(result).to eq(true)
        result = system("#{git_issue_loc} show #{issue_id}")
        expect(result).to eq(true)
        result = system("#{git_issue_loc} tag #{issue_id} blah:bleh")
        expect(result).to eq(true)
        result = system("#{git_issue_loc} close #{issue_id} -t deferred")
        expect(result).to eq(true)

        result = system("#{git_issue_loc} delete #{issue_id}")
        expect(result).to eq(true)


      end
    end
  end
end