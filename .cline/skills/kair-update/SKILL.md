---
name: kair-update
description: Pull engine updates into the vault via update.sh. Use when the user runs /kair-update or wants to sync skills and templates from the engine.
disable-model-invocation: true
---

# /kair-update — Engine Sync Skill

**Type:** Interactive skill
**Cadence:** On-demand

## Description

Runs the engine's `update.sh` to copy allowlisted paths (`skills/`, `agents/`, `hooks/`, `styles/`, `templates/`, `AGENTS.md`) into the vault, then regenerates backend skill adapters (`.cursor/skills/`, `.claude/skills/`, `.cline/skills/`).

Engine version always wins on allowlisted paths. Custom edits under those paths in the vault are overwritten.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos-vault}"
```

If the workspace root looks like a vault (contains `inbox/`, legacy `inbox.md`, or `AGENTS.md`), prefer the workspace root over the default.

## Engine Path Resolution

Resolve the engine root in this order:

1. `$VAULT/.engine-root` — one-line absolute path (written by `setup.sh`)
2. `KAIROS_ENGINE_ROOT` or `GSD_ENGINE_ROOT` environment variable
3. Ask the user for the path to their engine clone

Validate each candidate: `templates/allowlist.txt` must exist under the engine root.

## Behavior

1. Resolve `$VAULT` and `$ENGINE_ROOT`.
2. If `$ENGINE_ROOT` is missing or invalid, tell the user to run `setup.sh` from the engine or create `$VAULT/.engine-root` with the engine path.
3. Run:

```bash
bash "$ENGINE_ROOT/update.sh" "$ENGINE_ROOT" "$VAULT"
```

4. Summarize the output: which paths synced, whether skill adapters were regenerated.
5. Remind the user to reload the editor window if slash commands changed.

## Agent Instructions

- Run `update.sh` via the Shell tool — do not simulate the sync.
- Do not copy files by hand; always use `update.sh`.
- If the user customized allowlisted files in the vault, warn once that those edits will be overwritten, then proceed unless they cancel.
- Keep tone brief. Report success or the exact error from the script.
