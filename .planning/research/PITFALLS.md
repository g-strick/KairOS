# Pitfalls Research

**Domain:** Markdown-native PKM / personal OS built with Claude Code agents
**Researched:** 2026-06-23
**Confidence:** HIGH

## Critical Pitfalls

---

### 1. PKM Abandonment Loop

**The pitfall:** Users build an elaborate system, use it enthusiastically for 2-4 weeks, then quietly stop. The system becomes a monument to past good intentions.

**Warning signs:**
- Inbox grows but never gets processed
- Daily notes stop after week 3
- Goal files haven't been touched in a month
- System requires "catching up" before you can use it normally

**Root cause:** The system was designed for an idealized version of the user's life. Real life has bad weeks, travel, illness, overwhelm. A system that breaks if you miss a day will eventually break.

**Prevention strategy:**
- Make missing a day recoverable in <2 minutes (the morning skill should handle "I missed yesterday" gracefully)
- Weekly review auto-offers at "next login" if Sunday was missed — no guilt mechanic
- Inbox is always append-only — you can always capture even if you can't process
- Phase: **Onboarding** (design the recovery paths before building the primary paths)

---

### 2. Skill Bloat and Prompt Rot

**The pitfall:** Skills start focused, then get feature-creep additions. After 6 months, the morning skill is 300 lines and asks 15 questions. Nobody runs it anymore.

**Warning signs:**
- Skills take >5 minutes of user interaction
- Skills have optional sections that are "usually skipped"
- SKILL.md files have grown to multiple screens
- User starts appending `--skip` flags mentally

**Root cause:** It's tempting to add "just one more question" to a skill. Each addition feels small; the cumulative effect is an unusable ritual.

**Prevention strategy:**
- Each skill should have a stated time budget (morning: 3-5 min, weekly: 15-20 min)
- Skills must be testable against their time budget before shipping
- Any new question must replace an existing one, not append
- Design with "minimum viable ritual" — what is the fewest questions that produce the most value?
- Phase: **All phases** — enforce time budgets as a success criterion

---

### 3. Context Overload in Agent Files

**The pitfall:** AGENTS.md / CLAUDE.md grows to 2000+ lines trying to encode every rule. The agent's effective context is diluted. Skills stop working correctly.

**Warning signs:**
- AGENTS.md has more than ~500 lines
- Agents "forget" rules that are in the file
- Skill behavior is inconsistent across sessions
- Agent needs to be reminded of things stated in AGENTS.md

**Root cause:** LLMs have attention limits; extremely long context files result in important rules being deprioritized or missed. Token budget matters.

**Prevention strategy:**
- AGENTS.md should be a pointer file, not an encyclopedia. Keep it under 400 lines.
- Move domain knowledge (goal structure, north star explanation) to dedicated files that agents READ when relevant, not files that are always loaded
- Use `<files_to_read>` in skill prompts to load specific context on demand
- Phase: **Foundation (Phase 1)** — establish the right AGENTS.md architecture before it can grow

---

### 4. Engine/Vault Boundary Collapse

**The pitfall:** The developer (you) gradually starts working on the tool from inside the vault, committing private data to the public engine by accident, or personal customizations drift into the engine making it non-generic.

**Warning signs:**
- You're editing skill files from `~/kairos/` directory and pushing from there
- The engine `examples/` directory contains real dates or real goal names
- `.gitignore` in the engine is getting longer (denylist creep)
- `update.sh` hasn't been run in months — vault is out of sync

**Root cause:** Two repos in similar directories, both with SKILL.md files — easy to lose track of which working tree you're in.

**Prevention strategy:**
- Name the directories distinctly (`kairos-engine/` vs `kairos/`) — immediately obvious from terminal prompt
- Add the pre-push hook to the engine before the first real commit
- The `update.sh` allowlist is the primary safety mechanism — review it whenever you add a new engine file
- Make `setup.sh` test its own output against an allowlist before completing
- Phase: **Foundation (Phase 1)** — safety hooks before any content is committed

---

### 5. AppleScript Permission and Reliability Issues

**The pitfall:** AppleScript Calendar/Reminders integration works during development, then breaks for users (or after an OS update) because of TCC (Transparency, Consent, Control) permission requirements.

**Warning signs:**
- Scripts work in Script Editor but fail from `osascript` in terminal
- "Permission denied" or empty results with no error
- Scripts fail after macOS update
- Works in login shell but not in non-interactive shell (hooks)

