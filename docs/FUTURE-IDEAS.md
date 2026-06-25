# Future ideas

Brainstorm backlog from vault research (`reference/03_research/`) and gap analysis. **Not committed work** — revisit when `/kair-capture`, `/kair-daily`, and `/kair-triage` feel habitual.

For near-term parked skills and paths, see also [EXPANSIONS.md](EXPANSIONS.md).

---

## Week 2 — Session ritual (high leverage)

### `/kair-start`

On invoke: read `profile.md`, today's `daily/` note if it exists, inbox file count, last session log if present. Output a ~10-line context brief.

Could subsume a session-start hook (inbox count + last daily date) — prefer one skill over hook + skill duplication.

### `/kair-end` + `memory.md`

- Append a `## Session log` entry to `daily/YYYY-MM-DD.md` (time, summary, open loops, next action).
- Append one bullet to rolling `memory.md` at vault root (~50 lines; archive older entries to `archive/memory-YYYY-MM.md`).
- `/kair-daily` reads last 3 bullets from `memory.md` before asking for focus.

**Defer:** Proposal-before-write gate for digest rewrites (POSCA scale; not needed yet).

---

## Week 3 — GTD completion

### `/kair-weekly`

Guided weekly review: scan `waiting-for.md`, `someday-maybe.md`, active `projects/`, past week's `daily/` notes. MIT reference: ballred/obsidian-claude-pkm (adapt paths to KairOS).

---

## Additional skills (medium priority)

| Skill | Purpose |
|-------|---------|
| `/kair-braindump` | Rapid multi-capture — each item → separate `inbox/` file |
| `/kair-project` | Scaffold `projects/<slug>.md` with standard sections + optional frontmatter |
| `/kair-focus` | Pick one `@context` from `next-actions.md` — distraction-free mode |
| `/kair-evening` | Short end-of-day reflection |
| `/kair-monthly` | Monthly reset and priority review |
| `/kair-status` | One-screen summary (not a dashboard) |
| `/kair-archive` | Move completed work to `archive/` |

---

## Vault paths (create on demand)

- `archive/` — completed projects and archived memory digests
- `goals/` — only if a future `/kair-goals` skill ships (no hierarchy in lean kit today)
- `habits.md` — only if daily check-in should track streaks
- `memory.md` — with `/kair-end` (see Week 2)

---

## Navigation (ongoing discipline)

- Root `INDEX.md` — shipped via `setup.sh`; keep updated when adding top-level folders
- `_index.md` per dense folder — trigger at 3+ files (`reference/`, `projects/`, research corpora)
- `reference/_index.md` — link to executive summaries in large research trees

---

## Integrations (defer until ritual skills land)

**Principles (from external services research):**

- Read-only pulls first; land in `inbox/<source>/` before `/kair-triage`
- Credentials in `.env.local` (gitignored), never in vault git
- No bidirectional live sync; no `gmail.send` in v1
- CLI bridges under `scripts/bridges/` — skills never call vendor CLIs directly

**Suggested build order:**

1. Todoist — API token; `inbox/todoist/` JSON snapshots
2. Gmail — Google OAuth readonly; `inbox/email/` `.eml` files
3. Google Drive — shared OAuth; `inbox/gdrive/`
4. OneNote — MSAL export; `inbox/onenote/` HTML (migration use case)

**Cross-platform capture:** Todoist bridge as alternative to macOS-only Reminders for mobile capture.

**Near-term tweak:** `/kair-capture` mentions Reminders only when macOS + `rem` available.

---

## Engine / governance (low priority at lean scale)

- `THIRD_PARTY_NOTICES` when importing MIT skill packs from kepano/ballred
- Licensing policy doc before bulk skill imports (avoid CC BY-NC-SA personal-os)
- Session-start hook if `/kair-start` is not enough for a given backend

---

## Explicitly out of scope

Do not build unless requirements change dramatically:

- Vector database or semantic search over vault content
- Autonomous memory curation without user review
- Generated code maps (AgentLens-style)
- MCP workflow gate server (task-orchestrator pattern)
- Channel gateways (Slack, Telegram)
- Agent controller / multi-agent orchestration runtime
- POSCA-style ontology (`Ontology/00_`–`07_`, `_ingest/` envelopes)
- Goal hierarchies (north-star, 5-year plans) in the lean kit
- Copying amanaiproduct/personal-os templates (NC license)

---

*Graduate an item to [EXPANSIONS.md](EXPANSIONS.md) or `.planning/ROADMAP.md` when you decide to ship it.*
