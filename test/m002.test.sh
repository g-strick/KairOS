#!/usr/bin/env bash
# M002 verification — Phase 2 daily-proof skills exist and AGENTS.md lists them.

set -euo pipefail

PASS=0
FAIL=0

check() {
    local desc="$1"
    local check="$2"
    if eval "$check" >/dev/null 2>&1; then
        echo "  PASS: $desc"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: $desc"
        FAIL=$((FAIL + 1))
    fi
}

echo "=== M002: Daily Proof Skills ==="
echo ""

echo "Onboard skill:"
check "skills/onboard/SKILL.md exists" "test -s skills/onboard/SKILL.md"
check "onboard resolves KAIROS_VAULT" "grep -q 'KAIROS_VAULT' skills/onboard/SKILL.md"
check "onboard trigger is /onboard" "grep -q '/onboard' skills/onboard/SKILL.md"

echo "Capture skill:"
check "skills/capture/SKILL.md exists" "test -s skills/capture/SKILL.md"
check "capture writes to inbox.md" "grep -q 'inbox.md' skills/capture/SKILL.md"

echo "Daily skill:"
check "skills/daily/SKILL.md exists" "test -s skills/daily/SKILL.md"
check "daily reads inbox" "grep -q 'inbox' skills/daily/SKILL.md"
check "daily writes daily/" "grep -q 'daily/' skills/daily/SKILL.md"

echo "Help skill:"
check "skills/help/SKILL.md exists" "test -s skills/help/SKILL.md"
check "help trigger is /help" "grep -q '/help' skills/help/SKILL.md"

echo "AGENTS.md:"
check "AGENTS.md lists /onboard" "grep -q '/onboard' AGENTS.md"
check "AGENTS.md lists /capture" "grep -q '/capture' AGENTS.md"
check "AGENTS.md lists /daily" "grep -q '/daily' AGENTS.md"
check "AGENTS.md has no crew table" "! grep -q '## Crew' AGENTS.md"

echo "Parked agents removed:"
check "no concierge agent file" "! test -f agents/concierge.md"

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
