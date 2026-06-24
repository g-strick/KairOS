<!-- GSD:project-start source:PROJECT.md -->

## Context Root

AGENTS.md in the vault root is the canonical context file. Every agent and skill reads it first.
It contains the crew roster, active style pointer, and skill quick-reference. Domain knowledge loads
on demand — this file is a map, not the territory.

<!-- GSD:context-root-end -->

## Project

**KairOS**

KairOS is a markdown-native personal operating system operated by a crew of AI agents. It organizes goals across time horizons (daily to 5-year), runs interactive cadence rituals (morning, weekly, monthly), and grounds personal development in a north-star model drawn from Future Authoring psychology. There is no app, no database, no cloud service — just plain Markdown files, agent/skill definitions, bash hooks, and git. You clone it, answer an onboarding interview, and from then on a crew of agents check in with you at different cadences, plan your day, process your captures, and sit with you for reflection.

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
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->

## Architecture

### Engine directory layout (Phase 1 complete)

```
kairos-engine/
├── setup.sh               # interactive vault scaffolder (Phase 1)
├── update.sh              # allowlist-based engine→vault sync (Phase 1 Plan 03, pending)
├── install-hooks.sh       # installs hooks into vault (Phase 1 Plan 03, pending)
├── AGENTS.md              # canonical agent context (stub; fully populated in Phase 1 Plan 02)
├── templates/
│   ├── vault-dirs.txt     # canonical newline-delimited vault directory list (single source of truth)
│   └── allowlist.txt      # safe engine paths update.sh may copy (Phase 1 Plan 03, pending)
├── skills/                # Claude Code skill files (.md); one dir per skill
├── agents/                # crew and council agent definitions
├── hooks/
│   ├── pre-push           # aborts push if tracked file matches content glob (pending)
│   └── content-globs.txt  # content paths the hook checks (pending)
├── styles/                # default output style + generator how-to
├── examples/              # example vault content for development; files end in .example.md
└── test/
    ├── lib/assert.sh      # pure-bash assertion helpers (reused by all test scripts)
    └── *.test.sh          # per-script end-to-end tests
```

### Vault layout (created by setup.sh)

```
~/kairos/
├── AGENTS.md              # copied from engine on setup or update
├── inbox.md               # zero-friction capture target
├── habits.md              # habit tracker
├── north-star/            # desired.md, dreaded.md
├── goals/{5year,yearly,monthly,weekly}/
├── daily/                 # daily notes
├── projects/              # one dir per project
├── council/               # council member definitions (derived from projects in Phase 2)
└── archive/               # completed/closed items
```

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
