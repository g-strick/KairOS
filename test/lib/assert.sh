#!/usr/bin/env bash
set -euo pipefail

# assert.sh — Pure-bash assertion helpers for KairOS tests
# Usage: source this file, then call assert_* functions
# Each prints PASS or FAIL with an optional message

ASSERTIONS_PASSED=0
ASSERTIONS_FAILED=0

# Assert that PATH is a directory
assert_dir() {
  local path="$1"
  local msg="${2:-}"
  if [[ -d "$path" ]]; then
    echo "  PASS: directory exists — $path ${msg}"
    ((ASSERTIONS_PASSED++)) || true
  else
    echo "  FAIL: directory missing — $path ${msg}"
    ((ASSERTIONS_FAILED++)) || true
  fi
}

# Assert that PATH is a regular file
assert_file() {
  local path="$1"
  local msg="${2:-}"
  if [[ -f "$path" ]]; then
    echo "  PASS: file exists — $path ${msg}"
    ((ASSERTIONS_PASSED++)) || true
  else
    echo "  FAIL: file missing — $path ${msg}"
    ((ASSERTIONS_FAILED++)) || true
  fi
}

# Assert that PATH does NOT exist (file or directory)
assert_not_exists() {
  local path="$1"
  local msg="${2:-}"
  if [[ ! -e "$path" ]]; then
    echo "  PASS: does not exist — $path ${msg}"
    ((ASSERTIONS_PASSED++)) || true
  else
    echo "  FAIL: should not exist — $path ${msg}"
    ((ASSERTIONS_FAILED++)) || true
  fi
}

# Assert that EXPECTED equals ACTUAL
assert_eq() {
  local expected="$1"
  local actual="$2"
  local msg="${3:-}"
  if [[ "$expected" == "$actual" ]]; then
    echo "  PASS: values match — '$expected' == '$actual' ${msg}"
    ((ASSERTIONS_PASSED++)) || true
  else
    echo "  FAIL: values differ — expected '$expected', got '$actual' ${msg}"
    ((ASSERTIONS_FAILED++)) || true
  fi
}

# Assert that CMD exits with EXPECTED code
assert_exit_code() {
  local expected="$1"
  shift
  local msg="${1:-}"
  local cmd="$*"
  local actual
  set +e
  bash -c "$cmd" >/dev/null 2>&1
  actual=$?
  set -e
  if [[ "$expected" == "$actual" ]]; then
    echo "  PASS: exit code $actual (expected $expected) — ${cmd} ${msg}"
    ((ASSERTIONS_PASSED++)) || true
  else
    echo "  FAIL: exit code $actual (expected $expected) — ${cmd} ${msg}"
    ((ASSERTIONS_FAILED++)) || true
  fi
}

# Print summary and exit non-zero if any failures
assert_summary() {
  echo ""
  echo "================================"
  echo "  Assertions: $ASSERTIONS_PASSED passed, $ASSERTIONS_FAILED failed"
  echo "================================"
  if [[ "$ASSERTIONS_FAILED" -gt 0 ]]; then
    return 1
  fi
  return 0
}