# Requirements: KairOS

**Defined:** 2026-06-23
**Core Value:** The ritual and structure are what make a system stick — KairOS is a set of interactive check-ins at different cadences, not a screen to stare at.

## v1 Requirements

### Foundation

- [ ] **FOUND-01**: Engine directory structure exists (`skills/`, `agents/`, `hooks/`, `styles/`, `templates/`) with `AGENTS.md` as the canonical Claude Code context root (under 400 lines)
- [ ] **FOUND-02**: `setup.sh` scaffolds the private vault (`~/kairos/`) from engine templates — creates all required directories and seed files
- [ ] **FOUND-03**: `update.sh` syncs engine changes into the vault via an explicit allowlist of safe paths (never a denylist)
- [ ] **FOUND-04**: Pre-push safety hook on the engine repo aborts if any tracked file matches a content glob (e.g., `daily/`, `goals/`, `desired.md`, `dreaded.md`)
- [ ] **FOUND-05**: Vault directory structure is scaffolded by `setup.sh`: `north-star/`, `goals/` (5year, yearly, monthly, weekly), `daily/`, `inbox.md`, `projects/`, `council/`, `habits.md`, `archive/`

### Onboarding

- [ ] **ONBD-01**: Concierge agent definition — the first-contact agent, runs onboarding and periodic re-calibration
- [ ] **ONBD-02**: `/kairos-onboard` skill — semi-structured interview that collects basic profile (name, timezone, key priorities, habits to track) and confirms vault is ready
- [ ] **ONBD-03**: Standard Council members ship with the engine (e.g., Life Coach, Strategic Advisor, Accountability Partner) — pre-built agent definitions that cater to the personal-development aims of KairOS; user invokes them on demand
- [ ] **ONBD-04**: `/kairos-north-star` skill — guided desired/dreaded interview that writes `north-star/desired.md` and `north-star/dreaded.md`; user invokes after onboarding
- [ ] **ONBD-05**: `/kairos-goals` skill — guided setup of goal hierarchy (5-year → yearly → monthly → weekly goal files); user invokes on demand

### Capture & Triage

- [ ] **CAPT-01**: `/kairos-capture` skill — zero-friction append-only dump to `inbox.md`; no categorization required; one command, done in under 10 seconds
- [ ] **CAPT-02**: Sorter agent definition — reads `inbox.md` and routes each item to the correct vault file (daily note, project, goals, habits)
- [ ] **CAPT-03**: `/kairos-sort` skill — invokes Sorter to process `inbox.md`; user confirms routing decisions; clears inbox after processing

### Daily Rituals

- [ ] **DAILY-01**: Steward agent definition — includes explicit Architect voice (approach motivation) and Undertow voice (prevention motivation) guardrails; Undertow addresses trajectory and consequence only, never character
- [ ] **DAILY-02**: `/kairos-morning` skill — reads today's weekly focus, current monthly goal, and north-star files; helps user set one daily focus; surfaces `habits.md` streak summary; completes in ≤5 min
- [ ] **DAILY-03**: `habits.md` — structured habit tracking file updated by Steward during morning check-in; tracks streak count and last-completed date per habit

### Weekly Cadence

- [ ] **WEEK-01**: Scribe agent definition — weekly and monthly reflection agent; learns user's style over time
- [ ] **WEEK-02**: `/kairos-weekly` skill — guided review: reads the past 7 daily notes and current weekly goal file; surfaces progress against monthly goal; helps user write next week's focus; auto-offers if weekly review is overdue
- [ ] **WEEK-03**: Session-start hook — bash hook that runs on Claude Code session start; surfaces today's date and week number, flags if weekly review is due, displays any unprocessed inbox items

### Dashboard

- [ ] **DASH-01**: `/kairos-dashboard` skill — single-command executive summary: displays today's focus, active weekly goal, current monthly goal, habit streaks, and any overdue items from the weekly review queue
- [ ] **DASH-02**: Dashboard reads `habits.md` for streak data and renders a plain-text summary alongside goal progress

---

## v2 Requirements

### Evening Ritual

- **DAILY-04**: `/kairos-evening` skill — evening reflection: what moved, what didn't, one note for tomorrow

### Monthly Cadence

- **MNTH-01**: `/kairos-monthly` skill — monthly reset: reads past 4 weekly reviews, surfaces goal progress, identifies stalled items, resets next month's priorities
- **MNTH-02**: Keeper agent — hygiene agent; archives finished work, keeps the vault clean
- **MNTH-03**: `/kairos-cleanup` skill — invokes Keeper to move completed projects and goals to `archive/`

### macOS Integration

- **INTG-01**: AppleScript bridge — reads today's Apple Calendar events from Terminal via `osascript`; includes TCC permission onboarding step and graceful degradation if permission not yet granted
- **INTG-02**: AppleScript bridge — reads due/overdue Apple Reminders items via `osascript`
- **INTG-03**: Morning skill integration — inject Calendar + Reminders data into `/kairos-morning` context

### Voice & Style

- **STYL-01**: Default output style file ships with engine (`styles/default.md`)
- **STYL-02**: `/kairos-generate-style` skill — short interview (what should this voice prioritize, what should it never do, give an example) that writes a new style file
- **STYL-03**: `/kairos-set-style [name]` — sets active style in AGENTS.md

### Job Search Signal

- **JOBS-01**: `job-search/applications.md` — manual log file with structured entries (company, date applied, status, follow-up date)
- **JOBS-02**: Dashboard includes staleness signal: flags if no application logged in the past 7 days

### AI Coaching

- **COCH-01**: LLM-generated coaching paragraph in the dashboard — reads goals, streaks, and recent activity to produce a contextual summary paragraph; deferred until usage patterns are established

---

## Out of Scope

| Feature | Reason |
|---------|--------|
| Scheduling / push notifications | Requires a daemon or scheduler; out of scope for Bash-only constraint |
| Bidirectional sync with Apple apps | Read-only bridge is sufficient for v1; write-back introduces conflict risk |
| Bulk import from Apple Notes / Microsoft To Do | High complexity, low reward vs. clean-slate vault start |
| Python / Node.js runtime | Violates Bash + Markdown only constraint |
| Database (SQLite or otherwise) | Kills greppability; vault must be readable in any text editor |
| Multi-user / sharing features | Personal system; sharing compromises honesty in self-assessment |
| Obsidian / iCloud Drive dependency | Vault sync via git remote only; no proprietary vault tools required |
| Complex tagging taxonomy | Tag maintenance becomes a second job and causes system abandonment |

---

## Traceability

Populated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| FOUND-01 | — | Pending |
| FOUND-02 | — | Pending |
| FOUND-03 | — | Pending |
| FOUND-04 | — | Pending |
| FOUND-05 | — | Pending |
| ONBD-01 | — | Pending |
| ONBD-02 | — | Pending |
| ONBD-03 | — | Pending |
| ONBD-04 | — | Pending |
| ONBD-05 | — | Pending |
| CAPT-01 | — | Pending |
| CAPT-02 | — | Pending |
| CAPT-03 | — | Pending |
| DAILY-01 | — | Pending |
| DAILY-02 | — | Pending |
| DAILY-03 | — | Pending |
| WEEK-01 | — | Pending |
| WEEK-02 | — | Pending |
| WEEK-03 | — | Pending |
| DASH-01 | — | Pending |
| DASH-02 | — | Pending |

**Coverage:**
- v1 requirements: 21 total
- Mapped to phases: 0
- Unmapped: 21 ⚠️ (will be resolved during roadmap creation)

---
*Requirements defined: 2026-06-23*
*Last updated: 2026-06-23 after initial definition*
