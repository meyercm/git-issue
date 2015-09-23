---
layout: default
---
[back to issues](..)

## \#f234bb32: need to convert tags into atoms

###Status: **Open**
_created by meyer.cm@gmail.com (Chris Meyer) at 2015-09-23 14:26:30 -0400_

tag keys that come from the command line (e.g. git issue new bug, or
git issue tag deadbeef status:in_progress) are stored as strings, not atoms

this is linked to df64ef87.

set "kind" => "bug"  
_meyer.cm@gmail.com (Chris Meyer) at 2015-09-23 14:26:31 -0400_
