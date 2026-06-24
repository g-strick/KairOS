# /kairos-onboard — Onboarding Skill

**Type:** Interactive skill (bash)
**Agent:** Concierge
**Cadence:** On-demand (first use, then periodic re-calibration)

## Description

A semi-structured interview that collects the user's basic profile and writes it to the vault. Smart defaults are provided for each question, but the user can answer in their own words, write their own option, or redirect the conversation entirely.

## Vault Path Resolution

Read the vault path from the `KAIROS_VAULT` environment variable. If not set, default to `~/kairos`.

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos}"
```

## Pre-flight Check

Before proceeding, confirm the vault directory exists and contains the expected structure:

```bash
if [ ! -d "$VAULT" ]; then
    echo "Error: Vault not found at $VAULT"
    echo "Run setup.sh first to scaffold your vault."
    exit 1
fi

for dir in north-star goals daily projects council archive; do
    if [ ! -d "$VAULT/$dir" ]; then
        echo "Warning: $dir/ missing from vault. Run setup.sh to fix."
        exit 1
    fi
done
```

## Interview Flow

### Step 1: Name

Prompt: "What should I call you?"
Default: "User"
Write to: `$VAULT/profile.md` (append section)

### Step 2: Timezone

Prompt: "What's your timezone? (e.g., America/New_York, UTC, Europe/London)"
Default: "America/New_York"
Write to: `$VAULT/profile.md` (append section)

### Step 3: Key Priorities

Prompt: "List 3–5 key priorities right now. One per line. (e.g., health, career growth, relationships, learning, finances)"
Default: "health\ncareer\nrelationships\nlearning\nfinances"
Write to: `$VAULT/profile.md` (append section)

### Step 4: Habits to Track

Prompt: "What habits do you want to track? One per line. (e.g., exercise, meditation, reading, journaling)"
Default: "exercise\nmeditation\nreading"
Write to: `$VAULT/profile.md` (append section) and also initialize `$VAULT/habits.md` if it doesn't have habit entries yet.

### Step 5: Confirmation

Summarize what was collected and confirm the vault is ready. Offer to run `/kairos-north-star` next.

## Output Format

`$VAULT/profile.md` structure:

```markdown
# Profile

## Basic
- Name: <name>
- Timezone: <timezone>

## Priorities
1. <priority 1>
2. <priority 2>
...

## Habits to Track
- <habit 1>
- <habit 2>
...

## Completed
- Onboarded: <date>
```

## Agent Instructions

When the user runs `/kairos-onboard`:

1. Resolve the vault path. If the vault doesn't exist, tell them to run `setup.sh` first.
2. Walk through each interview step above. Present the default but allow free-form answers.
3. Write the collected data to `$VAULT/profile.md` in the format above.
4. If `$VAULT/habits.md` exists but has no habit entries, add them.
5. Summarize what was set up and ask if they want to do `/kairos-north-star` next.
6. Be warm but not effusive. Be concise. Respect the user's time.
