# Contributing to claude-scripts

How the repo is organized and how to add a command. For installation and usage,
see the [README](README.md).

## Layout

```
bin/      one executable Bash script per command (no extension), on PATH
shared/   helpers sourced by the commands
```

Shared helpers:

| File                | What it provides                                                                 |
| ------------------- | -------------------------------------------------------------------------------- |
| `shared/colors.sh`  | color support (`colors_enabled`), disabled on `NO_COLOR`, `--no-color` or a pipe |
| `shared/output.sh`  | reads the final `claude` result event and prints model, duration, cost and text  |
| `shared/spinner.sh` | spinner shown while `claude` runs (silent when no terminal is attached)          |

Each command sources what it needs relative to its own path, for example:

```bash
source "$(dirname "$0")/../shared/spinner.sh"
source "$(dirname "$0")/../shared/output.sh"
```

## Adding a command

1. Create an executable Bash script in `bin/` named after the command, no extension (`chmod +x`).
2. Source the shared helpers it needs from `shared/`.
3. Support `-h` / `--help` and `--no-color`, and print the model, run time and cost before the result (reuse `shared/output.sh`), so it behaves like the existing commands.
4. Document it in the README under `## Commands` with a usage example.

## Requirements

- [`claude`](https://docs.anthropic.com/claude/docs/claude-code) CLI
- [`jq`](https://jqlang.github.io/jq/)
- `git`, `bash`

## Conventions

- Commits follow [Conventional Commits](https://www.conventionalcommits.org/) in
  US English (`feat:`, `fix:`, `docs:`, `chore:`), matching the existing history.
- Keep machine-specific paths, hostnames and account names out of committed code
  and docs.
