#!/usr/bin/env bash
# lean-v1.test.sh — Personal KairOS gate: vault layout, skills, and docs agree.
#
# Usage: bash test/lean-v1.test.sh

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

check_not() {
    local desc="$1"
    local check="$2"
    if eval "$check" >/dev/null 2>&1; then
        echo "  FAIL: $desc"
        FAIL=$((FAIL + 1))
    else
        echo "  PASS: $desc"
        PASS=$((PASS + 1))
    fi
}

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "=== KairOS Gate ==="
echo ""

echo "Vault template:"
for dir in inbox daily projects someday archive goals scripts; do
    check "vault-dirs lists $dir" "grep -qx '$dir' templates/vault-dirs.txt"
done
check "vault-dirs includes _engine subtree" "grep -q '^_engine/' templates/vault-dirs.txt"
check "vault-seeds templates exist" "test -f templates/vault-seeds/_engine/HANDOFF.md"
check_not "vault-dirs.txt does not list north-star" "grep -q 'north-star' templates/vault-dirs.txt"

echo ""
echo "AGENTS.md:"
check "AGENTS.md documents projects/" "grep -q 'projects/' AGENTS.md"
check "AGENTS.md documents someday/" "grep -q 'someday/' AGENTS.md"
check "AGENTS.md documents archive/" "grep -q 'archive/' AGENTS.md"
check "AGENTS.md lists all four commands" "grep -q '/capture' AGENTS.md && grep -q '/daily' AGENTS.md"
check "AGENTS.md documents _engine/" "grep -q '_engine/' AGENTS.md"

echo ""
echo "Skills:"
for skill in help onboard capture daily; do
    check "skills/$skill/SKILL.md exists" "test -s skills/$skill/SKILL.md"
done
check "AGENTS.md documents inbox/" "grep -q 'inbox/' AGENTS.md"
check "capture writes to inbox/" "grep -q 'inbox/' skills/capture/SKILL.md"
check "capture creates new file per note" "grep -qi 'new file' skills/capture/SKILL.md"
check "daily reads inbox/" "grep -q 'inbox/' skills/daily/SKILL.md"
check "daily writes daily/YYYY-MM-DD.md" "grep -q 'daily/' skills/daily/SKILL.md"

echo ""
echo "Safety:"
check "profile.md in content-globs" "grep -q '^profile.md' hooks/content-globs.txt"
check "daily enforces one focus" "grep -qi 'one focus' skills/daily/SKILL.md"
check "inbox/ in content-globs" "grep -q '^inbox/' hooks/content-globs.txt"
check "someday/ in content-globs" "grep -q '^someday/' hooks/content-globs.txt"

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
