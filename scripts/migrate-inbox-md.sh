#!/usr/bin/env bash
# migrate-inbox-md.sh — Move legacy inbox.md captures into inbox/.
#
# Usage: migrate-inbox-md.sh [vault_root]

set -euo pipefail

VAULT="${1:-${KAIROS_VAULT:-$HOME/kairos-vault}}"
VAULT="${VAULT/#\~/$HOME}"
legacy="$VAULT/inbox.md"
inbox_dir="$VAULT/inbox"

[[ -f "$legacy" ]] || exit 0

mkdir -p "$inbox_dir"

body="$(grep -v '^# Inbox' "$legacy" | sed '/^[[:space:]]*$/d' || true)"
if [[ -n "$body" ]]; then
  stamp="$(date +%Y-%m-%dT%H%M)"
  migrated="$inbox_dir/${stamp}-migrated-from-inbox-md.md"
  {
    echo "# Migrated from inbox.md"
    echo ""
    echo "$body"
  } > "$migrated"
  echo "Migrated inbox.md → inbox/$(basename "$migrated")"
fi
rm -f "$legacy"
