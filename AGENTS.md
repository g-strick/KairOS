# KairOS

**Vault:** KairOS · **Path:** `~/kairos` (injected at runtime by the session-start hook) · **Date:** `{{CURRENT_DATE}}` · **Backend:** backend-agnostic — works under Claude Code, Codex, Gemini, Ollama, or any local LLM runner that supports Markdown context files.

---

## Skills

| Command | Description |
|---------|-------------|
| `/help` | Lists available commands and explains the engine-vs-vault model |
| `/onboard` | First-run interview → `profile.md` |
| `/capture` | Append anything to `inbox.md` — no categorization |
| `/daily` | Read inbox, set one focus, write today's note in `daily/` |

Planned skills (not shipped yet) are listed in `docs/EXPANSIONS.md` in the engine repo.

---

## Style

`styles/default.md` — plain, direct voice. No style switching in the lean kit.

---

*Canonical context root — every skill reads this file first. Domain knowledge loads on demand; this file is a map, not the territory.*
