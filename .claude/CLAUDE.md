<!-- GSD:project-start source:PROJECT.md -->

## Context Root

AGENTS.md in the vault root is the canonical context file. Every skill reads it first.
It contains the skill quick-reference and style pointer. Domain knowledge loads
on demand — this file is a map, not the territory.

<!-- GSD:context-root-end -->

## Project

**KairOS**

KairOS is a markdown-native personal operating system. Ships `/help`, `/onboard`, `/capture`, `/daily` with engine/vault separation. Author-first, public engine. See `docs/VAULT.md` for vault layout.

**Core Value:** The ritual and structure are what make a system stick. KairOS is a set of interactive check-ins at different cadences — not a screen to stare at.

### Constraints

- **Tech stack**: Bash + Markdown only (skills, agents, hooks, templates). No Python runtime, no Node.js, no scheduler.
- **Privacy**: Engine/vault must be structurally separate repos — not gitignore-based; private data is physically absent from the engine tree.
- **Backend-agnostic**: Same files must run under Claude Code or a local Ollama runner.
- **No vendor lock**: Plain Markdown is the source of truth. No proprietary format, no required cloud service.

<!-- GSD:project-end -->

<!-- GSD:stack-start source:research/STACK.md -->

## Technology Stack

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Claude Code skills (.md) | current | Interactive rituals and agent definitions | Native format; skills compose cleanly; no runtime dependency |
| Bash | 5.x (macOS ships 3.x — use Homebrew bash) | Hooks, sync scripts, setup.sh, update.sh | No runtime dependency; works in any shell; portable |
| Markdown + YAML frontmatter | CommonMark + YAML 1.2 | Data files (goals, notes, daily logs) | Greppable, git-versioned, human-readable, editor-agnostic |
| Git | 2.x | Version control for vault content, engine code | Structural backbone; enables rollback, history, sync |
| AppleScript / osascript | macOS 13+ | Bridge to Apple Calendar and Reminders | Only reliable macOS-native integration; no auth tokens needed |

### Claude Code Skill Patterns

- `.claude/settings.json` `hooks` array — runs bash before/after tool use, on session start
- Session-start hook: reads STATE.md, surfaces today's agenda, checks for pending reviews
- Auto-commit hook: commits vault changes after each session

### Supporting Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| `osascript -e '...'` | One-liner AppleScript calls from Bash | Prefer here-doc for multi-line scripts |
| `git log --since="1 week ago"` | Weekly review: what changed | Combined with `--pretty=format` for readable output |
| `grep -r` | Search across vault | Fast enough for personal vaults; no indexer needed |
| `date` / GNU coreutils | Date calculations for cadences | macOS `date` differs from GNU; use `gdate` from Homebrew or pure arithmetic |

### AppleScript Patterns

### Markdown Conventions

## What NOT to Use

| Avoid | Why |
|-------|-----|
| Python scripts for data processing | Adds a runtime dependency; breaks on Python version changes; violates "Bash + Markdown only" constraint |
| Node.js / npm tooling | Same runtime problem; overkill for file manipulation |
| SQLite or any database | Kills greppability; requires tooling to inspect; vault should be readable in any text editor |
| Obsidian-specific syntax | Creates vault lock-in (wikilinks `[[]]` are okay as they work in GitHub preview too, but don't depend on Obsidian plugins) |
| Cron jobs or daemons | Out of scope for v1; hooks on session-start are sufficient for cadence awareness |
| iCloud Drive for sync | Conflicts with git; file locking issues; use git remote instead |

## Sources

- Claude Code documentation: hooks, skills, agent definitions
- macOS AppleScript Reference: Calendar, Reminders dictionaries
- Git documentation: log, diff patterns for weekly review
- PKM community patterns: PARA, GTD, Zettelkasten conventions adapted for Markdown

<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->

## Conventions

### Bash scripts
- All scripts: `#!/usr/bin/env bash` + `set -euo pipefail`
- Bash 5.x required; scripts check `BASH_VERSINFO[0]` and exit with a `brew install bash` message on macOS if below 5
- `shellcheck` must report zero errors on every script
- GNU-only utilities are banned (`gdate`, `gnu-sed`, etc.) — write macOS/Linux portable code

### Testing
- Pure-bash test harness: source `test/lib/assert.sh` for `assert_dir`, `assert_file`, `assert_eq`, `assert_exit_code`
- Tests drive scripts non-interactively via stdin piping and `KAIROS_*` env overrides; never touch `~/kairos`
- TDD convention: commit failing (RED) test before implementing, then make it GREEN

### Templates and single source of truth
- Directory/path lists live in one canonical file (e.g. `templates/vault-dirs.txt`); scripts read from it, never duplicate inline
- Seed files and templates ship in `templates/`; scripts reference `$SCRIPT_DIR` to locate them

### Engine/vault boundary
- Engine holds only behavior (scripts, skills, agents, templates, examples) — never real content
- `.gitignore` excludes all vault content paths; add an entry for any new content-ish path
- All content paths must appear in `hooks/content-globs.txt` (Phase 1 Plan 03) before any hook can enforce them

### Git workflow
- **Branching:** GSD phase branches (`gsd/phase-{NN}-{slug}`); ad-hoc work on `fix/{slug}` or `docs/{slug}` off `master`
- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/) — `type(scope): subject` (e.g. `feat(capture):`, `test(01):`, `docs(02):`)
- **PRs:** Use `.github/pull_request_template.md`; run `bash test/setup.test.sh`, `bash test/lean-v1.test.sh`, `bash test/update.test.sh` before opening
- **Clean PRs:** `/gsd-pr-branch master` filters `.planning/` commits for reviewer-facing PRs
- Full guide: `docs/CONTRIBUTING.md`
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->

## Architecture

### Engine directory layout

```
kairos-engine/
├── setup.sh / update.sh / install-hooks.sh
├── AGENTS.md
├── templates/vault-dirs.txt
├── templates/allowlist.txt
├── skills/                # help, onboard, capture, daily
├── agents/                # empty (.gitkeep) — personas in docs/parked/
├── hooks/pre-push
├── hooks/content-globs.txt
└── test/
```

### Vault layout (setup.sh)

See `docs/VAULT.md`. Summary: `inbox/`, `daily/`, `projects/`, `someday/`, `archive/`, `AGENTS.md`, `profile.md` (from /onboard).

### Key design decisions
- `templates/vault-dirs.txt` is the single source of truth for vault directories; `setup.sh` and `test/setup.test.sh` both read it
- Engine and vault are **separate git working trees** — not gitignore-based separation
- No runtime dependency: every script must run with bash 5.x + standard POSIX utilities only
<!-- GSD:architecture-end -->

<!-- GSD:skills-start source:skills/ -->

## Project Skills

No project skills found. Add skills to any of: `.claude/skills/`, `.agents/skills/`, `.cursor/skills/`, `.github/skills/`, or `.codex/skills/` with a `SKILL.md` index file.
<!-- GSD:skills-end -->

<!-- GSD:workflow-start source:GSD defaults -->

## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:

- `/gsd-quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd-debug` for investigation and bug fixing
- `/gsd-execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->

<!-- GSD:profile-start -->

## Developer Profile

> Profile not yet configured. Run `/gsd-profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
