---
name: kair-daily
description: Read vault inbox, set one focus, write today's note in daily/. Use when the user runs /kair-daily or wants a daily check-in.
disable-model-invocation: true
---

# /kair-daily — Daily Check-in Skill

**Type:** Interactive skill
**Cadence:** Once per day (user-invoked)

## Description

Reads unprocessed captures in `inbox/`, helps the user pick one focus for today, and writes or updates today's note in `daily/`. Completes in about five minutes.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos-vault}"
INBOX_DIR="$VAULT/inbox"
TODAY="$(date +%Y-%m-%d)"
NOTE="$VAULT/daily/$TODAY.md"
```

## Pre-flight Check

Ensure `$VAULT/daily/` and `$INBOX_DIR` exist. If not, direct the user to `setup.sh`.

## Behavior

1. List files in `$INBOX_DIR` (exclude `README.md`) and summarize what's waiting (if anything).
2. Run the Reminders bridge (read-only, macOS only):

```bash
REMINDERS_HOOK="$VAULT/_kair/hooks/read-reminders.sh"
if [[ -x "$REMINDERS_HOOK" ]]; then
  REMINDERS_OUT="$(bash "$REMINDERS_HOOK" 2>&1)"
else
  REMINDERS_OUT="Reminders bridge not installed — run /kair-update to sync hooks from the engine."
fi
```

Capture stdout for the daily note. If stderr contains permission or platform messages, mention them briefly without blocking the check-in.

3. Read `$VAULT/profile.md` if it exists — use name for greeting and `## Current priorities` to orient the focus question.
4. Ask: "Your current priorities are X. What's your one focus for today?" (If priorities are unset, ask for focus without prescriptive framing.)
5. Write or update `$NOTE`:

```markdown
# YYYY-MM-DD

## Focus
<one focus>

## Inbox snapshot
<brief summary of inbox/ files at check-in time, or "empty">

## Reminders
<output from read-reminders.sh, or "none due" if stdout was empty, or platform/permission note if bridge was unavailable>

## Notes
<optional freeform from the conversation>
```

6. Do not read goal files, north-star files, or habits — those are not part of the lean kit.
7. Do not complete, edit, or create Reminders — read-only bridge only.

## Agent Instructions

- Plain, direct tone. No persona layers.
- Do not guilt or motivational framing unless the user asks.
- Suggest `/kair-capture` if they mention something to remember for later.
- Suggest `/kair-triage` if the vault inbox or Reminders Inbox has stale items.
