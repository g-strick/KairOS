# KairOS — Agent Context

## The Crew

The crew operates the system. Their definitions live in `agents/`.

| Agent | Role |
|-------|------|
| **Concierge** | First contact. Runs onboarding and periodic re-calibration. |
| **Sorter** | Triages the inbox — decides where each captured item goes. |
| **Steward** | Checks days against aims and flags drift (Architect + Undertow voices). |
| **Scribe** | Sits with you for weekly and monthly reflection; learns your style. |
| **Keeper** | Hygiene — archives finished work, keeps the structure clean. |

### Council

The Council is derived from your projects during onboarding. Standard advisors ship with the engine:

| Agent | Role |
|-------|------|
| **Life Coach** | Goal achievement, habit formation, motivation. |
| **Strategic Advisor** | Big-picture thinking, decision-making, trade-off analysis. |
| **Accountability Partner** | Follow-through, commitment tracking, gentle pressure. |

Summon any Council agent on demand — they don't run automatically.

## Skills

The interactive rituals live in `skills/`.

| Skill | Command | Purpose |
|-------|---------|---------|
| Onboarding | `/kairos-onboard` | Semi-structured interview: name, timezone, priorities, habits |
| North Star | `/kairos-north-star` | Guided desired/dreaded interview (Future Authoring) |
| Goals | `/kairos-goals` | Scaffold goal hierarchy (5-year → yearly → monthly → weekly) |
| Capture | `/kairos-capture` | Zero-friction dump to inbox.md |
| Sort | `/kairos-sort` | Process inbox, route items, confirm with user |
| Morning | `/kairos-morning` | Daily planning: focus, habits, weekly focus |
| Weekly | `/kairos-weekly` | Guided review of past week, plan next week |

## Output Style

The default style is defined in `styles/`.
