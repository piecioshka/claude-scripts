# claude-scripts

<!-- prettier-ignore-start -->
[![License: MIT](https://img.shields.io/github/license/piecioshka/claude-scripts)](https://piecioshka.mit-license.org)
[![Last commit](https://img.shields.io/github/last-commit/piecioshka/claude-scripts)](https://github.com/piecioshka/claude-scripts/commits/main)
[![Built for Claude Code](https://img.shields.io/badge/built%20for-Claude%20Code-d97757)](https://docs.anthropic.com/claude/docs/claude-code)
[![Shell: Bash](https://img.shields.io/badge/shell-bash-4eaa25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
<!-- prettier-ignore-end -->

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

## Commands

All commands support `-h` / `--help`.

### [`ai-commit`](bin/ai-commit)

Commit the current changes in the **current repository**. Claude reads `git status`, `git diff` and the recent `git log`, learns the commit message conventions of the repo (Conventional Commits, scopes, language) and creates one or more commits that follow them. When something is staged, only the staged changes are committed. It never pushes, amends or rewrites history.

```bash
cd ~/projects/my-repo
ai-commit
ai-commit "one commit only"
```

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

### Export to PDF

`what-did-i-do-this-week` and `what-did-i-do-this-week-workspace` print the summary as Markdown on stdout (the spinner goes to the terminal only), so you can pipe it to [`md-to-pdf`](https://github.com/simonhaenisch/md-to-pdf) to get a PDF file:

```bash
what-did-i-do-this-week | npx md-to-pdf > this-week.pdf

what-did-i-do-this-week-workspace ~/projects | npx md-to-pdf > this-week-workspace.pdf
```

## License

[The MIT License](https://piecioshka.mit-license.org) @ 2026

## Requirements

- [`claude`](https://docs.anthropic.com/claude/docs/claude-code) CLI
- [`jq`](https://jqlang.github.io/jq/)
- `git`, `bash`
