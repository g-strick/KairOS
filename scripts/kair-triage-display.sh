#!/usr/bin/env bash
# kair-triage-display.sh — ASCII desk progress for /kair-triage (any terminal).
#
# Usage:
#   kair-triage-display.sh intro
#   kair-triage-display.sh progress <remaining> <total>
#   kair-triage-display.sh done
#   kair-triage-display.sh empty

set -euo pipefail

BAR_WIDTH=24
MAX_DOCS=14
FRAME_INNER=44

frame_top() {
  printf '  +-%s-+\n' "$(printf '%*s' "$FRAME_INNER" '' | tr ' ' '-')"
}

frame_line() {
  # frame_line "content" — pad/truncate to inner width
  local text="$1"
  local len=${#text}
  if [[ "$len" -gt "$FRAME_INNER" ]]; then
    text="${text:0:FRAME_INNER}"
    len=$FRAME_INNER
  fi
  local pad=$(( FRAME_INNER - len ))
  printf '  | %s%*s |\n' "$text" "$pad" ''
}

frame_bottom() {
  frame_top
}

# pct_full — desk fullness 0-100 from remaining/total
pct_full() {
  local remaining="$1"
  local total="$2"
  if [[ "$total" -le 0 ]]; then
    echo 0
    return
  fi
  echo $(( remaining * 100 / total ))
}

# render_bar PCT — ASCII fill bar inside frame
render_bar() {
  local pct="$1"
  local filled=$(( pct * BAR_WIDTH / 100 ))
  local empty=$(( BAR_WIDTH - filled ))
  local bar=""
  local i

  for ((i = 0; i < filled; i++)); do bar+='#'; done
  for ((i = 0; i < empty; i++)); do bar+='.'; done
  frame_line "desk [${bar}] ${pct}% full"
}

# render_docs REMAINING — paper stacks on the desk
render_docs() {
  local remaining="$1"
  local line=""
  local shown="$remaining"
  local extra=0

  if [[ "$remaining" -gt "$MAX_DOCS" ]]; then
    shown="$MAX_DOCS"
    extra=$(( remaining - MAX_DOCS ))
  fi

  local i
  for ((i = 0; i < shown; i++)); do
    line+="[##]"
  done
  if [[ "$extra" -gt 0 ]]; then
    line+="+${extra}"
  fi
  if [[ -z "$line" ]]; then
    line="(clear)"
  fi
  frame_line "$line"
}

# render_scribe REMAINING TOTAL
render_scribe() {
  local remaining="$1"
  local total="$2"
  local cleared=0
  local pos=4

  if [[ "$total" -gt 0 ]]; then
    cleared=$(( total - remaining ))
    pos=$(( 4 + cleared * 20 / total ))
    [[ "$pos" -gt 28 ]] && pos=28
  fi

  local stick=''
  local i
  for ((i = 0; i < pos; i++)); do stick+=' '; done
  frame_line "${stick}\\"
  frame_line "${stick}o_ scribe"
}

cmd_intro() {
  frame_top
  frame_line "KAIR TRIAGE - scribe at the desk"
  frame_line ""
  frame_line "Pick 1-4, refine with edits, or type 5."
  frame_bottom
  printf '\n'
}

cmd_empty() {
  frame_top
  frame_line "KAIR TRIAGE"
  frame_line ""
  frame_line "Desk is clear. Nothing to triage."
  frame_bottom
  printf '\n'
}

cmd_done() {
  frame_top
  frame_line "KAIR TRIAGE - desk clear"
  frame_line ""
  render_docs 0
  render_scribe 0 1
  render_bar 0
  frame_bottom
  printf '\n'
  printf '  All items triaged. Desk is empty.\n\n'
}

cmd_progress() {
  local remaining="${1:-0}"
  local total="${2:-0}"
  local pct
  pct="$(pct_full "$remaining" "$total")"
  local label

  if [[ "$remaining" -eq 1 ]]; then
    label="1 on desk"
  else
    label="${remaining} on desk"
  fi

  frame_top
  frame_line "KAIR TRIAGE - ${label}"
  frame_line ""
  render_docs "$remaining"
  render_scribe "$remaining" "$total"
  render_bar "$pct"
  frame_bottom
  printf '\n'
}

case "${1:-}" in
  intro)
    cmd_intro
    ;;
  empty)
    cmd_empty
    ;;
  done)
    cmd_done
    ;;
  progress)
    [[ $# -ge 3 ]] || { echo "Usage: $0 progress <remaining> <total>" >&2; exit 1; }
    cmd_progress "$2" "$3"
    ;;
  *)
    echo "Usage: $0 {intro|empty|done|progress <remaining> <total>}" >&2
    exit 1
    ;;
esac
