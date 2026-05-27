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

## Commands

- [`what-did-i-do-this-week`](bin/what-did-i-do-this-week): Summarize this week's git activity in the current repository.
- [`what-did-i-do-this-week-workspace [dir]`](bin/what-did-i-do-this-week-workspace): Summarize this week's git activity across all repositories in a given workspace directory (defaults to the current directory).
