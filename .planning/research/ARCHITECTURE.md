# Architecture Research

**Domain:** Claude Code agent-operated personal knowledge management system
**Researched:** 2026-06-23
**Confidence:** HIGH

## System Components

### Overview

```
kairos-engine/          (public repo — THE TOOL)
├── AGENTS.md           ← canonical context file (Claude Code reads this)
├── skills/             ← interactive rituals (SKILL.md per skill)
├── agents/             ← Crew agent definitions
├── hooks/              ← bash glue (session-start, auto-commit)
├── styles/             ← output voice/style definitions
├── templates/          ← vault scaffolding (daily, weekly, project, north-star)
├── examples/           ← example content (never real data)
├── setup.sh            ← scaffolds ~/kairos/ from templates
├── update.sh           ← allowlist-syncs engine changes into vault
└── docs/

~/kairos/               (private vault — YOUR LIFE)
├── AGENTS.md           ← copy of engine AGENTS.md (updated by update.sh)
├── skills/ → linked    ← symlink or copy of engine skills
├── agents/ → linked    ← symlink or copy of engine agents
├── hooks/ → linked     ← symlink or copy of engine hooks
├── styles/             ← user's selected/generated styles
├── north-star/
│   ├── desired.md      ← the life you'd build (Future Authoring)
│   └── dreaded.md      ← the life you'd fall into
├── goals/
│   ├── 5year.md
│   ├── yearly/
│   │   └── 2026.md
│   ├── monthly/
│   │   └── 2026-06.md
│   └── weekly/
│       └── 2026-W25.md
├── daily/
│   └── 2026-06-23.md
├── inbox.md            ← zero-friction capture (append-only)
├── projects/
│   └── [project-name]/
│       └── README.md
├── council/
│   └── [advisor-name].md   ← derived during onboarding
├── habits.md           ← habit tracker (updated by Steward)
├── job-search/
│   └── applications.md ← manual mirror of Google Sheets (Sorter can update)
└── archive/            ← Keeper moves finished work here
```

## Component Boundaries

### Crew Agents

| Agent | Reads | Writes | Triggered By |
|-------|-------|--------|-------------|
| **Sorter** | `inbox.md`, project list | Clears inbox; appends to project files, daily note, habits | Daily (session-start hook or `/kairos-sort`) |
| **Steward** | `daily/[today].md`, `goals/weekly/[current].md`, `desired.md`, `dreaded.md`, `habits.md` | Appends to daily note; updates `habits.md` | Daily morning + evening cadence |
| **Scribe** | `daily/` (past week), `goals/weekly/[current].md`, `goals/monthly/[current].md` | Writes weekly review file; updates monthly goal | Weekly (`/kairos-weekly`) |
| **Keeper** | All project files, `goals/` | Moves done items to `archive/`, updates STATE.md | On demand + monthly |
| **Concierge** | Templates | Writes all goal files, `desired.md`, `dreaded.md`, `habits.md`, `council/*.md` | Onboarding once; re-calibration periodically |

### Data Flow

```
User types something
       ↓
  /kairos-capture → appends to inbox.md
       ↓
  /kairos-sort (Sorter) → reads inbox, routes to right file
       ↓
  Project file / daily note / habits.md / job-search/applications.md
       ↓
  /kairos-morning (Steward) → reads today + this week + north star → guided focus
       ↓
  daily/YYYY-MM-DD.md (today's log)
       ↓
  /kairos-weekly (Scribe) → reads past 7 days → guided review → writes weekly review
       ↓
  goals/weekly/YYYY-WNN.md
       ↓
  /kairos-monthly → reads past 4 weeks → goal progress → updates monthly
       ↓
  goals/monthly/YYYY-MM.md
```

### AppleScript Bridge Data Flow

```
/kairos-morning
       ↓
  hooks/read-calendar.sh → osascript → Apple Calendar → today's events (text)
  hooks/read-reminders.sh → osascript → Apple Reminders → due items (text)
       ↓
  Steward injects into morning context
       ↓
  User sees calendar + reminders + goals in one conversation
```

### Voice/Style Data Flow

```
styles/default.md  ← shipped with engine
       ↓
  User runs /kairos-generate-style
       ↓
  Concierge interviews user → writes styles/[name].md
       ↓
  User runs /kairos-set-style [name] → AGENTS.md references this style
       ↓
  All subsequent agent output uses that style
```

## Build Order

The dependency chain dictates build order. Earlier items must exist before later ones work.

### Phase 1: Foundation (must exist first)
1. **Engine directory structure** — skills/, agents/, hooks/, styles/, templates/ directories
2. **AGENTS.md** — the canonical context file all agents read
3. **`setup.sh`** — scaffolds the vault; needed before any user can run the system
4. **Vault directory structure** — goals/, daily/, inbox.md, north-star/, etc.
5. **Capture skill** (`/kairos-capture`) — zero-friction inbox append; simplest possible skill

### Phase 2: Onboarding (enables the rest)
6. **Concierge agent + `/kairos-onboard`** — creates desired.md, dreaded.md, goal files, council
7. **North star templates** — desired.md and dreaded.md structure
8. **Goal templates** (5year, yearly, monthly, weekly)

### Phase 3: Daily rituals (the core usage loop)
9. **Sorter agent + `/kairos-sort`** — processes inbox
10. **Steward agent + `/kairos-morning`** — daily morning planning
11. **Steward + `/kairos-evening`** — daily evening reflection
12. **Session-start hook** — auto-surfaces agenda and pending reviews

### Phase 4: Weekly/monthly cadences
13. **Scribe agent + `/kairos-weekly`** — weekly review skill
14. **`/kairos-monthly`** — monthly reset skill
15. **Keeper agent + `/kairos-cleanup`** — archive finished work

### Phase 5: Integrations and polish
16. **AppleScript bridge** (calendar + reminders read)
17. **Voice/style generator**
18. **Council generation** (during onboarding, but complex — can be simplified first)
19. **`update.sh`** (engine → vault sync)
20. **Pre-push safety hook** (engine repo)

## Hook System Design

```bash
# .claude/settings.json hooks structure
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "Stop": [
      {
        "matcher": "",
        "hooks": [{
          "type": "command",
          "command": "bash ~/.kairos/hooks/session-end.sh"
        }]
      }
    ]
  }
}
```

**session-start.sh (run via hook or manually):**
```bash
#!/usr/bin/env bash
# Check for pending reviews
# Surface today's date and week number
# Check if weekly review is due (last Sunday check)
# Auto-commit any uncommitted vault changes
```

## Key Architectural Decisions to Make

| Decision | Options | Recommendation |
|----------|---------|----------------|
| Engine → vault sync mechanism | Symlinks vs. copy | **Symlinks** for skills/agents/hooks (instant updates); copy for templates (user customizes) |
| AGENTS.md location | Engine root vs. `.claude/` | **`.claude/CLAUDE.md`** in vault (Claude Code convention); symlink to engine's AGENTS.md |
| Skill invocation | `/kairos-morning` vs. `/morning` | **`/kairos-` prefix** — avoids collision with user's other Claude Code skills |
| Council agent format | Full agent file vs. style modifier | **Separate agent files in `council/`** — summoned explicitly, don't run automatically |
| Habit tracking | Separate habits.md vs. in daily note | **`habits.md`** as dedicated file — easier to grep and summarize across days |

## Sources

- Claude Code documentation: CLAUDE.md conventions, skills/, agents/ directory structure
- Git documentation: hooks, worktree conventions
- AppleScript Reference for Calendar and Reminders
- PARA method (Forte) — adapted project/area/resource distinction
- GTD (Allen) — inbox/capture/sort model
