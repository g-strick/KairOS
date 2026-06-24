# /onboard — Onboarding Skill

**Type:** Interactive skill
**Cadence:** On-demand (first use)

## Description

A short interview that collects basic profile fields and writes them to `profile.md`. Smart defaults are offered; the user can answer in their own words.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos}"
```

## Pre-flight Check

```bash
if [ ! -d "$VAULT" ]; then
    echo "Error: Vault not found at $VAULT"
    echo "Run setup.sh first to scaffold your vault."
    exit 1
fi

for path in daily inbox.md; do
    if [ "$path" = "daily" ]; then
        [ -d "$VAULT/daily" ] || { echo "Warning: daily/ missing. Run setup.sh."; exit 1; }
    else
        [ -f "$VAULT/$path" ] || { echo "Warning: $path missing. Run setup.sh."; exit 1; }
    fi
done
```

## Interview Flow

### Step 1: Name

Prompt: "What should I call you?"
Default: "User"

### Step 2: Timezone

Prompt: "What's your timezone? (e.g., America/New_York, UTC, Europe/London)"
Default: "America/New_York"

### Step 3: Confirmation

Summarize what was collected. Suggest `/capture` and `/daily` as next steps.

## Output Format

`$VAULT/profile.md`:

```markdown
# Profile

## Basic
- Name: <name>
- Timezone: <timezone>

## Completed
- Onboarded: <date>
```

## Agent Instructions

When the user runs `/onboard`:

1. Resolve the vault path. If the vault does not exist, tell them to run `setup.sh` first.
2. Walk through each step. Present defaults but allow free-form answers.
3. Write `$VAULT/profile.md` in the format above.
4. Be concise. Respect the user's time.
