# Project Research Summary

**Project:** KairOS
**Domain:** Markdown-native personal OS / Claude Code agent system
**Synthesized:** 2026-06-23

## Key Findings

### Stack
- **Core primitives:** Claude Code skills (.md), agent definitions (.md), bash hooks, plain Markdown + YAML frontmatter, git. No runtime dependencies (no Python, no Node.js, no database).
- **AppleScript bridge:** `osascript` is the right tool for reading Apple Calendar and Reminders. Requires TCC permission grant from Terminal on first run. Needs graceful degradation if permission not yet granted.
- **Bash portability:** macOS ships Bash 3.2; scripts must be compatible or require Homebrew bash explicitly. Avoid GNU-only date flags.
- **Skill structure:** `skills/[name]/SKILL.md` per skill, invoked as `/kairos-[name]`. AGENTS.md is the context root — must stay under ~400 lines.
- **Vault sync:** Symlinks preferred for skills/agents/hooks (instant update); allowlist copy for templates.

### Features
- **Table stakes (must have or users abandon the system):**
  - Zero-friction capture (one command, no categorization required)
  - Daily check-in ritual with recovery path for missed days
  - Weekly review (Scribe) — the highest-leverage habit in any PKM
  - Consistent, predictable file structure
  - Goal visibility at the right horizon during each cadence
- **Differentiators (what makes KairOS genuinely different):**
  - North star model grounded in Future Authoring (desired.md + dreaded.md)
  - Dual motivational voice (Architect = approach/promotion; Undertow = avoidance/prevention)
  - Crew-of-agents model with discrete occupational roles
  - Council derived from user's actual projects (not a static advisor roster)
  - Psychology-grounded design (RFT, WOOP, Goal-Setting Theory, SDT, Implementation Intentions)
- **Anti-features (traps to avoid):**
  - Complex tagging / taxonomy → tag maintenance becomes a second job
  - Multiple dashboards → passive screens don't drive behavior
  - Feature parity with Notion/Obsidian → KairOS does one thing: rituals

### Architecture
- **Two-repo model:** `kairos-engine/` (public tool) + `~/kairos/` (private vault). Structurally separate working trees — not gitignore-based. Private data is physically absent from the engine.
- **Build order:** Foundation (directories + AGENTS.md + setup.sh + capture) → Onboarding (Concierge + north star) → Daily rituals (Sorter + Steward) → Weekly/Monthly (Scribe + Keeper) → Integrations (AppleScript bridge) → Polish (style generator + Council)
- **Data flow:** capture → inbox.md → Sorter → project/goal files → Steward reads during morning → Scribe reads during weekly review
- **Hook system:** Session-start hook surfaces today's agenda; session-end hook auto-commits. Both are bash scripts, not schedulers.

### Pitfalls
- **Highest risk:** PKM abandonment loop (missed days feel catastrophic → user stops). Build recovery paths before primary paths.
- **Agent-specific:** AGENTS.md bloat → agent attention dilution. Keep under 400 lines; load domain context on demand.
- **The Undertow problem:** Without explicit guardrails, the prevention voice drifts toward character judgments. Must bake in "trajectory not character" constraint at the agent definition level.
- **AppleScript:** TCC permissions are a first-run obstacle; design graceful degradation before shipping the bridge.
- **Engine/vault safety:** Pre-push hook on engine + allowlist sync (never denylist) are the structural safeguards. Install them before any content commits.

## Implications for Roadmap

### Phase ordering implications
1. **Foundation first, always.** The engine directory structure, AGENTS.md, and setup.sh must exist before anything else is testable. Engine/vault safety hooks go in Phase 1.
2. **Onboarding before daily rituals.** The north star (desired.md, dreaded.md) and goal hierarchy are prerequisites for the Steward agent to have anything meaningful to read.
3. **Capture before sort.** inbox.md + `/kairos-capture` is a 15-minute build and makes the system immediately useful even with nothing else done.
4. **Daily before weekly/monthly.** Get the daily ritual working and stick-tested before building the higher cadences.
5. **Integrations last.** AppleScript bridge enhances the morning skill but isn't required for the ritual itself to work.

### Coarse granularity (3-5 phases) suggested breakdown
- **Phase 1:** Foundation — engine structure, AGENTS.md, setup.sh, capture, vault scaffold, safety hooks
- **Phase 2:** Onboarding + north star — Concierge agent, desired/dreaded interview, goal hierarchy initialization, Council scaffolding
- **Phase 3:** Daily rituals — Sorter, Steward morning + evening, session-start hook, habits tracking
- **Phase 4:** Weekly/monthly cadences — Scribe (weekly review), monthly reset, Keeper cleanup, auto-commit hook
- **Phase 5:** Integrations + polish — AppleScript bridge, voice/style system, style generator, update.sh, pre-push safety

### Risk notes
- Schedule the Undertow guardrail review as a success criterion in Phase 3 (Steward agent)
- Add TCC permission onboarding step as a requirement in Phase 5 (bridge)
- Enforce skill time budgets (morning ≤5 min, weekly ≤20 min) as success criteria in Phases 3 and 4

## Sources

- Claude Code documentation: skills, agents, hooks, CLAUDE.md conventions
- macOS AppleScript Reference: Calendar and Reminders scripting dictionaries
- Regulatory Focus Theory (Higgins, 1997)
- Future Authoring / WOOP (Oettingen, 2012; Morisano et al., 2010)
- Goal-Setting Theory (Locke & Latham, 2002)
- Self-Determination Theory (Deci & Ryan)
- Implementation Intentions (Gollwitzer, 1999)
- Habit research (Fogg; Wood & Neal, 2007; Clear, 2018)
- GTD (Allen) and PARA (Forte) — adapted patterns
