#!/usr/bin/env bash
# M002 verification script — checks all Phase 2 engine artifacts exist and are valid.
#
# Usage: bash test/m002.test.sh

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

echo "=== M002: Onboarding + North Star ==="
echo ""

# T01: Concierge agent
echo "Concierge agent:"
check "agents/concierge.md exists and is non-empty" "test -s agents/concierge.md"
check "concierge.md has a shebang or clear role definition" "grep -q 'First contact' agents/concierge.md"

# T02: Onboarding skill
echo "Onboarding skill:"
check "skills/onboarding/SKILL.md exists and is non-empty" "test -s skills/onboarding/SKILL.md"
check "onboarding skill resolves KAIROS_VAULT" "grep -q 'KAIROS_VAULT' skills/onboarding/SKILL.md"
check "onboarding skill has vault path check" "grep -q 'Vault not found' skills/onboarding/SKILL.md"

# T03: North-star skill
echo "North-star skill:"
check "skills/north-star/SKILL.md exists and is non-empty" "test -s skills/north-star/SKILL.md"
check "north-star skill resolves KAIROS_VAULT" "grep -q 'KAIROS_VAULT' skills/north-star/SKILL.md"
check "north-star skill writes desired.md" "grep -q 'desired.md' skills/north-star/SKILL.md"
check "north-star skill writes dreaded.md" "grep -q 'dreaded.md' skills/north-star/SKILL.md"

# T04: Goals skill
echo "Goals skill:"
check "skills/goals/SKILL.md exists and is non-empty" "test -s skills/goals/SKILL.md"
check "goals skill resolves KAIROS_VAULT" "grep -q 'KAIROS_VAULT' skills/goals/SKILL.md"
check "goals skill creates index.md" "grep -q 'index.md' skills/goals/SKILL.md"

# T05: Council agents
echo "Council agents:"
check "agents/life-coach.md exists and is non-empty" "test -s agents/life-coach.md"
check "agents/strategic-advisor.md exists and is non-empty" "test -s agents/strategic-advisor.md"
check "agents/accountability-partner.md exists and is non-empty" "test -s agents/accountability-partner.md"

# T06: AGENTS.md updated
echo "AGENTS.md:"
check "AGENTS.md references Concierge" "grep -q 'Concierge' AGENTS.md"
check "AGENTS.md lists skills" "grep -q '/kairos-onboard' AGENTS.md"
check "AGENTS.md lists Council agents" "grep -q 'Life Coach' AGENTS.md"

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
