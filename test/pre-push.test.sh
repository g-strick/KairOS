#!/usr/bin/env bash
set -euo pipefail

# test/pre-push.test.sh — Pre-push content-glob hook tests
# Driven by plan 01-03 (Foundation, plan 03)
# Uses the assertion harness from test/lib/assert.sh
#
# TDD RED: hooks/pre-push and hooks/content-globs.txt do not yet exist,
# so these tests MUST fail. After Task 3 implements them, they should turn GREEN.
#
# NOTE: We invoke the hook directly (not via actual git push) because
# `git push --no-verify` skips pre-push hooks entirely, so a real push
# cannot be the test vehicle for the abort path. Direct invocation tests
# the hook's logic deterministically.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/lib/assert.sh"

# Verify prerequisites exist before running tests
GLOBS_FILE="$ROOT_DIR/hooks/content-globs.txt"
HOOK_FILE="$ROOT_DIR/hooks/pre-push"

if [ ! -f "$GLOBS_FILE" ]; then
  echo "  EXPECTED FAIL: hooks/content-globs.txt does not exist yet (RED step)"
  assert_exit_code 0 "cat $GLOBS_FILE" "content-globs.txt should exist"
  assert_summary
  exit 0
fi

if [ ! -f "$HOOK_FILE" ]; then
  echo "  EXPECTED FAIL: hooks/pre-push does not exist yet (RED step)"
  assert_exit_code 0 "cat $HOOK_FILE" "pre-push hook should exist"
  assert_summary
  exit 0
fi

# --- Test 1: Abort — tracked file matching a content glob causes non-zero exit ---
echo "TEST 1: Abort — tracked file matching content glob causes hook to fail"

REPO1=$(mktemp -d)
trap 'rm -rf "$REPO1" "$REPO2"' EXIT

# Initialize a temp git repo
cd "$REPO1"
git init -q
git config user.email "test@example.com"
git config user.name "Test"

# Copy the content-globs list
mkdir -p hooks
cp "$GLOBS_FILE" hooks/content-globs.txt

# Create a file that matches a content glob (e.g. daily/2026-06-24.md)
mkdir -p daily
echo "# Daily note" > daily/2026-06-24.md

# Stage and commit it
git add daily/2026-06-24.md
git commit -q -m "test: add daily note" 2>/dev/null || true

# Install the pre-push hook
cp "$HOOK_FILE" .git/hooks/pre-push
chmod +x .git/hooks/pre-push

# Run the hook and capture output + exit code
set +e
OUTPUT=$(bash .git/hooks/pre-push 2>&1)
RC=$?
set -e

if [ "$RC" -ne 0 ]; then
  echo "  PASS: hook exited non-zero ($RC) when content glob matched"
  ((ASSERTIONS_PASSED++)) || true
else
  echo "  FAIL: hook should exit non-zero when content glob matched"
  ((ASSERTIONS_FAILED++)) || true
fi

echo "$OUTPUT" | grep -qi "block" && echo "  PASS: hook output indicates blocked" || echo "  FAIL: hook output should indicate blocked"

# --- Test 2: Allow — safe tree causes zero exit ---
echo "TEST 2: Allow — safe tree causes hook to pass"

REPO2=$(mktemp -d)
trap 'rm -rf "$REPO1" "$REPO2"' EXIT

cd "$REPO2"
git init -q
git config user.email "test@example.com"
git config user.name "Test"

mkdir -p hooks
cp "$GLOBS_FILE" hooks/content-globs.txt

# Create only safe files (no vault content)
mkdir -p skills
echo "# Skill" > skills/SKILL.md
echo "# KairOS" > AGENTS.md

git add skills/SKILL.md AGENTS.md hooks/content-globs.txt
git commit -q -m "test: add safe files" 2>/dev/null || true

cp "$HOOK_FILE" .git/hooks/pre-push
chmod +x .git/hooks/pre-push

set +e
OUTPUT2=$(bash .git/hooks/pre-push 2>&1)
RC2=$?
set -e

if [ "$RC2" -eq 0 ]; then
  echo "  PASS: hook exited zero when no content globs matched"
  ((ASSERTIONS_PASSED++)) || true
else
  echo "  FAIL: hook should exit zero when no content globs matched (got $RC2)"
  ((ASSERTIONS_FAILED++)) || true
fi

# --- Test 3: Message — on abort, output names the offending file ---
echo "TEST 3: Message — on abort, output names the offending file"

# Re-create REPO3 with a daily note to test the message
REPO3=$(mktemp -d)
trap 'rm -rf "$REPO1" "$REPO2" "$REPO3"' EXIT

cd "$REPO3"
git init -q
git config user.email "test@example.com"
git config user.name "Test"

mkdir -p hooks daily
cp "$GLOBS_FILE" hooks/content-globs.txt
echo "# Daily note" > daily/2026-06-24.md

git add daily/2026-06-24.md
git commit -q -m "test: add daily note" 2>/dev/null || true

cp "$HOOK_FILE" .git/hooks/pre-push
chmod +x .git/hooks/pre-push

set +e
OUTPUT3=$(bash .git/hooks/pre-push 2>&1) || true
set -e

echo "$OUTPUT3" | grep -q "2026-06-24.md" && echo "  PASS: output names offending file" || echo "  FAIL: output should name the offending file"

# --- Summary ---
cd "$ROOT_DIR"
assert_summary
