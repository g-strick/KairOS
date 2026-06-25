#!/usr/bin/env bash
# setup.test.sh — End-to-end tests for setup.sh vault scaffolder
# Usage: bash test/setup.test.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SETUP="$ENGINE_DIR/setup.sh"

source "$SCRIPT_DIR/lib/assert.sh"

SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT

echo "=== KairOS setup.sh End-to-End Tests ==="
echo "Sandbox: $SANDBOX"
echo ""

echo "--- Test 1: Fresh scaffold creates minimal vault structure ---"
TEST_VAULT="$SANDBOX/test1-vault"

KAIROS_VAULT="$TEST_VAULT" KAIROS_YES=1 bash "$SETUP" 2>/dev/null || true

assert_dir "$TEST_VAULT/daily" "daily"
assert_dir "$TEST_VAULT/inbox" "inbox"
assert_dir "$TEST_VAULT/projects" "projects"
assert_dir "$TEST_VAULT/reference" "reference"
assert_file "$TEST_VAULT/inbox/README.md" "inbox README"
assert_file "$TEST_VAULT/next-actions.md" "next-actions.md"
assert_file "$TEST_VAULT/waiting-for.md" "waiting-for.md"
assert_file "$TEST_VAULT/someday-maybe.md" "someday-maybe.md"
assert_file "$TEST_VAULT/AGENTS.md" "AGENTS.md seed file"
assert_file "$TEST_VAULT/VAULT.md" "VAULT.md orientation"
assert_file "$TEST_VAULT/INDEX.md" "INDEX.md navigation map"
assert_file "$TEST_VAULT/reference/README.md" "reference README"
assert_file "$TEST_VAULT/_kair/README.md" "_kair README"
assert_file "$TEST_VAULT/.engine-root" ".engine-root points at engine"
assert_file "$TEST_VAULT/.engine-remote" ".engine-remote GitHub URL"
assert_file "$TEST_VAULT/.engine-branch" ".engine-branch default"
assert_not_exists "$TEST_VAULT/inbox.md" "legacy inbox.md not created"

if [[ -d "$TEST_VAULT/north-star" ]]; then
  FAILED=$((FAILED + 1))
  echo "  FAIL: north-star/ should not be created in lean scaffold"
else
  echo "  PASS: north-star/ correctly absent"
fi

echo ""

echo "--- Test 2: Seed files are regular files ---"
assert_file "$TEST_VAULT/AGENTS.md" "AGENTS.md is a file"

echo ""

echo "--- Test 3: Existing vault with Cancel leaves it unchanged ---"
TEST_VAULT3="$SANDBOX/test3-vault"
mkdir -p "$TEST_VAULT3"
echo "keep me" > "$TEST_VAULT3/keep-me.txt"

echo -e "\nc" | KAIROS_VAULT="$TEST_VAULT3" bash "$SETUP" 2>/dev/null || true

assert_file "$TEST_VAULT3/keep-me.txt" "cancel leaves existing files"

echo ""

echo "--- Test 4: Legacy inbox.md migrates into inbox/ ---"
TEST_VAULT4="$SANDBOX/test4-vault"
KAIROS_VAULT="$TEST_VAULT4" KAIROS_YES=1 bash "$SETUP" 2>/dev/null || true
echo "# Inbox — capture anything here with /kair-capture." > "$TEST_VAULT4/inbox.md"
echo "- **2026-01-01 12:00** — legacy item" >> "$TEST_VAULT4/inbox.md"
bash "$ENGINE_DIR/scripts/migrate-inbox-md.sh" "$TEST_VAULT4"

assert_not_exists "$TEST_VAULT4/inbox.md" "inbox.md removed after migration"
if ls "$TEST_VAULT4/inbox/"*-migrated-from-inbox-md.md >/dev/null 2>&1; then
  echo "  PASS: migrated capture file exists in inbox/"
  ((ASSERTIONS_PASSED++)) || true
else
  echo "  FAIL: migrated capture file missing in inbox/"
  ((ASSERTIONS_FAILED++)) || true
fi

echo ""
assert_summary
