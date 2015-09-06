

# git-issue
Git extension command for distributed [feature | bug | todo | etc.] tracking within the repository.  Inspired by the now defunct [git-issues](https://github.com/duplys/git-issues) python script.

Issues for git-issue are tracked with git-issue. Clone the repo, or try the [read-only web version](http://meyercm.github.io/git-issue/issues)

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

The strategy `git-issue` uses to solve these problems: create a new branch (by default: `issues`), and store all information related to issues there.  By using a non-development branch, changes can be made to the issues branch without requiring the complicated (and arbitrary) merges described above.

Issues are represented as files within folders; each issue is composed of multiple files- so that if two developers modify an issue, manual merging will only be required if they modify the same part of the issue- the title, for instance.  An example issue's structure:

```
./4bf8665f544328ac8d416eb2e002e71961e779db
├── events
│   ├── 3f8e1906136f1ca3f8507b0289bb9acfd4e6dbdd.event
│   ├── 997ea9f5bb4937422386a8974aca52fea8ff77fa.event
│   ├── bdc1f616ea55aaa9ff554955dfd1a70ecac76f9a.event
│   └── e5b178e4e7e8001ca9651e9f02fa7a255d5d6588.event
└── tags
    ├── assigned_to.tag
    ├── created_at.tag
    ├── creator.tag
    ├── description.tag
    ├── kind.tag
    ├── status.tag
    └── title.tag
```

Each tag is represented in it's own file as the yaml encoding of a hash: {key: tag_name, value: tag_value}. By storing them in separate files, two independent contributors can modify an issue's tags without a merge conflict, until they attempt to modify the same tag.  Also note that key issue metadata (:title, :description, etc.) is stored as tags, for consistent and simple issue editing.

Issue events provide historical tracking information (without needing to parse the git history). They include comments and the setting of issue properties and tags.  Just as with Tags, Events are also yaml-encoded hashes, with the following keys: [:creator :title :text :created_at :event_type :event_id].

##Installation and Dependencies

####Requirements:
 - a *nix-like OS: Linux, BSD, OSX, etc.
 - Ruby >= 1.8.7
 - Git >= ?.?.?

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
