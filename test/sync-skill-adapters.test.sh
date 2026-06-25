#!/usr/bin/env bash
set -euo pipefail

# test/sync-skill-adapters.test.sh — Skill adapter sync tests

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/lib/assert.sh"

VAULT="$ROOT_DIR/test/tmp/sync-adapters-$$"
mkdir -p "$VAULT"
trap 'rm -rf "$VAULT"' EXIT

# Seed canonical skills under _kair/ (PKM layout)
mkdir -p "$VAULT/_kair/skills/kair-capture" "$VAULT/_kair/skills/kair-help"
cat > "$VAULT/_kair/skills/kair-capture/SKILL.md" << 'EOF'
---
name: kair-capture
description: Test capture skill
disable-model-invocation: true
---
# Capture body
EOF

cat > "$VAULT/_kair/skills/kair-help/SKILL.md" << 'EOF'
---
name: kair-help
description: Test help skill
disable-model-invocation: true
---
# Help body
EOF

SYNC_SH="$ROOT_DIR/scripts/sync-skill-adapters.sh"
assert_file "$SYNC_SH" "sync-skill-adapters.sh exists"

assert_exit_code 0 "bash $SYNC_SH $VAULT" "sync script runs successfully"

for adapter in .cursor/skills .claude/skills .cline/skills; do
  assert_file "$VAULT/$adapter/kair-capture/SKILL.md" "$adapter/kair-capture/SKILL.md exists"
  assert_file "$VAULT/$adapter/kair-help/SKILL.md" "$adapter/kair-help/SKILL.md exists"
  assert_exit_code 0 "grep -q '^name: kair-capture' $VAULT/$adapter/kair-capture/SKILL.md" "$adapter kair-capture has frontmatter"
done

assert_summary
