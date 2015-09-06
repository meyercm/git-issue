---
:key: :description
:value: |-
  I think the issue is based on a non-0 return from commit because the generated
  files were identical to the originals.  Maybe add a generation timestamp to
  be displayed so that it will be able to commit even if most of the page is still
  the same.

  ##Stacktrace:
  ```
  $> git issue publish
  Switched to branch 'gh-pages'
  Switched to branch 'master'
  error in git command: git commit -m git-issue\ publish\ issues
  ["/Users/ChrisMeyer/projects/git-issues/src/git_issue/git_worker.rb:13:in `run'", "/Users/ChrisMeyer/projects/git-issues/src/git_issue/git_worker.rb:106:in `commit'", "/Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/publish_command.rb:32:in `block in run'", "/Users/ChrisMeyer/projects/git-issues/src/git_issue/git_worker.rb:181:in `call'", "/Users/ChrisMeyer/projects/git-issues/src/git_issue/git_worker.rb:181:in `work_on_branch'", "/Users/ChrisMeyer/projects/git-issues/src/git_issue/commands/publish_command.rb:25:in `run'", "/Users/ChrisMeyer/projects/git-issues/src/git_issue.rb:12:in `parse_and_run'", "/usr/local/bin/git-issue:6:in `<main>'"]
  ```
