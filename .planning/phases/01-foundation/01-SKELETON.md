# Walking Skeleton — KairOS

**Phase:** 1
**Generated:** 2026-06-23

## Capability Proven End-to-End

> One sentence: the smallest user-visible capability that exercises the full stack.

A user can clone the engine repo, run `./setup.sh`, answer a vault-path prompt and a confirm, and end with a fully scaffolded `~/kairos/` vault — verified by a bash end-to-end test that asserts every required directory and seed file exists.

## Architectural Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Runtime | Bash 5.x (`#!/usr/bin/env bash`, `set -euo pipefail`) | Hard project constraint: Bash + Markdown only, no Python/Node/scheduler runtime (CLAUDE.md). macOS system bash 3.2 unsupported; setup.sh checks BASH_VERSINFO and directs to `brew install bash` (D-12) |
| Data layer | Plain Markdown files + directory tree on the filesystem | Greppable, git-versioned, editor-agnostic; no database (kills greppability). The vault directory tree IS the data model |
| Engine/vault separation | Two physically separate working trees with separate remotes; sync by **copy**, not symlink (D-04) | Privacy is structural, not gitignore-based: private content is never in the engine tree, so a stray `git add .` cannot leak it. Copy (not symlink) lets strangers run KairOS without a local engine clone |
| Sync direction | Down by script (update.sh, allowlist), up only by hand one file at a time | DEVELOPMENT.md "the one rule". Allowlist sync, never denylist (D-07) — worst case is a missing feature, never a leaked journal |
| Canonical context root | `AGENTS.md` in the vault root; `.claude/CLAUDE.md` points to it (D-08) | Backend-agnostic (Claude Code, Codex, Gemini, Ollama). Must stay under 400 lines (D-10) — pointer file, not encyclopedia (pitfall 3) |
| Config storage | Single-line plain-text config files (e.g. `~/kairos/.engine-remote` for update.sh source) | No database; re-pointing to a fork is trivial; greppable |
| Test harness | Pure-bash assertions in `test/lib/assert.sh`, one `*.test.sh` per script, driven via stdin/env overrides + mktemp sandboxes | No Python/Node test framework allowed. Tests never touch the real `~/kairos`. shellcheck (D-14) gates every script |
| Portability | macOS (primary) + Linux via `uname` detection; avoid GNU-only AND BSD-only flags; pure arithmetic for date math (D-13) | macOS ships BSD coreutils; `date -d` is GNU-only (pitfall 8). Bash + portable utils only |

## Stack Touched in Phase 1

- [x] Project scaffold — engine top-level dirs (skills/, agents/, hooks/, styles/, templates/), .gitignore, bash test harness (plan 01)
- [x] "Routing" equivalent — interactive `setup.sh` entry point with confirm + existing-vault guard (plan 01)
- [x] Data layer — real filesystem write (the full vault scaffold) AND real read (update.sh reading allowlisted engine paths) (plans 01, 03)
- [x] "UI" equivalent — interactive prompts (vault path, confirm, existing-vault options) + `/kairos-help` skill (plans 01, 02)
- [x] Full-stack run command — documented: `git clone <engine> && cd <engine> && ./setup.sh` produces a working vault; `bash test/setup.test.sh` exercises the full path end-to-end

## Out of Scope (Deferred to Later Slices)

> Anything that is *not* in the skeleton. Be explicit — this prevents future phases from re-litigating Phase 1's minimalism.

- Onboarding interview, name/timezone collection, vault git remote setup — Phase 2 (Concierge); deliberately NOT in setup.sh (D-02, deferred ideas)
- North-star files (desired.md / dreaded.md) content and templates — Phase 2
- Goal hierarchy content (the directories are scaffolded in Phase 1; the guided setup is Phase 2)
- All agent definitions beyond the AGENTS.md crew-roster one-liners — Phase 2+
- All skills beyond `/kairos-help` — Phases 2-4
- Session-start hook, auto-commit hook — Phase 4
- Style system implementation (only the `styles/default.md` pointer ships in AGENTS.md) — later phase
- AppleScript Calendar/Reminders bridge — deferred (v2)

## Subsequent Slice Plan

Each later phase adds one vertical slice on top of this skeleton without altering its architectural decisions (Bash+Markdown, copy-not-symlink, AGENTS.md context root, allowlist sync, filesystem-as-data):

- Phase 2: User completes onboarding, writes desired/dreaded futures, and initializes the goal hierarchy into the scaffolded vault.
- Phase 3: User captures to inbox.md, sorts it with the Sorter agent, and runs a ≤5-minute morning check-in with habit streaks.
- Phase 4: User runs a guided weekly review, gets a session-start surfacing hook, and a single-command dashboard.

## Permanent Contracts Established Here

These decisions are load-bearing for every later phase. Changing them later forces a migration in update.sh:

- **Vault directory names** (`templates/vault-dirs.txt`): north-star, goals/{5year,yearly,monthly,weekly}, daily, projects, council, archive. Every Phase 2+ skill reads from these exact paths.
- **Allowlist** (`templates/allowlist.txt`): skills/, agents/, hooks/, styles/, templates/, AGENTS.md. New engine files do not reach vaults until added here.
- **Content-glob safety list** (`hooks/content-globs.txt`): daily/, north-star/, goals/, projects/, council/, archive/, inbox.md, habits.md, desired.md, dreaded.md. The pre-push backstop.
- **AGENTS.md structure**: four sections (identity, crew roster, style pointer, skill quick-reference), under 400 lines. Later phases add to the skill quick-reference within that budget.
