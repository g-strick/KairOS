# Expansions

Ideas for KairOS after the lean two-phase kit ships. **Not committed work** — no phase numbers, no dates. Pull from here when `/capture` and `/daily` feel real.

## Skills (candidates)

| Command | Purpose |
|---------|---------|
| `/sort` | Process `inbox.md` — route items to projects, goals, or daily notes |
| `/weekly` | Guided weekly review from past daily notes |
| `/evening` | Short end-of-day reflection |
| `/monthly` | Monthly reset and priority review |
| `/goals` | Scaffold a goal hierarchy when ready |
| `/status` | One-screen summary (avoid "dashboard" framing) |
| `/archive` | Move completed work to `archive/` |

## Vault paths (create on demand)

- `goals/` — when `/goals` or weekly review needs them
- `projects/` — one folder per active project
- `habits.md` — when daily check-in should track streaks
- `archive/` — completed items

## Integrations (deferred)

- Apple Calendar / Reminders (read-only macOS bridge)
- Job-search log and staleness signal
- Bulk import from other tools

## Optional extras

- Custom output styles (`/style`, `/style-new`)
- Functional agent files (e.g. `inbox-processor`) if a skill benefits from a separate definition
- Session-start hook surfacing inbox count and last `/daily` date

---

*When an item graduates from this list, add it to `.planning/REQUIREMENTS.md` and `ROADMAP.md` through normal GSD planning.*
