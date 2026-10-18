#!/usr/bin/env bash

# Color support shared by all commands.
# Colors are disabled when NO_COLOR is set (https://no-color.org),
# when --no-color is passed, or when the output is not a terminal.

# Returns 0 when colors may be used on the given file descriptor.
colors_enabled() {
  local fd="${1:-1}"
  [[ -z "${NO_COLOR:-}" && "${TERM:-}" != "dumb" && -t "$fd" ]]
}

# Sets color variables for stdout (BOLD, RED, ...) and stderr (E_BOLD, E_RED, ...).
setup_colors() {
  local names=(BOLD DIM RED GREEN YELLOW BLUE MAGENTA CYAN RESET)
  local codes=($'\033[1m' $'\033[2m' $'\033[31m' $'\033[32m' $'\033[33m' $'\033[34m' $'\033[35m' $'\033[36m' $'\033[0m')
  local i
  for i in "${!names[@]}"; do
    if colors_enabled 1; then
      printf -v "${names[$i]}" '%s' "${codes[$i]}"
    else
      printf -v "${names[$i]}" '%s' ""
    fi
    if colors_enabled 2; then
      printf -v "E_${names[$i]}" '%s' "${codes[$i]}"
    else
      printf -v "E_${names[$i]}" '%s' ""
    fi
  done
}

# Prints an error message in red to stderr.
print_error() {
  printf '%s%s%s\n' "$E_RED" "$*" "$E_RESET" >&2
}

# Prints a warning message in yellow to stderr.
print_warning() {
  printf '%s%s%s\n' "$E_YELLOW" "$*" "$E_RESET" >&2
}

# Prints an informational message in cyan to stdout.
print_info() {
  printf '%s%s%s\n' "$CYAN" "$*" "$RESET"
}

setup_colors
