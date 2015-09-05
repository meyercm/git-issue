---
:key: :description
:value: |-
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
