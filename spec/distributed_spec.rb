require 'spec_helper'

describe 'distributed operations' do

  it "auto-merges" do
    GitIssue::Helper.suppress_output do
      orig_dir = Dir.pwd
      begin
        Dir.mktmpdir do |d|
          Dir.mktmpdir do |d2|

            Dir.chdir(d)
            setup_git_dir
            git_issue "new -m 'new_issue'"

            Dir.chdir(d2)
            check_execute([
              "git clone #{d} clone"
            ])
            Dir.chdir(d)
            git_issue "new -m 'new_issue 2'"

            Dir.chdir("#{d2}/clone")
            expect(GitIssue::Issue.all.count).to eq(1)
            check_execute(["git pull origin"])
            git_issue "list"
            expect(GitIssue::Issue.all.count).to eq(2)
          end
        end
      ensure
        Dir.chdir(orig_dir)
      end
    end
  end
  it "auto-merges when origin is MIA" do
    GitIssue::Helper.suppress_output do
      orig_dir = Dir.pwd
      begin
        Dir.mktmpdir do |d|
          Dir.mktmpdir do |d2|

            Dir.chdir(d)
            setup_git_dir
            git_issue "new -m 'new_issue'"

            Dir.chdir(d2)
            check_execute([
              "git clone #{d} clone"
            ])
            Dir.chdir(d)
            git_issue "new -m 'new_issue 2'"

            Dir.chdir("#{d2}/clone")
            expect(GitIssue::Issue.all.count).to eq(1)
            check_execute(["git pull origin"])
            FileUtils.rm_rf(d)
            FileUtils.mkdir(d)
            git_issue "list"
            expect(GitIssue::Issue.all.count).to eq(2)
          end
        end
      ensure
        Dir.chdir(orig_dir)
      end
    end
  end
end