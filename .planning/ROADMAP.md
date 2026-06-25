# Roadmap: KairOS

## Overview

Two phases close the lean v1 kit. Phase 1 makes the engine cloneable and the vault safe. Phase 2 proves the daily loop: onboard, capture, daily. Everything else is parked in `docs/EXPANSIONS.md` — not phased until deliberately promoted.

## Phases

- [ ] **Phase 1: Foundation** — Engine/vault structure is cloneable, scaffoldable, and structurally safe
- [ ] **Phase 2: Daily proof** — User can onboard, capture, and run a daily check-in that reads inbox
- [ ] **Phase 3: Reminders bridge** — Read-only Apple Reminders integration in `/kair-daily`

## Phase Details

### Phase 1: Foundation

**Goal**: User can clone the engine, run `setup.sh`, and have a structurally safe minimal vault  
**Depends on**: Nothing  
**Requirements**: FOUND-01 through FOUND-05  

**Success Criteria**:

1. Clone finds `skills/`, `hooks/`, `styles/`, `templates/`, valid `AGENTS.md`
2. `setup.sh` creates `~/kairos/` with `daily/`, `inbox.md`, `AGENTS.md` only
3. `update.sh` copies only allowlisted paths
4. Pre-push hook blocks vault content globs
5. `/help` explains engine vs vault and lists shipped commands

**Plans**: 3 plans (01-01, 01-02, 01-03) — *may need refresh for lean scaffold and unprefixed commands*

### Phase 2: Daily proof

**Goal**: User runs `/onboard`, `/capture`, and `/daily` as a working habit  
**Depends on**: Phase 1  
**Requirements**: DAILY-01 through DAILY-03  

**Success Criteria**:

1. `/onboard` writes `profile.md`
2. `/capture` appends to `inbox.md` without categorization
3. `/daily` reads inbox, records one focus in `daily/YYYY-MM-DD.md`

**Plans**: TBD — replace obsolete `02-onboarding-north-star` plans

### Phase 3: Reminders bridge

**Goal**: `/kair-daily` surfaces due-today and overdue Apple Reminders on macOS without breaking Linux or permission-denied cases  
**Depends on**: Phase 2  
**Requirements**: INTG-01  

**Success Criteria**:

1. `hooks/read-reminders.sh` prints markdown for due/overdue reminders via `osascript`
2. Non-macOS and TCC-denied runs exit 0 with actionable stderr
3. `/kair-daily` includes a `## Reminders` section in today's note

**Plans**: TBD

## Parked

See `docs/EXPANSIONS.md`. No Phase 4+ until items are promoted via GSD.

## Progress

| Phase | Plans Complete | Status |
|-------|----------------|--------|
| 1. Foundation | 0/3 | Not started |
| 2. Daily proof | 0/TBD | Not started |
| 3. Reminders bridge | 0/TBD | Not started |
