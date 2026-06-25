---
name: kair-capture
description: Capture anything into vault inbox/ — no categorization. Use when the user runs /kair-capture or wants to quickly save a thought.
disable-model-invocation: true
---

# /kair-capture — Capture Skill

**Type:** Interactive skill
**Cadence:** On-demand

## Description

Zero-friction capture into `inbox/` — one file per item. No categorization, no routing. Done in under ten seconds.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos-vault}"
INBOX_DIR="$VAULT/inbox"
STAMP="$(date +%Y-%m-%dT%H%M)"
```

## Pre-flight Check

If `$INBOX_DIR` does not exist, tell the user to run `setup.sh`.

## Behavior

1. Ask: "What do you want to capture?" (or accept the user's message as the capture text).
2. Build a short slug from the first few words (lowercase, hyphens, max 40 chars).
3. Write a new file `$INBOX_DIR/${STAMP}-${slug}.md`:

```markdown
# Capture

<capture text>
```

4. Confirm briefly: "Captured." Do not sort, tag, or route.

## Agent Instructions

- Never block on questions beyond getting the text (unless the user gave none).
- Do not invoke other skills unless the user asks.
- Keep tone neutral and fast.
- Do not write to legacy `inbox.md` — use `inbox/` only.
