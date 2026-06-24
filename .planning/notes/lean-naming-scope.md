---
title: Lean naming and scope decisions
date: 2026-06-24
context: GSD explore session — scope cut, AIS-OS / obsidian-claude-pkm comparison
status: approved — implemented 2026-06-24
---

# Lean Naming & Scope — Proposed Renames

Decisions from explore session:
- **Two phases only** (Foundation → Daily proof); everything else in `EXPANSIONS.md`
- **Skills only** for v1 — no agent files, no crew/council in `AGENTS.md`
- **Defer** north star, psychology framing, goals cascade, sort, weekly, dashboard
- **Remove** Peterson / Future Authoring attributions; no AIS-OS trademark language
- **Morning reads inbox only** for v1

---

## 1. Skill commands

| Current | Proposed (lean) | Skill dir | AIS-OS | ballred | Recommendation |
|---------|-----------------|-----------|--------|---------|----------------|
| `/kairos-help` | **`/help`** | `skills/help/` | *(none — README)* | auto-discovery hook | **Keep skill** — explicit help is fine; drop prefix |
| `/kairos-onboard` | **`/onboard`** | `skills/onboard/` *(rename from `onboarding/`)* | `/onboard` | `/onboard` | **Align** with both references |
| `/kairos-capture` | **`/capture`** | `skills/capture/` *(new)* | *(none)* | via `Inbox/` + processor | **Ship Phase 2** |
| `/kairos-morning` | **`/daily`** | `skills/daily/` | Phase 2 | *(none)* | `/daily` ✓ |
| `/kairos-sort` | **`/sort`** | `skills/sort/` | *(none)* | inbox-processor agent | **EXPANSIONS** |
| `/kairos-weekly` | **`/weekly`** | `skills/weekly/` | *(none)* | `/weekly` | **EXPANSIONS** |
| `/kairos-evening` | **`/evening`** | `skills/evening/` | *(none)* | part of `/daily` | **EXPANSIONS** |
| `/kairos-monthly` | **`/monthly`** | `skills/monthly/` | *(none)* | `/monthly` | **EXPANSIONS** |
| `/kairos-dashboard` | **`/status`** | `skills/status/` | *(none)* | `/project status` | **EXPANSIONS** — avoid "dashboard" |
| `/kairos-north-star` | *(cut)* | — | — | — | **EXPANSIONS** as optional **Direction** skill later |
| `/kairos-goals` | **`/goals`** | `skills/goals/` | *(none)* | `/goal-tracking` | **EXPANSIONS** |
| `/kairos-cleanup` | **`/archive`** | `skills/archive/` | *(none)* | archive flow | **EXPANSIONS** |
| `/kairos-generate-style` | **`/style-new`** | `skills/style-new/` | *(none)* | output-styles | **EXPANSIONS** |
| `/kairos-set-style` | **`/style`** | `skills/style/` | *(none)* | `/output-style` | **EXPANSIONS** |

**Prefix rule:** Drop `/kairos-*` inside the vault. The repo name is already KairOS; commands match AIS-OS and ballred conventions.

**Optional alias:** Document `/daily` as an alias for `/morning` in EXPANSIONS if you later merge morning+evening like ballred.

---

## 2. Vault paths (minimal scaffold)

| Current (FOUND-05) | Proposed Phase 1 scaffold | Later (EXPANSIONS) | AIS-OS | ballred |
|--------------------|---------------------------|--------------------|--------|---------|
| `inbox/` | **`inbox/`** ✓ | — | — | `Inbox/` folder |
| `profile.md` | **`profile.md`** ✓ | — | `context/` | onboard → config |
| `daily/` | **`daily/`** ✓ | — | — | `Daily Notes/` |
| `north-star/` | *(omit)* | `direction/` or `goals/vision.md` | — | `Goals/0. Three Year Goals.md` |
| `goals/` (5 tiers) | *(omit)* | `goals/` flat or tiered | — | `Goals/1..3.*` |
| `projects/` | *(omit)* | `projects/` | — | `Projects/` |
| `council/` | *(omit)* | `.claude/agents/` if needed | — | `.claude/agents/` |
| `habits.md` | *(omit)* | `habits.md` | — | in daily flow |
| `archive/` | *(omit)* | `archive/` | `archives/` | `Archives/` |
| `desired.md`, `dreaded.md` | *(omit)* | cut or generic pair in EXPANSIONS | — | — |

