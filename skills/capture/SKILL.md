# /capture — Capture Skill

**Type:** Interactive skill
**Cadence:** On-demand

## Description

Zero-friction append to `inbox.md`. No categorization, no routing. Done in under ten seconds.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos}"
INBOX="$VAULT/inbox.md"
```

## Pre-flight Check

If `$INBOX` does not exist, tell the user to run `setup.sh`.

## Behavior

1. Ask: "What do you want to capture?" (or accept the user's message as the capture text).
2. Append a timestamped line to `$INBOX`:

```markdown
- **YYYY-MM-DD HH:MM** — <capture text>
```

3. Confirm briefly: "Captured." Do not sort, tag, or route.

## Agent Instructions

- Never block on questions beyond getting the text (unless the user gave none).
- Do not invoke other skills unless the user asks.
- Keep tone neutral and fast.
