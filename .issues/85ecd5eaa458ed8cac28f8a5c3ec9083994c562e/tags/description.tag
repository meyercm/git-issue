---
:key: :description
:value: |-
  Currently, we are switching branches in the actual repo in use- instead,
  we could clone the repo locally, checkout issues there and then push the
  changes back.  This approach requires the --orphan todo, and will not work
  if the user already has the issues branch checked out- so we will need to
  fallback to the current mode of operation.
