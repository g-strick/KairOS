#!/usr/bin/env bash
# kair-process-helpers.sh — fetch/format helpers for /kair-triage (and legacy process-* skills).
#
# Usage: source from agent shell or run subcommands directly.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

VAULT="${KAIROS_VAULT:-$HOME/kairos-vault}"
VAULT="${VAULT/#\~/$HOME}"
INBOX_DIR="$VAULT/inbox"
NEXT="$VAULT/next-actions.md"
WAITING="$VAULT/waiting-for.md"
SOMEDAY="$VAULT/someday-maybe.md"
PROJECTS="$VAULT/projects"
REFERENCE="$VAULT/reference"

# preflight_vault — verify default GTD scaffold exists
preflight_vault() {
  local missing=0
  for path in "$INBOX_DIR" "$PROJECTS" "$REFERENCE"; do
    if [[ ! -d "$path" ]]; then
      echo "Error: missing $path — run setup.sh" >&2
      missing=1
    fi
  done
  for path in "$NEXT" "$WAITING" "$SOMEDAY"; do
    if [[ ! -f "$path" ]]; then
      echo "Error: missing $path — run setup.sh" >&2
      missing=1
    fi
  done
  if [[ $missing -eq 1 ]]; then
    exit 1
  fi
  echo "OK"
}

# shellcheck source=scripts/bridges/rem.sh
source "$ENGINE_ROOT/scripts/bridges/rem.sh"

# list_reminders_inbox — tab-separated id, title, notes
list_reminders_inbox() {
  rem_preflight
  rem_ensure_lists
  rem_list_inbox_incomplete | rem_format_inbox_item
}

# list_vault_inbox_files — one path per line (excludes README.md)
list_vault_inbox_files() {
  shopt -s nullglob
  local f
  for f in "$INBOX_DIR"/*.md; do
    [[ "$(basename "$f")" == "README.md" ]] && continue
    echo "$f"
  done
  shopt -u nullglob
}

# complete_reminder ID
complete_reminder() {
  rem_complete_ids "$1"
}

# _triage_escape_field — make a field safe for tab-separated triage lines
_triage_escape_field() {
  local s="$1"
  s="${s//$'\t'/ }"
  s="${s//$'\n'/ }"
  s="${s//$'\r'/ }"
  printf '%s' "$s"
}

# _vault_inbox_title PATH — first heading or filename stem
_vault_inbox_title() {
  local path="$1"
  local title
  title="$(grep -m1 -E '^#+ ' "$path" 2>/dev/null | sed -E 's/^#+ //' || true)"
  if [[ -z "$title" ]]; then
    title="$(basename "$path" .md)"
  fi
  _triage_escape_field "$title"
}

# _vault_inbox_preview PATH — first non-empty, non-heading line
_vault_inbox_preview() {
  local path="$1"
  local line
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    _triage_escape_field "$line"
    return
  done < "$path"
  _triage_escape_field ""
}

# list_triage_queue — reminders first, then vault inbox (tab-separated)
# Fields: source  id_or_path  title  notes_or_preview
list_triage_queue() {
  if [[ "$(uname -s)" == "Darwin" ]] && command -v "$REM_BIN" >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    if rem_preflight >/dev/null 2>&1; then
      rem_ensure_lists
      local item id title notes
      while IFS=$'\t' read -r id title notes; do
        [[ -z "$id" ]] && continue
        printf 'reminder\t%s\t%s\t%s\n' "$id" "$(_triage_escape_field "$title")" "$(_triage_escape_field "$notes")"
      done < <(rem_list_inbox_incomplete | rem_format_inbox_item)
    fi
  fi

  local f
  shopt -s nullglob
  for f in "$INBOX_DIR"/*.md; do
    [[ "$(basename "$f")" == "README.md" ]] && continue
    printf 'vault\t%s\t%s\t%s\n' "$f" "$(_vault_inbox_title "$f")" "$(_vault_inbox_preview "$f")"
  done
  shopt -u nullglob
}

# count_triage_queue — number of items list_triage_queue would emit
count_triage_queue() {
  list_triage_queue | wc -l | tr -d ' '
}

case "${1:-}" in
  list-reminders)
    list_reminders_inbox
    ;;
  list-vault-inbox)
    list_vault_inbox_files
    ;;
  complete-reminder)
    [[ $# -ge 2 ]] || { echo "Usage: $0 complete-reminder <id>" >&2; exit 1; }
    complete_reminder "$2"
    ;;
  preflight)
    rem_preflight
    rem_ensure_lists
    echo "OK"
    ;;
  preflight-vault)
    preflight_vault
    ;;
  list-triage)
    list_triage_queue
    ;;
  count-triage)
    count_triage_queue
    ;;
  *)
    echo "Usage: $0 {list-reminders|list-vault-inbox|list-triage|count-triage|complete-reminder|preflight|preflight-vault}" >&2
    exit 1
    ;;
esac
