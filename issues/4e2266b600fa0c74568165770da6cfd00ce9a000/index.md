---
layout: default
---
[back to issues](..)

## \#4e2266b6: occasionally get wierd 'working dir' errors

###Status: **Closed**
_created by meyer.cm@gmail.com (Chris Meyer) at 2015-09-10 21:20:04 -0400_

seems to be happening from subdirectories, but it didn't happen in the manual
test repo.  Documenting to have a record.

set "kind" => "bug"  
_meyer.cm@gmail.com (Chris Meyer) at 2015-09-10 21:20:04 -0400_

---
new comment:

> #### confirmed.
> After the creation of this issue, I ran 'git status' as the next command, and
got 'fatal: Unable to read current working directory: No such file or directory'
back from git.  Typing 'cd $PWD' as suggested by SO seemed to fix the funky
state.

More reason to flip the write access to something other than full branch swap.

_meyer.cm@gmail.com (Chris Meyer) at 2015-09-10 21:27:43 -0400_


---
new comment:

> #### test idea
> Make another 'blind' test, but in the tempdir, clone the repo under test
I wonder if the bug isn't showing up in the test repos because they only have
a single folder/file, and 1 or 2 commits, vs. the real world, like this repo
with many files and commits, etc.

_meyer.cm@gmail.com (Chris Meyer) at 2015-09-10 21:37:21 -0400_

