---
name: kair-process-reminders
description: GTD clarify Apple Reminders Inbox into vault next actions, projects, waiting, someday, or reference (macOS). Use when the user runs /kair-process-reminders or wants to process phone/Siri captures.
disable-model-invocation: true
---

# /kair-process-reminders — Process Apple Reminders Inbox

**Type:** Interactive skill
**Cadence:** On-demand (macOS 13+)
**Bridge:** Apple Reminders via [rem](https://github.com/BRO3886/rem) (default)

## Description

Clarifies incomplete items in the **Reminders Inbox list** (phone/Siri capture) and routes them into the vault. Does not read vault `inbox/` — use `/kair-process-inbox` for `/kair-capture` files.

For each item, apply GTD routing using **only the default vault folders** from `setup.sh`:

| Outcome | Destination | How to write |
|---------|-------------|--------------|
| Not actionable, no value | Discard | `complete-reminder <id>` only |
| Not actionable, idea later | `someday-maybe.md` | Append one bullet line |
| Not actionable, reference | `reference/` | One `.md` per topic (substantial material only) |
| One physical action | `next-actions.md` | Append `- [ ] @Context …` |
| Multi-step outcome | `projects/<slug>.md` | New file per [projects/README.md](projects/README.md) format |
| Delegated / blocked | `waiting-for.md` | Append one bullet line |

On successful vault write: `complete-reminder <id>`. **Never touch the Reminders Actions list.**

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos-vault}"
NEXT="$VAULT/next-actions.md"
WAITING="$VAULT/waiting-for.md"
SOMEDAY="$VAULT/someday-maybe.md"
PROJECTS="$VAULT/projects"
REFERENCE="$VAULT/reference"
```

## Engine Path Resolution

`.engine-root` → env → ask user (same as `/kair-publish`).

## Pre-flight Check

Vault scaffold and Reminders bridge:

```bash
bash "$ENGINE_ROOT/scripts/kair-process-helpers.sh" preflight-vault
bash "$ENGINE_ROOT/scripts/kair-process-helpers.sh" preflight
```

## Behavior

1. Fetch Reminders Inbox incomplete:

```bash
bash "$ENGINE_ROOT/scripts/kair-process-helpers.sh" list-reminders
```

2. If empty, say so and stop.
3. Process each item one at a time. Ask clarifying questions until routable.
4. **Append** to `next-actions.md`, `waiting-for.md`, and `someday-maybe.md` — do not replace or recreate these files.
5. **New `.md` files only** in `projects/` or `reference/`. Never create markdown at the vault root or outside the default folders.
6. After successful vault write:

```bash
bash "$ENGINE_ROOT/scripts/kair-process-helpers.sh" complete-reminder <id>
```

7. Summarize: processed count, destinations used.

## Agent Instructions

- Interactive GTD clarification is the core value — do not batch-skip questions.
- Complete Reminders items only after the vault write succeeds (idempotent safety).
- **Never spawn new GTD list files** (`actions.md`, `processed.md`, etc.). Use only the seeded `next-actions.md`, `waiting-for.md`, and `someday-maybe.md`.
- **Never write YAML frontmatter** into list files — use simple markdown bullets and checkboxes.
- Do not modify `next-actions.md` items that were not part of this session unless consolidating project next actions.
- Suggest `/kair-publish` when the user wants items on their phone.
- If the user meant vault captures, redirect to `/kair-process-inbox`.
- Plain, direct tone. No guilt framing.
