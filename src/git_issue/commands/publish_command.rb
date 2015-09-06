require_relative 'base_command'

module GitIssue
  class PublishCommand < BaseCommand
    def parse(args)
      options = OpenStruct.new()
      options.branch = "gh-pages"
      options.folder = "issues"
      parser = OptionParser.new do |opts|
        opts.on("-b", "--branch BRANCH_NAME", "branch to publish to") do |branch|
          options.branch = branch

        end
        opts.on("-f", "--branch FOLDER_NAME", "folder to publish to") do |folder|
          options.folder = folder

        end
      end
      parser.parse!(args)

      options
    end

    def run(options)
      GitWorker.work_on_branch(options.branch) do |base_folder|
        working_folder = "#{base_folder}#{options.folder}"
        FileUtils.mkdir_p(working_folder) #this way rm_rf can't complain
        FileUtils.rm_rf(working_folder)
        FileUtils.mkdir_p(working_folder)
        create_page(working_folder)
        GitWorker.add(working_folder)
        GitWorker.commit("git-issue publish issues")
      end
    end

    def create_page(working_folder)
      issues = Issue.all.sort_by{|i| i.created_at}.reverse
      write_index("#{working_folder}/index.html", issues)
      issues.each do |i|
        write_issue(working_folder, i)
      end
    end
    def write_index(filename, all_issues)
      closed, others = all_issues.partition{|i| i.status == "closed"}
      text = "\
---
layout: default
title: Issues
---
<div>
  <p>Open issues: (#{others.count})</p>
  <ul class=\"issue_list\">
    #{(others.map{|i| one_issue_for_index(i)}).join("\n")}
  </ul>
  <p>Closed issues: (#{closed.count})</p>
  <ul class=\"issue_list\">
    #{(closed.map{|i| one_issue_for_index(i)}).join("\n")}
  </ul>
</div>
"
      File.open(filename, 'w') do |f|
        f.write(text)
      end
    end

    def one_issue_for_index(i)
      "\
    <li>
      <div class=\"issue_list_entry\">
        <a href=\"#{i.issue_id}\">#{i.title}</a>
        <div class=\"issue_list_meta\">
          <span>
            \##{i.short_id} created on #{Time.at(i.created_at)}
          </span>
          #{(i.custom_tags.map do |_k, t|
"\
<div class=\"tag_string\">#{t.detail_string}</div>
"
             end).join("\n")}
        </div>
      </div>
    </li>"
    end

    def write_issue(parent_folder, issue)
      issue_folder = "#{parent_folder}/#{issue.issue_id}"
      FileUtils.mkdir_p(issue_folder)
      text = "\
---
layout: default
---
[back to issues](..)

\#\# \\\##{issue.short_id}: #{issue.title}

\#\#\#Status: **#{issue.status.capitalize}**
_created by #{issue.creator} at #{Time.at(issue.created_at)}_

#{issue.description}

#{issue.events.sort_by{|e| e.created_at}.map{|e| e.markdown_string}.delete_if{|r| r == ""}.join("\n\n---\n")}
"

      File.open("#{issue_folder}/index.md", "w") do |f|
        f.write(text)
      end
    end

  end
  @@help_message ="\
Publishes all issues to the specified branch for use with Jekyll.

Usage:   git issue publish [options]

Options:
  -f, --folder FOLDER_NAME
    Specifies the folder to use as the root.  Defaults to \"issues\".

  -b, --branch BRANCH_NAME
    Specifies which branch to publish to.  Defaults to \"gh-pages\".
Examples:
  git issue publish
"
end