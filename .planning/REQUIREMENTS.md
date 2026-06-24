# Requirements: KairOS

**Defined:** 2026-06-23  
**Revised:** 2026-06-24 (lean two-phase cut)  
**Core Value:** Interactive check-ins you run — not a dashboard you stare at.

## v1 Requirements

### Foundation

- [ ] **FOUND-01**: Engine directory structure exists with `AGENTS.md` as canonical context root (under 400 lines)
- [ ] **FOUND-02**: `setup.sh` scaffolds minimal vault: `daily/`, `inbox.md`, `AGENTS.md`
- [ ] **FOUND-03**: `update.sh` syncs via explicit allowlist (never denylist)
- [ ] **FOUND-04**: Pre-push hook aborts on content-glob matches
- [ ] **FOUND-05**: `/help` skill lists commands and explains engine vs vault

### Daily Proof

- [ ] **DAILY-01**: `/onboard` — interview writes `profile.md` (name, timezone)
- [ ] **DAILY-02**: `/capture` — append-only to `inbox.md`; no categorization; under 10 seconds
- [ ] **DAILY-03**: `/daily` — reads inbox, sets one focus, writes `daily/YYYY-MM-DD.md`; ≤5 min

---

## Parked (EXPANSIONS.md — not v1)

Sort, weekly, monthly, evening, goals, status/dashboard, habits, integrations, styles, agents, archive/cleanup — promote through GSD planning when ready.

---

## Out of Scope

| Feature | Reason |
|---------|--------|
| Scheduling / push notifications | Requires daemon; out of Bash-only core |
| North-star / dual-futures interviews | Deferred — cut from lean v1 |
| Crew/council agent personas | Skills-only lean kit |
| Obsidian dependency | Plain markdown only |
| Python / Node / database | Bash + Markdown constraint |

---

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| FOUND-01 | Phase 1 | Pending |
| FOUND-02 | Phase 1 | Pending |
| FOUND-03 | Phase 1 | Pending |
| FOUND-04 | Phase 1 | Pending |
| FOUND-05 | Phase 1 | Pending |
| DAILY-01 | Phase 2 | Pending |
| DAILY-02 | Phase 2 | Pending |
| DAILY-03 | Phase 2 | Pending |

**Coverage:** 8 v1 requirements, all mapped ✓

---
*Last updated: 2026-06-24*
