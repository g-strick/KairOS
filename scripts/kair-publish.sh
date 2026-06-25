#!/usr/bin/env bash
# kair-publish.sh — Publish vault actionable items to Reminders Actions list.
#
# Usage: kair-publish.sh [vault_root]
# Environment: KAIROS_VAULT, KAIROS_ACTIONS_BRIDGE=rem (default)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

VAULT="${1:-${KAIROS_VAULT:-$HOME/kairos-vault}}"
VAULT="${VAULT/#\~/$HOME}"
BRIDGE="${KAIROS_ACTIONS_BRIDGE:-rem}"

NEXT_ACTIONS="$VAULT/next-actions.md"
PROJECTS_DIR="$VAULT/projects"

# file_uri PATH — file:// URI for rem --url back-link
file_uri() {
  local path="$1"
  local abs
  abs="$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
  echo "file://${abs// /%20}"
}

# parse_next_actions — print "title<TAB>url" lines from next-actions.md
parse_next_actions() {
  [[ -f "$NEXT_ACTIONS" ]] || return 0
  local url
  url="$(file_uri "$NEXT_ACTIONS")"
  while IFS= read -r line; do
    [[ "$line" =~ ^-[[:space:]]*\[[[:space:]]\][[:space:]]*(.+)$ ]] || continue
    local title="${BASH_REMATCH[1]}"
    title="${title#"${title%%[![:space:]]*}"}"
    title="${title%"${title##*[![:space:]]}"}"
    [[ -n "$title" ]] || continue
    printf '%s\t%s\n' "$title" "$url"
  done < "$NEXT_ACTIONS"
}

# parse_project_next_actions — print "title<TAB>url" from each projects/*.md
parse_project_next_actions() {
  local project_file base url in_section=0 line title

  shopt -s nullglob
  for project_file in "$PROJECTS_DIR"/*.md; do
    [[ "$(basename "$project_file")" == "README.md" ]] && continue
    in_section=0
    url="$(file_uri "$project_file")"
    while IFS= read -r line || [[ -n "$line" ]]; do
      if [[ "$line" =~ ^#{1,6}[[:space:]]+Next[[:space:]]+action ]]; then
        in_section=1
        continue
      fi
      if [[ $in_section -eq 1 && "$line" =~ ^# ]]; then
        break
      fi
      if [[ $in_section -eq 1 && "$line" =~ ^-[[:space:]]*\[[[:space:]]\][[:space:]]*(.+)$ ]]; then
        title="${BASH_REMATCH[1]}"
        title="${title#"${title%%[![:space:]]*}"}"
        title="${title%"${title##*[![:space:]]}"}"
        [[ -n "$title" ]] || continue
        printf '%s\t%s\n' "$title" "$url"
        break
      fi
    done < "$project_file"
  done
  shopt -u nullglob
}

main() {
  if [[ ! -d "$VAULT" ]]; then
    echo "Error: vault not found at $VAULT" >&2
    exit 1
  fi

  case "$BRIDGE" in
    rem)
      # shellcheck source=scripts/bridges/rem.sh
      source "$ENGINE_ROOT/scripts/bridges/rem.sh"
      rem_preflight
      rem_ensure_lists
      ;;
    *)
      echo "Error: unknown bridge '$BRIDGE' (supported: rem)" >&2
      exit 1
      ;;
  esac

  local actions=()
  local row title url count=0

  while IFS= read -r row; do
    [[ -n "$row" ]] || continue
    actions+=("$row")
  done < <(parse_next_actions; parse_project_next_actions)

  rem_clear_actions

  for row in "${actions[@]}"; do
    title="${row%%$'\t'*}"
    url="${row#*$'\t'}"
    rem_add_action "$title" "$url"
    count=$((count + 1))
  done

  echo "Published $count action(s) to Reminders list '$REM_ACTIONS_LIST'."
}

main "$@"