**Safety globs:** Keep `desired.md` / `dreaded.md` in `hooks/content-globs.txt` even if features are cut — filename blocklist only.

---

## 3. Engine layout

| Current | Proposed | Notes |
|---------|----------|-------|
| `AGENTS.md` | **`AGENTS.md`** ✓ | Keep — backend-agnostic; strip crew/council sections for v1 |
| `.claude/CLAUDE.md` | **points to `AGENTS.md`** ✓ | Same as now |
| `agents/concierge.md` etc. | **delete or move to `docs/parked/agents/`** | Skills-only v1 |
| `agents/.gitkeep` | **keep empty `agents/`** | Room for future functional agents |
| `styles/default.md` | **keep** | Minimal default voice; no generator in v1 |
| `README.md` | **rewrite** | Describe 2-phase lean kit only |
| *(none)* | **`EXPANSIONS.md`** | Parked ideas — mirror AIS-OS |
| `kairos-engine/` (concept) | **`kairos-engine/`** or repo root | Naming OK — distinctive |

---

## 4. Agent / persona names → remove for v1

| Current name | Action | Future functional name (if ever) |
|--------------|--------|----------------------------------|
| Sorter | **Remove** from AGENTS.md | sort skill only |
| Steward | **Remove** | morning skill only |
| Scribe | **Remove** | weekly skill only |
| Keeper | **Remove** | archive skill only |
| Concierge | **Remove** | onboard skill only |
| Life Coach | **Delete file** | EXPANSIONS: optional advisor |
| Strategic Advisor | **Delete file** | EXPANSIONS |
| Accountability Partner | **Delete file** | EXPANSIONS |
| Architect / Undertow | **Cut** | — |
| Council | **Cut** | EXPANSIONS: "advisors" |

Future agents (ballred-style): `inbox-processor`, `weekly-reviewer`, `goal-aligner` — only if a skill benefits from a separate agent file.

---

## 5. Phase & planning doc renames

| Current | Proposed |
|---------|----------|
| Phase 1: Foundation | **Phase 1: Foundation** *(unchanged)* |
| Phase 2: Onboarding + North Star | **Phase 2: Daily proof** |
| Phase 3: Daily Rituals | **→ EXPANSIONS.md** |
| Phase 4: Weekly + Dashboard | **→ EXPANSIONS.md** |
| `02-onboarding-north-star/` | **`02-daily-proof/`** *(when replanned)* |
| ONBD-01..05 | Replace with **DAILY-01..03** lean reqs |
| FOUND-05 full scaffold | **FOUND-05-minimal** — inbox, profile, daily only |

---

## 6. AGENTS.md v1 (proposed structure)

```markdown
# KairOS

**Vault:** … · **Path:** ~/kairos · **Date:** … · **Backend:** …

## Skills

| Command | Description |
|---------|-------------|
| /help | List commands; explain engine vs vault |
| /onboard | First-run interview → profile.md |
| /capture | New file in inbox/ |
| /morning | Read inbox; set one focus; write daily note |

See EXPANSIONS.md for planned skills.

## Style

`styles/default.md` — plain, direct voice.
```

No crew table. No council. No psychology. No style-switching commands until EXPANSIONS.

---

## 7. README positioning (one paragraph)

**Ship:** Markdown vault + bash hooks + 4 commands (`/help`, `/onboard`, `/capture`, `/morning`). Engine/vault split for privacy.

**Do not ship in README:** Peterson, Future Authoring, crew/council, cadence table, psychology bibliography, 5-year goals.

---

## 8. Apply order (when approved)

1. Add `EXPANSIONS.md` with parked features
2. Rewrite `README.md`, `AGENTS.md`, `.planning/PROJECT.md`, `REQUIREMENTS.md`, `ROADMAP.md`
3. Rename `skills/onboarding/` → `skills/onboard/`; update triggers to unprefixed commands
4. Park/delete `agents/*.md` (keep `.gitkeep`)
5. Update `skills/help/SKILL.md` — remove crew/council explanation
6. Trim FOUND-05 in plans + setup.sh scaffold (when executing Phase 1)
7. Add `LICENSE` before public release
8. Archive or delete `02-onboarding-north-star/` plans; replan Phase 2 as daily proof

---

*Approve as-is, or note exceptions. No repo-wide renames until confirmed.*
