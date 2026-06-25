# Expansions

Ideas for KairOS after the lean kit ships. **Not committed work** — no phase numbers, no dates. Pull from here when `/kair-capture` and `/kair-daily` feel real.

**Broader brainstorm:** [FUTURE-IDEAS.md](FUTURE-IDEAS.md) (session ritual, connectors, navigation discipline).

## Skills (candidates)

| Command | Purpose |
|---------|---------|
| `/kair-weekly` | Guided weekly review from past daily notes |
| `/kair-evening` | Short end-of-day reflection |
| `/kair-monthly` | Monthly reset and priority review |
| `/kair-goals` | Scaffold a goal hierarchy when ready |
| `/kair-status` | One-screen summary (avoid "dashboard" framing) |
| `/kair-archive` | Move completed work to `archive/` |
| `/kair-braindump` | Rapid multi-capture into `inbox/` |
| `/kair-project` | Scaffold a new `projects/<slug>.md` |
| `/kair-focus` | Pick one `@context` action from `next-actions.md` |

**Shipped:** `/kair-triage` subsumes the earlier `/sort` idea and replaces `/kair-process-inbox` + `/kair-process-reminders` (GTD clarify + smart routing).

## Vault paths (create on demand)

- `goals/` — when `/kair-goals` or weekly review needs them
- `habits.md` — when daily check-in should track streaks
- `archive/` — completed items
- `memory.md` — rolling digest (pairs with future `/kair-end`)

**Scaffolded by `setup.sh`:** `inbox/`, `projects/`, `reference/`, `INDEX.md`, `VAULT.md`, GTD list files

## Integrations

**Shipped (macOS 13+):** Apple Reminders — `/kair-triage` and `/kair-publish` via [rem](https://github.com/BRO3886/rem) (`rem-cli` + `jq`); read-only due/overdue snapshot in `/kair-daily` via `_kair/hooks/read-reminders.sh` (`osascript`, no extra deps).

**Deferred:** See [FUTURE-IDEAS.md](FUTURE-IDEAS.md) (Todoist, Gmail, Drive, OneNote bridges).

## Optional extras

- Custom output styles (`/kair-style`, `/kair-style-new`)
- Functional agent files if a skill benefits from a separate definition
- `/kair-start` / `/kair-end` session continuity (see FUTURE-IDEAS)

---

*When an item graduates from this list, add it to `.planning/REQUIREMENTS.md` and `ROADMAP.md` through normal GSD planning.*
