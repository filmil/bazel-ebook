# General change rules

Do not change files in `//third_party` without user's explicit permission.

## General git commit rules

Any git commit created by Gemini must contain this note as the last line in the
commit message in addition to any commit summaries added:

```
This commit has been created by an automated coding assistant,
with human supervision.
```

Also append the prompt used to generate the commit in full.

## Prefer rebase over merge

Instead of creating merges into a branch try to rebase the current branch on
top of another.

For example, to get content from branch `main` from the `origin` repo use `git
rebase --pull origin main`.

## Create pull request

Use the `gh` utility to create the pull request.

Use the remote `origin/main` as a baseline for the pull request.

Any pull request you create must contain this note as the last line in the
commit message in addition to any commit summaries added:

```
This pull request has been created by an automated coding assistant,
with human supervision.
```

Also append the prompt used to generate the pull request in full.

Rebase the branch `main` from remote `origin/main`.

Create a new branch from this branch. Use name pattern `ai-dev-XXX` where XXX
is replaced with date encoded as `YYYYMMDD` and a short nonce. Push the current
branch to remote.

Create the pull request, using in the pull request description a summary of all
the commits between `origin/main` and the top of this branch that will be part
of this pull request.

Once the `gh` command to create the pull request completes, the task is done.
