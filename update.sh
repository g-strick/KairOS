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
#   ./update.sh [engine_root] [vault_path]
#   ./update.sh [vault_path]              # vault only — uses local .engine-root or fetches .engine-remote
#   ./update.sh --remote [vault_path]     # force fetch from GitHub (sandbox / no local clone)
#   KAIROS_VAULT=/path/to/vault ./update.sh
#
# Engine source is resolved in this order:
#   1. First positional argument that contains templates/allowlist.txt
#   2. KAIROS_ENGINE_ROOT or GSD_ENGINE_ROOT environment variable
#   3. $VAULT/.engine-root (local clone path)
#   4. Parent directory of this script's location
#   5. Fetch from $VAULT/.engine-remote (or KAIROS_ENGINE_REMOTE) — GitHub by default

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FETCH_LIB="$SCRIPT_DIR/scripts/kair-fetch-engine.sh"

ENGINE_ROOT=""
VAULT_ROOT="${KAIROS_VAULT:-$HOME/kairos-vault}"
FORCE_REMOTE=0
FETCHED_ENGINE_TMP=""

cleanup() {
  if [[ -n "$FETCHED_ENGINE_TMP" && -d "$FETCHED_ENGINE_TMP" ]]; then
    rm -rf "$FETCHED_ENGINE_TMP"
  fi
}
trap cleanup EXIT

# shellcheck source=scripts/kair-fetch-engine.sh
source_fetch_lib() {
  if [[ -f "$FETCH_LIB" ]]; then
    # shellcheck disable=SC1090
    source "$FETCH_LIB"
    return 0
  fi
  if [[ -f "$ENGINE_ROOT/scripts/kair-fetch-engine.sh" ]]; then
  # shellcheck disable=SC1090
    source "$ENGINE_ROOT/scripts/kair-fetch-engine.sh"
    return 0
  fi
  return 1
}

is_engine_root() {
  [[ -f "${1%/}/templates/allowlist.txt" ]]
}

is_vault_root() {
  [[ -f "${1%/}/AGENTS.md" || -d "${1%/}/inbox" || -d "${1%/}/_kair" ]]
}

read_engine_root_file() {
  local vault="$1"
  local path=""
  [[ -f "$vault/.engine-root" ]] || return 1
  path="$(head -1 "$vault/.engine-root")"
  path="${path%%#*}"
  path="$(printf '%s' "$path" | tr -d '[:space:]')"
  path="${path/#\~/$HOME}"
  [[ -n "$path" ]] || return 1
  printf '%s' "$path"
}

resolve_engine_from_config() {
  local candidate=""

  if [[ -n "${KAIROS_ENGINE_ROOT:-}" ]]; then
    candidate="$KAIROS_ENGINE_ROOT"
  elif [[ -n "${GSD_ENGINE_ROOT:-}" ]]; then
    candidate="$GSD_ENGINE_ROOT"
  elif candidate="$(read_engine_root_file "$VAULT_ROOT" 2>/dev/null || true)" && [[ -n "$candidate" ]]; then
    :
  elif is_engine_root "$SCRIPT_DIR"; then
    candidate="$SCRIPT_DIR"
  elif [[ -d "$SCRIPT_DIR/.git" ]]; then
    candidate="$SCRIPT_DIR"
  else
    candidate="$(cd "$SCRIPT_DIR/.." && pwd)"
  fi

  if [[ -n "$candidate" ]] && is_engine_root "$candidate"; then
    ENGINE_ROOT="$candidate"
    return 0
  fi

  if [[ -n "$candidate" && ! -d "$candidate" ]]; then
    echo "NOTE: .engine-root points to missing path: $candidate" >&2
  elif [[ -n "$candidate" ]]; then
    echo "NOTE: engine path is not a valid KairOS checkout: $candidate" >&2
  fi
  ENGINE_ROOT=""
  return 1
}

