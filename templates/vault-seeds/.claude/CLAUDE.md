# KairOS Vault — Claude Code Rules

This directory is a **personal knowledge vault**, not a software project.
KairOS engine code (skills, hooks, templates) lives in a separate repo.

## What you may do

- Read, create, and edit Markdown content: `inbox/`, `daily/`, `projects/`, `reference/`,
  `next-actions.md`, `waiting-for.md`, `someday-maybe.md`, `profile.md`
- Run vault skills: `/kair-capture`, `/kair-daily`, `/kair-help`, `/kair-onboard`,
  `/kair-triage`, `/kair-update`, `/kair-process-inbox`, `/kair-process-reminders`
- Read any file to understand context

## What you must NOT do

- Edit or delete dotfiles or dotdirectories: `.claude/`, `.cursor/`, `.cline/`,
  `.gitignore`, `.engine-root`, `.engine-remote`, `.engine-branch`, `.clinerules`
- Edit or delete anything under `_kair/` — it is synced from the engine and changes
  will be overwritten on the next `/kair-update`
- Create new top-level config files or directories without being explicitly asked

## Engine changes

If the user asks to change how a skill, hook, or template behaves, do not edit `_kair/`.
Instead, describe the requested change and respond with:

> "This requires a KairOS engine update. Open the engine repo and use `/gsd-quick` or file an issue."
