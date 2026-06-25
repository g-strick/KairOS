---
name: kair-update
description: Pull engine updates into the vault via update.sh. Use when the user runs /kair-update or wants to sync skills and templates from the engine.
disable-model-invocation: true
---

# /kair-update — Engine Sync Skill

**Type:** Interactive skill
**Cadence:** On-demand

## Description

Runs the engine's `update.sh` to copy allowlisted paths into the vault under `_kair/` (`skills/`, `agents/`, `hooks/`, `styles/`, `templates/`) plus `AGENTS.md` at the vault root, then regenerates backend skill adapters (`.cursor/skills/`, `.claude/skills/`, `.cline/skills/`).

Engine version always wins on allowlisted paths. Custom edits under those paths in the vault are overwritten.

**Sandbox / no local clone:** When `.engine-root` points to a missing path, `update.sh` automatically fetches from GitHub using `$VAULT/.engine-remote` (default `https://github.com/g-strick/KairOS.git`, branch `main`). No local engine checkout required.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos-vault}"
```

If the workspace root looks like a vault (contains `inbox/`, legacy `inbox.md`, or `AGENTS.md`), prefer the workspace root over the default.

## Engine Path Resolution

Resolve the engine root in this order:

1. `$VAULT/.engine-root` — one-line absolute path (written by `setup.sh` when a local clone exists)
2. `KAIROS_ENGINE_ROOT` or `GSD_ENGINE_ROOT` environment variable
3. **Remote fetch** — `$VAULT/.engine-remote` + `$VAULT/.engine-branch` (or `KAIROS_ENGINE_REMOTE` / `KAIROS_ENGINE_BRANCH`)

Validate local candidates: `templates/allowlist.txt` must exist under the engine root. If missing or path does not exist, use remote fetch — do not ask the user to clone unless fetch fails.

## Behavior

1. Resolve `$VAULT`.
2. If a valid local `$ENGINE_ROOT` exists, run:

```bash
bash "$ENGINE_ROOT/update.sh" "$ENGINE_ROOT" "$VAULT"
```

3. Otherwise run vault-only update (fetches from GitHub automatically):

```bash
bash "$ENGINE_ROOT/update.sh" "$VAULT"
```

If `update.sh` is not available locally, bootstrap from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/g-strick/KairOS/main/update.sh | bash -s -- "$VAULT"
```

4. Summarize the output: which paths synced, whether skill adapters were regenerated, whether engine was fetched remotely.
5. Remind the user to reload the editor window if slash commands changed.

## Agent Instructions

- Run `update.sh` via the Shell tool — do not simulate the sync.
- Do not copy files by hand; always use `update.sh`.
- **Do not tell the user to clone the engine** when `.engine-root` is missing — run vault-only `update.sh` or the curl bootstrap first.
- If the user customized allowlisted files in the vault, warn once that those edits will be overwritten, then proceed unless they cancel.
- Keep tone brief. Report success or the exact error from the script.
