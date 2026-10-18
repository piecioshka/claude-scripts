#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

# Prints one spinner frame to the terminal.
# The spinner always writes to /dev/tty, so only NO_COLOR disables its colors.
_spinner_frame() {
  local frame="$1" message="$2" elapsed="$3"
  if [[ -z "${NO_COLOR:-}" ]]; then
    printf "\r\033[K\033[36m%s\033[0m %s \033[2m(%ds)\033[0m" "$frame" "$message" "$elapsed" > /dev/tty
  else
    printf "\r\033[K%s %s (%ds)" "$frame" "$message" "$elapsed" > /dev/tty
  fi
}

# Runs a command with an animated spinner and elapsed time.
# The command's stdout goes to the function's stdout — can be piped further.
# Usage:
#   with_spinner "Working..." some_command --flag arg | jq ...
with_spinner() {
  local message="$1"
  shift
  local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  local start
  start=$(date +%s)

  exec 3< <("$@")
  local pid=$!

  while kill -0 "$pid" 2>/dev/null; do
    i=$(( (i + 1) % ${#frames} ))
    local elapsed=$(( $(date +%s) - start ))
    _spinner_frame "${frames:$i:1}" "$message" "$elapsed"
    sleep 0.1
  done
  printf "\r\033[K" > /dev/tty

  cat <&3
  exec 3<&-
}

# Runs `claude` with stream-json and shows live status (current tool / activity).
# Emits only the final result event on stdout for downstream processing,
# extended with the "model" field taken from the init event.
# Usage:
#   with_claude_spinner -p "prompt" --allowedTools "..." | jq ...
with_claude_spinner() {
  local shared_dir
  shared_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local tmp_dir="$shared_dir/../tmp"
  mkdir -p "$tmp_dir"
  local status_file result_file model_file
  status_file=$(mktemp "$tmp_dir/spinner-status.XXXXXX")
  result_file=$(mktemp "$tmp_dir/spinner-result.XXXXXX")
  model_file=$(mktemp "$tmp_dir/spinner-model.XXXXXX")
  echo "Starting..." > "$status_file"

  (
    claude --output-format stream-json --verbose "$@" | while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      local type
      type=$(jq -r '.type // empty' <<< "$line" 2>/dev/null)
      case "$type" in
        system)
          echo "Initializing" > "$status_file"
          local model
          model=$(jq -r '.model // empty' <<< "$line" 2>/dev/null)
          [[ -n "$model" ]] && echo "$model" > "$model_file"
          ;;
        assistant)
          local tool
          tool=$(jq -r '[.message.content[]? | select(.type=="tool_use") | .name][0] // empty' <<< "$line" 2>/dev/null)
          if [[ -n "$tool" ]]; then
            local input
            input=$(jq -r '[.message.content[]? | select(.type=="tool_use") | (.input.command // .input.file_path // .input.pattern // "")][0] // empty' <<< "$line" 2>/dev/null)
            if [[ -n "$input" ]]; then
              echo "$tool: $input" > "$status_file"
            else
              echo "$tool" > "$status_file"
            fi
          else
            echo "Thinking" > "$status_file"
          fi
          ;;
        user)
          echo "Processing result" > "$status_file"
          ;;
        result)
          jq -c --arg model "$(cat "$model_file")" '. + {model: $model}' <<< "$line" > "$result_file"
          ;;
      esac
    done
  ) &
  local parser_pid=$!

  local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  local start
  start=$(date +%s)
  while kill -0 "$parser_pid" 2>/dev/null; do
    i=$(( (i + 1) % ${#frames} ))
    local elapsed=$(( $(date +%s) - start ))
    local status
    status=$(cat "$status_file" 2>/dev/null)
    _spinner_frame "${frames:$i:1}" "$status" "$elapsed"
    sleep 0.1
  done
  printf "\r\033[K" > /dev/tty
  wait "$parser_pid" 2>/dev/null

  cat "$result_file"
  rm -f "$status_file" "$result_file" "$model_file"
}
