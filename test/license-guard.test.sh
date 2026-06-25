#!/usr/bin/env bash
# license-guard.test.sh — Block premature license claims in engine-owned paths.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

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

echo "=== License guard ==="
echo ""

check "no root LICENSE file" "test ! -f '$ENGINE_DIR/LICENSE'"
check "no root LICENSE.md file" "test ! -f '$ENGINE_DIR/LICENSE.md'"

SPDX_HITS=$(
  grep -R -l -F 'SPDX-License-Identifier' \
    "$ENGINE_DIR/skills" \
    "$ENGINE_DIR/scripts" \
    "$ENGINE_DIR/hooks" \
    "$ENGINE_DIR/templates" \
    "$ENGINE_DIR/test/fixtures" \
    "$ENGINE_DIR/setup.sh" \
    "$ENGINE_DIR/update.sh" \
    2>/dev/null || true
)
check "no SPDX headers in engine scripts/skills" "test -z '$SPDX_HITS'"

check "README does not assert MIT project license" "! grep -qE 'MIT — see \[LICENSE\]' '$ENGINE_DIR/README.md'"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ "$FAIL" -eq 0 ]] || exit 1
