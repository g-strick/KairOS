---
name: kair-publish
description: Publish vault next actions to Reminders Actions list (macOS). Use when the user runs /kair-publish or wants actionable items on their phone.
disable-model-invocation: true
---

# /kair-publish — Publish Actions Skill

**Type:** Script-driven skill
**Cadence:** On-demand (macOS 13+)
**Bridge:** Apple Reminders via [rem](https://github.com/BRO3886/rem) (default)

## Description

Pushes actionable-now items from the vault to the Reminders **Actions** list — brute-force reconcile: clear Actions, re-add current set with `file://` back-links. Never touches the Reminders **Inbox** list.

**Sources:** unchecked tasks in `next-actions.md` plus the single next action from each `projects/*.md` file (under `## Next action`).

**Excludes:** `waiting-for.md`, `someday-maybe.md`, `reference/`, and project files themselves.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos-vault}"
```

If the workspace root looks like a vault (contains `inbox/` or `AGENTS.md`), prefer the workspace root.

## Engine Path Resolution

1. `$VAULT/.engine-root`
2. `KAIROS_ENGINE_ROOT` or `GSD_ENGINE_ROOT`
3. Ask the user for the engine clone path

## Pre-flight Check

- macOS only (`uname -s` = Darwin)
- `rem` and `jq` installed (`brew tap BRO3886/tap && brew install rem-cli jq`)
- Reminders permission granted to this host app (first interactive `rem` call prompts once)
- `$VAULT/next-actions.md` exists (run `setup.sh` if missing)

## Behavior

1. Resolve `$VAULT` and `$ENGINE_ROOT`.
2. Run:

```bash
bash "$ENGINE_ROOT/scripts/kair-publish.sh" "$VAULT"
```

3. Report the script output (count published).
4. Remind the user: phone check-offs are not synced back — run `/kair-publish` again after vault changes. iCloud lag may briefly resurrect an item if publish runs immediately after a phone completion.

## Agent Instructions

- Run the script via Shell — do not simulate publish.
- Do not touch the Reminders Inbox list.
- Keep tone brief. Report success or the exact error.
- If not on macOS, say this skill requires macOS 13+ and rem-cli.
