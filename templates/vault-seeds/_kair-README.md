# Engine (KairOS)

Synced from the public KairOS engine by `/kair-update`. This folder is **not** your notes — it holds skills, hooks, styles, and templates the AI uses.

- `skills/` — canonical slash-command definitions
- `styles/` — voice and tone
- `hooks/`, `templates/`, `agents/` — engine infrastructure

Slash menus also mirror into `.cursor/skills/`, `.claude/skills/`, and `.cline/skills/` at the vault root (required by each editor).

Do not edit files here if you plan to promote changes back to the engine — copy one file at a time per [DEVELOPMENT.md](https://github.com/graysonstricker/KairOS/blob/main/docs/DEVELOPMENT.md).
