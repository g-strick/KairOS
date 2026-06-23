# Development

How to work on Kairos without ever leaking your private life into the public repo. The separation is structural, not a matter of carefulness — follow the layout and the mistake becomes impossible, not just unlikely.

## The two directories

| | Path | Remote | Contains |
|---|---|---|---|
| **Engine** | `~/code/kairos-engine/` | **public** | skills, agents, hooks, styles, templates, examples, docs |
| **Vault** | `~/kairos/` | **private** (or local-only backup) | your real goals, projects, daily notes, north-star, dreams |

Name them distinctly so you always know which one you're in at a glance in the terminal prompt.

## The one rule

> **Edit *behavior* in the engine. Edit *your life* in the vault. Improvements flow *down* by script; they flow *up* only by hand, one file at a time, after you've looked at it.**

## Daily workflow

**Improving the tool** — work in `~/code/kairos-engine/`. Test against `examples/` or a throwaway instance, never your real vault. Commit, push to the public remote.

**Living your life** — work in `~/kairos/`. Capture, review, journal. Commit, push to the private remote.

**Pulling tool updates into your vault** — run the sync script, which copies an **allowlist** of safe paths (skills, agents, hooks, styles, templates, AGENTS.md) into your vault and touches nothing else:

```bash
~/code/kairos-engine/update.sh ~/kairos
```

**Promoting an improvement back to the engine** — made a skill tweak while using it? Copy that **one file** up by hand:

```bash
cp ~/kairos/skills/weekly/SKILL.md ~/code/kairos-engine/skills/weekly/SKILL.md
```

Never `cp -r`. Never bulk-copy from the vault to the engine.

## Why this is mistake-proof

The engine and vault are **separate working trees with separate remotes**. Your content isn't in the engine's tree at all — so a careless `git add .`, a stray commit, or a `.gitignore` typo *cannot* move your journal into the public repo. There's nothing there to move.

## Belt-and-suspenders (for the day you fat-finger something anyway)

- **Allowlist sync, never denylist.** The sync script copies an explicit list of safe paths. Its worst-case failure is "I forgot to publish a feature" (annoying). A denylist's worst-case failure is "I forgot to exclude my dreams" (the thing we're preventing). Always fail toward annoying.
- **`.gitignore` in the engine** excludes every content path; the repo ships `*.example.md` files and content dirs holding only `.gitkeep`.
- **A pre-push hook on the engine** aborts the push if any tracked file matches a content glob (e.g. `daily/`, `reviews/`, `desired.md`, `dreaded.md`).

All of this is bash — no extra tooling.

## Contributing (later)

While the project is solo there's nothing to coordinate. If contributors arrive, that's when to add a license, a contribution guide, and (if useful) a heavier upstream/submodule setup. Don't build for that now; grow into it.
