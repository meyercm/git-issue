require 'ostruct'
require_relative 'errors'
module GitIssue
  class Helper
    def self.first_non_blank(ary)
      ary.delete("")
      ary.delete(nil)
      ary.first
    end
    def self.is_full_sha?(str)
      !!(str =~ /^[a-fA-F0-9]{40}$/)
    end
    def self.is_partial_sha?(str)
      !!(str =~ /^[a-fA-F0-9]{1,40}$/)
    end
    def self.is_tag_spec(tag_str)
      result = catch :failed do # will be nil if thrown, else true
        throw :failed if tag_str.nil?
        split = tag_str.split(":")
        throw :failed if split.length > 2
        throw :failed if split[0] !~ /^\w+$/
        throw :failed if split[1] and split[1] =~ /\s/

        true # only get here if it's legit.
      end
      !!result
    end

    def self.tags_match(tag_ary, obj_tags)
      tag_ary.all? do |tag_q|
        if tag_q.value then
          regx = "^#{tag_q.value.gsub("?", ".{1}").gsub("*", ".*?")}$"
          obj_tags.any?{|_k, o_t| o_t.key == tag_q.key and
                              o_t.value =~ /#{regx}/}
        else
          obj_tags.any?{|_k, o_t| o_t.key == tag_q.key}
        end
      end
    end

    def self.terminal_size
      rows, cols = [39, 79]
      if RUBY_VERSION =~ /2\.\d.\d/ then
        begin
          window = [0,0,0,0].pack('SSSS')

          fd = IO.sysopen("/dev/tty", "w")
          terminal = IO.new(fd, "w")

          terminal.ioctl(1074295912, window)

          rows, cols, _width, _height = window.unpack('SSSS')
        rescue
        end
      elsif ENV['LINES'] and ENV['COLUMNS']
        rows = ENV['LINES']
        cols = ENV['COLUMNS']
      end
      OpenStruct.new(:rows =>rows, :cols => cols)
    end

    # grabbed from the 1.9.3 stdlb ShellWords module,
    # for compatibility with 1.8.7
    def self.shellescape(str)
      # An empty argument will be skipped, so return empty quotes.
      return "''" if str.empty?

      str = str.dup

      # Treat multibyte characters as is.  It is caller's responsibility
      # to encode the string in the right encoding for the shell
      # environment.
      str.gsub!(/([^A-Za-z0-9_\-.,:\/@\n])/, "\\\\\\1")

      # A LF cannot be escaped with a backslash because a backslash + LF
      # combo is regarded as line continuation and simply ignored.
      str.gsub!(/\n/, "'\n'")

      return str
    end

    def self.suppress_output
      if ENV['GIT_ISSUE_DEBUG'] then
        yield
      else
        begin
          original_stderr = $stderr.clone
          original_stdout = $stdout.clone
          $stderr.reopen(File.new('/dev/null', 'w'))
          $stdout.reopen(File.new('/dev/null', 'w'))
          retval = yield
        rescue Exception => e
          $stdout.reopen(original_stdout)
          $stderr.reopen(original_stderr)
          raise e
        ensure
          $stdout.reopen(original_stdout)
          $stderr.reopen(original_stderr)
        end
        retval
      end
    end
  end
end