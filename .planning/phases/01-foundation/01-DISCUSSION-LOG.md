# Phase 1: Foundation - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-06-23
**Phase:** 1-Foundation
**Areas discussed:** setup.sh interaction model, Vault sync mechanism, AGENTS.md skeleton, Bash compatibility target

---

## setup.sh Interaction Model

| Option | Description | Selected |
|--------|-------------|----------|
| Argument only | Path required as arg; errors if missing. Zero prompts. | |
| Arg with interactive fallback | Prompts if no arg given; defaults on Enter. | |
| Always interactive | Always prompts for vault path and other setup info. | ✓ |

**User's choice:** Always interactive

---

| Option | Description | Selected |
|--------|-------------|----------|
| Vault path | "Where should your vault live?" with default | |
| Git remote URL | Optional remote for the private vault | |
| Your name / timezone | Profile info for templates | |
| Confirm before creating | Summary screen before touching filesystem | ✓ |

**User's choice:** Confirm before creating (minimal prompts — just vault path + confirm screen)
**Notes:** Name/timezone deferred to Phase 2 onboarding. Git remote deferred to Phase 2.

---

| Option | Description | Selected |
|--------|-------------|----------|
| Abort with clear message | Exit cleanly if vault exists | |
| Offer to overwrite or update | Ask: overwrite / run update.sh / cancel | ✓ |
| Silently skip existing files | Only create missing files | |

**User's choice:** Offer to overwrite or update

---

## Vault Sync Mechanism

| Option | Description | Selected |
|--------|-------------|----------|
| Symlinks | ~/kairos/skills → symlink to engine/skills. Instant updates. | |
| Copies via update.sh | update.sh copies allowlisted files. User can edit copies. | ✓ |
| Copies on setup, symlinks on update | Hybrid approach | |

**User's choice:** Copies (via update.sh)
**Notes:** User questioned symlinks — correctly identified that symlinks break for other users since engine path doesn't exist on their machine. Evolved to remote-first design.

---

| Option | Description | Selected |
|--------|-------------|----------|
| GitHub remote first | update.sh pulls from engine GitHub repo | ✓ |
| Local path only | update.sh copies from local engine dir | |
| Both — local if exists, remote as fallback | Hybrid | |

**User's choice:** GitHub remote first
**Notes:** User's future vision: "update skill linked to my github" so other users can get updates.

---

| Option | Description | Selected |
|--------|-------------|----------|
| Overwrite with engine version (strict) | Engine always wins | ✓ |
| Skip modified files | Preserve local edits | |
| Backup then overwrite | Copy to *.bak before overwriting | |

**User's choice:** Strict overwrite

---

## AGENTS.md Skeleton

| Option | Description | Selected |
|--------|-------------|----------|
| Project identity block | Name, vault path, current date, backend note | ✓ |
| Crew roster with one-liners | List of active Crew agents and their roles | ✓ |
| Active style pointer | Points to styles/default.md | ✓ |
| Skill invocation quick reference | List of /kairos-* commands | ✓ |

**User's choice:** All four sections
**Notes:** User also requested a `/kairos-help` skill for confused users — added as D-11.

---

| Option | Description | Selected |
|--------|-------------|----------|
| .claude/CLAUDE.md (Claude Code standard) | Auto-read by Claude Code | |
| AGENTS.md in vault root (backend-agnostic) | Works with all runtimes | ✓ |
| Both — AGENTS.md canonical, .claude/CLAUDE.md points to it | Hybrid | |

**User's choice:** AGENTS.md in vault root (backend-agnostic)
**Notes:** setup.sh will also create .claude/CLAUDE.md for Claude Code auto-detection.

---

## Bash Compatibility Target

| Option | Description | Selected |
|--------|-------------|----------|
| macOS system bash 3.2 | Zero install. Restricts syntax. | |
| Homebrew bash 5.x | Modern syntax; one-time install. | ✓ |
| POSIX sh only | Most portable; most limiting. | |

**User's choice:** Homebrew bash 5.x

---

| Option | Description | Selected |
|--------|-------------|----------|
| macOS only for now | Linux deferred to v2 | |
| POSIX-safe from the start | Avoid all platform differences | |
| Detect and branch (uname) | OS-specific paths where needed | |

**User's choice:** "this should work on apple primarily and linux as well"
**Notes:** Interpreted as uname-detection approach — macOS primary, Linux supported via branching where needed.

---

## Claude's Discretion

- `examples/` directory content — what skeleton examples best demonstrate the system
- Exact allowlist for `update.sh`

## Deferred Ideas

- Vault git remote setup → Phase 2 (Concierge handles during onboarding)
- Linux-primary support and documentation → v2 concern
