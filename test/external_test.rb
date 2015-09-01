require 'tempfile'
git_issue = File.expand_path('../../git-issue', __FILE__)


Dir.mktmpdir do |d|
  Dir.mktmpdir do |d2|
    #test setup
    Dir.chdir(d)
    `mkdir test`
    Dir.chdir("#{d}/test")
    `git init`
    `echo "test" > test.txt`
    `git add .`
    `git commit -m "initial commit"`

    `#{git_issue} new -m "issue1"`
    list_output = `#{git_issue} list`
    lines = list_output.split("\n")
    fail "list_output" unless lines.length == 3
    print "."
    fail "list_output" unless lines[2].include?("issue1")
    print "."

    Dir.chdir(d2)
    `git clone #{d}/test`
    Dir.chdir("#{d2}/test")
    cloned_list_output = `#{git_issue} list`
    lines = cloned_list_output.split("\n")
    fail "cloned_list_output" unless lines.length == 3
    print "."
    fail "cloned_list_output" unless lines[2].include?("issue1")
    print "."
    fail "cloned_list_output" unless cloned_list_output == list_output
    print "."

    puts
  end
end