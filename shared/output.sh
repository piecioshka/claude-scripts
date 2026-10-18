#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

# Reads the final result event of `claude` from stdin and prints the model,
# duration, cost and the result text.
# Usage:
#   with_claude_spinner -p "prompt" | print_claude_result
print_claude_result() {
  local json
  json="$(cat)"
  if [[ -z "$json" ]]; then
    print_error "Claude returned no result."
    return 1
  fi

  local model duration cost result is_error
  model=$(jq -r 'if (.model // "") != "" then .model else (.modelUsage // {} | keys | join(", ")) end' <<< "$json")
  duration=$(jq -r '(.duration_ms // 0) / 100 | round / 10' <<< "$json")
  cost=$(jq -r '(.total_cost_usd // 0) * 10000 | round / 10000' <<< "$json")
  result=$(jq -r '.result // ""' <<< "$json")
  is_error=$(jq -r '.is_error // false' <<< "$json")

  printf '%sModel:%s %s%s%s\n' "$DIM" "$RESET" "$MAGENTA" "${model:-unknown}" "$RESET"
  printf '%sTime:%s  %s%ss%s\n' "$DIM" "$RESET" "$YELLOW" "$duration" "$RESET"
  printf '%sCost:%s  %s$%s%s\n' "$DIM" "$RESET" "$GREEN" "$cost" "$RESET"
  echo

  if [[ "$is_error" == "true" ]]; then
    printf '%s%s%s\n' "$RED" "$result" "$RESET"
    return 1
  fi
  printf '%s\n' "$result" | colorize_markdown
}

# Highlights Markdown headings, bullets, bold text and inline code.
# Passes text through unchanged when colors are disabled.
colorize_markdown() {
  if [[ -z "$RESET" ]]; then
    cat
    return
  fi
  sed -E \
    -e "s/^(#+ .*)$/${BOLD}${BLUE}\1${RESET}/" \
    -e "s/^([[:space:]]*)([-*]|[0-9]+\.) /\1${CYAN}\2${RESET} /" \
    -e "s/\*\*([^*]+)\*\*/${BOLD}\1${RESET}/g" \
    -e "s/\`([^\`]+)\`/${YELLOW}\1${RESET}/g"
}
