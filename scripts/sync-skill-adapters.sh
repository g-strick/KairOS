#!/usr/bin/env bash
set -euo pipefail

# sync-skill-adapters.sh — Copy canonical _kair/skills/ into backend-native paths.
#
# KairOS keeps one portable source of truth at _kair/skills/<name>/SKILL.md.
# Cursor, Claude Code, and Cline each register slash commands from their
# own directories. This script mirrors the canonical skills into:
#   .cursor/skills/   — Cursor
#   .claude/skills/   — Claude Code
#   .cline/skills/    — Cline (VS Code / VSCodium)
#
# Usage:
#   ./scripts/sync-skill-adapters.sh [vault_root]
#   KAIROS_VAULT=/path/to/vault ./scripts/sync-skill-adapters.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="${1:-${KAIROS_VAULT:-$HOME/kairos-vault}}"
VAULT_ROOT="${VAULT_ROOT/#\~/$HOME}"
SKILLS_SRC="$VAULT_ROOT/_kair/skills"

ADAPTER_DIRS=(
  ".cursor/skills"
  ".claude/skills"
  ".cline/skills"
)

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "ERROR: skills source not found at $SKILLS_SRC" >&2
  echo "Run update.sh first to sync skills into the vault." >&2
  exit 1
fi

shopt -s nullglob
skill_dirs=("$SKILLS_SRC"/*/)
shopt -u nullglob

if [ "${#skill_dirs[@]}" -eq 0 ]; then
  echo "SKIP: no skill packages under $SKILLS_SRC"
  exit 0
fi

echo "Syncing skill adapters into $VAULT_ROOT"

canonical_names=()
for skill_dir in "${skill_dirs[@]}"; do
  skill_name="$(basename "$skill_dir")"
  [ -f "$skill_dir/SKILL.md" ] && canonical_names+=("$skill_name")
done

for adapter in "${ADAPTER_DIRS[@]}"; do
  dest_root="$VAULT_ROOT/$adapter"
  mkdir -p "$dest_root"

  # Remove adapter packages dropped from canonical skills/
  shopt -s nullglob
  for existing in "$dest_root"/*/; do
    existing_name="$(basename "$existing")"
    keep=false
    for name in "${canonical_names[@]}"; do
      if [ "$name" = "$existing_name" ]; then
        keep=true
        break
      fi
    done
    if [ "$keep" = false ]; then
      rm -rf "$existing"
      echo "  REMOVE: $adapter/$existing_name/"
    fi
  done
  shopt -u nullglob

  for skill_name in "${canonical_names[@]}"; do
    src_file="$SKILLS_SRC/$skill_name/SKILL.md"
    dest_dir="$dest_root/$skill_name"

    mkdir -p "$dest_dir"
    cp -f "$src_file" "$dest_dir/SKILL.md"
    echo "  SYNC: $adapter/$skill_name/SKILL.md"
  done
done

echo "Skill adapters synced."
