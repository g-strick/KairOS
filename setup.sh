#!/usr/bin/env bash
# setup.sh — Interactive vault scaffolder for KairOS.
#
# Usage:
#   ./setup.sh              # prompts for vault path (default ~/kairos)
#   ./setup.sh ~/my-vault   # scaffolds at the given path
#
# Environment overrides (for non-interactive / test use):
#   KAIROS_VAULT  — vault path (bypasses path prompt)
#   KAIROS_YES    — set to "true" to skip the confirm prompt (assume yes)
#
# Requires: bash 5.x, templates/vault-dirs.txt at repo root.

set -euo pipefail

# ── Resolve repo root (directory containing this script) ──
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIRS_FILE="$SCRIPT_DIR/templates/vault-dirs.txt"

# ── Bash 5.x check ──
check_bash_version() {
  if [[ "${BASH_VERSINFO[0]:-0}" -lt 5 ]]; then
    echo "Error: KairOS requires Bash 5.x."
    echo "Your Bash: ${BASH_VERSION:-unknown}"
    if [[ "$(uname -s)" == "Darwin" ]]; then
      echo "Install it: brew install bash"
    else
      echo "Install Bash 5.x from your package manager."
    fi
    exit 1
  fi
}

# ── Read canonical vault directory list ──
read_vault_dirs() {
  VAULT_DIRS=()
  while IFS= read -r line || [[ -n "$line" ]]; do
     [[ -z "$line" || "$line" == \#* ]] && continue
    VAULT_DIRS+=("$line")
  done < "$VAULT_DIRS_FILE"
}

# ── Prompt helpers ──

# prompt_text VAR PROMPT [DEFAULT]
# Reads a line from stdin into VAR. If DEFAULT is set and input is empty, uses it.
prompt_text() {
  local var_name="$1"
  local prompt="$2"
  local default="${3:-}"
  local input=""

  if [[ -n "${KAIROS_VAULT:-}" && "$var_name" == "VAULT_PATH" ]]; then
    # Non-interactive: use env override
    eval "$var_name=\$KAIROS_VAULT"
    return
  fi

  local prompt_str="$prompt"
  if [[ -n "$default" ]]; then
    prompt_str="$prompt [$default]: "
  else
    prompt_str="$prompt: "
  fi

  printf "%s" "$prompt_str"
  read -r input || input=""

  if [[ -z "$input" && -n "$default" ]]; then
    input="$default"
  fi

  eval "$var_name=\$input"
}

# prompt_y_n PROMPT [DEFAULT]
# Reads y/Y/yes or n/N/no. Returns 0 for yes, 1 for no.
prompt_y_n() {
  local prompt="$1"
  local default="${2:-N}"  # N = require explicit yes
  local input=""

  printf "%s [y/N]: " "$prompt"
  read -r input || input="$default"
  input="${input,,}"  # lowercase

  if [[ "$input" == "y" || "$input" == "yes" ]]; then
    return 0
  fi
  return 1
}

# ── Main ──

check_bash_version
read_vault_dirs

# Determine vault path
VAULT_PATH=""
prompt_text "VAULT_PATH" "Where should I create your KairOS vault?" "$HOME/kairos"
VAULT_PATH="$VAULT_PATH"

# Expand ~ to $HOME
VAULT_PATH="${VAULT_PATH/#\~/$HOME}"

# Resolve to absolute path
if [[ "$VAULT_PATH" != /* ]]; then
  VAULT_PATH="$(cd "$PWD" && cd "$(dirname "$VAULT_PATH")" 2>/dev/null && pwd)/$(basename "$VAULT_PATH")" || \
  VAULT_PATH="$(pwd)/$VAULT_PATH"
fi

# ── Existing vault check ──
if [[ -d "$VAULT_PATH" ]] && [[ -n "$(ls -A "$VAULT_PATH" 2>/dev/null)" ]]; then
  echo ""
  echo "⚠  Vault already exists at: $VAULT_PATH"
  echo ""
  echo "Choose an option:"
  echo "  1) Overwrite  — erase everything and scaffold fresh (data loss!)"
  echo "  2) update.sh  — run the sync script to pull engine updates instead"
  echo "  3) Cancel     — abort without changes"
  echo ""
  printf "Option [1/2/3]: "
  read -r choice || choice="3"

  case "$choice" in
    1)
      echo ""
      echo "WARNING: This will erase everything in $VAULT_PATH"
      if ! prompt_y_n "Are you sure you want to proceed with overwrite?" N; then
        echo "Aborted."
        exit 1
      fi
      echo "Removing existing vault..."
      rm -rf "$VAULT_PATH"
      ;;
    2)
      echo ""
      echo "Run the sync script to pull engine updates:"
      echo "  $SCRIPT_DIR/update.sh $VAULT_PATH"
      exit 1
      ;;
    *)
      echo "Aborted."
      exit 1
      ;;
  esac
fi

# ── Confirm screen ──
if [[ -z "${KAIROS_YES:-}" ]]; then
  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo "  KairOS Vault Setup"
  echo "═══════════════════════════════════════════════════════"
  echo ""
  echo "  Vault path:  $VAULT_PATH"
  echo ""
  echo "  Directories to create:"
  for dir in "${VAULT_DIRS[@]}"; do
    echo "    · $dir/"
  done
  echo ""
  echo "  Seed files:"
  echo "    · inbox.md"
  echo "    · habits.md"
  echo "    · AGENTS.md"
  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo ""

  if ! prompt_y_n "Proceed with scaffold?" N; then
    echo "Aborted — nothing was changed."
    exit 1
  fi
fi

# ── Create vault ──
echo "Creating vault at $VAULT_PATH ..."
mkdir -p "$VAULT_PATH"

# Create directories
for dir in "${VAULT_DIRS[@]}"; do
  mkdir -p "$VAULT_PATH/$dir"
done

# Create seed files
echo "# Inbox — capture anything here, then run /kairos-sort to process." \
  > "$VAULT_PATH/inbox.md"

echo "# Habits — track daily habit streaks. Updated by the Steward." \
  > "$VAULT_PATH/habits.md"

# Copy AGENTS.md from engine
cp "$SCRIPT_DIR/AGENTS.md" "$VAULT_PATH/AGENTS.md"

echo ""
echo "✓ Vault scaffolded at $VAULT_PATH"
echo ""
echo "Next steps:"
echo "  cd $VAULT_PATH"
echo "  # Then run /kairos-onboard to complete onboarding"
echo ""
