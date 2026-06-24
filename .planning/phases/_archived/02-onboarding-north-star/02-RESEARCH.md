# Phase 2: Onboarding + North Star — Research

**Researched:** 2026-06-24
**Domain:** KairOS skill authoring, Future Authoring psychology, agent definition patterns, git safety infrastructure
**Confidence:** HIGH (all findings verified against actual files in the working tree)

---

## Situation Summary

Phase 2 is NOT greenfield. A previous GSD workflow (milestone M002) already produced all seven
Phase 2 engine artifacts. The `m002.test.sh` verification script runs 18 checks; 16 pass and 2
fail right now. The planning framework (`.planning/`) shows Phase 2 as not started because it was
executed outside this framework.

**The research question therefore shifts:** this is not "how to build onboarding skills" but
"what is the gap between the existing artifacts and the stated success criteria, and what must
the planner remediate?"

---

## ARCHITECTURE

### What Already Exists (Committed to Git)

| File | Status | Notes |
|------|--------|-------|
| `agents/concierge.md` | COMMITTED | First-contact agent with skill inventory |
| `agents/life-coach.md` | COMMITTED | Council: goal achievement, habit formation |
| `agents/strategic-advisor.md` | COMMITTED | Council: big-picture thinking, trade-offs |
| `agents/accountability-partner.md` | COMMITTED | Council: follow-through, commitment tracking |
| `skills/onboarding/SKILL.md` | COMMITTED | `/kairos-onboard` skill |
| `test/m002.test.sh` | COMMITTED | 18-check verification script |

### What Exists on Disk but Is GITIGNORED (Critical Bug — Broader Than Two Skills)

| File | Root Cause | Impact |
|------|------------|--------|
| `skills/north-star/SKILL.md` | `.gitignore` line 6: `north-star/` matches ANY path at any directory depth | File exists on this machine only; never enters the engine repo |
| `skills/goals/SKILL.md` | `.gitignore` line 7: `goals/` matches `skills/goals/` for the same reason | Same as above |
| `examples/daily/2025-01-01.md.example` | `.gitignore` line 5: `daily/` matches `examples/daily/` | Example files from Phase 1 are also unreachable by git |
| `examples/goals/weekly/example.md.example` | `.gitignore` line 7: `goals/` matches `examples/goals/` | Same as above |

**Verification:** `git check-ignore -v` returns all four collisions:
```
.gitignore:6:north-star/    skills/north-star/SKILL.md
.gitignore:7:goals/         skills/goals/SKILL.md
.gitignore:5:daily/         examples/daily/2025-01-01.md.example
.gitignore:7:goals/         examples/goals/weekly/example.md.example
```

`git ls-files examples/` returns nothing — the example files are not tracked.

**The `!*.example.md` line in `.gitignore` is a failed prior rescue attempt.** Git cannot
re-include a file whose parent directory is already excluded. This line does nothing and is
evidence that someone already hit this problem without resolving the root cause.

This is the blocking defect. The `.gitignore` uses unanchored directory patterns that were
intended to exclude vault content (the `~/kairos/north-star/`, `~/kairos/goals/`, `~/kairos/daily/`
directories) but accidentally also exclude engine directories with matching names.

**All six vault-content directory patterns in `.gitignore` are unanchored and unsafe:**

```
daily/      →   also excludes examples/daily/
north-star/ →   also excludes skills/north-star/
goals/      →   also excludes skills/goals/ AND examples/goals/
projects/   →   would also exclude skills/projects/ or examples/projects/ if created
council/    →   would also exclude skills/council/ or examples/council/ if created
archive/    →   would also exclude skills/archive/ or examples/archive/ if created
```

The fix must anchor ALL six patterns, not just the two currently blocking skills.

### Engine/Vault File Flow

```
Engine repo (kairos-engine)
        |
   git commit
        |
   GitHub remote
        |
   update.sh (allowlist-based copy)
        |
   Vault (~/kairos)
        ├── agents/          ← copy of engine agents/
        ├── skills/          ← copy of engine skills/
        └── council/         ← EMPTY after setup.sh; agents are in agents/ not council/
```

### Vault Path Resolution Pattern (Established Convention)

All Phase 2 skills already follow this pattern (must be preserved in any remediation):

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos}"
```

This is in all three skill files and the concierge agent. Any new work must match this pattern
exactly — it is the established convention for backend-agnostic vault path resolution.

### Skills Directory Structure (Current)

```
skills/
├── help/
│   └── SKILL.md          ← /kairos-help (Phase 1, committed)
├── onboarding/
│   └── SKILL.md          ← /kairos-onboard (Phase 2, committed)
├── north-star/
│   └── SKILL.md          ← /kairos-north-star (GITIGNORED — not in repo)
└── goals/
    └── SKILL.md          ← /kairos-goals (GITIGNORED — not in repo)
