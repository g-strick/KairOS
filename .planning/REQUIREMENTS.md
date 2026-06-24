# Requirements: KairOS

**Defined:** 2026-06-23  
**Revised:** 2026-06-24  
**Core Value:** Interactive check-ins you run — not a dashboard you stare at.

Canonical vault layout: [docs/VAULT.md](../docs/VAULT.md)

## v1 Requirements

### Foundation

- [x] **FOUND-01**: Engine structure + `AGENTS.md` as context root (under 400 lines)
- [x] **FOUND-02**: `setup.sh` scaffolds `inbox/`, `daily/`, `projects/`, `someday/`, `archive/`, `AGENTS.md`
- [x] **FOUND-03**: `update.sh` syncs via explicit allowlist
- [x] **FOUND-04**: Pre-push hook + `content-globs.txt`
- [x] **FOUND-05**: `/help` lists commands and explains engine vs vault

### Daily Proof

- [x] **DAILY-01**: `/onboard` → `profile.md`
- [x] **DAILY-02**: `/capture` → new file in `inbox/`
- [x] **DAILY-03**: `/daily` → reads `inbox/`, one focus, `daily/YYYY-MM-DD.md`

> **UAT:** Requirements are implemented in repo; Phase 3 validates them in real daily use.

---

## Parked (EXPANSIONS.md)

`/sort`, `/weekly`, `/monthly`, `/goals`, integrations, styles, agent personas.

---

## Traceability

| Requirement | Phase | Implementation |
|-------------|-------|----------------|
| FOUND-01–05 | 1 | Engine tree, `setup.sh`, `update.sh`, hooks, `skills/help/` |
| DAILY-01–03 | 2 | `skills/onboard/`, `capture/`, `daily/` |

---
*Last updated: 2026-06-24*