**Root cause:** macOS requires explicit user permission for each application that accesses Calendar and Reminders. This permission is granted per-bundle-identifier — Terminal gets its own permission, cron gets none, and hooks may run in contexts without permission.

**Prevention strategy:**
- First run: instruct user to run the AppleScript bridge from Terminal manually so TCC grants Terminal the permission
- Wrap all osascript calls in error handlers that return helpful messages ("Please grant Terminal access to Calendar in System Settings > Privacy & Security")
- Test bridge scripts on macOS 13+ and document that they won't work on macOS 12 and below (JXA API differences)
- Design the morning skill to degrade gracefully when bridge returns empty (don't crash if Calendar access isn't granted yet)
- Phase: **Integration bridge phase** — add TCC onboarding step before any bridge code

---

### 6. The Undertow Becomes a Self-Criticism Engine

**The pitfall:** The Undertow voice, designed to point at the trajectory and consequence (not the person), drifts toward character judgments through prompt drift or style-file edits. The user starts dreading the morning check-in.

**Warning signs:**
- User skips the morning skill on "bad days" specifically
- User reports feeling worse after using the system
- Undertow messages use "you are" or "you always" instead of "this choice leads to"
- No distinction in output between a one-off skip and a pattern

**Root cause:** The distinction between "trajectory" and "character" is subtle and requires explicit prompting. Without guardrails, LLMs default to evaluative language. The Regulatory Focus Theory grounding must be explicitly reinforced.

**Prevention strategy:**
- The Steward agent definition must include explicit rules: Undertow speaks only about the road and the consequence, never about the person's character or worth
- Include a "Undertow check" in the weekly review: "Did any feedback feel like a character judgment? Flag it."
- Style generator interview must include: "What should the Undertow NEVER say?" as a required question
- Test with examples: "Skipping the gym today" → acceptable: "That path leads away from the body you described." → unacceptable: "You're being lazy."
- Phase: **Onboarding / Steward agent** — bake in the guardrail from the start

---

### 7. Goal Hierarchy Orphaning

**The pitfall:** User sets up 5-year → yearly → monthly → weekly goal chain during onboarding, then weekly goals stop linking to monthly goals, monthly goals stop being updated. The hierarchy becomes a fiction.

**Warning signs:**
- Weekly goals mention projects not in the monthly goal
- Monthly goals have no connection to the yearly aim
- North star files haven't been read in a monthly review in 3 months

**Root cause:** The links between horizons require active maintenance. If reviews don't explicitly surface the parent horizon, the chain breaks silently.

**Prevention strategy:**
- Weekly review (Scribe) must read and display the current monthly goal before asking about next week
- Monthly reset must read and display the yearly aim before asking about next month
- Yearly review must display desired.md before asking about the year
- The Steward should catch "this weekly focus has no clear link to your monthly goal" and flag it
- Phase: **Scribe agent / weekly skill** — enforce the chain in the review skill structure

---

### 8. Bash Compatibility (macOS vs Linux)

**The pitfall:** Scripts use GNU coreutils (gdate, GNU awk, etc.) that work on developer's Homebrew-equipped Mac but fail on fresh macOS installs or in CI.

**Warning signs:**
- `date -d` works in dev but breaks on another machine
- Script behavior differs between macOS and Linux
- `bash --version` shows 3.x (macOS system bash) which lacks modern features

**Root cause:** macOS ships Bash 3.2 (GPLv2; Apple won't upgrade to GPLv3) and BSD coreutils. Scripts that use Bash 4+ features or GNU date will fail silently or with confusing errors.

**Prevention strategy:**
- All scripts should be tested against macOS system bash (3.2) OR explicitly require Homebrew bash and document the requirement
- Avoid `date -d` (GNU-only) — use Python one-liners or pure arithmetic for date math
- Run `shellcheck` on all hook scripts before shipping
- Add `#!/usr/bin/env bash` and test with `bash --version` check at script top
- Phase: **Foundation hooks** — enforce portability before any hooks go to users

---

## Summary Table

| Pitfall | Severity | Phase to Address |
|---------|----------|-----------------|
| PKM abandonment loop | Critical | Onboarding + all ritual skills |
| Skill bloat / prompt rot | High | All phases — ongoing |
| Context overload in AGENTS.md | High | Foundation (Phase 1) |
| Engine/vault boundary collapse | High | Foundation (Phase 1) |
| AppleScript TCC permissions | Medium | Integration phase |
| Undertow self-criticism drift | High | Steward agent + style system |
| Goal hierarchy orphaning | Medium | Scribe + review skills |
| Bash compatibility | Medium | Foundation hooks |
