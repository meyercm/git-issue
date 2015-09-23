---
:key: :description
:value: |-
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
