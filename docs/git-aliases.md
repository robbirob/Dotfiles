# Git Aliases (Zsh)

These aliases are defined in `home/common.nix` under `programs.zsh.initContent`.

Notes:
- `gs` is intentionally not used (can clash with ghostscript). Use `gst` instead.
- No `git push` alias is defined (intentional; avoids accidental pushes). Use `git push`.
- oh-my-zsh's `git` plugin is enabled; these aliases are added via `initContent` so they take precedence.

## Core
- `g` -> `git`
- `gc` -> `git clone`
- `gcm` -> `git commit -m`

## Add / Diff / Status
- `ga` -> `git add`
- `gaa` -> `git add -A`
- `gap` -> `git add -p`
- `gst` -> `git status -sb`
- `gd` -> `git diff`
- `gds` -> `git diff --staged`

## Branch / Switch
- `gco` -> `git checkout`
- `gcb` -> `git checkout -b`
- `gsw` -> `git switch`
- `gswc` -> `git switch -c`

## Log
- `gl` -> `git log --oneline --decorate --graph`
- `gll` -> `git log --oneline --decorate --graph --all`

## Pull
- `gpl` -> `git pull --rebase --autostash`
