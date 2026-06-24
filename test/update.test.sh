#!/usr/bin/env bash
set -euo pipefail

# test/update.test.sh — Allowlist sync tests for update.sh
# Driven by plan 01-03 (Foundation, plan 03)
# Uses the assertion harness from test/lib/assert.sh
#
# TDD RED: update.sh does not yet exist at the repo root, so these tests MUST fail.
# After Task 2 implements update.sh at the repo root, they should turn GREEN.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/lib/assert.sh"

# Engine source: where update.sh reads engine content from
ENGINE_SRC=$(mktemp -d)
# Target vault: where update.sh copies to
VAULT=$(mktemp -d)

# Cleanup on exit
trap 'rm -rf "$ENGINE_SRC" "$VAULT"' EXIT

# --- Seed the engine source with test fixtures ---

# Create allowlisted content
mkdir -p "$ENGINE_SRC/skills"
echo "# Skill template" > "$ENGINE_SRC/skills/SKILL.md"

mkdir -p "$ENGINE_SRC/agents"
echo "# Agent template" > "$ENGINE_SRC/agents/.gitkeep"

mkdir -p "$ENGINE_SRC/hooks"
echo "# Hook template" > "$ENGINE_SRC/hooks/pre-push"

mkdir -p "$ENGINE_SRC/styles"
touch "$ENGINE_SRC/styles/.gitkeep"

mkdir -p "$ENGINE_SRC/templates"
echo "# Template" > "$ENGINE_SRC/templates/README.md"

# Create AGENTS.md stub
echo "# KairOS" > "$ENGINE_SRC/AGENTS.md"

# Create templates/allowlist.txt in engine source
cat > "$ENGINE_SRC/templates/allowlist.txt" << 'ALLOWLIST'
skills/
agents/
hooks/
styles/
templates/
AGENTS.md
ALLOWLIST

# Create NON-allowlisted content (should NOT be copied)
echo "SECRET NOTES" > "$ENGINE_SRC/secret-notes.md"
mkdir -p "$ENGINE_SRC/private"
echo "private data" > "$ENGINE_SRC/private/data.txt"

# Path to update.sh under test — initially does not exist at repo root
UPDATE_SH="$ROOT_DIR/update.sh"

# --- Test 1: Allowlist positive — allowlisted content IS copied ---
echo "TEST 1: Allowlist positive — allowlisted content syncs"

# Run update.sh with explicit engine source and vault target
set +e
bash "$UPDATE_SH" "$ENGINE_SRC" "$VAULT"
RC1=$?
set -e

if [ "$RC1" -eq 0 ]; then
  # Assert allowlisted content arrived
  assert_dir "$VAULT/skills" "skills/ directory exists in vault"
  assert_file "$VAULT/skills/SKILL.md" "skills/SKILL.md exists in vault"
  assert_dir "$VAULT/agents" "agents/ directory exists in vault"
  assert_file "$VAULT/agents/.gitkeep" "agents/.gitkeep exists in vault"
  assert_dir "$VAULT/hooks" "hooks/ directory exists in vault"
  assert_dir "$VAULT/styles" "styles/ directory exists in vault"
  assert_file "$VAULT/AGENTS.md" "AGENTS.md exists in vault"
else
  # EXPECTED FAIL: update.sh does not exist yet (RED step)
  assert_exit_code 0 "bash $UPDATE_SH $ENGINE_SRC $VAULT" "update.sh should exist and run"
fi

# --- Test 2: Allowlist negative — NON-allowlisted content is NOT copied ---
echo "TEST 2: Allowlist negative — non-allowlisted files do NOT sync"

if [ "$RC1" -eq 0 ]; then
  # Assert non-allowlisted content is absent
  assert_not_exists "$VAULT/secret-notes.md" "secret-notes.md should NOT be in vault"
  assert_not_exists "$VAULT/private" "private/ should NOT be in vault"
else
  # Red step — skip negative assertions until script exists
  echo "  SKIPPED (RED): update.sh not yet implemented"
fi

# --- Test 3: Strict overwrite — engine wins on allowlisted paths ---
echo "TEST 3: Strict overwrite — engine version wins"

if [ "$RC1" -eq 0 ]; then
  # Modify the file in vault to something different
  echo "vault custom content" > "$VAULT/skills/SKILL.md"

  # Run update again
  set +e
  bash "$UPDATE_SH" "$ENGINE_SRC" "$VAULT"
  set -e

  # Engine version should have overwritten vault version
  assert_file "$VAULT/skills/SKILL.md" "skills/SKILL.md still exists after re-sync"
else
  echo "  SKIPPED (RED): update.sh not yet implemented"
fi

# --- Test 4: Non-interactive mode via env override ---
echo "TEST 4: Non-interactive mode via env override"

VAULT2=$(mktemp -d)
trap 'rm -rf "$ENGINE_SRC" "$VAULT" "$VAULT2"' EXIT

if [ "$RC1" -eq 0 ]; then
  set +e
  KAIROS_VAULT="$VAULT2" GSD_ENGINE_ROOT="$ENGINE_SRC" bash "$UPDATE_SH"
  set -e
  assert_dir "$VAULT2/skills" "skills/ exists with env override"
  assert_file "$VAULT2/AGENTS.md" "AGENTS.md exists with env override"
else
  echo "  SKIPPED (RED): update.sh not yet implemented"
fi

# --- Summary ---
assert_summary