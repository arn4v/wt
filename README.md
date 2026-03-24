# wt

Minimal git worktree helper.

Worktrees live at `$WORKTREE_ROOT/<repo>/<branch>`. Default: `~/dev/worktrees`.

`wt` was vibe-forked from Phil Haack's [Tree Me](https://haacked.com/archive/2025/11/21/tree-me/).

## Requirements

- `bash`
- `git`
- `gh` for `wt pr`

Run `wt` inside a git repo.

## Install

```bash
git clone https://github.com/arn4v/wt.git
cd wt
chmod +x wt
mkdir -p ~/.bin
ln -sf "$PWD/wt" ~/.bin/wt
grep -qxF 'export PATH="$HOME/.bin:$PATH"' ~/.zshrc || echo 'export PATH="$HOME/.bin:$PATH"' >> ~/.zshrc
grep -qxF 'eval "$(wt shellenv)"' ~/.zshrc || echo 'eval "$(wt shellenv)"' >> ~/.zshrc
exec $SHELL -l
```

Use `~/.bashrc` instead of `~/.zshrc` if needed.

## Agent Prompt

```text
Install https://github.com/arn4v/wt for me. Clone it if needed, symlink the repo's `wt` script to `~/.bin/wt`, ensure `~/.bin` is on my PATH, add `eval "$(wt shellenv)"` to my shell rc (`~/.zshrc` or `~/.bashrc`) without duplicates, and do not use `source <(wt shellenv)` in bash because `wt` needs a shell function for auto-`cd` and `eval` is the reliable setup path. Reload the shell, then show `type wt` and the `~/.bin/wt` symlink target.
```

## Usage

```bash
wt create <branch> [base]
wt pr <number|url>
wt jump|j|cd [branch|query]
wt main
wt list|ls
wt remove|rm [branch|path|query]
wt prune
wt shellenv
```

## Notes

- `eval "$(wt shellenv)"` is required for auto-`cd`
- Do not use `source <(wt shellenv)` in bash
- `wt create` uses `origin/HEAD`, then `main`, then `master`
- `wt remove` accepts a branch, worktree basename, or full path
- `wt remove` excludes the main checkout from interactive removal

## Hooks

After creating a worktree, `wt` runs:

- `$WT_SETUP_HOOK`, if set
- `.wt-hook` in repo root, if present

Hook env:

- `WT_SOURCE_PATH`
- `WT_WORKTREE_PATH`
- `WT_BRANCH`
- `WT_BASE_BRANCH`
- `WT_PR_NUMBER`
- `WT_REPO`

`wt` runs the hook with `bash` from inside the new worktree.

To keep the old `node_modules` copy behavior:

```bash
cp examples/copy-node-modules-hook.sh .wt-hook
```
