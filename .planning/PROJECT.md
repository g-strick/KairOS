# KairOS

## What This Is

KairOS is a markdown-native personal operating system operated by slash commands (skills). Capture to `inbox/`, daily check-in, projects/someday/archive routing — with a structurally safe split between a **public engine repo** and a **private vault**.

Built primarily for the maintainer's daily use; others are welcome to clone and adapt.

## Core Value

The ritual and structure are what make a system stick. KairOS is interactive check-ins you run, not a dashboard you stare at.

## Requirements

### Validated

(None yet — Phase 3 dogfooding)

### Shipped (pending UAT)

**Foundation**
- [x] Engine structure: `skills/`, `hooks/`, `templates/`, `AGENTS.md`
- [x] `setup.sh` scaffolds vault per [docs/VAULT.md](../docs/VAULT.md)
- [x] `update.sh` allowlist sync
- [x] Pre-push hook + `content-globs.txt`
- [x] `/help` skill

**Daily loop**
- [x] `/onboard` → `profile.md`
- [x] `/capture` → new file in `inbox/`
- [x] `/daily` → reads `inbox/`, one focus, `daily/YYYY-MM-DD.md`

### Out of Scope (see EXPANSIONS.md)

Goal hierarchy, crew/council personas, `/sort`, `/weekly`, integrations, style system, Python/Node/database.

## Context

Dogfood capture + daily for 7–14 days before promoting expansions. Vault layout is documented in `docs/VAULT.md` — single source of truth.

## Key Decisions

| Decision | Outcome |
|----------|---------|
| Author-first, public engine | Approved |
| `inbox/` folder (not `inbox.md`) | Done |
| Vault: inbox, daily, projects, someday, archive | Done |
| Unprefixed commands | Done |
| Skills only — no agent personas in tree | Done |
| Phase 3 validation before expansions | Active |

---
*Last updated: 2026-06-24*
