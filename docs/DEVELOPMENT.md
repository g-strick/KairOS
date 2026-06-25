# Development

How to work on KairOS without leaking private life into the public engine repo. The separation is structural — follow the layout and the mistake becomes difficult, not just unlikely.

## The two directories

| | Path | Remote | Contains |
|---|---|---|---|
| **Engine** | `~/code/KairOS/` | **public** | skills, hooks, styles, templates, docs |
| **Vault** | `~/kairos-vault/` | **private** | inbox, profile, daily notes |

The vault display name is **Kairos Vault**; the default folder is shell-friendly `~/kairos-vault`. Name them distinctly so you always know which tree you're in.

## The one rule

> **Edit behavior in the engine. Edit your life in the vault. Improvements flow down via `update.sh`; they flow up only by hand, one file at a time.**

## Daily workflow

**Improving the tool** — work in the engine repo. Test with `test/*.test.sh` and throwaway vault paths (`mktemp`), never your real `~/kairos-vault/`.

**Living your life** — work in `~/kairos-vault/`. Capture and daily notes. Commit to a private remote.

**Pulling engine updates into your vault:**

```bash
~/code/KairOS/update.sh ~/kairos-vault
```

Or from the vault workspace: `/kair-update` (uses `.engine-root` when present, otherwise fetches from `.engine-remote` on GitHub — works in sandboxes without a local engine clone).

`update.sh` copies an **allowlist** only into the vault: `skills/`, `agents/`, `hooks/`, `styles/`, `templates/`, and `AGENTS.md` (at vault root). Engine directories are stored under `_kair/` in the vault (PKM underscore convention).

**Promoting one improvement back to the engine:**

```bash
cp ~/kairos-vault/_kair/skills/kair-capture/SKILL.md ~/code/KairOS/skills/kair-capture/SKILL.md
```

Never `cp -r`. Never bulk-copy from vault to engine.

## Why this is mistake-proof

Engine and vault are **separate working trees with separate remotes**. Your journal isn't in the engine tree — a careless `git add .` in the engine can't pick up vault content that isn't there.

## Belt-and-suspenders

- **Allowlist sync, never denylist.** Worst case: forgot to publish a feature. Not: leaked inbox.
- **Anchored `.gitignore`** in the engine excludes vault content paths at repo root only (`/daily/`, `/inbox/`, `/next-actions.md`, etc.).
- **Pre-push hook** aborts if any tracked file matches `hooks/content-globs.txt`.

All bash — no extra tooling.

## Contributing

Full workflow: **[docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)** — branching (`gsd/phase-*`), conventional commits, PR template, and `/gsd-pr-branch` for clean reviews.

See [docs/EXPANSIONS.md](EXPANSIONS.md) for planned features not in the lean kit.

## Action bridges (macOS)

Skills `/kair-triage` and `/kair-publish` call scripts under `scripts/bridges/` — not vendor CLIs directly from skill markdown. Today: `rem.sh` (Apple Reminders via [rem](https://github.com/BRO3886/rem)). Future backends (Todoist, Microsoft To Do) add sibling adapters selected by `KAIROS_ACTIONS_BRIDGE`.
