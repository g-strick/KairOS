#!/usr/bin/env bash
set -euo pipefail

# setup.test.sh — End-to-end tests for setup.sh vault scaffolder
# Usage: bash test/setup.test.sh
# Runs non-interactively against a temp vault; cleans up on exit.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SETUP="$ENGINE_DIR/setup.sh"

source "$SCRIPT_DIR/lib/assert.sh"

# Create a temporary vault sandbox; clean up on exit
SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT

echo "=== KairOS setup.sh End-to-End Tests ==="
echo "Sandbox: $SANDBOX"
echo ""

# -------------------------------------------------------------------
# Test 1: Fresh vault — all directories and seed files created
# -------------------------------------------------------------------
echo "--- Test 1: Fresh scaffold creates all vault structure ---"
TEST_VAULT="$SANDBOX/test1-vault"

# Run setup.sh non-interactively via env overrides
KAIROS_VAULT="$TEST_VAULT" KAIROS_YES=1 bash "$SETUP" 2>/dev/null || true

assert_dir "$TEST_VAULT/north-star" "north-star"
assert_dir "$TEST_VAULT/goals/5year" "goals/5year"
assert_dir "$TEST_VAULT/goals/yearly" "goals/yearly"
assert_dir "$TEST_VAULT/goals/monthly" "goals/monthly"
assert_dir "$TEST_VAULT/goals/weekly" "goals/weekly"
assert_dir "$TEST_VAULT/daily" "daily"
assert_dir "$TEST_VAULT/projects" "projects"
assert_dir "$TEST_VAULT/council" "council"
assert_dir "$TEST_VAULT/archive" "archive"
assert_file "$TEST_VAULT/inbox.md" "inbox.md seed file"
assert_file "$TEST_VAULT/habits.md" "habits.md seed file"
assert_file "$TEST_VAULT/AGENTS.md" "AGENTS.md seed file"

echo ""

# -------------------------------------------------------------------
# Test 2: Seed files exist and are regular files (not empty by default)
# -------------------------------------------------------------------
echo "--- Test 2: Seed files are regular files ---"
assert_file "$TEST_VAULT/inbox.md" "inbox.md is a file"
assert_file "$TEST_VAULT/habits.md" "habits.md is a file"
assert_file "$TEST_VAULT/AGENTS.md" "AGENTS.md is a file"

echo ""

# -------------------------------------------------------------------
# Test 3: Existing vault with Cancel option — leaves vault unchanged
# -------------------------------------------------------------------
echo "--- Test 3: Existing vault with Cancel leaves it unchanged ---"
TEST_VAULT3="$SANDBOX/test3-vault"
mkdir -p "$TEST_VAULT3"
# Create a marker file to detect if anything was modified
echo "keep me" > "$TEST_VAULT3/keep-me.txt"

# Pipe "y" for path (use default), then "c" for cancel on existing-vault prompt
echo -e "\nc" | KAIROS_VAULT="$TEST_VAULT3" bash "$SETUP" 2>/dev/null || true

assert_file "$TEST_VAULT3/keep-me.txt" "marker file still exists after cancel"

echo ""

# -------------------------------------------------------------------
# Test 4: Answering 'no' at confirm creates nothing
# -------------------------------------------------------------------
echo "--- Test 4: 'no' at confirm creates nothing ---"
TEST_VAULT4="$SANDBOX/test4-vault"
mkdir -p "$TEST_VAULT4"

# Pipe "y" for path, then "n" for confirm
echo -e "\nn" | KAIROS_VAULT="$TEST_VAULT4" bash "$SETUP" 2>/dev/null || true

# The vault should NOT have been scaffolded — no subdirs, no seed files
# Use negation: PASS if the directory/file does NOT exist
if [[ ! -d "$TEST_VAULT4/north-star" ]]; then
  echo "  PASS: directory correctly absent — north-star NOT created when confirm=no"
else
  FAILED=$((FAILED + 1))
  echo "  FAIL: directory should not exist — north-star was created when confirm=no"
fi

if [[ ! -f "$TEST_VAULT4/inbox.md" ]]; then
  echo "  PASS: file correctly absent — inbox.md NOT created when confirm=no"
else
  FAILED=$((FAILED + 1))
  echo "  FAIL: file should not exist — inbox.md was created when confirm=no"
fi

if [[ ! -f "$TEST_VAULT4/AGENTS.md" ]]; then
  echo "  PASS: file correctly absent — AGENTS.md NOT created when confirm=no"
else
  FAILED=$((FAILED + 1))
  echo "  FAIL: file should not exist — AGENTS.md was created when confirm=no"
fi

echo ""
assert_summary