```

### Skill File Anatomy (Verified from Existing Files)

The Phase 1 help skill uses XML tags:
```markdown
<skill>
  <purpose>One-line description</purpose>
  <trigger>/kairos-help</trigger>
  <process>Step-by-step instructions</process>
  <output>What it produces and where</output>
</skill>
```

The Phase 2 skills use a richer Markdown format with headings, code blocks for bash snippets,
and explicit "Agent Instructions" sections. Both formats work — the LLM reads both. The Phase 2
style is more prescriptive and is the better pattern for skills that write vault files.

---

## PATTERNS

### Skill Design Pattern (From Existing Phase 2 Skills)

All three Phase 2 skills follow the same five-step structure:

1. **Vault Path Resolution** — `VAULT="${KAIROS_VAULT:-$HOME/kairos}"`
2. **Pre-flight Check** — Verify expected directories exist; fail with actionable error message
3. **Interview Flow** — Numbered steps, one question per step, each with a default
4. **Output Format** — Explicit Markdown template showing exactly what gets written where
5. **Agent Instructions** — Numbered steps the agent follows when the skill is invoked

This pattern is working. Remediation should preserve it.

### Interview Pattern

The existing `/kairos-onboard` skill uses 5 questions with smart defaults:
- What should I call you? (Default: "User")
- Timezone? (Default: "America/New_York")
- 3-5 key priorities? (Default: health/career/relationships/learning/finances)
- Habits to track? (Default: exercise/meditation/reading)
- Confirmation + offer to chain to next skill

The existing `/kairos-north-star` uses 7 questions across two parts (desired/dreaded), also
with defaults. This follows Future Authoring psychology: desired future first (what you want to
build), dreaded future second (what you want to avoid). This ordering is correct — desired future
activates approach motivation before dreaded activates prevention motivation.

### Profile Storage Decision (Already Made in Existing Skill)

The onboarding skill writes to `$VAULT/profile.md`. Format:

```markdown
# Profile

## Basic
- Name: <name>
- Timezone: <timezone>

## Priorities
1. <priority>

## Habits to Track
- <habit>

## Completed
- Onboarded: <date>
```

**Safety gap:** `profile.md` is NOT in `.gitignore`, `hooks/content-globs.txt`, or
`templates/vault-dirs.txt`. It is a vault content file (private personal data) that lacks the
safety net the other vault files have. This is a defect introduced in M002.

### Council Accessibility Pattern

The engine's `agents/` directory contains all crew and council agents. `update.sh` copies
`agents/` to `vault/agents/`. The vault `council/` directory (created by `setup.sh`) is a
separate directory for the user to place council agent files they want.

**Ambiguity in Success Criterion 4:** "Standard Council agent definitions are available in the
engine and accessible from the vault after `setup.sh`" — the agents ARE accessible in
`vault/agents/` (after `update.sh` runs). The vault `council/` directory is empty but is not
required to be populated by Phase 2. The planner must decide: is the success criterion satisfied
by the agents existing in `vault/agents/`, or must `setup.sh` copy them to `council/`?

### Future Authoring Psychology (Verified in Existing Skill)

The `/kairos-north-star` skill is grounded in:
- **Future Authoring** (Pennebaker / Morisano / Peterson) — structured written reflection on
  ideal future activates motivation and clarifies goals
- **WOOP / Mental Contrasting** (Oettingen) — imagining both the desired future AND the obstacles
  activates implementation intentions
- **Regulatory Focus Theory** (Higgins) — approach motivation (desired.md) + prevention
  motivation (dreaded.md) together cover both motivational systems

The existing skill already handles this correctly. The Undertow/Architect distinction (prevent
vs. approach) is already encoded in the Design Notes section of the north-star skill.

### Agent Definition Pattern (Verified from All Four Agent Files)

All council agents follow this structure:
- `# [Agent Name] Agent` — heading with role in subtitle
- `**Role:**` — one-line role description
- `## Operating Principles` — persona, behavioral constraints, framework grounding
- `## When to Invoke` — explicit trigger conditions (not open-ended)
- `## What You Do` — bulleted positive scope
- `## What You Don't Do` — bulleted negative scope (critical — prevents scope creep)

This pattern is effective. The "What You Don't Do" section is the key anti-drift guardrail.

---

## WAVE DECOMPOSITION

### Current State Assessment

