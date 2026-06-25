#!/usr/bin/env bash
# rem.sh — Apple Reminders bridge for KairOS (macOS 13+, rem-cli + jq).
#
# JSON fields (rem list -o json): id, title, notes, list, completed, url, ...
# Legacy jq examples use .name; we accept .title with .name fallback.
#
# Usage: source this file, then call rem_* functions.

set -euo pipefail

REM_BIN="${REM_BIN:-rem}"
REM_INBOX_LIST="${REM_INBOX_LIST:-Inbox}"
REM_ACTIONS_LIST="${REM_ACTIONS_LIST:-Actions}"

# rem_title — extract display title from one reminder JSON object
rem_title() {
  jq -r '.title // .name // empty'
}

# rem_preflight — require darwin, rem, jq; smoke-test rem lists
rem_preflight() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Error: Apple Reminders bridge requires macOS." >&2
    return 1
  fi
  if ! command -v "$REM_BIN" >/dev/null 2>&1; then
    echo "Error: rem not found. Install: brew tap BRO3886/tap && brew install rem-cli" >&2
    return 1
  fi
  if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq not found. Install: brew install jq" >&2
    return 1
  fi
  if ! "$REM_BIN" lists -o json >/dev/null 2>&1; then
    echo "Error: rem could not access Reminders." >&2
    echo "Grant Reminders access to this app in System Settings → Privacy & Security → Reminders." >&2
    echo "Run rem interactively once from Terminal or Cursor before background use." >&2
    return 1
  fi
}

# rem_ensure_lists — create Inbox and Actions lists if missing
rem_ensure_lists() {
  local lists_json existing
  lists_json="$("$REM_BIN" lists -o json)"
  existing="$(echo "$lists_json" | jq -r '.[] | if type == "string" then . else (.title // .name // empty) end')"

  if ! echo "$existing" | grep -Fxq "$REM_INBOX_LIST"; then
    "$REM_BIN" list-mgmt create "$REM_INBOX_LIST"
  fi
  if ! echo "$existing" | grep -Fxq "$REM_ACTIONS_LIST"; then
    "$REM_BIN" list-mgmt create "$REM_ACTIONS_LIST"
  fi
}

# rem_list_inbox_incomplete — print JSON array of incomplete Reminders Inbox items
rem_list_inbox_incomplete() {
  "$REM_BIN" list --list "$REM_INBOX_LIST" --incomplete -o json
}

# rem_list_actions — print JSON array of all items on Actions list
rem_list_actions() {
  "$REM_BIN" list --list "$REM_ACTIONS_LIST" -o json
}

# rem_complete_ids — complete one or more reminder IDs
rem_complete_ids() {
  local id
  for id in "$@"; do
    [[ -n "$id" ]] || continue
    "$REM_BIN" complete "$id"
  done
}

# rem_clear_actions — complete every item on the Actions list
rem_clear_actions() {
  local ids id
  ids="$(rem_list_actions | jq -r '.[].id // empty')"
  if [[ -z "$ids" ]]; then
    return 0
  fi
  while IFS= read -r id; do
    [[ -n "$id" ]] || continue
    "$REM_BIN" complete "$id"
  done <<< "$ids"
}

# rem_add_action TITLE URL — add high-priority action with vault back-link
rem_add_action() {
  local title="$1"
  local url="$2"
  "$REM_BIN" add "$title" --list "$REM_ACTIONS_LIST" --priority high --url "$url"
}

# rem_format_inbox_item — human-readable line from JSON object on stdin
rem_format_inbox_item() {
  jq -r '"\(.id)\t\(.title // .name // "untitled")\t\(.notes // "")"'
}
