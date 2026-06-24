# Roadmap: KairOS

## Overview

Four phases to a usable daily loop. **Current focus: Phase 3 — use the system and log friction** before adding features from `docs/EXPANSIONS.md`.

## Phases

- [x] **Phase 0.5: Reconciliation** — Repo, docs, and tests agree on product shape
- [x] **Phase 1: Foundation** — setup, update, hooks, `/help` *(skills synced; validate hooks in your environment)*
- [x] **Phase 2: Daily proof** — `/onboard`, `/capture`, `/daily` skill specs shipped
- [ ] **Phase 3: Validation** — 7–14 days real use; promote one expansion if friction repeats

## Phase details

### Phase 0.5: Reconciliation ✓

Repo, tests, and docs describe the same product: unprefixed commands, skills-only, no crew/council, parked agent personas.

### Phase 1: Foundation ✓

**Vault scaffold** (`setup.sh`):

```
inbox/, daily/, projects/, someday/, archive/, AGENTS.md, inbox/README.md
```

**Engine:** `update.sh` (allowlist sync), `hooks/pre-push` + `content-globs.txt`, four skills in `skills/`.

**Verify locally:**

```bash
bash test/setup.test.sh
bash test/lean-v1.test.sh
bash test/update.test.sh
bash test/pre-push.test.sh   # requires git write in sandbox
```

### Phase 2: Daily proof ✓

| Skill | Delivers |
|-------|----------|
| `/onboard` | `profile.md` |
| `/capture` | New file in `inbox/` |
| `/daily` | Reads `inbox/`, one focus, writes `daily/YYYY-MM-DD.md` |

Specs live in `skills/*/SKILL.md`. **UAT:** run the loop in your vault for real.

### Phase 3: Validation (current)

**Goal:** Prove capture + daily before building `/sort`, `/weekly`, etc.

Track:

- Was capture fast enough?
- Was daily short enough?
- Did `inbox/` become intimidating?
- Did you return the next day?
- What did you wish existed more than once?

**Rule:** Promote **one** item from `docs/EXPANSIONS.md` only after repeated friction.

## Parked

See `docs/EXPANSIONS.md`. No Phase 4+ until promotion through planning.

## Progress

| Phase | Status |
|-------|--------|
| 0.5 Reconciliation | Complete |
| 1 Foundation | Complete (verify hooks locally) |
| 2 Daily proof | Skills shipped — UAT pending |
| 3 Validation | **In progress** |
