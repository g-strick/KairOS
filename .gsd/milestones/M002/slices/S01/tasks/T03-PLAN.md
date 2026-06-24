---
estimated_steps: 1
estimated_files: 1
skills_used: []
---

# T03: Created /kairos-north-star skill with desired/dreaded interview based on Future Authoring

Create the /kairos-north-star skill as a Markdown file in skills/north-star/. The skill implements a guided interview based on Future Authoring / WOOP methodology. It should: (1) read vault path from KAIROS_VAULT or default to ~/kairos, (2) guide the user through writing desired.md — prompts for: what's working well, what they want more of, what their ideal life looks like in key domains (work, relationships, health, growth), (3) guide the user through writing dreaded.md — prompts for: what habits to avoid, what outcomes to prevent, what the worst-case future looks like if current patterns continue, (4) write both files to north-star/ directory, (5) surface a brief summary of what was written. Use read -r with prompts. The skill should work under any agent platform.

## Inputs

- None specified.

## Expected Output

- `skills/north-star/SKILL.md`

## Verification

test -s skills/north-star/SKILL.md
