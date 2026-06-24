# /capture — Capture Skill

**Type:** Interactive skill  
**Cadence:** Anytime — should take under 10 seconds

## Description

Create a new file in `inbox/` for the user's raw note. No categorization, no routing, no rewriting. The inbox is a folder — users can also drop documents, videos, and other files here directly.

## Vault Path Resolution

```bash
VAULT="${KAIROS_VAULT:-$HOME/kairos}"
INBOX="$VAULT/inbox"
```

## Pre-flight Check

```bash
if [ ! -d "$INBOX" ]; then
    echo "Error: inbox/ not found at $INBOX"
    echo "Run setup.sh first to scaffold your vault."
    exit 1
fi
```

## Flow

1. Ask what to capture — or accept text the user already provided with the command.
2. If empty, prompt once: "What should I capture?"
3. Write a new file in `$INBOX/` with a timestamp filename.

## Output Format

Create `$VAULT/inbox/YYYY-MM-DD-HHMM.md`:

```markdown
# Capture — YYYY-MM-DD HH:MM

<captured text exactly as the user said it>
```

- Filename uses vault timezone from `profile.md` if set; otherwise local time.
- If a file with that timestamp already exists, append `-2`, `-3`, etc.
- Do not overwrite existing inbox items.

## Agent Instructions

When the user runs `/capture`:

1. Resolve the vault path.
2. Capture the note verbatim — fix typos only if the user asks.
3. Write a new `.md` file in `inbox/`; never append to a shared inbox file.
4. Do not sort into `projects/`, `someday/`, or `archive/`.
5. Confirm briefly: "Captured to inbox/YYYY-MM-DD-HHMM.md"
6. Do not start a daily check-in unless the user asks for `/daily`.

For non-text items (PDFs, videos, folders), tell the user to drop them in `inbox/` manually — `/capture` is for quick text notes.
