# /onboard — Onboarding Skill

**Type:** Interactive skill  
**Cadence:** On-demand (first use)

## Description

A short interview that collects basic profile info and writes `profile.md` to the vault.

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

for path in inbox AGENTS.md daily projects someday archive; do
    if [ ! -e "$VAULT/$path" ]; then
        echo "Warning: $path missing from vault. Run setup.sh to fix."
        exit 1
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

Summarize what was collected. Tell the user:

- `/capture` anytime → new file in `inbox/`
- `/daily` once a day → `daily/YYYY-MM-DD.md`
- Move items to `projects/`, `someday/`, or `archive/` by hand until `/sort` exists

## Output Format

Write `$VAULT/profile.md`:

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
2. Walk through each interview step. Present defaults but allow free-form answers.
3. Write the collected data to `$VAULT/profile.md` in the format above.
4. Be warm but concise. Respect the user's time.