| ONBD Requirement | Artifact | Current Status |
|-----------------|---------|---------------|
| ONBD-01: Concierge agent | `agents/concierge.md` | COMPLETE — committed, tests pass |
| ONBD-02: /kairos-onboard | `skills/onboarding/SKILL.md` | COMPLETE — committed, tests pass |
| ONBD-03: Council agents | `agents/life-coach.md`, `agents/strategic-advisor.md`, `agents/accountability-partner.md` | COMPLETE — committed, tests pass |
| ONBD-04: /kairos-north-star | `skills/north-star/SKILL.md` | BLOCKED — gitignored, not in repo |
| ONBD-05: /kairos-goals | `skills/goals/SKILL.md` | BLOCKED — gitignored, not in repo |
| AGENTS.md update | Skill list + Council table | FAILING — 2/18 m002 checks fail |
| profile.md safety | `.gitignore`, `content-globs.txt` | MISSING — safety net gap |

### Proposed Wave Structure: 2 Plans

#### Plan 02-01: Fix the gitignore collision (Wave 1, Blocking)

**Objective:** Make `skills/north-star/SKILL.md` and `skills/goals/SKILL.md` trackable and
committable without false-positive gitignore/hook matches.

**Problem:** Unanchored patterns in `.gitignore` (`north-star/` and `goals/`) match
`skills/north-star/` and `skills/goals/` even though these are engine behavior files, not vault
content.

**Fix options (planner chooses one):**

Option A — Anchor ALL six vault-content gitignore patterns (recommended):
```
# In .gitignore, change these six unanchored patterns:
daily/      →    /daily/
north-star/ →    /north-star/
goals/      →    /goals/
projects/   →    /projects/
council/    →    /council/
archive/    →    /archive/
```
This anchors every pattern to the repo root, so `skills/north-star/`, `examples/daily/`, etc.
are no longer matched. Partial anchoring (only the two blocking skills) leaves the other four
patterns as ongoing landmines for future `skills/projects/` or `examples/council/` directories.

**Do NOT apply anchoring to `hooks/content-globs.txt`.** The pre-push hook reads that file and
matches with `grep "^${pattern}"` against paths returned by `git ls-files`. Tracked file paths
never begin with `/`, so anchoring `content-globs.txt` patterns to `/north-star/` would cause
`grep ^/north-star/` to match nothing — breaking the hook. The hook is correctly designed as-is;
`skills/north-star/SKILL.md` does NOT match `^north-star/` (hook is safe). Touch only `.gitignore`.

Option B — Rename the skill directories:
```
skills/north-star/   →   skills/northstar/
skills/goals/        →   skills/goal-setup/
```
The trigger (`/kairos-north-star`, `/kairos-goals`) lives inside the SKILL.md file, not in the
directory name. Renaming the dir doesn't break the skill trigger. However, this does NOT fix the
`examples/daily/` and `examples/goals/` collision — those example files remain gitignored.

**Recommendation for planner:** Option A is cleaner and more complete — it fixes the root cause
for all six patterns (including the `examples/` collision Option B cannot address) rather than
working around two of them. The `.gitignore` should anchor all vault-root-only paths.

