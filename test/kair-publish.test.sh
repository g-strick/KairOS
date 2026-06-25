#!/usr/bin/env bash
# kair-publish.test.sh — Tests kair-publish.sh with stub rem.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PUBLISH="$ENGINE_DIR/scripts/kair-publish.sh"
STUB_REM="$SCRIPT_DIR/fixtures/stub-rem.sh"

source "$SCRIPT_DIR/lib/assert.sh"

SANDBOX=$(mktemp -d)
STUB_STATE=$(mktemp -d)
trap 'rm -rf "$SANDBOX" "$STUB_STATE"' EXIT

export REM_BIN="$STUB_REM"
export REM_STUB_STATE_DIR="$STUB_STATE"
export PATH="$SANDBOX/bin:$PATH"

# Pretend darwin for rem_preflight — stub rem skips darwin check if we patch rem.sh...
# rem_preflight checks uname; run test only on darwin OR patch via uname stub
mkdir -p "$SANDBOX/bin"
cat > "$SANDBOX/bin/uname" <<'EOF'
#!/usr/bin/env bash
[[ "${1:-}" == "-s" ]] && echo Darwin && exit 0
exec /usr/bin/uname "$@"
EOF
chmod +x "$SANDBOX/bin/uname"

VAULT="$SANDBOX/vault"
mkdir -p "$VAULT/projects" "$VAULT/inbox"

cat > "$VAULT/next-actions.md" <<'EOF'
# Next actions

- [ ] @Computer Ship publish test
- [x] @Computer Done item
EOF

cat > "$VAULT/projects/website.md" <<'EOF'
# Website relaunch

## Next action
- [ ] @Errands Buy domain name
EOF

echo ""
echo "=== kair-publish.sh tests ==="
echo ""

echo "--- Test 1: publish adds actionable items ---"
KAIROS_VAULT="$VAULT" bash "$PUBLISH" "$VAULT"

count="$(REM_STUB_STATE_DIR="$STUB_STATE" "$STUB_REM" list --list Actions -o json | jq '[.[] | select(.completed != true)] | length')"
assert_eq "2" "$count" "two incomplete actions published"

echo ""

echo "--- Test 2: publish clears and replaces ---"
cat > "$VAULT/next-actions.md" <<'EOF'
# Next actions

- [ ] @Computer Only one now
EOF
rm -f "$VAULT/projects/"*.md

KAIROS_VAULT="$VAULT" bash "$PUBLISH" "$VAULT"
count="$(REM_STUB_STATE_DIR="$STUB_STATE" "$STUB_REM" list --list Actions -o json | jq '[.[] | select(.completed != true)] | length')"
assert_eq "1" "$count" "reconcile leaves one action"

title="$(REM_STUB_STATE_DIR="$STUB_STATE" "$STUB_REM" list --list Actions --incomplete -o json | jq -r '.[0].title // empty')"
assert_eq "@Computer Only one now" "$title" "correct title after reconcile"

echo ""
assert_summary
