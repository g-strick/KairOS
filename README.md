# KairOS

*A Markdown-native personal operating loop — capture, daily focus, projects, and archive.*

> **Author-first, open source.** Built for daily use by the maintainer. Clone it, run `setup.sh`, and adapt the vault to your life.

---

## Quick start

```bash
git clone https://github.com/g-strick/KairOS.git ~/code/kairos-engine
cd ~/code/kairos-engine
./setup.sh                         # creates ~/kairos (prompt to confirm)
./update.sh ~/kairos               # sync skills into your vault
cd ~/kairos                        # open this folder in Cursor or Obsidian
```

Then: **`/onboard`** → **`/capture`** → **`/daily`**

Full vault layout: **[docs/VAULT.md](docs/VAULT.md)**

## Commands

| Command | When |
|---------|------|
| `/help` | Orient — commands, folders, engine vs vault |
| `/onboard` | Once — writes `profile.md` |
| `/capture` | Anytime — new note in `inbox/` |
| `/daily` | Once a day — read inbox, one focus, write today's note |

## How it works

| | Engine (this repo) | Vault (`~/kairos`) |
|--|-------------------|---------------------|
| **What** | Skills, scripts, templates | Your inbox, goals, daily notes |
| **Git** | Public | Private |
| **You edit** | When improving the tool | Every day |

`setup.sh` scaffolds the vault including an `_engine/` folder for private experiments and handoffs — so you can live in the vault without juggling repos.

## Principles

- **Markdown is the source of truth**
- **Bash + Markdown only** in the core
- **Check-ins, not dashboards**
- **Ritual before features** — see [docs/EXPANSIONS.md](docs/EXPANSIONS.md) for what's intentionally not built yet

## Documentation

| Doc | Purpose |
|-----|---------|
| [docs/VAULT.md](docs/VAULT.md) | Vault folders, `_engine/` lab, setup |
| [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) | Engine vs vault workflow |
| [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) | Branches, commits, tests |

## Tests

```bash
bash test/setup.test.sh && bash test/lean-v1.test.sh && bash test/update.test.sh
```

## License

TBD