bootstrap_source_fetch_lib() {
  local remote branch slug tmp_script
  remote="${KAIROS_ENGINE_REMOTE:-}"
  if [[ -z "$remote" && -f "$VAULT_ROOT/.engine-remote" ]]; then
    remote="$(head -1 "$VAULT_ROOT/.engine-remote")"
    remote="${remote%%#*}"
    remote="$(printf '%s' "$remote" | tr -d '[:space:]')"
  fi
  remote="${remote:-https://github.com/g-strick/KairOS.git}"
  branch="${KAIROS_ENGINE_BRANCH:-}"
  if [[ -z "$branch" && -f "$VAULT_ROOT/.engine-branch" ]]; then
    branch="$(head -1 "$VAULT_ROOT/.engine-branch")"
    branch="${branch%%#*}"
    branch="$(printf '%s' "$branch" | tr -d '[:space:]')"
  fi
  branch="${branch:-main}"
  remote="${remote%.git}"
  if [[ "$remote" =~ github\.com[:/]([^/]+)/([^/]+)$ ]]; then
    slug="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
  elif [[ "$remote" =~ ^[^/]+/[^/]+$ ]]; then
    slug="$remote"
  else
    echo "ERROR: cannot bootstrap fetch from remote: $remote" >&2
    return 1
  fi
  if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: curl required to bootstrap engine fetch" >&2
    return 1
  fi
  tmp_script="$(mktemp -t kair-fetch-lib.XXXXXX)"
  if ! curl -fsSL "https://raw.githubusercontent.com/${slug}/${branch}/scripts/kair-fetch-engine.sh" -o "$tmp_script"; then
    rm -f "$tmp_script"
    echo "ERROR: could not download kair-fetch-engine.sh from GitHub" >&2
    return 1
  fi
  # shellcheck disable=SC1090
  source "$tmp_script"
  rm -f "$tmp_script"
}

fetch_engine_into_temp() {
  if ! source_fetch_lib; then
    bootstrap_source_fetch_lib || {
      echo "ERROR: kair-fetch-engine.sh not found and bootstrap failed" >&2
      exit 1
    }
  fi
  local remote branch
  remote="$(kair_resolve_engine_remote "$VAULT_ROOT")"
  branch="$(kair_resolve_engine_branch "$VAULT_ROOT")"
  FETCHED_ENGINE_TMP="$(mktemp -d -t kair-engine.XXXXXX)"
  echo "Fetching engine from $remote (branch: $branch) ..."
  if ! kair_fetch_engine "$remote" "$branch" "$FETCHED_ENGINE_TMP"; then
    echo "ERROR: could not fetch engine from $remote" >&2
    exit 1
  fi
  ENGINE_ROOT="$FETCHED_ENGINE_TMP"
  echo "Engine fetched to temporary directory."
  echo ""
}

# --- Parse arguments ---
POSITIONAL_DIRS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote)
      FORCE_REMOTE=1
      shift
      ;;
    -*)
      echo "ERROR: unknown option: $1" >&2
      exit 1
      ;;
    *)
      if [[ ! -d "$1" ]]; then
        echo "ERROR: not a directory: $1" >&2
        exit 1
      fi
      POSITIONAL_DIRS+=("$1")
      shift
      ;;
  esac
done

