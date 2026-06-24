#!/usr/bin/env bash
set -euo pipefail

# setup.test.sh — End-to-end tests for setup.sh vault scaffolder
# Usage: bash test/setup.test.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SETUP="$ENGINE_DIR/setup.sh"

source "$SCRIPT_DIR/lib/assert.sh"

SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT

echo "=== KairOS setup.sh End-to-End Tests ==="
echo "Sandbox: $SANDBOX"
echo ""

echo "--- Test 1: Fresh scaffold creates vault structure ---"
TEST_VAULT="$SANDBOX/test1-vault"

KAIROS_VAULT="$TEST_VAULT" KAIROS_YES=1 bash "$SETUP" 2>/dev/null || true

assert_dir "$TEST_VAULT/inbox" "inbox/"
assert_dir "$TEST_VAULT/daily" "daily/"
assert_dir "$TEST_VAULT/projects" "projects/"
assert_dir "$TEST_VAULT/someday" "someday/"
assert_dir "$TEST_VAULT/archive" "archive/"
assert_dir "$TEST_VAULT/goals" "goals/"
assert_dir "$TEST_VAULT/scripts" "scripts/"
assert_dir "$TEST_VAULT/_engine" "_engine/"
assert_file "$TEST_VAULT/goals/current.md" "goals/current.md seed"
assert_file "$TEST_VAULT/daily/TEMPLATE.md" "daily/TEMPLATE.md seed"
assert_file "$TEST_VAULT/_engine/NOW.md" "_engine/NOW.md seed"
assert_file "$TEST_VAULT/_engine/HANDOFF.md" "_engine/HANDOFF.md seed"
assert_file "$TEST_VAULT/inbox/README.md" "inbox/README.md seed"
assert_file "$TEST_VAULT/AGENTS.md" "AGENTS.md seed"

if [[ -f "$TEST_VAULT/inbox.md" ]]; then
  FAILED=$((FAILED + 1))
  echo "  FAIL: inbox.md should not exist — use inbox/ folder"
else
  echo "  PASS: inbox.md correctly absent (inbox/ folder used)"
fi

if [[ -d "$TEST_VAULT/north-star" || -d "$TEST_VAULT/council" ]]; then
  FAILED=$((FAILED + 1))
  echo "  FAIL: legacy folders (north-star/council) should not exist"
else
  echo "  PASS: legacy folders absent"
fi

if [[ -f "$TEST_VAULT/profile.md" ]]; then
  FAILED=$((FAILED + 1))
  echo "  FAIL: profile.md should be created by /onboard, not setup"
else
  echo "  PASS: profile.md correctly absent (created by /onboard)"
fi

echo ""

echo "--- Test 2: Seed files are regular files ---"
assert_file "$TEST_VAULT/inbox/README.md" "inbox/README.md is a file"
assert_file "$TEST_VAULT/AGENTS.md" "AGENTS.md is a file"

echo ""

echo "--- Test 3: Existing vault with Cancel leaves it unchanged ---"
TEST_VAULT3="$SANDBOX/test3-vault"
mkdir -p "$TEST_VAULT3"
echo "keep me" > "$TEST_VAULT3/keep-me.txt"

echo -e "\nc" | KAIROS_VAULT="$TEST_VAULT3" bash "$SETUP" 2>/dev/null || true

assert_file "$TEST_VAULT3/keep-me.txt" "marker file still exists after cancel"

echo ""

echo "--- Test 4: 'no' at confirm creates nothing ---"
TEST_VAULT4="$SANDBOX/test4-vault"
mkdir -p "$TEST_VAULT4"

echo -e "\nn" | KAIROS_VAULT="$TEST_VAULT4" bash "$SETUP" 2>/dev/null || true

if [[ ! -d "$TEST_VAULT4/daily" ]]; then
  echo "  PASS: daily/ NOT created when confirm=no"
else
  FAILED=$((FAILED + 1))
  echo "  FAIL: daily/ was created when confirm=no"
fi

if [[ ! -d "$TEST_VAULT4/inbox" ]]; then
  echo "  PASS: inbox/ NOT created when confirm=no"
else
  FAILED=$((FAILED + 1))
  echo "  FAIL: inbox/ was created when confirm=no"
fi

if [[ ! -f "$TEST_VAULT4/inbox.md" && ! -d "$TEST_VAULT4/inbox" ]]; then
  :
else
  if [[ -f "$TEST_VAULT4/inbox.md" ]]; then
    FAILED=$((FAILED + 1))
    echo "  FAIL: inbox.md should not be created"
  fi
fi

echo ""
assert_summary
