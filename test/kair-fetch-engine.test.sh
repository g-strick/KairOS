#!/usr/bin/env bash
# kair-fetch-engine.test.sh — Tests for remote engine fetch helper

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FETCH="$ENGINE_DIR/scripts/kair-fetch-engine.sh"

source "$SCRIPT_DIR/lib/assert.sh"

# shellcheck disable=SC1090
source "$FETCH"

ENGINE_SRC=$(mktemp -d)
DEST=$(mktemp -d)
trap 'rm -rf "$ENGINE_SRC" "$DEST"' EXIT

mkdir -p "$ENGINE_SRC/templates"
cat > "$ENGINE_SRC/templates/allowlist.txt" <<'EOF'
skills/
AGENTS.md
EOF
echo "# Engine" > "$ENGINE_SRC/AGENTS.md"

echo "=== kair-fetch-engine Tests ==="
echo ""

assert_file "$FETCH" "kair-fetch-engine.sh exists"

kair_fetch_engine "file://$ENGINE_SRC" main "$DEST"
assert_file "$DEST/templates/allowlist.txt" "file:// fetch copies allowlist"
assert_file "$DEST/AGENTS.md" "file:// fetch copies AGENTS.md"

slug="$(kair_github_slug "https://github.com/g-strick/KairOS.git")"
assert_eq "g-strick/KairOS" "$slug" "parses https GitHub URL"

remote="$(KAIR_DEFAULT_ENGINE_REMOTE=https://github.com/example/KairOS.git kair_resolve_engine_remote "")"
assert_eq "https://github.com/example/KairOS.git" "$remote" "default remote env override"

echo ""
assert_summary
