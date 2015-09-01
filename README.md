

# git-issue
Git extension command for distributed (feature|bug|todo|etc.) tracking within the repository.  Inspired by the now defunct [git-issues](https://github.com/duplys/git-issues) python script.

## Quick Example
- open a new issue
- list issues
- close the issue
- list the issues again to see that it's gone.

``` bash
$> git issue new todo -m "Write a better example for README.md"
Switched to branch 'issues'
Switched to branch 'master'
6d3ed3dd successfully created
$>
$> git issue list todo
Status  ID        Title
-------------------------------------------------------------------------------
Open    deadbeef  Kill more cows!
  Tags: assigned_to:Chris  kind:todo milestone:2.0.0
Open    6d3ed3dd  Write a better example for README.md
  Tags: assigned_to:Chris  kind:todo
$>
$> # writing some documentation...
$> git issue close 6de
Switched to branch 'issues'
Switched to branch 'master'
6d3ed3dd successfully closed
$>
$> git issue list todo
Status  ID        Title
-------------------------------------------------------------------------------
Open    deadbeef  Kill more cows!
  Tags: assigned_to:Chris  kind:todo milestone:2.0.0
```
##General Notes on Use
- As needed, create an issue with `git issue new`. A convenience exists to initially add a `kind` tag, e.g. `git issue new feature` creates an issue tagged with `kind:feature`.  This default tag is configurable, see `git issue show --config`.
- Issues are referenced by a standard git hash.  In any command, they may be abbreviated with the first few hex characters, provided they uniquely identify a single issue.
- Once an issue exists, it may be edited with `git issue edit <issue id>`, which will open an editor to set the title and description of the issue.
- Comments can be added to the issue with `git issue comment <issue id>`, and additional tags may be applied with `git issue tag`
- `git issue show` will provide a detailed view of all aspects of an issues's history.
- `git issue list` is an essential command for querying amongst the existing issues. It includes options for seeing previously closed issues, as well as limiting results based on tags, or searching for particular text in the title or description.
- Once an issue is complete, it may be closed with `git issue close <issue id>`. Closed issues no longer appear in `git issue list` unless the `--all` option is specified.
- Alternately, an accidentally created issue may be removed with `git issue delete <issue id>`, although the issue will remain in the repository's history.
- When all else fails, `git issue help` might see you straight.

##Discussion
`git-issue` aims to solve two problems.

 1. Issue tracking on a central server (github, bugzilla, etc.) is problematic:
   - Connectivity- A developer's workflow is dependent on a connection; when disconnected, they must rely on notes, todo lists, comments, or worse: their memory.  When they regain their connection, they must 'catch-up' and update the issue server.
   - Ownership- Organizations that can setup their own tracking server do have ownership of their data, but individuals using a 'free' service on the internet only have their data at the sufferance of the service provider.
 2. Distributed options are [limited, and not being maintained](http://stackoverflow.com/questions/2186628/textbased-issue-tracker-todo-list-for-git).
     - The naive (and common) solution uses a TODO file or a BUGS file at the root of the project; this works fine for a single developer; but when two developers contribute to the same TODO file, they will eventually need to address conflicts in the file with a manual merge.   Additionally, when used in a project with a complicated branching strategy e.g. [gitflow](http://nvie.com/posts/a-successful-git-branching-model/), the TODO file will require out of the ordinary merges to be available (think of a new TODO item created on a hotfix branch being available on a feature/topic branch).
     - Solutions do exist- however, as mentioned above, there isn't an option that is being currently maintained.

`git-issue` is an extension to git: when the file is located on your path, it can be invoked by typing `git issue <subcommand>`. Note that `git-issue` is very lightly opinionated- it does insist on being invoked inside an existing git repository that has at least one commit.

##Installation and Dependencies

####Requirements:
 - a *nix-like OS: Linux, BSD, OSX, etc.
 - Ruby >= 1.8.7
 - Git
####Installation:
 1. copy the file `git-issue` to a location of your choice on your computer.
 2. make the file executable.
 3. add the folder to your PATH.
#####One way to get it done:
``` bash
git clone https://github.com/meyercm/git-issue.git
cp git-issue/git-issue /usr/local/bin
chmod +x /usr/local/bin/git-issue
```
Now the commands should be accessible system-wide, provided that `/usr/local/bin` is already on the PATH.
