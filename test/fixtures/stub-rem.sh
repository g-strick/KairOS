#!/usr/bin/env bash
# Stub rem for KairOS tests — simulates rem-cli JSON I/O.

set -euo pipefail

STATE_DIR="${REM_STUB_STATE_DIR:?REM_STUB_STATE_DIR required}"
ACTIONS_FILE="$STATE_DIR/actions.json"
INBOX_FILE="$STATE_DIR/inbox.json"
LISTS_FILE="$STATE_DIR/lists.json"

init_state() {
  mkdir -p "$STATE_DIR"
  [[ -f "$LISTS_FILE" ]] || echo '["Inbox","Actions"]' > "$LISTS_FILE"
  [[ -f "$INBOX_FILE" ]] || echo '[]' > "$INBOX_FILE"
  [[ -f "$ACTIONS_FILE" ]] || echo '[]' > "$ACTIONS_FILE"
}

init_state

cmd="${1:-}"
shift || true

case "$cmd" in
  lists)
    output="table"
    while [[ $# -gt 0 ]]; do
      case "$1" in
        -o|--output) output="$2"; shift 2 ;;
        *) shift ;;
      esac
    done
    if [[ "$output" == "json" ]]; then
      jq -c '[.[] | {title: ., name: .}]' "$LISTS_FILE"
    else
      cat "$LISTS_FILE"
    fi
    ;;
  list)
    list_name=""
    incomplete=0
    output="table"
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --list|-l) list_name="$2"; shift 2 ;;
        --incomplete) incomplete=1; shift ;;
        -o|--output) output="$2"; shift 2 ;;
        *) shift ;;
      esac
    done
    file="$ACTIONS_FILE"
    [[ "$list_name" == "Inbox" ]] && file="$INBOX_FILE"
    if [[ "$output" == "json" ]]; then
      if [[ $incomplete -eq 1 ]]; then
        jq '[.[] | select(.completed != true)]' "$file"
      else
        cat "$file"
      fi
    else
      cat "$file"
    fi
    ;;
  list-mgmt)
    sub="${1:-}"
    shift || true
    if [[ "$sub" == "create" ]]; then
      name="$1"
      tmp="$(mktemp)"
      jq --arg n "$name" '. + [$n] | unique' "$LISTS_FILE" > "$tmp"
      mv "$tmp" "$LISTS_FILE"
    fi
    ;;
  complete|done)
    id="$1"
    for file in "$INBOX_FILE" "$ACTIONS_FILE"; do
      if jq -e --arg id "$id" 'map(select(.id == $id)) | length > 0' "$file" >/dev/null; then
        tmp="$(mktemp)"
        jq --arg id "$id" 'map(if .id == $id then .completed = true else . end)' "$file" > "$tmp"
        mv "$tmp" "$file"
        exit 0
      fi
    done
    ;;
  add)
    title="$1"
    shift
    list_name="Actions"
    priority=""
    url=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --list) list_name="$2"; shift 2 ;;
        --priority) priority="$2"; shift 2 ;;
        --url) url="$2"; shift 2 ;;
        *) shift ;;
      esac
    done
    file="$ACTIONS_FILE"
    [[ "$list_name" == "Inbox" ]] && file="$INBOX_FILE"
    id="stub-$(date +%s)-$RANDOM"
    tmp="$(mktemp)"
    jq --arg id "$id" --arg title "$title" --arg url "$url" --arg priority "$priority" \
      '. + [{id: $id, title: $title, name: $title, notes: "", url: $url, priority: $priority, completed: false, list: "'"$list_name"'"}]' \
      "$file" > "$tmp"
    mv "$tmp" "$file"
    echo "$id"
    ;;
  *)
    echo "stub-rem: unsupported command: $cmd" >&2
    exit 1
    ;;
esac
