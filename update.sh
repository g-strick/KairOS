#!/usr/bin/env bash
set -euo pipefail

# update.sh — Allowlist-based engine→vault sync
# Driven by plan 01-03 (Foundation, plan 03)
#
# Copies only explicitly-listed safe paths from the engine repo into the vault.
# Never copies anything not on the allowlist. Never uses symlinks.
# Engine version always wins on allowlisted paths (strict overwrite).
#
# Usage:
#   ./update.sh [vault_path]
#   KAIROS_VAULT=/path/to/vault ./update.sh [engine_root]
#
# Engine source is resolved in this order:
#   1. First positional argument (engine_root)
#   2. GSD_ENGINE_ROOT environment variable
#   3. Config value: git config kairos.engine-root (if in a git repo)
#   4. Parent directory of this script's location

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve engine source root
if [ $# -ge 1 ] && [ -d "$1" ]; then
  ENGINE_ROOT="$1"
elif [ -n "${GSD_ENGINE_ROOT:-}" ]; then
  ENGINE_ROOT="$GSD_ENGINE_ROOT"
elif [ -d "$SCRIPT_DIR/.git" ]; then
  ENGINE_ROOT="$SCRIPT_DIR"
else
  ENGINE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

# Resolve vault target
VAULT_ROOT="${KAIROS_VAULT:-$HOME/kairos}"
if [ $# -ge 2 ]; then
  VAULT_ROOT="$2"
fi

# Allowlist manifest — the single source of truth for what may be copied
ALLOWLIST_FILE="$ENGINE_ROOT/templates/allowlist.txt"

if [ ! -f "$ALLOWLIST_FILE" ]; then
  echo "ERROR: allowlist not found at $ALLOWLIST_FILE" >&2
  echo "Ensure the engine root is correct: $ENGINE_ROOT" >&2
  exit 1
fi

# Ensure vault directory exists
mkdir -p "$VAULT_ROOT"

echo "Engine source: $ENGINE_ROOT"
echo "Vault target:  $VAULT_ROOT"
echo ""
echo "Syncing allowlisted paths:"

# Iterate only the entries in templates/allowlist.txt
while IFS= read -r entry || [ -n "$entry" ]; do
  # Skip empty lines and comments
  [[ -z "$entry" || "$entry" =~ ^# ]] && continue

  src="$ENGINE_ROOT/$entry"
  dest="$VAULT_ROOT/$entry"

  # Only copy if source exists
  if [ ! -e "$src" ]; then
    echo "  SKIP (not found): $entry"
    continue
  fi

  # Create destination directory
  mkdir -p "$(dirname "$dest")"

  # Copy with overwrite (engine wins), never symlink
  if [ -d "$src" ]; then
    # For directories: recursive copy, overwrite existing
    cp -Rf "$src" "$dest"
  else
    # For files: force overwrite
    cp -f "$src" "$dest"
  fi

  echo "  SYNC: $entry"
done < "$ALLOWLIST_FILE"

echo ""
echo "Update complete. $(( $(grep -cv '^$\|^#' "$ALLOWLIST_FILE" 2>/dev/null || echo 0) )) allowlisted paths synced."