---
estimated_steps: 1
estimated_files: 2
skills_used: []
---

# T01: Created Concierge agent definition with role, operating principles, skill inventory, and invocation triggers

Create the Concierge agent definition as a Markdown file in agents/. This agent is the first-contact agent that runs onboarding and periodic re-calibration. The definition should include: role description, operating principles (semi-structured interview with smart defaults, free-form answers allowed, vault-aware), and a list of skills it can invoke (/kairos-onboard, /kairos-north-star, /kairos-goals, /kairos-capture, /kairos-sort, /kairos-morning, /kairos-weekly). The agent should be designed to work under both Claude Code and local Ollama/Pi runners — use generic agent instructions, not Claude Code-specific syntax.

## Inputs

- `AGENTS.md`

## Expected Output

- `agents/concierge.md`

## Verification

test -s agents/concierge.md
