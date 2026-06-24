# Development

How to work on KairOS without leaking private life into the public engine repo.

KairOS is **author-first**: the maintainer dogfoods it daily; the engine is public. Anyone can clone, run `setup.sh`, and keep their own private vault.

## The two directories

| | Path | Remote | Contains |
|---|---|---|---|
| **Engine** | `~/code/kairos-engine/` | **public** | skills, hooks, templates, docs |
| **Vault** | `~/kairos/` | **private** | [docs/VAULT.md](VAULT.md) — inbox, daily, projects, etc. |

## The one rule

> **Edit behavior in the engine. Edit your life in the vault. Improvements flow down via `update.sh`; they flow up only by hand, one file at a time.**

## Daily workflow

**Improving the tool** — engine repo. Test with `test/*.test.sh` and temp vault paths (`KAIROS_VAULT=$(mktemp -d)`), never your real `~/kairos`.

**Living your life** — `~/kairos/`. Run `/capture` and `/daily`. Commit to a private remote.

**Sync engine → vault:**

```bash
~/code/kairos-engine/update.sh ~/kairos
```

Allowlist: `skills/`, `agents/`, `hooks/`, `styles/`, `templates/`, `AGENTS.md`.

**Promote one file engine ← vault:**

```bash
cp ~/kairos/skills/capture/SKILL.md ~/code/kairos-engine/skills/capture/SKILL.md
```

Never `cp -r`. Never bulk-copy vault → engine.

## Safety

- Engine and vault are **separate git working trees**
- `.gitignore` blocks vault paths at engine repo root (`/inbox/`, `/daily/`, etc.)
- `hooks/pre-push` aborts if tracked files match `hooks/content-globs.txt`

## Tests before PR

```bash
bash test/setup.test.sh
bash test/lean-v1.test.sh
bash test/update.test.sh
bash test/pre-push.test.sh
```

## See also

- [VAULT.md](VAULT.md) — vault layout
- [CONTRIBUTING.md](CONTRIBUTING.md) — branches, commits, PRs
- [EXPANSIONS.md](EXPANSIONS.md) — parked features
