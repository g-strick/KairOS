#!/usr/bin/env bash
# assert.sh — Pure-bash assertion helpers for KairOS tests.
# Source this file in your test script, then use the assert_* functions.
# Prints PASS/FAIL per assertion and a summary count at the end.
# Requires bash 5.x (for arrays and namerefs).

set -euo pipefail

# ── Counters (global so functions can mutate them) ──
ASSERT_PASSED=0
ASSERT_FAILED=0

# ── Helpers ──

# assert_dir PATH [MSG]
# Passes if PATH exists and is a directory.
assert_dir() {
  local path="$1"
  local msg="${2:-directory $path}"
  if [[ -d "$path" ]]; then
    echo "  PASS: $msg"
    ((ASSERT_PASSED++))
  else
    echo "  FAIL: $msg (not a directory, or missing: $path)"
    ((ASSERT_FAILED++))
  fi
}

# assert_file PATH [MSG]
# Passes if PATH exists and is a regular file.
assert_file() {
  local path="$1"
  local msg="${2:-file $path}"
  if [[ -f "$path" ]]; then
    echo "  PASS: $msg"
    ((ASSERT_PASSED++))
  else
    echo "  FAIL: $msg (not a regular file, or missing: $path)"
    ((ASSERT_FAILED++))
  fi
}

# assert_eq EXPECTED ACTUAL [MSG]
# Passes if EXPECTED equals ACTUAL (string comparison).
assert_eq() {
  local expected="$1"
  local actual="$2"
  local msg="${3:-expected "$expected" equals actual}"
  if [[ "$expected" == "$actual" ]]; then
    echo "  PASS: $msg"
    ((ASSERT_PASSED++))
  else
    echo "  FAIL: $msg (got '$actual')"
    ((ASSERT_FAILED++))
  fi
}

# assert_exit_code EXPECTED_CMD...
# Passes if the command exits with code 0; fails otherwise.
# Usage: assert_exit_code 0 bash -c 'false'  → fails
#         assert_exit_code 0 bash -c 'true'   → passes
# We capture the exit code manually since the function itself must not
# trigger set -e on the command under test.
assert_exit_code() {
  local expected_code="$1"
  shift
  local msg="${1:-command exit code $expected_code}"
  local actual_code=0
  "$@" || actual_code=$?
  if [[ "$actual_code" -eq "$expected_code" ]]; then
    echo "  PASS: $msg (exit $actual_code)"
    ((ASSERT_PASSED++))
  else
    echo "  FAIL: $msg (expected $expected_code, got $actual_code)"
    ((ASSERT_FAILED++))
  fi
}

# assert_contains FILE SUBSTRING [MSG]
# Passes if FILE contains SUBSTRING.
assert_contains() {
  local file="$1"
  local substring="$2"
  local msg="${3:-file $file contains \"$substring\"}"
  if [[ -f "$file" ]] && grep -qF -- "$substring" "$file"; then
    echo "  PASS: $msg"
    ((ASSERT_PASSED++))
  else
    echo "  FAIL: $msg"
    ((ASSERT_FAILED++))
  fi
}

# assert_not_contains FILE SUBSTRING [MSG]
# Passes if FILE does NOT contain SUBSTRING.
assert_not_contains() {
  local file="$1"
  local substring="$2"
  local msg="${3:-file $file does not contain \"$substring\"}"
  if [[ -f "$file" ]] && ! grep -qF -- "$substring" "$file"; then
    echo "  PASS: $msg"
    ((ASSERT_PASSED++))
  else
    echo "  FAIL: $msg"
    ((ASSERT_FAILED++))
  fi
}

# ── Summary ──

assert_summary() {
  echo ""
  echo "── Test Summary ──"
  echo "  Passed: $ASSERT_PASSED"
  echo "  Failed: $ASSERT_FAILED"
  echo "  Total:  $((ASSERT_PASSED + ASSERT_FAILED))"
  echo "──────────────────"
  if [[ "$ASSERT_FAILED" -gt 0 ]]; then
    return 1
  fi
  return 0
}
