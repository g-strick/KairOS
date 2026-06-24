# Development

How to work on KairOS without leaking private life into the public engine repo. The separation is structural — follow the layout and the mistake becomes difficult, not just unlikely.

## The two directories

| | Path | Remote | Contains |
|---|---|---|---|
| **Engine** | `~/code/kairos-engine/` | **public** | skills, hooks, styles, templates, docs |
| **Vault** | `~/kairos/` | **private** | inbox, profile, daily notes |

Name them distinctly so you always know which tree you're in.

## The one rule

> **Edit behavior in the engine. Edit your life in the vault. Improvements flow down via `update.sh`; they flow up only by hand, one file at a time.**

## Daily workflow

**Improving the tool** — work in the engine repo. Test with `test/*.test.sh` and throwaway vault paths (`mktemp`), never your real `~/kairos/`.

**Living your life** — work in `~/kairos/`. Capture and daily notes. Commit to a private remote.

**Pulling engine updates into your vault:**

```bash
~/code/kairos-engine/update.sh ~/kairos
```

`update.sh` copies an **allowlist** only: `skills/`, `agents/`, `hooks/`, `styles/`, `templates/`, `AGENTS.md`.

**Promoting one improvement back to the engine:**

```bash
cp ~/kairos/skills/capture/SKILL.md ~/code/kairos-engine/skills/capture/SKILL.md
```

Never `cp -r`. Never bulk-copy from vault to engine.

## Why this is mistake-proof

Engine and vault are **separate working trees with separate remotes**. Your journal isn't in the engine tree — a careless `git add .` in the engine can't pick up vault content that isn't there.

## Belt-and-suspenders

- **Allowlist sync, never denylist.** Worst case: forgot to publish a feature. Not: leaked inbox.
- **Anchored `.gitignore`** in the engine excludes vault content paths at repo root only (`/daily/`, `/inbox.md`, etc.).
- **Pre-push hook** aborts if any tracked file matches `hooks/content-globs.txt`.

All bash — no extra tooling.

## Contributing

License and full workflow: **[docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)** — branching (`gsd/phase-*`), conventional commits, PR template, and `/gsd-pr-branch` for clean reviews.

See [docs/EXPANSIONS.md](EXPANSIONS.md) for planned features not in the lean kit.
