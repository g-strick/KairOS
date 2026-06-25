#!/usr/bin/env bash
# read-reminders.sh — Read-only Apple Reminders bridge for KairOS (macOS only).
#
# Prints markdown to stdout for inclusion in daily notes. Soft-fails (exit 0) on
# non-macOS platforms or when TCC permission is denied.
#
# Environment:
#   KAIROS_OSASCRIPT       — override osascript binary (for tests)
#   KAIROS_REMINDERS_LIST  — filter to a single Reminders list name
#   KAIROS_REMINDERS_DAYS  — include items due within N days (default: 0 = today + overdue)
#
# Usage:
#   bash hooks/read-reminders.sh
#   bash ~/kairos-vault/hooks/read-reminders.sh

set -euo pipefail

OSASCRIPT="${KAIROS_OSASCRIPT:-osascript}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Reminders bridge: macOS only (skipped on $(uname -s))" >&2
  exit 0
fi

if ! command -v "$OSASCRIPT" >/dev/null 2>&1; then
  echo "Reminders bridge: osascript not found" >&2
  exit 0
fi

REMINDERS_LIST="${KAIROS_REMINDERS_LIST:-}"
REMINDERS_DAYS="${KAIROS_REMINDERS_DAYS:-0}"

if ! [[ "$REMINDERS_DAYS" =~ ^[0-9]+$ ]]; then
  echo "Reminders bridge: KAIROS_REMINDERS_DAYS must be a non-negative integer (got: $REMINDERS_DAYS)" >&2
  exit 0
fi

stderr_file="$(mktemp)"
trap 'rm -f "$stderr_file"' EXIT

if ! output="$("$OSASCRIPT" -l AppleScript - "$REMINDERS_LIST" "$REMINDERS_DAYS" 2>"$stderr_file" <<'APPLESCRIPT'
on pad2(n)
  if n < 10 then
    return "0" & n
  else
    return n as string
  end if
end pad2

on isoDate(d)
  set y to year of d
  set m to month of d as integer
  set dayNum to day of d
  return (y as string) & "-" & my pad2(m) & "-" & my pad2(dayNum)
end isoDate

on sanitizeText(t)
  set s to t as string
  set AppleScript's text item delimiters to tab
  set parts to text items of s
  set AppleScript's text item delimiters to " "
  return parts as text
end sanitizeText

on run argv
  set listFilter to item 1 of argv
  set daysAhead to (item 2 of argv) as integer

  set now to current date
  set startOfToday to now
  set time of startOfToday to 0

  set endCutoff to now
  if daysAhead > 0 then
    set endCutoff to now + (daysAhead * days)
  end if
  set time of endCutoff to 86399

  set outputLines to {}

  tell application "Reminders"
    if listFilter is not "" then
      if not (exists list listFilter) then
        error "Reminders list not found: " & listFilter
      end if
      set targetLists to {list listFilter}
    else
      set targetLists to every list
    end if

    repeat with L in targetLists
      set listName to my sanitizeText(name of L)
      set dueItems to (every reminder of L whose completed is false and due date is not missing value and due date is less than or equal to endCutoff)
      repeat with r in dueItems
        set dueD to due date of r
        set overdueFlag to "0"
        if dueD < startOfToday then
          set overdueFlag to "1"
        end if
        set reminderName to my sanitizeText(name of r)
        set end of outputLines to listName & tab & reminderName & tab & (my isoDate(dueD)) & tab & overdueFlag
      end repeat
    end repeat
  end tell

  set AppleScript's text item delimiters to linefeed
  return outputLines as text
end run
APPLESCRIPT
)"; then
  if [[ -s "$stderr_file" ]]; then
    cat "$stderr_file" >&2
  fi
  echo "Reminders bridge: could not read Reminders. Grant the calling app access under System Settings → Privacy & Security → Reminders." >&2
  exit 0
fi

if [[ -z "${output//[$'\t\n\r ']}" ]]; then
  exit 0
fi

if [[ "$REMINDERS_DAYS" -gt 0 ]]; then
  echo "## Reminders (due within ${REMINDERS_DAYS} days)"
else
  echo "## Reminders (due today or overdue)"
fi

while IFS=$'\t' read -r listName reminderName dueDate overdueFlag || [[ -n "${listName:-}" ]]; do
  [[ -z "${listName:-}" ]] && continue
  suffix=" — due ${dueDate}"
  if [[ "$overdueFlag" == "1" ]]; then
    suffix="${suffix} (overdue)"
  fi
  echo "- [List: ${listName}] ${reminderName}${suffix}"
done <<< "$output"
