# KairOS

*A markdown-native personal operating system — capture and daily check-ins in plain text, run by slash commands and bash hooks.*

> **Status:** early development. See [docs/EXPANSIONS.md](docs/EXPANSIONS.md) for ideas not yet built.

---

## What it is

KairOS is a personal system that lives entirely in Markdown. There is no app, no database, no cloud service. You clone the engine, run `setup.sh` to create a private vault, and use a small set of slash commands:

| Command | When |
|---------|------|
| `/kair-help` | Orient — commands and engine vs vault |
| `/kair-onboard` | Once — writes `profile.md` |
| `/kair-capture` | Anytime — capture into `inbox/` |
| `/kair-daily` | Once a day — read inbox, one focus, write today's note |
| `/kair-triage` | GTD clarify Reminders + vault `inbox/` — smart options |
| `/kair-publish` | macOS — push next actions to Reminders Actions list |
| `/kair-update` | After engine changes — sync skills and templates into vault |

The design bet is that **ritual beats features**: prove the daily loop before adding goals, sorting, or reviews.

## Principles

- **Markdown is the source of truth.** Greppable, git-versioned, portable. No Obsidian required.
- **Bash and Markdown only.** No Python runtime, no scheduler in the core.
- **Check-ins, not dashboards.** Interactive commands you run — not a screen to stare at.
- **Engine vs vault separation.** Public tool, private life — structurally separate repos ([docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)).
- **Backend-agnostic.** `AGENTS.md` is the canonical context for Claude Code, Codex, Gemini, Ollama, or similar.

## Repository structure (engine)

```
KairOS/
├── README.md
├── AGENTS.md
├── setup.sh / update.sh / install-hooks.sh
├── docs/
│   ├── DEVELOPMENT.md   # engine vs vault discipline
│   ├── EXPANSIONS.md    # parked skill ideas
│   ├── FUTURE-IDEAS.md  # research-backed brainstorm backlog
│   └── CONTRIBUTING.md  # branches, commits, PRs
├── skills/              # slash commands (kair-*)
├── scripts/
│   ├── bridges/         # rem, future Todoist/M365 adapters
│   ├── kair-publish.sh
│   ├── kair-process-helpers.sh
│   └── kair-triage-display.sh
├── agents/              # reserved (empty in lean v1)
├── hooks/
├── styles/
├── templates/
├── examples/
└── test/
```

No real personal content lives in this repo — only templates and examples.

## Engine vs your vault

- **KairOS** (this repo, public) — skills, hooks, templates.
- **Kairos Vault** at `~/kairos-vault/` (private) — inbox, profile, daily notes, GTD lists.

Your private data cannot end up in the public repo by accident if you follow [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md).

## Minimal vault layout

```
~/kairos-vault/
├── AGENTS.md
├── VAULT.md             # human orientation
├── INDEX.md             # agent L0 navigation map
├── .engine-root         # path to local engine clone (optional)
├── .engine-remote       # GitHub URL when no local clone (default: g-strick/KairOS)
├── .engine-branch       # branch to fetch (default: main)
├── inbox/               # unprocessed captures (/kair-capture)
├── next-actions.md      # actionable now
├── waiting-for.md
├── someday-maybe.md
├── projects/
├── reference/
├── profile.md           # from /kair-onboard
├── daily/
│   └── YYYY-MM-DD.md
└── _kair/               # engine sync (PKM meta — skills, styles, hooks)
```

After `/kair-update`, engine paths land under `_kair/` so your document folders stay primary in the file tree. Editor slash adapters (`.cursor/skills/`, etc.) remain at the vault root.

## Getting started

```bash
git clone <engine-repo-url> ~/code/KairOS
cd ~/code/KairOS
./setup.sh              # default vault: ~/kairos-vault
cd ~/kairos-vault
claude                  # or your local runner
# /kair-onboard → /kair-capture → /kair-daily
```

### Apple Reminders bridge (macOS 13+)

Optional phone capture and execution via **[rem](https://github.com/BRO3886/rem)** — a CLI for Apple Reminders. KairOS shells out to `rem` through `scripts/bridges/rem.sh`; it is not bundled. Install and usage details are on the [rem project page](https://github.com/BRO3886/rem).

```bash
brew tap BRO3886/tap && brew install rem-cli
brew install jq
```

Grant Reminders access to Terminal or Cursor on first use (System Settings → Privacy & Security → Reminders).

- Capture on phone → Reminders **Inbox** list → `/kair-triage` on Mac
- `/kair-publish` → Reminders **Actions** list for phone execution

One-way per command — no two-way sync. See [scripts/bridges/README.md](scripts/bridges/README.md).

## Roadmap

**Phase 1 — Foundation:** clone, setup, safety hooks, `/kair-help`  
**Phase 2 — Daily proof:** `/kair-onboard`, `/kair-capture`, `/kair-daily`  
**Phase 3 — Reminders bridge:** `/kair-triage`, `/kair-publish`

Everything else lives in [docs/EXPANSIONS.md](docs/EXPANSIONS.md) and [docs/FUTURE-IDEAS.md](docs/FUTURE-IDEAS.md) until deliberately planned.

## Contributing

Branching, commit messages, and PRs: [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).

## License

**TBD** — no project license has been chosen yet. Do not add `LICENSE` files or `SPDX-License-Identifier` headers to engine code until that decision is made (see [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)).
