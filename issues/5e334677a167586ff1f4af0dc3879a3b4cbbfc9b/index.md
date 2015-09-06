---
layout: default
---
[back to issues](..)

## \#5e334677: create a publish command to write to the gh-pages branch

###Status: **Closed**
_created by meyer.cm@gmail.com (Chris Meyer) at 2015-09-05 13:11:22 -0400_

Originally, I thought to have a sweet set of layouts that could simply interpret
the tags and events- but because GH always runs in safe mode, the code to do so
will be heinous-  a better option would be to have a command that creates a
portion of the gh-pages branch based on the contents of the issues branch.

maybe syntax like:
'git issue publish --branch gh-pages --path "issues"'
which would checkout gh-pages, clear the <root>/issues folder, and re-create
it based on the current content of issues

Once this is in place, we should add a config option: issue.auto-publish,
which allows any git-issue subcommand that writes to issues to automatically
publish the new version to gh-pages.

Also may need another config setting to auto push gh pages to a particular repo

set "kind" => "feature"  
_meyer.cm@gmail.com (Chris Meyer) at 2015-09-05 13:11:22 -0400_
