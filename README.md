# claude-scripts

🔨 Claude Code utility scripts

## Installation

```bash
cd ~/projects/ # or any workspace what you use
git clone git@github.com:piecioshka/claude-scripts.git

# Bash: please add to `~/.bash_profile`
export PATH="$HOME/projects/claude-scripts/bin/:$PATH"

# Fish: please add to `~/.config/fish/config.fish`
set -gx PATH $HOME/projects/claude-scripts/bin/ $PATH
```

**TIP**: After changing the shell configuration, restart the terminal to apply the new settings.

## Requirements

- [`claude`](https://docs.anthropic.com/claude/docs/claude-code) CLI
- [`jq`](https://jqlang.github.io/jq/)
- `git`, `bash`

## Commands

All commands support `-h` / `--help`.

### [`what-did-i-do-this-week`](bin/what-did-i-do-this-week)

Summarize this week's git activity in the **current repository**. Runs `git log` (since last Monday, authored by you) and `git status`, then asks Claude to summarize.

```bash
cd ~/projects/my-repo
what-did-i-do-this-week
```

### [`what-did-i-do-this-week-workspace`](bin/what-did-i-do-this-week-workspace)

Summarize this week's git activity across **all repositories** in a workspace directory. For each subdirectory containing a `.git` folder, runs `git log` on the `main` (or `master`) branch since last Monday, then asks Claude to summarize.

```bash
# scan current directory
what-did-i-do-this-week-workspace

# scan a specific workspace
what-did-i-do-this-week-workspace ~/projects
```

## Project layout

- [`bin/`](bin/) — executable commands, added to `$PATH`
- [`shared/`](shared/) — sourced helpers (e.g. spinner)
- `tmp/` — local scratch files (created on demand, git-ignored)

## License

[The MIT License](https://piecioshka.mit-license.org) @ 2026
