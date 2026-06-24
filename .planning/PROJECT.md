# KairOS

## What This Is

KairOS is a markdown-native personal operating system operated by slash commands (skills). It provides a minimal daily loop — capture to inbox, daily check-in — with a structurally safe split between a public engine repo and a private vault. No app, no database, no cloud service: Markdown files, skill definitions, bash hooks, and git.

## Core Value

The ritual and structure are what make a system stick. KairOS is interactive check-ins you run, not a dashboard you stare at.

## Requirements

### Validated

(None yet — ship to validate)

### Active

**Foundation (Phase 1)**
- [ ] Engine directory structure (`skills/`, `agents/`, `hooks/`, `styles/`, `templates/`) with `AGENTS.md` under 400 lines
- [ ] `setup.sh` scaffolds minimal private vault: `daily/`, `inbox.md`, `AGENTS.md`
- [ ] `update.sh` syncs engine into vault via allowlist (never denylist)
- [ ] Pre-push safety hook aborts if tracked files match content globs
- [ ] `/help` skill lists commands and explains engine vs vault

**Daily proof (Phase 2)**
- [ ] `/onboard` — short interview → `profile.md`
- [ ] `/capture` — append to `inbox.md` in under 10 seconds
- [ ] `/daily` — read inbox, one focus, write `daily/YYYY-MM-DD.md`

### Out of Scope (see EXPANSIONS.md)

- Goal hierarchy, north-star interviews, motivational voice personas
- Crew/council agent layer
- Sort, weekly, monthly, evening, dashboard/status skills
- macOS integrations, job-search signals, style generator
- AI coaching paragraphs, scheduling/push notifications
- Python, Node.js, database, Obsidian dependency

## Context

The user has tool sprawl elsewhere; KairOS starts minimal — prove capture + daily before layering goals or reviews. The engine must remain cloneable by strangers with private data structurally impossible to leak into the public repo.

## Constraints

- **Tech stack**: Bash + Markdown only
- **Privacy**: Engine/vault structural separation (two repos)
- **Backend-agnostic**: `AGENTS.md` canonical; works under Claude Code or local runners
- **No vendor lock**: Plain Markdown source of truth

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Skills only for lean v1 — no agent personas | Matches lean kits; less lore, faster to ship | — Pending |
| Unprefixed commands (`/capture`, `/daily`) | Aligns with AIS-OS and obsidian-claude-pkm conventions | — Approved 2026-06-24 |
| `/daily` not `/morning` | Room to add evening later; matches ballred naming | — Approved 2026-06-24 |
| Two phases only; rest in EXPANSIONS.md | Cut brainstorm scope creep | — Approved 2026-06-24 |
| Minimal vault scaffold | Dirs imply features; create paths on demand later | — Pending |
| Allowlist sync in `update.sh` | Worst-case: forgot to publish a feature; not leaked data | — Pending |
| Pre-push safety hook in Phase 1 | Before content commits land | — Pending |
| Phase branching + conventional commits | Clean PRs per phase; see docs/CONTRIBUTING.md | — Approved 2026-06-24 |

## Evolution

Updated at phase transitions via GSD workflows. Parked ideas live in `EXPANSIONS.md`, not in phased requirements, until deliberately promoted.

---
*Last updated: 2026-06-24 after lean scope cut*
