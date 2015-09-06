---
:key: :description
:value: "It should have just aborted cleanly.\n\n##Stacktrace:\n\n```\n$ git issue
  new bug\n/Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/base_command.rb:36:in
  `clean_message!': undefined method `strip' for nil:NilClass (NoMethodError)\n\tfrom
  /Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/base_command.rb:28:in
  `get_message_from_editor'\n\tfrom /Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/new_command.rb:30:in
  `run'\n\tfrom /Users/ChrisMeyer/projects/git-issues/src/git_issue.rb:12:in `parse_and_run'\n\tfrom
  /usr/local/bin/git-issue:6:in `<main>'\n```"
