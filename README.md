# Kairos

*A markdown-native personal operating system — goals, projects, and reflection in plain text, run by a crew of agents that check in with you at different cadences.*

> **Status:** early design / active development. This README describes the intended system. Much of it isn't built yet — it's the map, not the territory. Working title: *Kairos*.

---

## What it is

Kairos is a personal goal-and-task system that lives entirely in plain Markdown and is operated by an AI agent — Claude Code or a local Ollama model, your choice. There's no app, no database, no cloud service. You clone it, answer an onboarding interview, and from then on the system checks in with you: it plans your day, processes what you capture, and sits with you for weekly and monthly reflection.

The design bet is that the *ritual and structure* are what make a system stick — not features. So Kairos is built from four boring, durable primitives: Markdown files, agent/skill definitions, subagents, and bash hooks. Everything else attaches to that core later.

## Principles

- **Markdown is the source of truth.** Greppable, git-versioned, yours forever. No proprietary format, no vault lock-in, no Obsidian required.
- **Bash and Markdown only** (for now). No Python, no runtime, no scheduler. External integrations are deliberately deferred (see Roadmap).
- **Check-ins, not dashboards.** The system is a set of interactive rituals at different cadences, not a screen you stare at.
- **Built for anyone.** Your private life and the public tool are strictly separated (see Development), so a stranger can clone this and make it their own.
- **Backend-agnostic.** `AGENTS.md` is the canonical context; the same files run under Claude Code or Ollama/Pi.

## The two layers of agents

**The Crew** — they *operate* the system. Fixed, occupational, legible to anyone. Default names below; an optional themed "skin" can rename them (e.g. a mythic set) without changing behavior.

| Crew member | Role |
|---|---|
| **Sorter** | Triages your inbox — decides where each captured thing goes. Runs daily. |
| **Steward** | Checks your days against your aims and flags drift. |
| **Scribe** | Sits with you for weekly and monthly reflection; learns your style over time. |
| **Keeper** | Hygiene — archives finished work, keeps the structure clean. |
| **Concierge** | First contact. Runs onboarding and the periodic re-calibration. |

**The Council** — they *think with you* on a domain. You summon them; they don't run anything. The roster is **derived from your projects during onboarding** rather than pre-built: business-idea projects spin up a product-owner advisor, dev projects a senior engineer, a depth-psychology project a Jungian analyst, and so on. You can add more by hand later.

## Cadences

Each is an interactive ritual — the agent asks, you answer, it writes. The set is a dial, not a law.

| Cadence | What happens |
|---|---|
| On-demand | Capture (zero-friction dump), process the inbox, create/track projects, ask the system anything. |
| Daily | A morning planning touch and an evening reflection. |
| Weekly | A guided review that reads the week's notes and helps plan the next. Auto-offers itself Sunday evening — or the next time you log in if you miss it. |
| Monthly | Goal progress, what's stalled, a reset of priorities. |

State-surfacing and auto-commit run from bash hooks on session start, so the system meets you where you are without any scheduler.

## Output styles

The *voice* of a session is separate from *who does the work*. Kairos ships one sensible default style and a command to generate new ones — coach/mentor, Stoic, strategist, Jungian analyst, or whatever you invent. The generator is a short interview ("what should this voice prioritize, what should it never do, give an example") that writes a new style file, with a how-to alongside the default so anyone can fork it by example.

## Onboarding & the north star

Setup is a **semi-structured, mixed-initiative interview** — questions with smart defaults, but you can answer in your own words, write your own option, or redirect the conversation entirely. It builds a bird's-eye view of your priorities, values, current goals, and habits to track, and it derives your Council from your projects.

The north star is modeled on Jordan Peterson's **Future Authoring** structure, split in two:

- **`desired.md`** — the life you'd build if what's good in you wins.
- **`dreaded.md`** — the life you'd fall into if your worst habits ran unchecked.

These power two motivational voices used by the daily loop:

- **The Architect** (approach) reads activity against your *desired* future: *"The gym today moved you toward that."*
- **The Undertow** (avoidance) reads it against your *dreaded* future: *"Skipping again is the first stone on the path you said you don't want."*

The Undertow aims at the **road and the consequence**, never at you — it points at where a choice bends your trajectory, not at your character. That distinction is the whole difference between motivation and a self-criticism engine in a costume.

## Grounded in the research

The motivational and goal-setting design draws on established psychology rather than vibes — these double as the first notes the system is meant to help you organize:

- **Regulatory Focus Theory** (Higgins) — promotion vs. prevention; the basis for the two voices.
- **WOOP / Mental Contrasting** (Oettingen) and **Future Authoring** (Pennebaker's expressive-writing + Morisano's goal-setting lineage) — the desired/dreaded structure.
- **Goal-Setting Theory** (Locke & Latham) and **Self-Determination Theory** (Deci & Ryan, self-concordance) — why specific, values-aligned goals stick.
- **Implementation Intentions** (Gollwitzer) and habit research (Fogg; Wood & Neal; Clear) — closing the gap between intending and doing.

## Repository structure (the engine)

```
kairos-engine/
├── AGENTS.md            # canonical agent context (CLAUDE.md symlinks here)
├── skills/              # the interactive rituals
├── agents/              # the Crew (and Council templates)
├── hooks/               # bash glue: session-start state, auto-commit
├── styles/              # default output style + generator + how-to
├── templates/           # note skeletons (daily, weekly, project, north-star)
├── examples/            # example content for development/testing
├── docs/
├── DEVELOPMENT.md       # how to work on this without leaking private data
└── README.md
```

Note there is **no real content** in this repo — only templates and examples. Your actual goals, projects, and journals live in a separate private vault (see below).

## Engine vs. your vault

Kairos is two directories on purpose:

- **`kairos-engine/`** (this repo, public) — the tool. Skills, agents, hooks, templates.
- **`~/kairos/`** (private to you) — your life. Real goals, projects, daily notes, dreams.

You develop the tool in the engine and live your life in the vault; the two are never the same working tree, so your private data physically cannot end up in the public repo. Full discipline in **[DEVELOPMENT.md](DEVELOPMENT.md)**.

## Getting started *(intended flow — in development)*

```bash
git clone <engine-repo-url> ~/code/kairos-engine
cd ~/code/kairos-engine
./setup.sh ~/kairos     # scaffolds your private vault from templates
cd ~/kairos
claude                  # or your local Ollama runner (Pi/GSD)
# then: /onboard
```

## Roadmap / deferred

These are explicitly **not** in the first version — to be designed deliberately later:

- **External integrations** — Apple Calendar/Reminders, *or* a pivot to Google / CalDAV / `.ics` / a different surface. Open question.
- **Multi-source import** — pulling outside sources into the system (ingestion model, dedup, where things land).
- **Scheduling/notifications** — anything that pings you at a time lives in an integration, not the core.

The core leaves room for these (the inbox is a natural import target; the daily note can later mirror a calendar) without depending on any of them.

## License

**TBD — a GPL-family license is planned.** Until a `LICENSE` file is added, default copyright applies (all rights reserved): you may view and fork on GitHub, but the open-source grant isn't in effect yet. This will be settled before the project invites contributors.