if [[ ${#POSITIONAL_DIRS[@]} -eq 2 ]]; then
  ENGINE_ROOT="${POSITIONAL_DIRS[0]}"
  VAULT_ROOT="${POSITIONAL_DIRS[1]}"
elif [[ ${#POSITIONAL_DIRS[@]} -eq 1 ]]; then
  if is_engine_root "${POSITIONAL_DIRS[0]}"; then
    ENGINE_ROOT="${POSITIONAL_DIRS[0]}"
  elif is_vault_root "${POSITIONAL_DIRS[0]}"; then
    VAULT_ROOT="${POSITIONAL_DIRS[0]}"
  elif [[ -f "${POSITIONAL_DIRS[0]}/AGENTS.md" ]]; then
    VAULT_ROOT="${POSITIONAL_DIRS[0]}"
  elif [[ -f "${POSITIONAL_DIRS[0]}/templates/allowlist.txt" ]]; then
    ENGINE_ROOT="${POSITIONAL_DIRS[0]}"
  else
    # Bare vault path (e.g. fresh sandbox) — create markers on sync
    VAULT_ROOT="${POSITIONAL_DIRS[0]}"
  fi
elif [[ ${#POSITIONAL_DIRS[@]} -gt 2 ]]; then
  echo "ERROR: too many directory arguments (expected at most 2)" >&2
  exit 1
fi

VAULT_ROOT="${VAULT_ROOT/#\~/$HOME}"
mkdir -p "$VAULT_ROOT"

if [[ "$FORCE_REMOTE" -eq 1 ]]; then
  ENGINE_ROOT=""
fi

if [[ -z "$ENGINE_ROOT" ]]; then
  resolve_engine_from_config || true
fi

if [[ "$FORCE_REMOTE" -eq 1 ]] || [[ -z "$ENGINE_ROOT" ]] || ! is_engine_root "$ENGINE_ROOT"; then
  fetch_engine_into_temp
fi

# Allowlist manifest — the single source of truth for what may be copied
ALLOWLIST_FILE="$ENGINE_ROOT/templates/allowlist.txt"

if [[ ! -f "$ALLOWLIST_FILE" ]]; then
  echo "ERROR: allowlist not found at $ALLOWLIST_FILE" >&2
  echo "Ensure the engine root is correct: $ENGINE_ROOT" >&2
  exit 1
fi

# vault_dest_for ENTRY — PKM convention: engine dirs live under _kair/
vault_dest_for() {
  local entry="${1%/}"
  case "$entry" in
    AGENTS.md) echo "AGENTS.md" ;;
    skills|agents|hooks|styles|templates) echo "_kair/$entry" ;;
    *) echo "$entry" ;;
  esac
}

# migrate_flat_engine_layout — move legacy vault-root engine dirs into _kair/
migrate_flat_engine_layout() {
  local name migrated=0
  for name in skills agents hooks styles templates; do
    if [[ -e "$VAULT_ROOT/$name" && ! -e "$VAULT_ROOT/_kair/$name" ]]; then
      mkdir -p "$VAULT_ROOT/_kair"
      mv "$VAULT_ROOT/$name" "$VAULT_ROOT/_kair/$name"
      echo "  MIGRATE: $name/ → _kair/$name/"
      migrated=1
    fi
  done
  if [[ $migrated -eq 1 ]]; then
    echo ""
  fi
}

migrate_flat_engine_layout

echo "Engine source: $ENGINE_ROOT"
echo "Vault target:  $VAULT_ROOT"
echo ""
echo "Syncing allowlisted paths:"

# Iterate only the entries in templates/allowlist.txt
while IFS= read -r entry || [[ -n "$entry" ]]; do
  # Skip empty lines and comments
  [[ -z "$entry" || "$entry" =~ ^# ]] && continue

  src="$ENGINE_ROOT/$entry"
  rel_dest="$(vault_dest_for "$entry")"
  dest="$VAULT_ROOT/$rel_dest"

  # Only copy if source exists
  if [[ ! -e "$src" ]]; then
    echo "  SKIP (not found): $entry"
    continue
  fi

  # Create destination directory
  mkdir -p "$(dirname "$dest")"

  # Copy with overwrite (engine wins), never symlink
  if [[ -d "$src" ]]; then
    # For directories: replace entirely so renames/removals propagate
    rm -rf "$dest"
    cp -R "$src" "$dest"
  else
    # For files: force overwrite
    cp -f "$src" "$dest"
  fi

  if [[ "$rel_dest" != "$entry" ]]; then
    echo "  SYNC: $entry → $rel_dest"
  else
    echo "  SYNC: $entry"
  fi
done < "$ALLOWLIST_FILE"

# Install vault seeds from templates (safe to refresh on update)
INDEX_SEED="$ENGINE_ROOT/templates/vault-seeds/INDEX.md"
if [[ -f "$INDEX_SEED" ]]; then
  cp -f "$INDEX_SEED" "$VAULT_ROOT/INDEX.md"
  echo "  INSTALL: INDEX.md"
fi

KAIR_README_SEED="$ENGINE_ROOT/templates/vault-seeds/_kair-README.md"
if [[ -f "$KAIR_README_SEED" ]]; then
  mkdir -p "$VAULT_ROOT/_kair"
  cp -f "$KAIR_README_SEED" "$VAULT_ROOT/_kair/README.md"
  echo "  INSTALL: _kair/README.md"
fi

echo ""
echo "Update complete. $(( $(grep -cv '^$\|^#' "$ALLOWLIST_FILE" 2>/dev/null || echo 0) )) allowlisted paths synced."

# Mirror skills/ into backend-native adapter paths (Cursor, Claude Code, Cline)
SYNC_ADAPTERS="$ENGINE_ROOT/scripts/sync-skill-adapters.sh"
if [[ -x "$SYNC_ADAPTERS" ]]; then
  echo ""
  bash "$SYNC_ADAPTERS" "$VAULT_ROOT"
elif [[ -f "$SYNC_ADAPTERS" ]]; then
  echo ""
  bash "$SYNC_ADAPTERS" "$VAULT_ROOT"
fi
