# S01: Onboarding, North Star, and Council Agents

**Goal:** Deliver all Phase 2 capabilities: Concierge agent, onboarding skill, north-star skill, goals skill, and Council agent definitions.
**Demo:** User can run /kairos-onboard, /kairos-north-star, and /kairos-goals in a test vault and produce the expected files

## Must-Haves

- All 5 engine files exist and are non-empty; AGENTS.md references Concierge; skills resolve vault path correctly; skills produce expected output files in a test vault

## Proof Level

- This slice proves: contract

## Integration Closure

Skills consume vault-dirs.txt directory structure from M001; AGENTS.md consumes Concierge agent definition; Council agents are consumed by onboarding skill for roster derivation

## Verification

- None — skills are interactive, no runtime signals

## Tasks

- [x] **T01: Created Concierge agent definition with role, operating principles, skill inventory, and invocation triggers** `est:30m`
  Create the Concierge agent definition as a Markdown file in agents/. This agent is the first-contact agent that runs onboarding and periodic re-calibration. The definition should include: role description, operating principles (semi-structured interview with smart defaults, free-form answers allowed, vault-aware), and a list of skills it can invoke (/kairos-onboard, /kairos-north-star, /kairos-goals, /kairos-capture, /kairos-sort, /kairos-morning, /kairos-weekly). The agent should be designed to work under both Claude Code and local Ollama/Pi runners — use generic agent instructions, not Claude Code-specific syntax.
  - Files: `agents/concierge.md`, `AGENTS.md`
  - Verify: test -s agents/concierge.md

- [x] **T02: Created /kairos-onboard skill with semi-structured interview for profile, priorities, and habits** `est:45m`
  Create the /kairos-onboard skill as a Markdown file in skills/onboarding/. The skill implements a semi-structured interview that collects: (1) user's name, (2) timezone, (3) key priorities (3-5 items), (4) habits to track (list of habit names). It must: read vault path from an environment variable (KAIROS_VAULT) or default to ~/kairos, confirm the vault exists (error if not), write a profile.json (or profile.md) with collected data, and confirm vault readiness by checking that key directories exist. Use read -r for input with clear prompts and smart defaults. The skill should be self-contained and work under any agent platform.
  - Files: `skills/onboarding/SKILL.md`
  - Verify: test -s skills/onboarding/SKILL.md

- [x] **T03: Created /kairos-north-star skill with desired/dreaded interview based on Future Authoring** `est:45m`
  Create the /kairos-north-star skill as a Markdown file in skills/north-star/. The skill implements a guided interview based on Future Authoring / WOOP methodology. It should: (1) read vault path from KAIROS_VAULT or default to ~/kairos, (2) guide the user through writing desired.md — prompts for: what's working well, what they want more of, what their ideal life looks like in key domains (work, relationships, health, growth), (3) guide the user through writing dreaded.md — prompts for: what habits to avoid, what outcomes to prevent, what the worst-case future looks like if current patterns continue, (4) write both files to north-star/ directory, (5) surface a brief summary of what was written. Use read -r with prompts. The skill should work under any agent platform.
  - Files: `skills/north-star/SKILL.md`
  - Verify: test -s skills/north-star/SKILL.md

- [x] **T04: Created /kairos-goals skill with scaffolded goal hierarchy across 5 time horizons** `est:45m`
  Create the /kairos-goals skill as a Markdown file in skills/goals/. The skill scaffolds a goal hierarchy by: (1) reading vault path from KAIROS_VAULT or default to ~/kairos, (2) prompting the user for their 5-year goals (write to goals/5year/), (3) prompting for yearly goals (write to goals/yearly/), (4) prompting for monthly goals (write to goals/monthly/), (5) prompting for weekly goals (write to goals/weekly/), (6) creating a brief index file that links the horizons together. Each prompt should allow free-form input. If files already exist, append rather than overwrite. Use read -r with clear prompts.
  - Files: `skills/goals/SKILL.md`
  - Verify: test -s skills/goals/SKILL.md

- [x] **T05: Created 3 standard Council agent definitions: Life Coach, Strategic Advisor, Accountability Partner** `est:30m`
  Create three standard Council agent definitions in agents/: (1) life-coach.md — focused on goal achievement, habit formation, motivation; (2) strategic-advisor.md — focused on big-picture thinking, decision-making, trade-off analysis; (3) accountability-partner.md — focused on follow-through, commitment tracking, gentle pressure. Each agent should have: role description, operating principles, and a list of when to invoke them. These agents are summoned on demand during onboarding or later sessions. They must work under any agent platform.
  - Files: `agents/life-coach.md`, `agents/strategic-advisor.md`, `agents/accountability-partner.md`
  - Verify: test -s agents/life-coach.md

- [x] **T06: Updated AGENTS.md with crew roster, Council agents, and skill quick-reference; created verification script** `est:30m`
  Update AGENTS.md to reference the Concierge agent as the first-contact agent. Add a section that lists all available skills with brief descriptions. Then create a verification script at test/m002.test.sh that checks: (1) all 5 engine files exist and are non-empty, (2) skills have bash shebangs, (3) skills reference KAIROS_VAULT or ~/kairos for vault path, (4) Council agents exist. Run the verification script and confirm all checks pass.
  - Files: `AGENTS.md`, `test/m002.test.sh`
  - Verify: test -s test/m002.test.sh

## Files Likely Touched

- agents/concierge.md
- AGENTS.md
- skills/onboarding/SKILL.md
- skills/north-star/SKILL.md
- skills/goals/SKILL.md
- agents/life-coach.md
- agents/strategic-advisor.md
- agents/accountability-partner.md
- test/m002.test.sh
