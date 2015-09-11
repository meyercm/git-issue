require 'tempfile'
require 'ostruct'
require 'optparse'

require_relative '../errors'
require_relative '../git_worker'
require_relative '../helper'
require_relative '../models/issue'

module GitIssue
  class BaseCommand
    def self.help_message
      class_variable_get(:@@help_message)
    end

    def get_message_from_editor(initial_editor_text, clean=true)
      result = ""
      editor_status = :not_execute
      Dir.mktmpdir do |d|
        filename = "#{d}/new_issue.txt"
        File.open(filename, 'w') do |f|
          f.write(initial_editor_text)
        end
        system "#{get_editor} #{filename}"  #use system rather than backticks
        editor_status = $?
        result = File.read(filename)
      end
      if editor_status != 0 then
        raise IssueError.new "Editor error, exit code #{input.editor_status.inspect}"
      end
      if clean then
        result = clean_message!(result)
      end
      result
    end

    def clean_message!(message, options = {:raise => true})
      title = clean_message = ""
      if message.is_a? String then
        split_message = message.split("\n")
        split_message.delete_if {|i| i =~ /^\s*\#\$\#/}
        if split_message.join("").strip == "" then
          if options[:raise] then
            raise IssueError.new "Empty issue message, Aborting"
          end
        else
          title = split_message[0].strip
          clean_message = split_message[1..-1].map{|l| l.rstrip}.join("\n").strip
        end
      end
      [title, clean_message]
    end

    def validate_sha(sha)
      if !Helper.is_partial_sha?(sha) then
        raise IssueError.new "#{sha} does not appear to be an issue-id"
      end
      sha
    end

    def get_issue(sha)
      if sha == nil
        nil
      else
        issues = Issue.find(sha)
        if issues.length == 0 then
          raise IssueError.new "could not find an issue matching issue-id #{sha}"
        elsif issues.length > 1 then
          raise IssueError.new "multiple issues match #{sha}: #{issues.map{|i| i.issue_id}.inspect}"
        end
        issues.shift
      end
    end

    def get_editor
      visual= ENV['VISUAL']
      editor = ENV['EDITOR']
      git = GitWorker.editor
      fallback = 'vim'
      Helper.first_non_blank [visual, editor, git, fallback]
    end
    def get_pager
      git = GitWorker.pager
      fallback = 'less'
      Helper.first_non_blank [git, fallback]
    end

    def write_output(str)
      lines = str.split("\n").length

      if lines > Helper.terminal_size.rows then
        Dir.mktmpdir do |d|
          filename = "#{d}/tmp.txt"
          File.open(filename, 'w') do |f|
            f.write(str)
          end
          system "#{get_pager} #{filename}"
        end
      else
        puts str
      end
    end
  end
end