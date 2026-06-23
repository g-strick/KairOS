<!-- GSD:project-start source:PROJECT.md -->

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

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->

## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
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
