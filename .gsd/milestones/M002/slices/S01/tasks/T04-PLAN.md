---
estimated_steps: 1
estimated_files: 1
skills_used: []
---

# T04: Created /kairos-goals skill with scaffolded goal hierarchy across 5 time horizons

Create the /kairos-goals skill as a Markdown file in skills/goals/. The skill scaffolds a goal hierarchy by: (1) reading vault path from KAIROS_VAULT or default to ~/kairos, (2) prompting the user for their 5-year goals (write to goals/5year/), (3) prompting for yearly goals (write to goals/yearly/), (4) prompting for monthly goals (write to goals/monthly/), (5) prompting for weekly goals (write to goals/weekly/), (6) creating a brief index file that links the horizons together. Each prompt should allow free-form input. If files already exist, append rather than overwrite. Use read -r with clear prompts.

## Inputs

- None specified.

## Expected Output

- `skills/goals/SKILL.md`

## Verification

test -s skills/goals/SKILL.md
