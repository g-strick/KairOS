# Stack Research

**Domain:** Markdown-native personal OS / Claude Code agent system
**Researched:** 2026-06-23
**Confidence:** HIGH

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

**Skill file structure (current best practice):**
```
skills/
  morning/
    SKILL.md       ← skill definition loaded by /morning command
  weekly-review/
    SKILL.md
  capture/
    SKILL.md
```

**SKILL.md anatomy:**
```markdown
<skill>
  <purpose>One-line description</purpose>
  <trigger>/kairos-morning</trigger>
  <process>
    Step-by-step what the skill does
  </process>
  <output>What it produces and where</output>
</skill>
```

**Agent definition structure:**
```
agents/
  sorter.md        ← crew agent definitions
  steward.md
  scribe.md
  keeper.md
  concierge.md
```

**Hook patterns:**
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

**Read today's Apple Calendar events:**
```applescript
tell application "Calendar"
  set today to current date
  set startOfDay to today
  set time of startOfDay to 0
  set endOfDay to today
  set time of endOfDay to 86399
  set allEvents to {}
  repeat with cal in calendars
    set calEvents to (every event of cal whose start date is greater than or equal to startOfDay and start date is less than or equal to endOfDay)
    set allEvents to allEvents & calEvents
  end repeat
  repeat with evt in allEvents
    log summary of evt & " at " & (start date of evt as string)
  end repeat
end tell
```

**Read Apple Reminders (due today or overdue):**
```applescript
tell application "Reminders"
  set dueItems to (every reminder whose completed is false and due date is not missing value and due date is less than or equal to (current date))
  repeat with r in dueItems
    log name of r
  end repeat
end tell
```

**Important:** macOS 14+ requires explicit TCC permission for Calendar and Reminders. First run will prompt the user. Wrap in error handler and instruct user to grant permission in System Settings > Privacy.

### Markdown Conventions

**Daily note filename:** `YYYY-MM-DD.md` — sorts chronologically, no config needed
**Goal files:** `goals/yearly/2026.md`, `goals/weekly/2026-W25.md`, etc.
**Inbox:** `inbox.md` — append-only; Sorter clears it
**Frontmatter for daily notes:**
```yaml
---
date: 2026-06-23
week: W25
focus: "The one thing"
mood: 3  # 1-5
---
```

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
