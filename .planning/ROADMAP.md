# Roadmap: KairOS

## Overview

KairOS is built in four phases that each close a complete loop. Phase 1 makes the engine clonable and the vault scaffoldable — nothing else runs until this exists. Phase 2 gives the user their north star and goal hierarchy, the content every later ritual reads. Phase 3 delivers the daily practice: capture, sort, and morning check-in with habit tracking. Phase 4 closes the v1 loop with a weekly guided review and a single-command dashboard that surfaces everything that matters.

## Phases

**Phase Numbering:**

- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Foundation** - Engine and vault structure is cloneable, scaffoldable, and structurally safe
- [ ] **Phase 2: Onboarding + North Star** - User has their goals, north-star documents, and council written into the system
- [ ] **Phase 3: Daily Rituals** - User has a functional morning practice with zero-friction capture and daily triage
- [ ] **Phase 4: Weekly Cadence + Dashboard** - Full v1 loop closes: weekly review, session hook, and executive dashboard

## Phase Details

### Phase 1: Foundation

**Goal**: User can clone the engine, run `setup.sh`, and have a structurally safe engine/vault pair ready for the rest of the system
**Mode:** mvp
**Depends on**: Nothing (first phase)
**Requirements**: FOUND-01, FOUND-02, FOUND-03, FOUND-04, FOUND-05
**Success Criteria** (what must be TRUE):

  1. User can clone `kairos-engine/` and find all expected directories (`skills/`, `agents/`, `hooks/`, `styles/`, `templates/`) with a valid `AGENTS.md` under 400 lines
  2. User can run `setup.sh` and have `~/kairos/` scaffolded with all required vault directories and seed files (`north-star/`, `goals/`, `daily/`, `inbox.md`, `projects/`, `council/`, `habits.md`, `archive/`)
  3. `update.sh` copies only allowlisted engine paths into the vault — adding a file to the engine that is not on the allowlist does not copy it
  4. A `git push` on the engine repo is aborted if any tracked file matches the content-glob safety list (e.g., path contains `daily/`, `desired.md`, `dreaded.md`)

**Plans**: 3 plans
**Wave 1**

- [ ] 01-01-PLAN.md — Walking Skeleton: engine structure, bash test harness, interactive setup.sh + full vault scaffold (Wave 1)

**Wave 2** *(blocked on Wave 1 completion)*

- [ ] 01-02-PLAN.md — AGENTS.md canonical sections, /kairos-help skill, example content (Wave 2)
- [ ] 01-03-PLAN.md — update.sh allowlist sync + pre-push content-glob safety hook (Wave 2)

### Phase 2: Onboarding + North Star

**Goal**: User has completed the onboarding interview, written their desired and dreaded futures, and initialized their goal hierarchy
**Mode:** mvp
**Depends on**: Phase 1
**Requirements**: ONBD-01, ONBD-02, ONBD-03, ONBD-04, ONBD-05
**Success Criteria** (what must be TRUE):

  1. User can run `/kairos-onboard` and complete a semi-structured interview that populates their profile (name, timezone, key priorities, habits to track) and confirms the vault is ready
  2. User can run `/kairos-north-star` and produce populated `north-star/desired.md` and `north-star/dreaded.md` files in their vault
  3. User can run `/kairos-goals` and have a scaffolded goal hierarchy (5-year → yearly → monthly → weekly goal files) in their vault
  4. Standard Council agent definitions are available in the engine and accessible from the vault after `setup.sh`

**Plans**: 2 plans
**Wave 1**

- [ ] 02-01-PLAN.md — Fix unanchored .gitignore (un-ignore north-star/goals skills), register profile.md safety net, extend m002 gate with git-tracking assertions (Wave 1)

**Wave 2** *(blocked on Wave 1 completion)*

- [ ] 02-02-PLAN.md — Commit the two skills, update AGENTS.md skill list + Council section, verify 20/20 m002 + full suite (Wave 2)

### Phase 3: Daily Rituals

**Goal**: User has a functional morning practice — they can capture anything instantly, sort their inbox with agent help, and run a ≤5-minute morning check-in that surfaces their focus and habit streaks
**Mode:** mvp
**Depends on**: Phase 2
**Requirements**: CAPT-01, CAPT-02, CAPT-03, DAILY-01, DAILY-02, DAILY-03
**Success Criteria** (what must be TRUE):

  1. User can run `/kairos-capture` and append any thought to `inbox.md` in under 10 seconds with no categorization required
  2. User can run `/kairos-sort` to invoke the Sorter agent, confirm routing decisions interactively, and have `inbox.md` cleared after processing
  3. User can run `/kairos-morning` and in ≤5 minutes: see their weekly focus and monthly goal, set one daily focus, and view a habit streak summary from `habits.md`
  4. Steward agent definition includes explicit Architect (approach) and Undertow (prevention — trajectory not character) voice guardrails
  5. `habits.md` is updated by Steward during morning check-in and correctly reflects streak counts and last-completed dates

**Plans**: TBD

### Phase 4: Weekly Cadence + Dashboard

**Goal**: User can run a guided weekly review that reads the past week and writes next week's focus, and can get a single-command executive summary of their entire system state
**Mode:** mvp
**Depends on**: Phase 3
**Requirements**: WEEK-01, WEEK-02, WEEK-03, DASH-01, DASH-02
**Success Criteria** (what must be TRUE):

  1. User can run `/kairos-weekly` and complete a guided review that reads the past 7 daily notes, surfaces monthly goal progress, and produces a written next-week focus; the skill auto-offers when a weekly review is overdue
  2. A session-start hook surfaces today's date and week number, flags if a weekly review is due, and displays any unprocessed inbox items — without any user action required
  3. User can run `/kairos-dashboard` and see a single-screen summary: today's focus, active weekly goal, current monthly goal, habit streaks, and any overdue weekly review items
  4. Dashboard renders habit streak data from `habits.md` in a plain-text format alongside goal progress

**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 0/3 | Not started | - |
| 2. Onboarding + North Star | 0/TBD | Not started | - |
| 3. Daily Rituals | 0/TBD | Not started | - |
| 4. Weekly Cadence + Dashboard | 0/TBD | Not started | - |
