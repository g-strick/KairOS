#!/usr/bin/env bash
set -euo pipefail

# install-hooks.sh — Installs pre-push hook into the engine repo's .git/hooks
# Driven by plan 01-03 (Foundation, plan 03)
#
# Usage:
#    ./install-hooks.sh
#
# Copies hooks/pre-push into .git/hooks/pre-push and makes it executable.
# This is how a developer activates the content-glob safety hook after cloning.
#
# Note: `git push --no-verify` deliberately bypasses pre-push hooks.
# This is an intentional developer override, backstopped by structural
# separation (.gitignore + physically-separate vault).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
GIT_HOOKS="$REPO_ROOT/.git/hooks"
# Resolve hook source relative to this script's location
HOOK_SRC="$SCRIPT_DIR/hooks/pre-push"
HOOK_DEST="$GIT_HOOKS/pre-push"

# Verify we're in a git repo
if [ ! -d "$REPO_ROOT/.git" ]; then
  echo "ERROR: not in a git repository (no .git directory found at $REPO_ROOT)" >&2
  exit 1
fi

# Verify the hook source exists
if [ ! -f "$HOOK_SRC" ]; then
  echo "ERROR: hook source not found at $HOOK_SRC" >&2
  exit 1
fi

# Create .git/hooks directory if it doesn't exist
mkdir -p "$GIT_HOOKS"

# Copy the hook and make it executable
cp "$HOOK_SRC" "$HOOK_DEST"
chmod +x "$HOOK_DEST"

echo "Hook installed: $HOOK_DEST"
echo "Activated content-glob safety check on git push."
echo ""
echo "To bypass (not recommended): git push --no-verify"