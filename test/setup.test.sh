#!/usr/bin/env bash
# setup.test.sh — End-to-end tests for setup.sh (KairOS vault scaffolder).
#
# Drives setup.sh non-interactively by piping answers to stdin, OR by
# setting environment overrides:
#   KAIROS_VAULT    — vault path to use (instead of the interactive prompt)
#   KAIROS_YES      — non-interactive assume-yes mode (bypasses confirm prompt)
#
# Uses a mktemp -d sandbox cleaned up via trap. Never touches ~/kairos.
#
# Requires: bash 5.x, setup.sh at repo root, test/lib/assert.sh sourced.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SETUP="$REPO_ROOT/setup.sh"
VAULT_DIRS_FILE="$REPO_ROOT/templates/vault-dirs.txt"

# ── Source assertion helpers ──
source "$SCRIPT_DIR/lib/assert.sh"

# ── Helpers ──

# Run setup.sh non-interactively with given stdin input.
# Usage: run_setup "path\ny"   or   run_setup "path\nn"
run_setup() {
  local input="$1"
  local sandbox="$2"
  export KAIROS_VAULT="$sandbox"
  export KAIROS_YES="true"
  # If input has a 'n' (no-confirm), unset KAIROS_YES so confirm is forced.
  if echo "$input" | grep -q '^n$'; then
    unset KAIROS_YES
  fi
  # Pipe input to setup.sh; capture exit code.
  local exit_code=0
  echo "$input" | bash "$SETUP" >/dev/null 2>&1 || exit_code=$?
  unset KAIROS_VAULT
  unset KAIROS_YES
  return $exit_code
}

# Read the canonical vault directory list from vault-dirs.txt.
# Sets the global array VAULT_DIRS.
read_vault_dirs() {
  VAULT_DIRS=()
  while IFS= read -r line; do
    # Skip comments and blank lines.
    [[ -z "$line" || "$line" == \#* ]] && continue
    VAULT_DIRS+=("$line")
  done < "$VAULT_DIRS_FILE"
}

# ── Test 1: Fresh scaffold creates all vault directories ──
test_1_fresh_scaffold_dirs() {
  echo "Test 1: Fresh scaffold — vault directories"
  local sandbox
  sandbox="$(mktemp -d)"
  trap 'rm -rf "$sandbox"' RETURN

  read_vault_dirs

  run_setup "$sandbox\ny"

  for dir in "${VAULT_DIRS[@]}"; do
    assert_dir "$sandbox/$dir" "vault dir: $dir"
  done
}

# ── Test 2: Fresh scaffold creates seed files ──
test_2_fresh_scaffold_files() {
  echo "Test 2: Fresh scaffold — seed files"
  local sandbox
  sandbox="$(mktemp -d)"
  trap 'rm -rf "$sandbox"' RETURN

  run_setup "$sandbox\ny"

  assert_file "$sandbox/inbox.md" "seed file: inbox.md"
  assert_file "$sandbox/habits.md" "seed file: habits.md"
  assert_file "$sandbox/AGENTS.md" "seed file: AGENTS.md"
}

# ── Test 3: Existing vault, Cancel — leaves vault unchanged ──
test_3_existing_vault_cancel() {
  echo "Test 3: Existing vault — Cancel leaves it unchanged"
  local sandbox
  sandbox="$(mktemp -d)"
  trap 'rm -rf "$sandbox"' RETURN

  # Pre-populate the vault with a marker file.
  mkdir -p "$sandbox/north-star"
  echo "pre-existing" > "$sandbox/north-star/existing.md"
  local pre_count
  pre_count="$(find "$sandbox" -type f | wc -l)"

  # Run setup.sh with "Cancel" (n) at the existing-vault prompt.
  local exit_code=0
  echo -e "$sandbox\nn" | bash "$SETUP" >/dev/null 2>&1 || exit_code=$?

  # Vault should be untouched and setup should have exited non-zero.
  assert_eq 0 "$exit_code" "setup.sh exits non-zero on Cancel" || true
  assert_file "$sandbox/north-star/existing.md" "pre-existing file still present"
  local post_count
  post_count="$(find "$sandbox" -type f | wc -l)"
  assert_eq "$pre_count" "$post_count" "file count unchanged after Cancel"
}

# ── Test 4: Confirm = 'no' — creates nothing ──
test_4_no_confirm_creates_nothing() {
  echo "Test 4: Confirm = no — nothing created"
  local sandbox
  sandbox="$(mktemp -d)"
  trap 'rm -rf "$sandbox"' RETURN

  # Run with 'n' at confirm prompt.
  run_setup "$sandbox\nn"

  # None of the expected dirs/files should exist.
  assert_not_exists() {
    local path="$1"
    local msg="$2"
    if [[ ! -e "$path" ]]; then
      echo "  PASS: $msg (not created)"
      ((ASSERT_PASSED++))
    else
      echo "  FAIL: $msg (should not exist, but does: $path)"
      ((ASSERT_FAILED++))
    fi
  }

  assert_not_exists "$sandbox/north-star" "north-star/ not created"
  assert_not_exists "$sandbox/daily" "daily/ not created"
  assert_not_exists "$sandbox/inbox.md" "inbox.md not created"
  assert_not_exists "$sandbox/habits.md" "habits.md not created"
  assert_not_exists "$sandbox/AGENTS.md" "AGENTS.md not created"
}

# ── Run all tests ──
echo ""
echo "═══════════════════════════════════════"
echo "  KairOS setup.sh — End-to-End Tests"
echo "═══════════════════════════════════════"
echo ""

# Ensure setup.sh exists (this test MUST fail if it doesn't — RED phase).
if [[ ! -f "$SETUP" ]]; then
  echo "FATAL: setup.sh not found at $SETUP"
  echo "This is expected during RED (pre-implementation). Build it to go GREEN."
  exit 1
fi

test_1_fresh_scaffold_dirs
test_2_fresh_scaffold_files
test_3_existing_vault_cancel
test_4_no_confirm_creates_nothing

assert_summary
