---
layout: default
---
[back to issues](..)

## \#92fc9381: crash in ListCommand when specifiying a default tag.

###Status: **Closed**
_created by meyer.cm@gmail.com (Chris Meyer) at 2015-09-01 16:00:45 -0400_

##What: `git issue list feature` crashed.

##Stacktrace:
computer:git-issues ChrisMeyer$ git issue list feature
/Users/ChrisMeyer/projects/git-issues/src/git_issue/helper.rb:31:in `block in tags_match': undefined method `value' for ["kind", "feature"]:Array (NoMethodError)
	from /Users/ChrisMeyer/projects/git-issues/src/git_issue/helper.rb:30:in `each'
	from /Users/ChrisMeyer/projects/git-issues/src/git_issue/helper.rb:30:in `all?'
	from /Users/ChrisMeyer/projects/git-issues/src/git_issue/helper.rb:30:in `tags_match'
	from /Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/list_command.rb:43:in `block in run'
	from /Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/list_command.rb:43:in `delete_if'
	from /Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/list_command.rb:43:in `run'
	from /Users/ChrisMeyer/projects/git-issues/src/git_issue.rb:11:in `parse_and_run'
	from /usr/local/bin/git-issue:6:in `<main>'

set "kind" => "bug"  
_meyer.cm@gmail.com (Chris Meyer) at 2015-09-01 16:00:45 -0400_
