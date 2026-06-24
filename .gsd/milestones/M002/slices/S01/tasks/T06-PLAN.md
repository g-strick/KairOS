---
estimated_steps: 1
estimated_files: 2
skills_used: []
---

# T06: Updated AGENTS.md with crew roster, Council agents, and skill quick-reference; created verification script

Update AGENTS.md to reference the Concierge agent as the first-contact agent. Add a section that lists all available skills with brief descriptions. Then create a verification script at test/m002.test.sh that checks: (1) all 5 engine files exist and are non-empty, (2) skills have bash shebangs, (3) skills reference KAIROS_VAULT or ~/kairos for vault path, (4) Council agents exist. Run the verification script and confirm all checks pass.

## Inputs

- `agents/concierge.md`
- `skills/onboarding/SKILL.md`
- `skills/north-star/SKILL.md`
- `skills/goals/SKILL.md`
- `agents/life-coach.md`
- `agents/strategic-advisor.md`
- `agents/accountability-partner.md`

## Expected Output

- `AGENTS.md`
- `test/m002.test.sh`

## Verification

test -s test/m002.test.sh
