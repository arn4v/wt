# wt

Minimal git worktree helper.

`wt` keeps worktrees under a predictable path:

```text
$WORKTREE_ROOT/<repo>/<branch>
```

Default root:

```text
~/dev/worktrees
```

## Why

- Small wrapper around native `git worktree`
- Fast jump/create flow
- GitHub PR checkout via `gh`
- Optional auto-`cd` and shell completion
- Copies existing `node_modules` into new worktrees

## Acknowledgement

`wt` was vibe-forked from Phil Haack's [Tree Me](https://haacked.com/archive/2025/11/21/tree-me/).

## Requirements

- `bash`
- `git`
- `gh` for `wt pr`
- macOS-style `cp -cR` support for the `node_modules` clone step

Run `wt` from inside a git repo.

## Install

Put `wt` somewhere on your `PATH`, make it executable:

```bash
chmod +x wt
```

## Shell setup

Without shell setup, `wt` prints the target path. With shell setup, `wt create`, `wt pr`, and `wt jump` will also `cd` into the selected worktree.

Add this to `~/.zshrc` or `~/.bashrc`:

```bash
source <(wt shellenv)
```

This also enables tab completion for commands and worktree branches.

## Commands

```bash
wt create <branch> [base]
wt pr <number|url>
wt jump [branch|query]
wt list
wt remove [branch]
wt prune
wt shellenv
```

### `wt create <branch> [base]`

- Creates a worktree at `$WORKTREE_ROOT/<repo>/<branch>`
- If local branch exists, links it
- If remote branch exists, creates a local tracking branch
- Else creates a new branch from `[base]`
- Default base is `origin/HEAD`, fallback `main`
- If the branch already has a worktree, reuses it

Examples:

```bash
wt create my-feature
wt create my-feature develop
```

### `wt pr <number|url>`

- Resolves the PR head branch with `gh`
- Creates or reuses a worktree for that branch
- Accepts either a PR number or GitHub PR URL

Examples:

```bash
wt pr 123
wt pr https://github.com/org/repo/pull/123
```

### `wt jump [branch|query]`

- With an exact branch/path match, jumps there
- With a partial match, prompts if multiple worktrees match
- If no worktree exists but the branch exists locally or on `origin`, creates one
- With no argument, shows an interactive worktree picker

Examples:

```bash
wt jump feature-branch
wt jump api
wt jump
```

Aliases: `wt j`, `wt cd`

### `wt list`

Shows `git worktree list`.

```bash
wt list
```

Alias: `wt ls`

### `wt remove [branch]`

- Removes the matching worktree
- With no argument, opens an interactive multi-select prompt
- Interactive mode excludes the current worktree

Examples:

```bash
wt remove old-branch
wt remove
```

Alias: `wt rm`

### `wt prune`

Runs:

```bash
git worktree prune
```

## Notes

- Interactive `jump` and `remove` need a TTY
- `wt` derives the repo name from `origin`, fallback repo dir name
- New worktrees copy any existing `node_modules` directories from the current worktree
