# Tips and good practices 


## Configuring your browser

If you encounter some troubles with HTTP/HTTPS redirect policy, take a look to [Disable HTTPS Redirect in Firefox](https://itadminguide.com/disable-https-redirect-in-firefox/). Changing web browser or testing with curl may help.

## Git

### Use case : rebase a branch from your fork onto {MainProject}/develop

From the `src/` directory :
```sh
git remote add mf git@github.com:{your-github-username}/{project-repo}.git
git fetch mf
git checkout mf/my_branch
git rebase -i develop
git push -f origin develop
```

> ⚠️ **Caution**: Force-pushing (git push -f) can overwrite remote history. Use with caution and always communicate with your team.

### Use case : resolve conflicts during a rebase

```sh
Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".
```

### Use case: Edit or insert a commit in git history

To modify an old commit or insert a new one after it:

* ```sh
    git rebase --interactive '{commit id}^'
    ```
    > The ^ symbol indicates the commit before the one you want to edit.
* In the interactive editor, change pick to edit on the desired commit.
* Save and exit.
    > At this point, '{commit id}' is your last commit (as if you had just created it) and you can easily amend it.
* Make your changes :
  * Use `git commit --amend` to edit the selected commit
  * Or git commit to insert a new one
* Continue the rebase : `git rebase --continue`

> Resources :
> - [Rewriting-history](https://backlog.com/git-tutorial/rewriting-history/) 
> - [How to modify a specified commit?](https://stackoverflow.com/questions/1186535/how-to-modify-a-specified-commit)


### Use case: find the commit that introduced a bug (`git bisect`)

Git can help you locate a bug by binary search:
```sh
git bisect start
git bisect bad                     # current commit is bad
git bisect good {known-good-commit}
```

Then, for each step:
```sh
# Test and indicate the result:
git bisect good     # or
git bisect bad
```

Once the culprit is found:
```sh
git bisect reset
```

### Use case : insert a commit at a specific point in history

See this guide for more details: [Inserting a new commit in the Git history](https://blog.frankel.ch/inserting-new-commit-git-history/)


### Use case : clean up local branches that no longer exist remotely

To list local branches that have been deleted on the remote
```sh
git remote prune origin --dry-run
```

To remove them
```sh
git remote prune origin
```
