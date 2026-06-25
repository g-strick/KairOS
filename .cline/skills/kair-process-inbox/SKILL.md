---
name: kair-process-inbox
description: GTD clarify vault inbox/ captures into next actions, projects, waiting, someday, or reference. Use when the user runs /kair-process-inbox or wants to process Kairos inbox files.
disable-model-invocation: true
---

# /kair-process-inbox — Process Vault Inbox

**Type:** Interactive skill
**Cadence:** On-demand

## Description

Clarifies unprocessed files in **vault `inbox/`** (from `/kair-capture`). Does not read Apple Reminders — use `/kair-process-reminders` for phone/Siri captures.

For each item, apply GTD routing using **only the default vault folders** from `setup.sh`:

| Outcome | Destination | How to write |
|---------|-------------|--------------|
| Not actionable, no value | Discard | Delete the inbox file |
| Not actionable, idea later | `someday-maybe.md` | Append one bullet line |
| Not actionable, reference | `reference/` | One `.md` per topic (substantial material only) |
| One physical action | `next-actions.md` | Append `- [ ] @Context …` |
| Multi-step outcome | `projects/<slug>.md` | New file per [projects/README.md](projects/README.md) format |
| Delegated / blocked | `waiting-for.md` | Append one bullet line |

On successful vault write, delete the inbox file.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos-vault}"
INBOX_DIR="$VAULT/inbox"
NEXT="$VAULT/next-actions.md"
WAITING="$VAULT/waiting-for.md"
SOMEDAY="$VAULT/someday-maybe.md"
PROJECTS="$VAULT/projects"
REFERENCE="$VAULT/reference"
```

## Engine Path Resolution

`.engine-root` → env → ask user (same as `/kair-publish`).

## Pre-flight Check

```bash
bash "$ENGINE_ROOT/scripts/kair-process-helpers.sh" preflight-vault
```

## Behavior

1. List vault inbox files:

```bash
bash "$ENGINE_ROOT/scripts/kair-process-helpers.sh" list-vault-inbox
```

2. If empty, say so and stop.
3. Process each file one at a time. Ask clarifying questions until routable.
4. **Append** to `next-actions.md`, `waiting-for.md`, and `someday-maybe.md` — do not replace or recreate these files.
5. **New `.md` files only** in `projects/` or `reference/`. Never create markdown at the vault root or outside the default folders.
6. After successful write, delete the inbox file.
7. Summarize: processed count, destinations used.

## Agent Instructions

- Interactive GTD clarification is the core value — do not batch-skip questions.
- **Never spawn new GTD list files** (`actions.md`, `processed.md`, etc.). Use only the seeded `next-actions.md`, `waiting-for.md`, and `someday-maybe.md`.
- **Never write YAML frontmatter** into list files — use simple markdown bullets and checkboxes.
- Do not modify `next-actions.md` items that were not part of this session unless consolidating project next actions.
- Suggest `/kair-publish` when the user wants actions on their phone.
- If the user meant Reminders Inbox, redirect to `/kair-process-reminders`.
- Plain, direct tone. No guilt framing.
