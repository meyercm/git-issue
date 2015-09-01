require_relative 'base_command'

module GitIssue
  class ListCommand < BaseCommand
    def parse(args)
      options = OpenStruct.new()
      options.tags = []
      options.not_tags = []
      parser = OptionParser.new do |opts|
        opts.on("-a", "--all", "also show closed issues") do |message|
          options.all = true
        end
        opts.on("-t", "--tag TAGS", "filter to issues with tag") do |tags|
          options.tags = Tag.parse(tags)
        end
        opts.on("-f", "--find SEARCH_STRING", "filter to issues with text") do |search_string|
          options.find = search_string
        end
        opts.on("-n", "--not-tag TAGS", "filter to issues without tag") do |not_tags|
          options.not_tags = Tag.parse(not_tags)
        end
        opts.on("-p", "--pretty FORMATTER", "specify output format") do |formatter|
          options.formatter = formatter
        end
      end
      parser.parse!(args)

      cl_tag = args.shift
      if cl_tag then
        options.tags << Tag.new({key: GitWorker.default_tag,
                                value: cl_tag})
      end

      options
    end

    def run(options)
      issues = Issue.all

      if !options.all then
        issues.delete_if{|i| i.status == "closed"}
      end
      if options.tags.any? then
        issues.delete_if{|i| !Helper.tags_match(options.tags, i.tags)}
      end
      if options.not_tags.any? then
        issues.delete_if{|i| Helper.tags_match(options.not_tags, i.tags)}
      end
      if options.find then
        issues.delete_if{|i| !(i.title.include?(options.find) or
                               i.description.include?(options.find))}
      end

      issues = issues.sort_by{|i| i.created_at}
      formatter = options.formatter
      formatter ||= "withtags"


      write_output [Issue.table_header(formatter),
                    issues.map{|i| i.as_table_row(formatter) }.join("\n")].join("\n")
    end
    @@help_message ="\
Queries the issue datastore.

Usage:   git issue list [default_tag_specifier] [options]

Default tag specifier:
  When present, the default tag specifier restricts results to issues with the
  default tag set to the queried value. For example, if the default tag is
  'kind' (which is the default default tag), then `git issue list feature` will
  present all open issues with the tag kind:feature.

Options:
  -a, --all
    includes all issues in the resultset, including closed issues.
  -t, --tag TAGS
    limits results to issues with tags matching TAGS
  -n, --not-tag TAGS
    limits results to issues without tags matching TAGS
  -f, --find SEARCH_STRING
    limits results to issues containing SEARCH_STRING in the title or
    description.
  -p, --pretty FORMAT=withtags
    specifies the output format for the matching issues.  Currently available
    options are 'oneline', 'withtags', and 'detail'

Examples:
  git issue list                       # all open issues
  git issue list bug -t priority:high  # all open bugs with priority=high
  git issue list feature -n milestone  # open features without a milestone
  git issue list feature -t milestone:v2.1.?  # features for version 2.1.x
  git issue list bug -t assigned_to:c* # bugs assigned to chris, cathy, etc.
"
  end
end