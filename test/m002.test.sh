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
check "skills/kair-onboard/SKILL.md exists" "test -s skills/kair-onboard/SKILL.md"
check "onboard resolves KAIROS_VAULT" "grep -q 'KAIROS_VAULT' skills/kair-onboard/SKILL.md"
check "onboard trigger is /kair-onboard" "grep -q '/kair-onboard' skills/kair-onboard/SKILL.md"
check "onboard collects priorities" "grep -q 'Current priorities' skills/kair-onboard/SKILL.md"

echo "Capture skill:"
check "skills/kair-capture/SKILL.md exists" "test -s skills/kair-capture/SKILL.md"
check "capture writes to inbox/" "grep -q 'inbox/' skills/kair-capture/SKILL.md"

echo "Daily skill:"
check "skills/kair-daily/SKILL.md exists" "test -s skills/kair-daily/SKILL.md"
check "daily reads inbox" "grep -q 'inbox' skills/kair-daily/SKILL.md"
check "daily writes daily/" "grep -q 'daily/' skills/kair-daily/SKILL.md"
check "daily reads priorities" "grep -q 'Current priorities' skills/kair-daily/SKILL.md"
check "AGENTS.md has parallel sessions note" "grep -q 'Parallel sessions' AGENTS.md"

echo "Triage skill:"
check "skills/kair-triage/SKILL.md exists" "test -s skills/kair-triage/SKILL.md"
check "triage trigger is /kair-triage" "grep -q '/kair-triage' skills/kair-triage/SKILL.md"
check "triage uses list-triage" "grep -q 'list-triage' skills/kair-triage/SKILL.md"
check "triage uses display script" "grep -q 'kair-triage-display' skills/kair-triage/SKILL.md"
check "triage forbids new list files" "grep -q 'Never spawn' skills/kair-triage/SKILL.md"

echo "Legacy process skills (redirect):"
check "skills/kair-process-inbox/SKILL.md exists" "test -s skills/kair-process-inbox/SKILL.md"
check "process-inbox redirects to triage" "grep -q '/kair-triage' skills/kair-process-inbox/SKILL.md"
check "skills/kair-process-reminders/SKILL.md exists" "test -s skills/kair-process-reminders/SKILL.md"
check "process-reminders redirects to triage" "grep -q '/kair-triage' skills/kair-process-reminders/SKILL.md"
check "old kair-process skill removed" "test ! -f skills/kair-process/SKILL.md"

echo "Publish skill:"
check "skills/kair-publish/SKILL.md exists" "test -s skills/kair-publish/SKILL.md"
check "publish runs kair-publish.sh" "grep -q 'kair-publish.sh' skills/kair-publish/SKILL.md"
check "publish trigger is /kair-publish" "grep -q '/kair-publish' skills/kair-publish/SKILL.md"

echo "Help skill:"
check "skills/kair-help/SKILL.md exists" "test -s skills/kair-help/SKILL.md"
check "help trigger is /kair-help" "grep -q '/kair-help' skills/kair-help/SKILL.md"

echo "Update skill:"
check "skills/kair-update/SKILL.md exists" "test -s skills/kair-update/SKILL.md"
check "update runs update.sh" "grep -q 'update.sh' skills/kair-update/SKILL.md"
check "update trigger is /kair-update" "grep -q '/kair-update' skills/kair-update/SKILL.md"

echo "Scripts:"
check "scripts/bridges/rem.sh exists" "test -x scripts/bridges/rem.sh"
check "scripts/kair-publish.sh exists" "test -x scripts/kair-publish.sh"
check "README links to rem project" "grep -q 'github.com/BRO3886/rem' README.md"

echo "AGENTS.md:"
check "AGENTS.md lists /kair-onboard" "grep -q '/kair-onboard' AGENTS.md"
check "AGENTS.md lists /kair-capture" "grep -q '/kair-capture' AGENTS.md"
check "AGENTS.md lists /kair-daily" "grep -q '/kair-daily' AGENTS.md"
check "AGENTS.md lists /kair-triage" "grep -q '/kair-triage' AGENTS.md"
check "AGENTS.md does not list legacy /kair-process" "! grep -q '| \`/kair-process\`' AGENTS.md"
check "AGENTS.md lists /kair-publish" "grep -q '/kair-publish' AGENTS.md"
check "AGENTS.md lists /kair-update" "grep -q '/kair-update' AGENTS.md"
check "AGENTS.md has no crew table" "! grep -q '## Crew' AGENTS.md"

echo "Parked agents removed:"
check "no concierge agent file" "! test -f agents/concierge.md"

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
