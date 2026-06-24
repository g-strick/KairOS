# KairOS Agent Instructions

**Vault:** KairOS · **Path:** `~/kairos` (or `KAIROS_VAULT`) · **Date:** `{{CURRENT_DATE}}` · **Backend:** backend-agnostic — works under Claude Code, Codex, Gemini, Ollama, or any local LLM runner that supports Markdown context files.

---

## Product

Markdown-native personal operating loop. The user runs skills; skills read and write the vault. The engine is public and forkable; each user's vault is private.

## Engine vs vault

- **Engine** (public repo): skills, hooks, `setup.sh`, `update.sh`
- **Vault** (`~/kairos`, private): inbox, notes, projects — your life data

Run `update.sh` to pull engine improvements into the vault. Never bulk-copy vault content back into the engine.

## Vault layout

See `docs/VAULT.md` for the full tree.

| Path | Purpose |
|------|---------|
| `inbox/` | Raw capture (`/capture` writes `.md` files; drop any file type here). Process during `/daily` or move by hand. |
| `daily/` | One note per day (`/daily`) — focus, short reflection. |
| `projects/` | Active commitments. Start with one `.md` or folder per project. |
| `someday/` | Parked ideas — not committing now, don't want to forget. |
| `archive/` | Retired items |
| `goals/` | Current intentions — edit manually |
| `scripts/` | Local automation (private) |
| `_engine/` | Private lab — NOW, BACKLOG, HANDOFF, experiments (never publish) |

## Session start

If `~/kairos/_engine/HANDOFF.md` exists, read it and `NOW.md` before other work.

## Commands

| Command | Description |
|---------|-------------|
| `/help` | List commands; explain engine vs vault |
| `/onboard` | First-run interview → `profile.md` |
| `/capture` | Write a timestamped note to `inbox/` |
| `/daily` | Read inbox, set one focus, write today's note |

Future: `/sort` to route inbox items → projects, someday, archive. Not shipped yet — move by hand or ask during `/daily`.

## Rules

- Never write private vault content into the engine repo.
- Preserve user wording in captures — no auto-categorization on capture.
- Each `/capture` creates a **new file** in `inbox/`; never append to a shared inbox file.
- Keep daily check-in short — **one focus**, not a dashboard.
- Prefer append-only on capture files; move or archive only when the user asks.
- Do not auto-create new top-level folders beyond the scaffold in `docs/VAULT.md`.
- Never copy `_engine/` to the public engine repo.

---

*Canonical context root — every skill reads this file first.*
