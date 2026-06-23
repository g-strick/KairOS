# Phase 1: Foundation - Context

**Gathered:** 2026-06-23
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 1 delivers the engine scaffolding and vault setup infrastructure so that any user — including strangers — can clone `kairos-engine`, run `setup.sh`, and have a structurally safe, ready-to-use private vault. It also ships `update.sh` for pulling future engine updates and safety hooks that prevent private vault content from leaking into the public engine repo.

**In scope:** Engine directory structure, AGENTS.md skeleton, setup.sh (interactive first-run), update.sh (allowlist sync from GitHub remote), pre-push safety hook on engine repo, vault directory scaffold, `/kairos-help` skill.

**Out of scope:** Any agent definitions beyond AGENTS.md skeleton, any skills beyond `/kairos-help`, onboarding interview (Phase 2), north-star files (Phase 2), daily rituals (Phase 3).

</domain>

<decisions>
## Implementation Decisions

### setup.sh — Interaction Model
- **D-01:** `setup.sh` is always interactive — it never requires a path argument; it prompts the user.
- **D-02:** Minimum prompts: vault path (default: `~/kairos`) and a summary-then-confirm before any filesystem changes. Name/timezone and git remote are NOT collected here — deferred to onboarding (Phase 2).
- **D-03:** If the vault directory already exists: offer three options — Overwrite (dangerous, warn clearly), Run `update.sh` instead, Cancel. Never silently skip or proceed.

### update.sh — Vault Sync Mechanism
- **D-04:** No symlinks. Engine content is copied into the vault by `update.sh`. This allows strangers to use KairOS without a local engine clone.
- **D-05:** `update.sh` pulls from the engine's **GitHub remote** as the primary source (not a local path). The GitHub repo URL is configured once (stored in vault as a config value, e.g., `~/.kairos/.engine-remote`). Future: other users run `update.sh` to get skill updates from the public repo.
- **D-06:** Engine version always wins on update — **strict overwrite**. User edits to skills/agents/hooks in the vault will be wiped on `update.sh`. This is the documented trade-off. Users who want to customize skills must fork the engine and point `update.sh` at their fork.
- **D-07:** Allowlist-based sync: `update.sh` copies an explicit list of safe paths (skills/, agents/, hooks/, styles/, templates/, AGENTS.md). Adding a new engine file doesn't propagate to vaults until it's on the allowlist. Worst-case failure: "forgot to publish a feature" (annoying). Never: "accidentally published a journal entry" (catastrophic).

### AGENTS.md — Structure and Location
- **D-08:** Canonical file is `AGENTS.md` in the **vault root** (backend-agnostic; works with Claude Code, Codex, Gemini, Ollama). setup.sh also creates `.claude/CLAUDE.md` that reads or includes it for Claude Code auto-detection.
- **D-09:** Phase 1 AGENTS.md skeleton includes these sections:
  1. **Project identity block** — vault name, vault path, current date (injected by session-start hook), backend note
  2. **Crew roster** — one-liner per agent (Sorter, Steward, Scribe, Keeper, Concierge) with their role
  3. **Active style pointer** — `styles/default.md` (even though the style system isn't fully built until later phases, the pointer belongs here so skills know where to look)
  4. **Skill quick reference** — list of available `/kairos-*` commands with one-line descriptions
- **D-10:** AGENTS.md must stay under 400 lines. Domain context (north-star, goal structure) is NOT loaded into AGENTS.md — agents load it on demand via `<files_to_read>` in skill prompts.
- **D-11:** `/kairos-help` skill ships in Phase 1. It surfaces available commands, explains the system for a confused or new user, and points to the README.

### Bash Compatibility Target
- **D-12:** Scripts target **Homebrew bash 5.x** (`#!/usr/bin/env bash`). setup.sh checks for bash 5.x on first run and directs the user to install it (`brew install bash`) if missing. macOS system bash 3.2 is not supported.
- **D-13:** Scripts must run on **both macOS and Linux** (macOS is primary). Use `uname` detection where OS-specific behavior is needed (e.g., date formatting: `gdate` on macOS Homebrew vs `date` on Linux). Avoid GNU-only flags that don't exist on BSD, and avoid BSD-only flags that don't exist on GNU. When in doubt, use pure arithmetic or Python one-liners for date math (even though no Python runtime is required — one-liners are acceptable as a fallback for date operations that differ across platforms).
- **D-14:** `shellcheck` passes on all hook and script files before they ship.

### Claude's Discretion
- Engine `examples/` directory content — what skeleton content best demonstrates the system without containing real data. Claude should create minimal, instructive examples (e.g., `examples/daily/2025-01-01.md.example`, `examples/goals/weekly/example.md`) that show format without being mistaken for real content.
- Exact allowlist contents for `update.sh` — Claude determines which paths are safe to sync based on the engine directory structure.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project context
- `.planning/PROJECT.md` — full project definition, constraints (Bash+Markdown only, engine/vault separation, backend-agnostic)
- `.planning/REQUIREMENTS.md` — FOUND-01 through FOUND-05 (the five Foundation requirements)
- `README.md` — detailed design document; engine/vault model, setup flow, intended repository structure
- `DEVELOPMENT.md` — engine/vault separation rules; the one rule ("edit behavior in engine, edit life in vault")

### Research findings
- `.planning/research/ARCHITECTURE.md` — engine/vault directory structure, build order, hook system design
- `.planning/research/STACK.md` — AppleScript patterns, Bash portability notes, Markdown conventions
- `.planning/research/PITFALLS.md` — engine/vault boundary collapse (pitfall #4), Bash compatibility (pitfall #8), AGENTS.md bloat (pitfall #3)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- None yet — this is the first phase. The engine directory is empty.

### Established Patterns
- None yet — Phase 1 establishes the patterns all subsequent phases follow.

### Integration Points
- `setup.sh` output (the vault scaffold) is the foundation every Phase 2+ skill reads from. Directory names and file paths decided here are permanent — changing them later requires a migration in `update.sh`.
- `AGENTS.md` structure decided here persists across all phases. Sections added later must fit within the 400-line budget.

</code_context>

<specifics>
## Specific Ideas

- **`/kairos-help`**: A skill specifically for confused or new users — surfaces all `/kairos-*` commands with brief descriptions, explains the system model (engine vs. vault, crew vs. council), and points to README. Should feel welcoming, not technical.
- **`update.sh` remote config**: Store the engine GitHub URL in `~/kairos/.engine-remote` (a single-line plain text file). `update.sh` reads this file; if missing, prompts the user once and saves it. Makes re-pointing to a fork trivial.
- **setup.sh confirm screen**: Before creating anything, show a table: "I will create the following:" + list of directories and files. One line: "Proceed? [y/N]". Abort cleanly on N.

</specifics>

<deferred>
## Deferred Ideas

- **Git remote setup for vault** — user asked about adding a private git remote during setup. Deferred: vault git remote is set up during Phase 2 onboarding (Concierge handles it), not during raw scaffolding.
- **Linux-primary support** — macOS is primary in v1; Linux is supported via uname-detection branches where needed, but Linux-first testing and documentation is a v2 concern once AppleScript bridge is replaced.

</deferred>

---

*Phase: 1-Foundation*
*Context gathered: 2026-06-23*
