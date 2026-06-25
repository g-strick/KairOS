# KairOS

**Engine:** KairOS · **Vault:** Kairos Vault · **Path:** `~/kairos-vault` (injected at runtime by the session-start hook) · **Date:** `{{CURRENT_DATE}}` · **Backend:** backend-agnostic — works under Claude Code, Cursor, Cline (Ollama/VSCodium), Codex, Gemini, or any local LLM runner that supports Markdown context files. Canonical skills live in `_kair/skills/`; `update.sh` mirrors them into `.cursor/skills/`, `.claude/skills/`, and `.cline/skills/` for native `/` menus.

**Engine vs vault:** The engine (public KairOS repo) holds skills, hooks, and templates. The Kairos Vault holds your inbox, profile, daily notes, and GTD lists. Private data stays out of the engine tree.

**Updates:** `/kair-update` syncs from a local engine clone (`.engine-root`) or fetches from GitHub (`.engine-remote`) when no clone exists — sandbox-safe.

---

## Skills

| Command | Description |
|---------|-------------|
| `/kair-help` | Lists available commands and explains the engine-vs-vault model |
| `/kair-onboard` | First-run interview → `profile.md` |
| `/kair-capture` | Capture anything into `inbox/` — no categorization |
| `/kair-daily` | Read inbox, set one focus, write today's note in `daily/` |
| `/kair-triage` | GTD clarify Reminders Inbox (first) + vault `inbox/` — four smart options per item, merge suggestions, ASCII desk progress; one-by-one approval (macOS Reminders when `rem` + `jq` available) |
| `/kair-publish` | Publish next actions → Reminders Actions list (macOS) |
| `/kair-update` | Pull engine updates into the vault (`update.sh`) |

**Deprecated (redirect to `/kair-triage`):** `/kair-process-inbox`, `/kair-process-reminders`

Planned skills and future ideas: `docs/EXPANSIONS.md` and `docs/FUTURE-IDEAS.md` in the engine repo.

---

## Daily loop

1. **Capture** — `/kair-capture` or phone → Reminders Inbox
2. **Orient** — `/kair-daily` once a day
3. **Clarify** — `/kair-triage` when inbox items pile up (Reminders first, then vault files)
4. **Execute** — work from `next-actions.md`; `/kair-publish` to push actions to the phone (macOS)

GTD lists: `next-actions.md`, `waiting-for.md`, `someday-maybe.md`, `projects/`, `reference/`. Full routing rules live in `skills/kair-triage/SKILL.md`.

---

## Style

`_kair/styles/default.md` — plain, direct voice. No style switching in the lean kit.

---

## Parallel sessions

`daily/` notes and `inbox/` captures are append-safe (different files per day/item). `next-actions.md`, `waiting-for.md`, and `someday-maybe.md` are single-writer — do not edit them from parallel sessions; let the user serialize.

---

*Canonical context root — every skill reads this file first. Domain knowledge loads on demand; this file is a map, not the territory.*