**Also in this plan:** Add `profile.md` to `.gitignore`, `hooks/content-globs.txt`, and document
it as a vault-only file. Update `test/setup.test.sh` to assert `profile.md` is excluded from
engine tracking (or document why it shouldn't be).

**Dependencies:** None — this unblocks Plan 02-02.

#### Plan 02-02: Commit skills + update AGENTS.md (Wave 2, Depends on 02-01)

**Objective:** Commit the two gitignored skill files and update AGENTS.md so all 18 m002 checks
pass.

**Tasks:**
1. After gitignore fix is in place, `git add skills/north-star/SKILL.md skills/goals/SKILL.md`
2. Update AGENTS.md skill quick-reference to list `/kairos-onboard`, `/kairos-north-star`,
   `/kairos-goals` (currently only lists `/kairos-help`)
3. Add a Council section to AGENTS.md listing Life Coach, Strategic Advisor, Accountability Partner
4. Keep AGENTS.md under 400 lines (currently 36 lines — no risk)
5. Run `bash test/m002.test.sh` and verify 18/18 pass

**Gate:** `bash test/m002.test.sh` exits 0.

**Note on Council accessibility:** The planner must decide whether success criterion 4 requires
setup.sh to copy council agents to `council/` or whether `vault/agents/` is sufficient. If the
former, a third task in this plan (or a separate plan 02-03) would add that logic to `setup.sh`
and its test.

---

## VALIDATION APPROACH

### What Can Be Tested

| Deliverable | Test Type | Command | What It Checks |
|-------------|-----------|---------|----------------|
| gitignore fix | Structural (bash) | `git check-ignore skills/north-star/SKILL.md; echo $?` | Must exit non-zero (not ignored) after fix |
| Both skill files committed | Structural (bash) | `git ls-files skills/north-star/ skills/goals/` | Must return the SKILL.md paths |
| profile.md in gitignore | Structural (bash) | `git check-ignore profile.md` | Must exit 0 (is ignored) |
| AGENTS.md skill list | Structural (grep) | `grep -q '/kairos-onboard' AGENTS.md` | Quick-reference has Phase 2 commands |
| AGENTS.md Council section | Structural (grep) | `grep -q 'Life Coach' AGENTS.md` | Council table present |
| AGENTS.md under 400 lines | Structural (wc) | `wc -l < AGENTS.md` | < 400 |
| All Phase 2 checks | Integration | `bash test/m002.test.sh` | 18/18 pass |
| Pre-push hook still safe | Integration | `bash test/pre-push.test.sh` | Existing tests still pass |

### Existing Test Coverage

`test/m002.test.sh` — 18 checks covering all five Phase 2 artifacts. This is the phase gate.
All 18 must pass before Phase 2 can be marked complete.

`test/pre-push.test.sh` — 3 checks on the pre-push hook. After gitignore changes, re-run to
verify the hook still correctly blocks vault content and passes safe trees.

`test/update.test.sh` — 12 checks on update.sh. No changes expected but should be re-run after
any `.gitignore` or allowlist changes.

### Wave 0 Gaps

None for tests — `test/m002.test.sh` already exists and covers all requirements. The planner
should run it at the start of execution to confirm the current 16/18 baseline.

---

## PITFALLS

### Pitfall 1: The Gitignore Anchoring Defect (BLOCKING — Affects 4+ Paths)

**What goes wrong:** ALL six vault-content patterns in `.gitignore` are unanchored, causing them
to match engine directories at any path depth. Confirmed collisions:
- `north-star/` → `skills/north-star/SKILL.md` (Phase 2 skill invisible to git)
- `goals/` → `skills/goals/SKILL.md` (Phase 2 skill invisible to git)
- `daily/` → `examples/daily/2025-01-01.md.example` (Phase 1 example invisible to git)
- `goals/` → `examples/goals/weekly/example.md.example` (Phase 1 example invisible to git)

The `!*.example.md` exemption is a failed prior rescue attempt — git cannot re-include files
whose parent directory is excluded, so this line does nothing.

**Why it happens:** Unanchored gitignore patterns (without a leading `/`) match at any directory
depth. The intention was to exclude `~/kairos/north-star/` from the engine repo, but the pattern
also excludes `skills/north-star/` and `examples/north-star/` etc.

**How to avoid:** Anchor ALL six patterns with a leading slash: `/north-star/`, `/goals/`,
`/daily/`, `/projects/`, `/council/`, `/archive/`. Apply this principle to any future vault-content
gitignore additions. Do NOT anchor `content-globs.txt` — it uses a different matching system and
anchoring would break the hook.

**Warning signs:** `git ls-files examples/` or `git ls-files skills/<name>/` returns empty when
you expect files. Files appear on disk but not in `git status --short`.

### Pitfall 2: profile.md Safety Net Gap

**What goes wrong:** The `/kairos-onboard` skill writes `$VAULT/profile.md` — personal data
including the user's name, timezone, priorities, and habit list. This file is not in `.gitignore`,
`hooks/content-globs.txt`, or documented anywhere in the safety infrastructure.

**Why it happens:** M002 added the skill without registering the new vault-content path in the
safety systems that Phase 1 established. New vault-content files require updates to three places.

**How to avoid:** Any time a skill creates a new vault file, the checklist is:
1. Add the filename to `.gitignore` (prevents accidental tracking)
2. Add the filename to `hooks/content-globs.txt` (prevents push even with `git add -f`)
3. Document the file in the vault layout (ARCHITECTURE.md or README)

### Pitfall 3: AGENTS.md Staleness

**What goes wrong:** AGENTS.md still shows the Phase 1 skill list (only `/kairos-help`). Any
user or agent reading it will not know the three Phase 2 skills exist. This breaks the "map, not
the territory" contract AGENTS.md is supposed to fulfil.

**Why it happens:** AGENTS.md was not updated in the M002 milestone — the milestone committed
the individual skill files but did not update the canonical index.

**How to avoid:** Every new skill must be registered in AGENTS.md's Skill Quick-Reference before
the phase is marked complete. This is a phase gate, not optional cleanup.

### Pitfall 4: Council Accessibility Ambiguity — setup.sh vs update.sh

**What goes wrong:** The success criterion says Council agents are "accessible from the vault
after setup.sh" — but `setup.sh` does NOT copy `agents/` to the vault at all. Only `update.sh`
does. After `setup.sh` alone, there are zero council agents anywhere in the vault.

**Why it matters:** The wording of success criterion 4 implies `setup.sh` provides access, but
the actual mechanism is `update.sh`. The planner must resolve:
- Is the criterion satisfied if `update.sh` is run after `setup.sh`? (The README would need to
  say this clearly; the test would need to cover the two-step flow.)
- Or must `setup.sh` itself provision the agents? (Requires updating setup.sh and its test to
  copy `agents/*.md` from the engine to the vault, plus deciding which directory: `vault/agents/`
  or `vault/council/`.)

**Root cause:** `templates/vault-dirs.txt` does not include an `agents/` directory, and setup.sh
creates directories from that list only. The allowlist (`templates/allowlist.txt`) does include
`agents/` for update.sh, but setup.sh doesn't run update.sh.

**How to avoid:** Planner must lock this as D-P2-02 before writing plans. The test in
`test/m002.test.sh` does not currently verify vault-side accessibility — it only verifies that
agent files exist in the engine. A vault-side check would need to test after `update.sh` runs.

### Pitfall 5: Skill Bloat — Already Built In (Preserved)

The existing `/kairos-north-star` skill has 7 questions with defaults. The existing `/kairos-onboard`
has 5 questions. Both finish in <5 minutes in normal use. Do not add more questions during
remediation — the pitfall of skill bloat is real (PITFALLS.md pitfall 2) and the existing
question counts are calibrated.

---

## DECISIONS NEEDED

The planner must lock these before writing plans:

| # | Decision | Options | Stakes |
|---|----------|---------|--------|
| D-P2-01 | How to fix the gitignore collision | A: Anchor ALL six vault-content patterns in `.gitignore` (`/daily/`, `/north-star/`, `/goals/`, `/projects/`, `/council/`, `/archive/`) — also recovers the two gitignored `examples/` directories; B: Rename the two blocking skill directories only — does NOT fix `examples/` collision | Option A is strongly preferred — fixes root cause for all six patterns; Option B is a partial fix |
| D-P2-02 | Council accessibility — setup.sh vs update.sh | A: "Accessible" means after BOTH setup.sh + update.sh — document the two-step flow, update the success criterion; B: Make setup.sh provision agents directly (copy from engine `agents/` to vault `agents/` or `council/`) | Affects scope of setup.sh changes and its test; clarifying the criterion may be sufficient |
| D-P2-03 | profile.md safety net | Add to `.gitignore` + `content-globs.txt` only (minimum correct fix), OR also document in vault layout docs | A file doesn't need to pre-exist in the vault; `.gitignore` + `content-globs.txt` is the required minimum |
| D-P2-04 | test/m002.test.sh scope | Keep as-is (18 checks pass = done) OR extend to include gitignore-structure checks | Existing checks are already correct; adding structural assertions on all six `.gitignore` patterns adds long-term robustness |

---

## RESEARCH COMPLETE

**Summary of key findings:**

1. **BLOCKING DEFECT (broader than expected):** `skills/north-star/SKILL.md` and `skills/goals/SKILL.md`
   are gitignored by unanchored `.gitignore` patterns. Additionally, `examples/daily/` and
   `examples/goals/` are also gitignored by the same defect — Phase 1 example files are not in
   the repo. ALL six vault-content gitignore patterns are unanchored; the fix must anchor all six.
   The `!*.example.md` line is a failed rescue that does nothing (git cannot un-exclude files
   whose parent directory is excluded).

2. **SAFETY GAP:** `profile.md` (written by `/kairos-onboard`) is missing from `.gitignore`,
   `hooks/content-globs.txt`, and `vault-dirs.txt` — it has no safety net.

3. **STALE INDEX:** AGENTS.md does not list the three Phase 2 skills and has no Council section —
   2 of 18 m002 checks currently fail.

4. **EXISTING ARTIFACTS ARE GOOD:** All four agent files and the onboarding skill are well-designed,
   follow established patterns, and pass their tests. No rewrite needed.

5. **2 plans recommended:** Plan 02-01 (fix gitignore, register profile.md) → Plan 02-02 (commit
   skills, update AGENTS.md, verify 18/18).

**Ready for planning.** The planner should treat this as defect remediation + integration work,
not greenfield authoring.
