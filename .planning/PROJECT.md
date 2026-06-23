# KairOS

## What This Is

KairOS is a markdown-native personal operating system operated by a crew of AI agents. It organizes goals across time horizons (daily to 5-year), runs interactive cadence rituals (morning, weekly, monthly), and grounds personal development in a north-star model drawn from Future Authoring psychology. There is no app, no database, no cloud service — just plain Markdown files, agent/skill definitions, bash hooks, and git. You clone it, answer an onboarding interview, and from then on a crew of agents check in with you at different cadences, plan your day, process your captures, and sit with you for reflection.

## Core Value

The ritual and structure are what make a system stick. KairOS is a set of interactive check-ins at different cadences — not a screen to stare at.

## Requirements

### Validated

(None yet — ship to validate)

### Active

**Onboarding**
- [ ] Concierge agent runs semi-structured onboarding interview with smart defaults and free-form answers
- [ ] User writes `desired.md` (the life they'd build if what's good in them wins) during onboarding
- [ ] User writes `dreaded.md` (the life they'd fall into if their worst habits ran unchecked) during onboarding
- [ ] Council roster is derived from the user's active projects during onboarding (not pre-built)
- [ ] `setup.sh` scaffolds the private vault from engine templates

**The Crew (core agents)**
- [ ] Sorter — triages the inbox daily; decides where each captured item goes
- [ ] Steward — checks days against aims, flags drift using the Architect/Undertow voices
- [ ] Scribe — sits with the user for weekly and monthly reflection; learns their style over time
- [ ] Keeper — hygiene agent; archives finished work, keeps the structure clean
- [ ] Concierge — first contact; runs onboarding and periodic re-calibration

**Cadences**
- [ ] Daily morning planning skill (touch + focus for the day)
- [ ] Daily evening reflection skill (what happened, what moved, what didn't)
- [ ] Weekly guided review skill (reads week's notes, plans next week; auto-offers Sunday or next login)
- [ ] Monthly reset skill (goal progress, what's stalled, priority recalibration)

**Goal hierarchy**
- [ ] Template and structure supporting daily / weekly / monthly / yearly / 5-year goal horizons
- [ ] Each goal links up to its parent horizon (daily task → weekly focus → monthly goal → yearly goal → north star)

**North star model**
- [ ] `desired.md` template and interview questions
- [ ] `dreaded.md` template and interview questions
- [ ] The Architect voice — reads activity against desired future (approach motivation, promotion-focused)
- [ ] The Undertow voice — reads activity against dreaded future (prevention-focused; addresses the road and the consequence, never the person's character)

**Voice / style system**
- [ ] Default output style shipped with engine
- [ ] Style generator skill (short interview → writes a new style file)
- [ ] How-to doc so anyone can fork the default by example

**Engine / vault separation**
- [ ] `kairos-engine/` as public repo containing skills, agents, hooks, styles, templates, examples
- [ ] `~/kairos/` as private vault containing the user's real goals, projects, daily notes, north-star files
- [ ] `update.sh` (allowlist sync — copies only safe engine paths into the vault; never a denylist)
- [ ] Pre-push safety hook on the engine repo that aborts if any tracked file matches a content glob

**macOS integration bridge (v1)**
- [ ] AppleScript bridge reads today's events from Apple Calendar
- [ ] AppleScript bridge reads due/overdue items from Apple Reminders
- [ ] Dashboard skill surfaces calendar + reminders data alongside goal progress and streaks
- [ ] Job application staleness signal — alerts when no applications logged in the configured window

**Executive dashboard skill**
- [ ] Today's tasks + calendar view
- [ ] Goal progress across active horizons
- [ ] Current focus area
- [ ] Streak / habit tracking summary
- [ ] Job application signal (sourced from Google Sheets or manual log)

**On-demand capture**
- [ ] Zero-friction capture skill that dumps anything into the inbox without categorizing
- [ ] Inbox file as natural landing zone for all captured items (Sorter processes it)

### Out of Scope

- AI coaching paragraph / LLM-generated narrative — deferred to a later milestone
- Scheduling / push notifications — anything that pings at a time lives in an integration layer; not the core
- Multi-source import (bulk pull from Apple Notes, Microsoft To Do, Google Sheets) — deferred
- Cross-platform integration beyond macOS (CalDAV, Google Calendar API) — macOS AppleScript bridge ships first; cross-platform is designed in later
- Python runtime, Node.js app, or any database — Bash + Markdown only for v1
- Real-time sync to Apple apps — read-only bridge only in v1

## Context

The user has years of scattered tool sprawl: Google Sheets (yearly/quarterly goals + job applications), Apple Notes (large unorganized archive), Apple Reminders (gotten too large), Microsoft To Do (old, unused), Apple Calendar (inconsistent), OneNote (tried), Emacs (tried — liked extensibility, too complex). Nothing connects. Reviews stop happening. The archive pile grows and is never revisited.

KairOS addresses this not by importing everything at once but by creating a single system with strong ritual structure that the user actually shows up to. External data (Apple Calendar, Reminders, job app sheet) is surfaced read-only into the daily check-in; the user's canonical records live in the vault.

The user is a developer (Emacs background, Claude Code user). They want the tool to be open-source, cloneable by strangers, with their personal data physically impossible to leak into the public repo.

The design is grounded in established psychology:
- **Regulatory Focus Theory** (Higgins) — promotion (Architect) vs. prevention (Undertow)
- **WOOP / Mental Contrasting** (Oettingen) and **Future Authoring** (Pennebaker / Morisano lineage via Peterson) — the desired/dreaded structure
- **Goal-Setting Theory** (Locke & Latham) and **Self-Determination Theory** (Deci & Ryan) — specific, values-aligned goals
- **Implementation Intentions** (Gollwitzer) and habit research (Fogg; Wood & Neal; Clear) — closing the gap between intending and doing

## Constraints

- **Tech stack**: Bash + Markdown only (skills, agents, hooks, templates). No Python runtime, no Node.js, no scheduler.
- **Privacy**: Engine/vault must be structurally separate repos — not gitignore-based; private data is physically absent from the engine tree.
- **Backend-agnostic**: Same files must run under Claude Code or a local Ollama runner.
- **No vendor lock**: Plain Markdown is the source of truth. No proprietary format, no required cloud service.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Agents/skills + Markdown only (no app, no DB) | Greppable, git-versioned, forever portable; eliminates runtime dependency | — Pending |
| Engine/vault structural separation (two repos, two remotes) | Makes private data leak structurally impossible rather than just unlikely | — Pending |
| Allowlist sync (never denylist) in `update.sh` | Worst-case failure is "forgot to publish a feature" (annoying); denylist worst-case is leaked dreams (catastrophic) | — Pending |
| Check-ins not dashboards as the primary model | Rituals drive consistency; passive screens don't | — Pending |
| North star = desired.md + dreaded.md (Future Authoring-inspired) | Bridges intention and motivation with evidence-backed structure | — Pending |
| Two motivational voices (Architect = promotion, Undertow = prevention) | Grounded in RFT; Undertow addresses trajectory not character to avoid self-criticism trap | — Pending |
| AppleScript bridge for v1 integrations | macOS-only for now; quick to ship without API dependencies; cross-platform designed in later | — Pending |
| Council derived from projects (not pre-built roster) | Makes the system personal and avoids dead advisor slots | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-06-23 after initialization*
