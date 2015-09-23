---
layout: default
---
[back to issues](..)

## \#502621e9: blows up from subdirectories

###Status: **Closed**
_created by meyer.cm@gmail.com (Chris Meyer) at 2015-09-10 12:18:20 -0400_

I think the issue is that the subdir doesn't exist in the issues
branch, and so the shell is hosed, and can't find the git dir to
make changes, commit, switch back.  Probably need to add change
of directory to the 'work_on_issues_branch' function.

set "kind" => "bug"  
_meyer.cm@gmail.com (Chris Meyer) at 2015-09-10 12:18:20 -0400_
