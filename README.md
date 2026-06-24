# KairOS

*A markdown-native personal operating system — capture and daily check-ins in plain text, run by slash commands and bash hooks.*

> **Status:** early development. See [docs/EXPANSIONS.md](docs/EXPANSIONS.md) for ideas not yet built.

---

## What it is

KairOS is a personal system that lives entirely in Markdown. There is no app, no database, no cloud service. You clone the engine, run `setup.sh` to create a private vault, and use a small set of slash commands:

| Command | When |
|---------|------|
| `/help` | Orient — commands and engine vs vault |
| `/onboard` | Once — writes `profile.md` |
| `/capture` | Anytime — append to `inbox.md` |
| `/daily` | Once a day — read inbox, one focus, write today's note |

The design bet is that **ritual beats features**: prove the daily loop before adding goals, sorting, or reviews.

## Principles

- **Markdown is the source of truth.** Greppable, git-versioned, portable. No Obsidian required.
- **Bash and Markdown only.** No Python runtime, no scheduler in the core.
- **Check-ins, not dashboards.** Interactive commands you run — not a screen to stare at.
- **Engine vs vault separation.** Public tool, private life — structurally separate repos ([docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)).
- **Backend-agnostic.** `AGENTS.md` is the canonical context for Claude Code, Codex, Gemini, Ollama, or similar.

## Repository structure (engine)

```
kairos-engine/
├── README.md
├── AGENTS.md
├── setup.sh / update.sh / install-hooks.sh
├── docs/
│   ├── DEVELOPMENT.md   # engine vs vault discipline
│   ├── EXPANSIONS.md    # parked ideas
│   └── CONTRIBUTING.md  # branches, commits, PRs
├── skills/              # /help, /onboard, /capture, /daily
├── agents/              # reserved (empty in lean v1)
├── hooks/
├── styles/
├── templates/
├── examples/
└── test/
```

No real personal content lives in this repo — only templates and examples.

## Engine vs your vault

- **`kairos-engine/`** (this repo, public) — skills, hooks, templates.
- **`~/kairos/`** (private) — inbox, profile, daily notes.

Your private data cannot end up in the public repo by accident if you follow [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md).

## Minimal vault layout

```
~/kairos/
├── AGENTS.md
├── inbox.md
├── profile.md       # from /onboard
└── daily/
    └── YYYY-MM-DD.md
```

## Getting started

```bash
git clone <engine-repo-url> ~/code/kairos-engine
cd ~/code/kairos-engine
./setup.sh              # default vault: ~/kairos
cd ~/kairos
claude                  # or your local runner
# /onboard → /capture → /daily
```

## Roadmap

**Phase 1 — Foundation:** clone, setup, safety hooks, `/help`  
**Phase 2 — Daily proof:** `/onboard`, `/capture`, `/daily`

Everything else lives in [docs/EXPANSIONS.md](docs/EXPANSIONS.md) until deliberately planned.

## Contributing

Branching, commit messages, and PRs: [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).

## License

**TBD** — a license file will be added before the project invites contributors.
