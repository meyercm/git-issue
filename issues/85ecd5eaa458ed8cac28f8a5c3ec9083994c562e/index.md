---
layout: default
---
[back to issues](..)

## \#85ecd5ea: attempt to clone to /tmp for write operations

###Status: **Open**
_created by meyer.cm@gmail.com (Chris Meyer) at 2015-09-05 13:01:34 -0400_

Currently, we are switching branches in the actual repo in use- instead,
we could clone the repo locally, checkout issues there and then push the
changes back.  This approach requires the --orphan todo, and will not work
if the user already has the issues branch checked out- so we will need to
fallback to the current mode of operation.

set "kind" => "experiment"  
_meyer.cm@gmail.com (Chris Meyer) at 2015-09-05 13:01:34 -0400_

---
new comment:

> #### git clone has --single-branch option
> Available in git >= 1.7.10.

_meyer.cm@gmail.com (Chris Meyer) at 2015-09-05 16:40:03 -0400_

