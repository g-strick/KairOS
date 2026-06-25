---
name: kair-process-reminders
description: Deprecated — use /kair-triage. Redirects Reminders Inbox processing to the unified triage skill.
disable-model-invocation: true
---

# /kair-process-reminders — Deprecated

**Use `/kair-triage` instead.** This command is kept so old habits and docs still resolve.

## Agent Instructions

Run the full `/kair-triage` workflow from `skills/kair-triage/SKILL.md`. The unified skill processes **Reminders Inbox first**, then vault `inbox/`. Do not use the legacy step-by-step Q&A flow.
