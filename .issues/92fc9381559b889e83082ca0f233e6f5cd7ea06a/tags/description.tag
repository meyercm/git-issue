---
:key: :description
:value: "##What: `git issue list feature` crashed.\n\n##Stacktrace:\ncomputer:git-issues
  ChrisMeyer$ git issue list feature\n/Users/ChrisMeyer/projects/git-issues/src/git_issue/helper.rb:31:in
  `block in tags_match': undefined method `value' for [\"kind\", \"feature\"]:Array
  (NoMethodError)\n\tfrom /Users/ChrisMeyer/projects/git-issues/src/git_issue/helper.rb:30:in
  `each'\n\tfrom /Users/ChrisMeyer/projects/git-issues/src/git_issue/helper.rb:30:in
  `all?'\n\tfrom /Users/ChrisMeyer/projects/git-issues/src/git_issue/helper.rb:30:in
  `tags_match'\n\tfrom /Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/list_command.rb:43:in
  `block in run'\n\tfrom /Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/list_command.rb:43:in
  `delete_if'\n\tfrom /Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/list_command.rb:43:in
  `run'\n\tfrom /Users/ChrisMeyer/projects/git-issues/src/git_issue.rb:11:in `parse_and_run'\n\tfrom
  /usr/local/bin/git-issue:6:in `<main>'"
