---
estimated_steps: 1
estimated_files: 1
skills_used: []
---

# T02: Created /kairos-onboard skill with semi-structured interview for profile, priorities, and habits

Create the /kairos-onboard skill as a Markdown file in skills/onboarding/. The skill implements a semi-structured interview that collects: (1) user's name, (2) timezone, (3) key priorities (3-5 items), (4) habits to track (list of habit names). It must: read vault path from an environment variable (KAIROS_VAULT) or default to ~/kairos, confirm the vault exists (error if not), write a profile.json (or profile.md) with collected data, and confirm vault readiness by checking that key directories exist. Use read -r for input with clear prompts and smart defaults. The skill should be self-contained and work under any agent platform.

## Inputs

- None specified.

## Expected Output

- `skills/onboarding/SKILL.md`

## Verification

test -s skills/onboarding/SKILL.md
