# Features Research

**Domain:** Personal knowledge management / personal OS with AI agents
**Researched:** 2026-06-23
**Confidence:** HIGH

## Feature Categories

### Table Stakes

Features that every sustainable personal productivity system must have. Without these, users abandon the system within weeks.

| Feature | Complexity | Why It's Non-Negotiable |
|---------|------------|------------------------|
| Zero-friction capture | Low | If capturing takes >5 seconds, it doesn't happen. Inbox must be one command. |
| Daily check-in ritual | Medium | Without a daily touchpoint, the system becomes a write-once archive |
| Consistent file structure | Low | If you can't find something in <3 seconds, you stop trusting the system |
| Review cadence (weekly minimum) | Medium | The system must "close the loop" — capture without review is noise |
| Goal visibility at the right horizon | Medium | Users lose motivation when long-term goals are invisible during daily work |
| Recovery from missed days | Low | System must gracefully handle gaps without requiring a "catch-up" ritual |

### Differentiators

Features that make KairOS distinctive versus other PKM tools.

| Feature | Complexity | What Makes It Different |
|---------|------------|------------------------|
| North star model (desired/dreaded) | Medium | Most PKMs store goals; KairOS grounds them in narrative futures the user has written — much more motivationally resonant |
| Dual motivational voice (Architect + Undertow) | Medium | No mainstream PKM tool has RFT-grounded motivational feedback. The distinction between "trajectory" (Undertow) and "character" is rare and important. |
| Crew-of-agents model | High | Each agent has a discrete occupational role — Sorter/Steward/Scribe/Keeper/Concierge — rather than a single monolithic assistant |
| Council derived from projects | Medium | Domain advisors generated from what the user is actually working on, not a static roster |
| Voice/style system with generator | Medium | Lets the user define the *tone* of feedback independently of functionality |
| Engine/vault structural separation | Low | Makes tool improvement and personal data completely independent — public contributions don't require private data hygiene |
| Psychology-grounded design | Low (design, not code) | WOOP, RFT, Implementation Intentions, SDT — most tools are vibes-based |

### Anti-Features (Deliberately Excluded)

These are tempting to add but consistently cause system abandonment.

| Anti-Feature | Why to Avoid |
|-------------|-------------|
| Complex tagging / taxonomy | Tag maintenance becomes a second job; people stop tagging, then the tags are useless |
| Deep folder hierarchies | Every piece of content needs a "home" decision; decision fatigue → avoidance |
| Multiple views / dashboards | Passive screens don't drive behavior; the ritual is the thing |
| Notifications / scheduled pings | Out of scope for v1; requires scheduler; and push notifications in productivity tools often become noise |
| "Smart" automatic organization | AI categorization is unreliable and creates distrust when it's wrong |
| Feature parity with Notion/Obsidian | KairOS does one thing well: rituals. It's not a wiki, a database, or a project manager. |
| Social / sharing features | This is a personal system; sharing is the enemy of honesty in self-assessment |

## Feature Depth Analysis

### What makes PKM systems actually stick (research synthesis)

Studies on habit formation and tool adoption consistently show:

1. **Simplicity wins over power.** Users adopt the simplest tool that works. Elaborate systems (Zettelkasten, PARA with 4 levels, GTD full capture-clarify-organize-reflect-engage) are more often written about than practiced. KairOS's answer: rituals are the UX, not folder taxonomies.

2. **Reflection drives retention.** The weekly review is the highest-leverage habit in GTD — users who do it consistently stick with the system; those who skip it drift off. KairOS's Scribe agent makes this a conversation, not a form.

3. **Capture must be friction-free.** The most common abandonment pattern: user captures three items, then has to categorize each one, then gives up. KairOS's answer: inbox.md is append-only; Sorter processes it separately.

4. **Long-term goals must be visible daily.** Implementation intention research (Gollwitzer) shows that people who connect daily actions to long-term goals are 2-3x more likely to achieve them. KairOS's answer: Steward reads north-star files and surfaces them during daily check-ins.

5. **Missing a day must not feel catastrophic.** Systems that feel broken if you miss a day create negative reinforcement. KairOS's answer: weekly review auto-offers at "next login after Sunday" — no guilt trigger for missing the ideal time.

### Cadence design principles

| Cadence | Key principle | What goes wrong if you get it wrong |
|---------|--------------|-------------------------------------|
| Daily | Short (<5 min), consistent time, low stakes | Too long → skipped. Too demanding → becomes a chore |
| Weekly | Longer (15-30 min), reflective, forward-planning | Skip one week → stop doing it. Must feel valuable, not mechanical |
| Monthly | Big picture, strategic, reset permissions | If monthly = "fill out a spreadsheet" it gets skipped; needs to feel like a real check-in |

### Goal horizon design

Research on goal-setting theory (Locke & Latham) shows the most effective goal structures:
- Specific + challenging + achievable (not vague, not impossible)
- Linked vertically (daily task → weekly focus → monthly goal → yearly aim → north star)
- With visible progress markers
- Reviewed at the right horizon frequency

KairOS should NOT show all horizons simultaneously — that's overwhelming. The Steward should surface only the *relevant* horizon for the current cadence.

## Feature Dependencies

```
desired.md + dreaded.md
         ↓
  North Star established
         ↓
  Yearly goals (link to north star)
         ↓
  Monthly goals (link to yearly)
         ↓
  Weekly focus (link to monthly)
         ↓
  Daily check-in (link to weekly focus)
         ↓
  Inbox capture → Sorter processes → lands in right file
```

The onboarding flow must build this chain top-down. Daily rituals won't work until the hierarchy exists.

## Sources

- Locke & Latham, "Building a practically useful theory of goal setting" (2002)
- Gollwitzer, "Implementation intentions" (1999)
- Oettingen, "Future thought and behaviour change" (2012) — WOOP
- Higgins, "Beyond pleasure and pain" (1997) — Regulatory Focus Theory
- Deci & Ryan, Self-Determination Theory (autonomy, competence, relatedness)
- Wood & Neal, habit formation research (2007)
- GTD (Allen) and PARA (Forte) — adapted patterns, not wholesale adoption
- Zettelkasten community — linking patterns adapted for daily notes
