require_relative 'base_command'
require_relative '../models/tag'
module GitIssue
  class TagCommand < BaseCommand
    def parse(args)
      options = OpenStruct.new()
      parser = OptionParser.new do |opts|
        opts.on("-d", "--delete TAGSTR", "delete a tag from an issue") do |tagstr|
          options.delete = Tag.parse(tagstr)
        end
        opts.on("-l", "--list", "list all tags") do
          options.list = true
        end

      end
      warn args.inspect
      parser.parse!(args)
      if options.list then
        # skip sha and tag validation
      else
        options.sha = validate_sha(args.shift)
        options.tags = Tag.parse(args.shift)
      end
      options
    end

    def run(options)
      issue = get_issue(options.sha)

      if options.delete then
        warn options.inspect
        Tag.delete(issue, options.delete)
        write_output "successfully deleted tag(s) '#{options.delete.keys.join(", ")}' from #{issue.short_id}"
      elsif options.list then
        result_map = {}
        Tag.all.each do |t|
          result_map[t.key] ||= []
          result_map[t.key] << t.value unless result_map[t.key].include? t.value
        end
        result_map.delete_if{|k, v_ary| Issue.standard_tags.include? k}
        result = result_map.map do |k, v|
          "#{k}: #{v.join(",")}"
        end
        write_output result.join("\n")
      else
        Tag.create(issue, options.tags)
        tag_str = options.tags.map{|k,t| "#{k}:#{t.value}"}
        write_output "successfully added tag(s) '#{tag_str.join(", ")}' to #{issue.short_id}"
      end
    end
    @@help_message ="\
Various tag utilities.

Usage:   git issue tag <issue_id> TAGSTR
         git issue tag <issue_id> --delete TAGSTR
         git issue tag --list

Options:
  TAGSTR
    applies the tags given in TAGSTR to the issue.
  -d, --delete, TAGSTR
    removes the specified tags from the issue.
  -l, --list
    lists all tags and their values.

Examples:
  git issue tag cc4 deliverable
  git issue tag 3cf91 --delete priority
  git issue tag --list
"
  end
end