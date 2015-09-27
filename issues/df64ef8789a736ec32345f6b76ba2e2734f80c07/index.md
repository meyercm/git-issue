---
layout: default
---
[back to issues](..)

## \#df64ef87: crash in issue list from single-branch clone

###Status: **Closed**
_created by meyer.cm@gmail.com (Chris Meyer) at 2015-09-23 13:23:29 -0400_

cloned a large repo, with the single branch option.  then ran git-issue list
and got a stacktrace:

git-issue:546:in `status': undefined method `value' for nil:NilClass (NoMethodError)
1056 in run
1056 in delete_if
1056 in run
1538 in parse_and_run
1566


source commit ff3fc9f3
on ruby187

set "kind" => "bug"  
_meyer.cm@gmail.com (Chris Meyer) at 2015-09-23 13:23:30 -0400_
