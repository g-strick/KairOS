# /daily — Daily Check-in Skill

**Type:** Interactive skill  
**Cadence:** Once per day — target ≤5 minutes

## Description

Read `inbox/`, help the user choose **one focus** for today, write `daily/YYYY-MM-DD.md`. Short ritual, not a planning session.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos}"
INBOX="$VAULT/inbox"
TODAY="$(date +%Y-%m-%d)"
NOTE="$VAULT/daily/$TODAY.md"
```

## Pre-flight Check

```bash
if [ ! -d "$VAULT/daily" ] || [ ! -d "$INBOX" ]; then
    echo "Error: daily/ or inbox/ not found. Run setup.sh first."
    exit 1
fi
```

## Flow

### Step 1: Read inbox

List recent items in `inbox/` — `.md` captures, documents, folders, media. Summarize in 2–3 bullets max. Skip `README.md` unless it is the only file.

### Step 2: One focus

Ask: **"What's the one thing that would make today a win?"**

- Exactly one focus. Push back gently if the user lists three priorities.
- The focus can come from inbox items or be unrelated.

### Step 3: Optional triage (light)

Ask once: **"Anything in inbox to park in projects, someday, or archive?"**

- If yes, move files or folders with user confirmation.
- If no or user is rushed, skip — inbox can wait.
- Do **not** run a full sort. No new projects unless the user names one.

### Step 4: Write today's note

Create or update `$VAULT/daily/YYYY-MM-DD.md`.

## Output Format

```markdown
# YYYY-MM-DD

## Focus
<one sentence — the single priority for today>

## Inbox snapshot
- <optional 1–3 bullets from inbox/, if relevant>

## Notes
<optional short reflection — keep brief>
```

If the note already exists today, append an evening addendum under `## Notes` rather than overwriting.

## Agent Instructions

When the user runs `/daily`:

1. Resolve vault path and today's date.
2. Read `inbox/` and `profile.md` (name/timezone) if present.
3. Run the flow above. Stay concise.
4. Write `daily/YYYY-MM-DD.md`.
5. Do not build dashboards, goal hierarchies, or habit trackers.
6. When triaging, move inbox items out — do not delete without confirmation.
