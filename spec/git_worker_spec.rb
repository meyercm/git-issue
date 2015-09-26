require 'spec_helper'

describe "GitWorker" do
  describe "#hash_str" do
    it "can hash a string with a single quote" do
      GitIssue::GitWorker.hash_str("a'b")
    end
    it "can hash a string with a double quote" do
      GitIssue::GitWorker.hash_str('a"b')
    end
    it "can hash a string with a semicolon" do
      GitIssue::GitWorker.hash_str("a;b")
    end
  end

  describe "#work_on_branch" do
    it "works from the base directory" do
      orig_dir = Dir.pwd
      Dir.mktmpdir do |d|
        begin
          Dir.chdir(d)
          setup_git_dir
          check_execute(["git branch test_branch"])
          GitIssue::GitWorker.work_on_branch("test_branch") do
            expect(GitIssue::GitWorker.current_branch).to eq("test_branch")
          end
        ensure
          Dir.chdir(orig_dir)
        end
      end
    end
    it "works from a committed sub-directory" do
      orig_dir = Dir.pwd
      Dir.mktmpdir do |d|
        begin
          Dir.chdir(d)
          setup_git_dir
          FileUtils.mkdir_p("#{d}/test_dir")
          Dir.chdir("#{d}/test_dir")
          File.open("#{d}/test_dir/test.txt", "w") do |f|
            f.write("test_content")
          end
          check_execute([
            "git add .",
            "git commit -m 'test'"
          ])
          GitIssue::GitWorker.work_on_branch("test_branch", :create_orphan => true) do |path|
            expect(GitIssue::GitWorker.current_branch).to eq("test_branch")
            expect(File.exists?("#{path}/test_dir/test.txt")).to eq(false)
          end
          File.open("#{d}/test_dir/test.txt") do |f|
            expect(f.read).to eq("test_content")
          end
        ensure
          Dir.chdir(orig_dir)
        end
      end
    end
    it "works from an uncommitted subdir" do
      orig_dir = Dir.pwd
      Dir.mktmpdir do |d|
        begin
          Dir.chdir(d)
          setup_git_dir
          FileUtils.mkdir_p("#{d}/test_dir")
          Dir.chdir("#{d}/test_dir")
          File.open("#{d}/test_dir/test.txt", "w") do |f|
            f.write("test_content")
          end
          GitIssue::GitWorker.work_on_branch("publish_branch") do |path|
            expect(GitIssue::GitWorker.current_branch).to eq("publish_branch")
            expect(File.exists?("#{path}/test_dir/test.txt")).to eq(false)
          end
          File.open("#{d}/test_dir/test.txt") do |f|
            expect(f.read).to eq("test_content")
          end
        ensure
          Dir.chdir(orig_dir)
        end
      end
    end
    it "creates an orphan branch if asked" do
      orig_dir = Dir.pwd
      Dir.mktmpdir do |d|
        begin
          Dir.chdir(d)
          setup_git_dir
          FileUtils.mkdir_p("#{d}/test_dir")
          File.open("#{d}/test_dir/test.txt", "w") do |f|
            f.write("test_content")
          end
          GitIssue::GitWorker.work_on_branch("test_branch", :create_orphan => true) do |path|
            expect(GitIssue::GitWorker.current_branch).to eq("test_branch")
            expect(File.exists?("#{path}/test_dir/test.txt")).to eq(false)
          end
          expect(GitIssue::GitWorker.current_branch).to eq("master")
          File.open("#{d}/test_dir/test.txt") do |f|
            expect(f.read).to eq("test_content")
          end
        ensure
          Dir.chdir(orig_dir)
        end
      end
    end
    it "works when already on the branch" do
      orig_dir = Dir.pwd
      Dir.mktmpdir do |d|
        begin
          Dir.chdir(d)
          setup_git_dir
          FileUtils.mkdir_p("#{d}/test_dir")
          File.open("#{d}/test_dir/test.txt", "w") do |f|
            f.write("test_content")
          end
          GitIssue::GitWorker.work_on_branch("publish_branch", :create_orphan => true) do |path|
            expect(GitIssue::GitWorker.current_branch).to eq("publish_branch")
            expect(File.exists?("#{path}/test_dir/test.txt")).to eq(false)
          end
          File.open("#{d}/test_dir/test.txt") do |f|
            expect(f.read).to eq("test_content")
          end
        ensure
          Dir.chdir(orig_dir)
        end
      end
    end

    it "preserves uncommitted stuff even on a crash" do
      orig_dir = Dir.pwd
      Dir.mktmpdir do |d|
        begin
          Dir.chdir(d)
          setup_git_dir
          FileUtils.mkdir_p("#{d}/test_dir")
          File.open("#{d}/test_dir/test.txt", "w") do |f|
            f.write("test_content")
          end
          begin
            GitIssue::GitWorker.work_on_branch("test_branch", :create_orphan => true) do
              expect(GitIssue::GitWorker.current_branch).to eq("test_branch")
              raise ArgumentError.new
            end
          rescue ArgumentError
          end
          File.open("#{d}/test_dir/test.txt") do |f|
            expect(f.read).to eq("test_content")
          end
        ensure
          Dir.chdir(orig_dir)
        end
      end
    end
  end
end