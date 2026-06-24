# KairOS

**Vault:** KairOS · **Path:** `~/kairos` (injected at runtime by the session-start hook) · **Date:** `{{CURRENT_DATE}}` · **Backend:** backend-agnostic — works under Claude Code, Codex, Gemini, Ollama, or any local LLM runner that supports Markdown context files.

---

## Crew

| Agent | Role |
|-------|------|
| **Sorter** | Triages the inbox — routes captured items to the right project, daily note, or habits file. |
| **Steward** | Runs the daily rhythm — morning focus (goals + calendar + reminders) and evening reflection (what happened, what changed). |
| **Scribe** | Writes weekly and monthly reviews — synthesises past days into structured reflections and progress reports. |
| **Keeper** | Maintains vault hygiene — archives finished work, keeps goals and projects tidy. |
| **Concierge** | First-contact and onboarding — guides new users through setup, goal-setting, and periodic recalibration. |

---

## Active Style

`styles/default.md`

The style system is built in a later phase. For now, all output uses the default voice defined in that file. Set a different style with `/kairos-set-style` (Phase 4+).

---

## Skill Quick-Reference

| Command | Description |
|---------|-------------|
| `/kairos-help` | Lists available commands and explains the engine-vs-vault and crew-vs-council model. |

> More `/kairos-*` commands arrive in later phases: capture, sort, morning, evening, weekly, monthly, cleanup, onboarding, and more.

---

*Canonical context root — every agent and skill reads this file first. Domain knowledge loads on demand; this file is a map, not the territory.*