require 'fileutils'

require_relative 'errors'
module GitIssue
  class GitWorker
    def self.run(command, opts = :no_opts)
      if opts == :no_opts then
        opts = {:raise => true}
      end
      warn "running #{command.inspect}" if ENV['GIT_ISSUE_DEBUG']
      res = `#{command}`.chomp
      warn "got #{$?} : #{res.inspect}" if ENV['GIT_ISSUE_DEBUG']
      raise GitError.new(command) if ($? != 0 and opts[:raise])
      res
    end

    def self.current_sha(branch = "HEAD")
      run("git rev-parse #{branch}")
    end
    def self.current_branch
      res = nil
      begin
        res = run("git symbolic-ref HEAD --short")
      rescue GitError
      end
      res
    end

    def self.stash_all
      run("git stash -u")
    end
    def self.unstash
      run("git stash pop")
    end
    def self.switch_to(branch_name)
      run("git checkout #{branch_name}")
    end
    def self.branch_exists?(branch_name)
      run("git branch --list #{branch_name}") != ""
    end
    def self.create_orphan_branch(branch_name)
      top_level = path_to_top_level
      top_level = "." if top_level == ""
      run("git checkout --orphan #{branch_name}")
      run("git rm -r -f --ignore-unmatch #{top_level}")
      commit("initial commit of #{branch_name}", "--allow-empty")
    end
    def self.switch_branch(branch_name)
      run("git checkout #{branch_name}")
    end
    def self.path_to_top_level
      run("git rev-parse --show-cdup")
    end
    def self.remove_folder(path)
      run("git rm -r #{path}")
    end
    def self.config(key, default = nil)
      res = run("git config --get #{key}", :raise => false)
      (res == "") ? default : res
    end
    def self.list_format
      config("issue.list-format", "withtags")
    end
    def self.issues_branch
      config("issue.branch", "issues")
    end
    def self.issues_folder
      config("issue.folder", ".issues")
    end
    def self.default_tag
      config("issue.default-tag", "kind")
    end
    def self.user_name
      config("user.name", "anon")
    end
    def self.user_email
      config("user.email", "anon@anon.org")
    end
    def self.editor
      config "core.editor"
    end
    def self.pager
      config "core.pager"
    end
    def self.get_obj(sha)
      run("git cat-file -p #{sha}")
    end
    def self.user_str
      res = config "issue.user"
      if res == nil then
        res = "#{user_email} (#{user_name})"
      end
    end
    def self.hash_str(data)
      run("git hash-object --stdin <<< \"#{Helper.shellescape(data)}\"")
    end
    def self.hash_file(filename)
      run("git hash-object #{filename}")
    end
    def self.pending_changes?
      run("git status -s") != ""
    end
    def self.add(folder)
      run("git add #{folder}")
    end
    def self.commit(commit_message, options = "")
      run("git commit -m #{Helper.shellescape(commit_message)} #{options}")
    end

    def self.list_issues
      if !branch_exists?(issues_branch) then
        work_on_issues_branch do
          #set up the issues branch if this is the first command they run
        end
      end
      run("git ls-tree --full-tree -r #{issues_branch} -- #{issues_folder}").strip.split("\n")
    end

    def self.validate_repo_state
      if current_branch == nil
        raise IssueError.new "You are in detached-HEAD mode.  Please check out a branch and try again."
      end
      if !branch_exists?(current_branch) then
        raise IssueError.new "This repository needs at least an initial commit.  Please commit something and try again."
      end
      merge_issues_with_upstream
    end

    def self.merge_issues_with_upstream
      ib = issues_branch
      rb = config("branch.#{ib}.remote", :stop!)

      if rb != :stop! then

        rb += "/#{ib}"
        if current_sha(ib) != current_sha(rb) then
          if run("git rev-list --count #{ib}..#{rb}").to_i > 0 then
            work_on_issues_branch do
              begin
                run "git pull --no-edit"
                puts "updated issues branch"
              rescue GitError
                run "git merge --abort", :raise => false
                raise IssueError.new "\
  Attempted to merge issues with upstream (#{rb}), and failed.  Please manually
  merge #{ib} and #{rb}. Try:

    \"git checkout #{ib}\"
    \"git merge #{rb}\"

  "
              end
            end #work_on_issues_branch
          else #we are at least caught up w/ origin
            commits_ahead = run("git rev-list --count #{ib}..#{rb}").to_i
            if commits_ahead > 0 then
              puts "your git issues branch is #{commits_ahead} ahead of #{rb}"
            end
          end
        end
      end

    end
    def self.work_on_branch(target_branch, options = {}, &block)
      orig_branch = current_branch
      base_path = path_to_top_level
      if target_branch == orig_branch then
        block.call(base_path)
      else
        need_to_stash = (pending_changes?)
        stash_all if need_to_stash
        begin
          switch_branch(target_branch)
        rescue GitError
          if options[:create_orphan] then
            create_orphan_branch(target_branch)
          else
            raise IssueError.new("#{target_branch} does not exist")
          end
        end
        begin
          block.call(base_path)
        ensure
          switch_branch(orig_branch)
          unstash if need_to_stash
        end
      end

    end

    def self.work_on_issues_branch &block
      issues_folder_path = "#{path_to_top_level}#{issues_folder}"
      work_on_branch(issues_branch, {:create_orphan => true}) do
        FileUtils.mkdir_p(issues_folder_path)
        block.call(issues_folder_path)
      end
    end
  end
end