#!/usr/bin/env bash
# kair-triage.test.sh — Tests for triage helpers and ASCII desk display.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
HELPERS="$ENGINE_DIR/scripts/kair-process-helpers.sh"
DISPLAY="$ENGINE_DIR/scripts/kair-triage-display.sh"

PASS=0
FAIL=0

check() {
  local desc="$1"
  local check_cmd="$2"
  if eval "$check_cmd" >/dev/null 2>&1; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc"
    FAIL=$((FAIL + 1))
  fi
}

check_output() {
  local desc="$1"
  local pattern="$2"
  shift 2
  local out
  out="$("$@" 2>/dev/null || true)"
  if printf '%s\n' "$out" | grep -q "$pattern"; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== kair-triage Tests ==="
echo ""

echo "Scripts:"
check "kair-triage-display.sh exists" "test -f '$DISPLAY'"
check "kair-process-helpers.sh exists" "test -f '$HELPERS'"
chmod +x "$DISPLAY" 2>/dev/null || true

echo "Display (ASCII):"
check_output "intro renders KAIR TRIAGE" "KAIR TRIAGE" bash "$DISPLAY" intro
check_output "empty desk message" "Nothing to triage" bash "$DISPLAY" empty
check_output "done shows desk clear" "desk clear" bash "$DISPLAY" done
check_output "progress shows papers" '\[##\]' bash "$DISPLAY" progress 3 5
check_output "progress shows percent" '60% full' bash "$DISPLAY" progress 3 5
check_output "progress 0 remaining" '0% full' bash "$DISPLAY" progress 0 4

echo "Helpers (sandbox vault):"
SANDBOX=$(mktemp -d)
STUB_STATE=$(mktemp -d)
trap 'rm -rf "$SANDBOX" "$STUB_STATE"' EXIT

mkdir -p "$SANDBOX/bin" "$SANDBOX/inbox" "$SANDBOX/projects" "$SANDBOX/reference"
cat > "$SANDBOX/bin/uname" <<'EOF'
#!/usr/bin/env bash
[[ "${1:-}" == "-s" ]] && echo Darwin && exit 0
exec /usr/bin/uname "$@"
EOF
chmod +x "$SANDBOX/bin/uname"

export REM_BIN="$SCRIPT_DIR/fixtures/stub-rem.sh"
export REM_STUB_STATE_DIR="$STUB_STATE"
export PATH="$SANDBOX/bin:$PATH"
printf '# Next\n' > "$SANDBOX/next-actions.md"
printf '# Wait\n' > "$SANDBOX/waiting-for.md"
printf '# Someday\n' > "$SANDBOX/someday-maybe.md"
cat > "$SANDBOX/inbox/2025-06-25-test-item.md" <<'EOF'
# Test capture

Buy more coffee filters
EOF

export KAIROS_VAULT="$SANDBOX"

check_output "list-triage includes vault item" $'vault\t' bash "$HELPERS" list-triage
check_output "list-triage has title" 'Test capture' bash "$HELPERS" list-triage
check_output "count-triage is 1" '^1$' bash "$HELPERS" count-triage

# Order: reminders before vault when both exist (mock reminder line prepended manually)
check "list-triage vault path absolute" "bash \"$HELPERS\" list-triage | grep -q '$SANDBOX/inbox/'"

echo "Skill:"
check "kair-triage skill exists" "test -s '$ENGINE_DIR/skills/kair-triage/SKILL.md'"
check "skill uses list-triage" "grep -q 'list-triage' '$ENGINE_DIR/skills/kair-triage/SKILL.md'"
check "skill uses display script" "grep -q 'kair-triage-display' '$ENGINE_DIR/skills/kair-triage/SKILL.md'"
check "skill forbids proprietary UI" "grep -q 'No proprietary' '$ENGINE_DIR/skills/kair-triage/SKILL.md'"
check "skill has refinement loop" "grep -q 'Regenerate four new options' '$ENGINE_DIR/skills/kair-triage/SKILL.md'"
check "legacy inbox redirects" "grep -q '/kair-triage' '$ENGINE_DIR/skills/kair-process-inbox/SKILL.md'"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ "$FAIL" -eq 0 ]] || exit 1
