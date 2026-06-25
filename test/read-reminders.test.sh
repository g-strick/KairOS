#!/usr/bin/env bash
# read-reminders.test.sh — Tests for hooks/read-reminders.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
READ_REMINDERS="$ENGINE_DIR/hooks/read-reminders.sh"

source "$SCRIPT_DIR/lib/assert.sh"

echo "=== read-reminders.sh Tests ==="
echo ""

assert_file "$READ_REMINDERS" "read-reminders.sh exists"

if [[ -x "$READ_REMINDERS" ]]; then
  echo "  PASS: read-reminders.sh is executable"
  ((ASSERTIONS_PASSED++)) || true
else
  echo "  FAIL: read-reminders.sh is not executable"
  ((ASSERTIONS_FAILED++)) || true
fi

if grep -q 'osascript' "$READ_REMINDERS" && grep -q 'Reminders' "$READ_REMINDERS"; then
  echo "  PASS: script references osascript and Reminders"
  ((ASSERTIONS_PASSED++)) || true
else
  echo "  FAIL: script missing osascript or Reminders references"
  ((ASSERTIONS_FAILED++)) || true
fi

echo ""
echo "--- Non-Darwin skip (mocked) ---"
SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT

cat > "$SANDBOX/uname-linux" <<'EOF'
#!/usr/bin/env bash
echo Linux
EOF
chmod +x "$SANDBOX/uname-linux"

cat > "$SANDBOX/uname-darwin" <<'EOF'
#!/usr/bin/env bash
echo Darwin
EOF
chmod +x "$SANDBOX/uname-darwin"

cp "$SANDBOX/uname-linux" "$SANDBOX/uname"
chmod +x "$SANDBOX/uname"
PATH="$SANDBOX:$PATH"

stderr_out="$SANDBOX/stderr.txt"
set +e
bash "$READ_REMINDERS" 2>"$stderr_out"
exit_code=$?
set -e

assert_eq "0" "$exit_code" "non-Darwin exits 0"
if grep -q 'macOS only' "$stderr_out"; then
  echo "  PASS: stderr mentions macOS-only skip"
  ((ASSERTIONS_PASSED++)) || true
else
  echo "  FAIL: stderr missing macOS-only skip message"
  ((ASSERTIONS_FAILED++)) || true
fi

echo ""
echo "--- Malformed KAIROS_REMINDERS_DAYS ---"
cp "$SANDBOX/uname-darwin" "$SANDBOX/uname"
chmod +x "$SANDBOX/uname"

stderr_bad="$SANDBOX/stderr-bad-days.txt"
set +e
KAIROS_REMINDERS_DAYS=not-a-number bash "$READ_REMINDERS" 2>"$stderr_bad"
bad_exit=$?
set -e

assert_eq "0" "$bad_exit" "invalid KAIROS_REMINDERS_DAYS exits 0"
if grep -q 'KAIROS_REMINDERS_DAYS' "$stderr_bad"; then
  echo "  PASS: invalid days env produces helpful stderr"
  ((ASSERTIONS_PASSED++)) || true
else
  echo "  FAIL: invalid days env missing helpful stderr"
  ((ASSERTIONS_FAILED++)) || true
fi

echo ""
echo "--- Mock osascript (Darwin path) ---"
MOCK_OSASCRIPT="$SANDBOX/mock-osascript"
cat > "$MOCK_OSASCRIPT" <<'EOF'
#!/usr/bin/env bash
echo $'Groceries\tBuy milk\t2026-06-24\t0'
EOF
chmod +x "$MOCK_OSASCRIPT"

# Darwin uname already active from previous test

stdout_mock="$SANDBOX/stdout-mock.txt"
set +e
KAIROS_OSASCRIPT="$MOCK_OSASCRIPT" bash "$READ_REMINDERS" >"$stdout_mock" 2>/dev/null
mock_exit=$?
set -e

assert_eq "0" "$mock_exit" "mock osascript exits 0"
if grep -q '## Reminders' "$stdout_mock" && grep -q 'Buy milk' "$stdout_mock"; then
  echo "  PASS: mock osascript output formatted as markdown"
  ((ASSERTIONS_PASSED++)) || true
else
  echo "  FAIL: mock osascript output not formatted correctly"
  cat "$stdout_mock" >&2
  ((ASSERTIONS_FAILED++)) || true
fi

assert_summary
