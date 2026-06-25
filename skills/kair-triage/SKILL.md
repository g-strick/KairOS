---
name: kair-triage
description: GTD clarify Reminders Inbox and vault inbox/ with smart routing options, merge suggestions, and ASCII desk progress. Use when the user runs /kair-triage or wants to process captures.
---

# /kair-triage — Smart GTD Triage

**Type:** Interactive skill (AI-generated options)
**Cadence:** On-demand
**Portability:** Plain markdown + bash — works in Cursor, Claude Code, Cline, Codex, Gemini, or any terminal LLM. No proprietary UI.

## Description

Unified triage for **both** capture sources:

1. **Apple Reminders Inbox** (phone/Siri) — processed **first** (macOS 13+ when `rem` + `jq` available)
2. **Vault `inbox/`** (from `/kair-capture`) — processed after Reminders

For each item, read vault context and present **four smart routing options** plus a freeform fifth choice. The user approves **one item at a time** before any write. Nothing is filed until they confirm.

Replaces `/kair-process-inbox` and `/kair-process-reminders` (those skills redirect here).

## GTD destinations (unchanged)

| Outcome | Destination | How to write |
|---------|-------------|--------------|
| Not actionable, no value | Discard | Delete inbox file or `complete-reminder <id>` |
| Not actionable, idea later | `someday-maybe.md` | Append one bullet line |
| Not actionable, reference | `reference/` | One `.md` per topic (substantial material only) |
| One physical action | `next-actions.md` | Append `- [ ] @Context …` |
| Multi-step outcome | `projects/<slug>.md` | New file or **merge into existing** project |
| Delegated / blocked | `waiting-for.md` | Append one bullet line |

On successful vault write: delete vault inbox file, or `complete-reminder <id>` for Reminders items. **Never touch the Reminders Actions list.**

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

Reminders (best-effort — skip on non-macOS or missing `rem`):

```bash
bash "$ENGINE_ROOT/scripts/kair-process-helpers.sh" preflight
```

## Gather queue (Reminders first)

```bash
bash "$ENGINE_ROOT/scripts/kair-process-helpers.sh" list-triage
```

Tab-separated fields: `source`, `id_or_path`, `title`, `notes_or_preview`

- `reminder` — Apple Reminders Inbox item
- `vault` — file under `inbox/`

If empty:

```bash
bash "$ENGINE_ROOT/scripts/kair-triage-display.sh" empty
```

Stop. Do not invent items.

## ASCII desk progress (every turn)

Show the desk **before each item** and **after each approved write**. Uses only ASCII — any terminal.

```bash
TOTAL=$(bash "$ENGINE_ROOT/scripts/kair-process-helpers.sh" count-triage)
# At session start:
bash "$ENGINE_ROOT/scripts/kair-triage-display.sh" intro
bash "$ENGINE_ROOT/scripts/kair-triage-display.sh" progress "$TOTAL" "$TOTAL"

# Before item N (remaining = items left including current):
bash "$ENGINE_ROOT/scripts/kair-triage-display.sh" progress "$REMAINING" "$TOTAL"

# After last item:
bash "$ENGINE_ROOT/scripts/kair-triage-display.sh" done
```

`remaining` counts items **not yet triaged** (including the current one). Desk goes from 100% full → 0% empty.

## Vault context (read before generating options)

For each item, scan:

- `projects/*.md` — titles, outcomes, existing next actions (merge candidates)
- `reference/` — topic files to append to
- `next-actions.md` — duplicates, `@context` patterns
- `waiting-for.md`, `someday-maybe.md` — related deferred items
- `profile.md` — user contexts and priorities if present

For vault inbox files, read the full capture file. For reminders, use title + notes.

## Portable option picker (required format)

Present options in **plain markdown** — no proprietary widgets, no canvas, no backend-specific tools.

Use this structure every time:

```markdown
---
**Item** 2 of 5 · `reminder` · Fix bike tire

> Fix bike tire

**Choose one** (reply with `1`–`4`, or `5` + your own routing):

1. **Next action** → `next-actions.md`
   `- [ ] @Errands Fix bike tire at home`
   *Single errand; no existing project match.*

2. **Merge project** → `projects/home-maintenance.md`
   Add under `## Open loops`: "Fix bike tire"
   *Matches existing home upkeep outcome.*

3. **Someday** → `someday-maybe.md`
   `- Learn proper bike repair and tool kit`
   *Defer until you want a maintenance hobby.*

4. **Discard**
   *Noise capture — no vault write.*

5. **Something else** — describe destination and exact text.

To **refine** an option, reply with the option number plus your edits (e.g. `2 but put it under ## Maintenance` or paste the full revised line). **Regenerate four new options** that incorporate your text, then ask again. Repeat until the user picks without further edits.
```

### Option quality rules

- All four options must be **meaningfully different** (not four shades of the same route).
- At least one option should consider **merging** into an existing `projects/` or `reference/` file when a plausible match exists.
- Name the **exact destination path** and **exact text to write** in every option.
- Keep rationales to one short line.

## Approval loop (one item at a time)

1. Show desk progress (`progress` with current `remaining` / `TOTAL`).
2. Show capture + four options + option 5.
3. Wait for user reply.
4. **If user adds or edits text** on any option → regenerate four options using their additions; go to step 2 (do not write yet).
5. **If user picks 1–4 as-is** → show a **confirmation block**:

```markdown
**Apply this?** (reply `yes` to confirm, or send corrections)

- **Source:** reminder `abc123` / vault `inbox/foo.md`
- **Action:** append to `next-actions.md`
- **Text:** `- [ ] @Errands Fix bike tire`
- **Then:** complete reminder / delete inbox file
```

6. On `yes` only → perform the write, then source cleanup, then next item.
7. On `skip` or `later` → leave item in queue; continue to next if user wants.

**Never write** on first pick alone — always confirm with `yes` unless the user's message is explicitly `yes` after seeing the confirmation block.

## Write rules

- **Append** to `next-actions.md`, `waiting-for.md`, `someday-maybe.md` — never replace.
- **New `.md` files only** in `projects/` or `reference/`.
- **Never spawn** extra GTD list files (`actions.md`, `processed.md`, etc.).
- **No YAML frontmatter** in list files.
- Do not modify list items outside this session except when merging into a project file the user approved.

## After session

Summarize: items triaged, destinations used, items skipped. Suggest `/kair-publish` if next actions should appear on the phone.

## Agent Instructions

- Smart options are the core value — use vault context; do not offer generic placeholders.
- **Portable only:** numbered markdown options work in every provider. Do not use Canvas, AskQuestion, or other IDE-specific UI.
- **Refinement loop:** any user edit to an option line triggers **new** four options before write.
- **Reminders before vault** — queue order is fixed by `list-triage`.
- Plain, direct tone. No guilt framing.
- If user invokes legacy `/kair-process-inbox` or `/kair-process-reminders`, run this skill instead.
