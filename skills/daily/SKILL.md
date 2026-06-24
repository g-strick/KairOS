# /daily — Daily Check-in Skill

**Type:** Interactive skill
**Cadence:** Once per day (user-invoked)

## Description

Reads `inbox.md`, helps the user pick one focus for today, and writes or updates today's note in `daily/`. Completes in about five minutes.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos}"
INBOX="$VAULT/inbox.md"
TODAY="$(date +%Y-%m-%d)"
NOTE="$VAULT/daily/$TODAY.md"
```

## Pre-flight Check

Ensure `$VAULT/daily/` exists and `$INBOX` exists. If not, direct the user to `setup.sh`.

## Behavior

1. Read `$INBOX` and summarize what's waiting (if anything).
2. Read `$VAULT/profile.md` if it exists (name, timezone only — no goal hierarchy in v1).
3. Ask: "What's your one focus for today?"
4. Write or update `$NOTE`:

```markdown
# YYYY-MM-DD

## Focus
<one focus>

## Inbox snapshot
<brief summary of inbox at check-in time, or "empty">

## Notes
<optional freeform from the conversation>
```

5. Do not read goal files, north-star files, or habits — those are not part of the lean kit.

## Agent Instructions

- Plain, direct tone. No persona layers.
- Do not guilt or motivational framing unless the user asks.
- Suggest `/capture` if they mention something to remember for later.
