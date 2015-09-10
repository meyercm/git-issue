---
:key: :description
:value: |-
  I think the issue is that the subdir doesn't exist in the issues
  branch, and so the shell is hosed, and can't find the git dir to
  make changes, commit, switch back.  Probably need to add change
  of directory to the 'work_on_issues_branch' function.
