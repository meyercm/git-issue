---
layout: default
---
[back to issues](..)

## \#b0378c39: crash in 'git issue new bug' with  empty message

###Status: **Closed**
_created by meyer.cm@gmail.com (Chris Meyer) at 2015-09-06 10:51:39 -0400_

It should have just aborted cleanly.

##Stacktrace:

```
$ git issue new bug
/Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/base_command.rb:36:in `clean_message!': undefined method `strip' for nil:NilClass (NoMethodError)
	from /Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/base_command.rb:28:in `get_message_from_editor'
	from /Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/new_command.rb:30:in `run'
	from /Users/ChrisMeyer/projects/git-issues/src/git_issue.rb:12:in `parse_and_run'
	from /usr/local/bin/git-issue:6:in `<main>'
```

set "kind" => "bug"  
_meyer.cm@gmail.com (Chris Meyer) at 2015-09-06 10:51:39 -0400_
