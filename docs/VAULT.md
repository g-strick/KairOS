# Vault layout

Canonical reference for `~/kairos/` (or `KAIROS_VAULT`). Created by `setup.sh`; skills and `AGENTS.md` assume this structure.

## Tree

```
~/kairos/
├── AGENTS.md              # copied from engine
├── inbox/                 # capture — notes, files, media, folders
├── profile.md             # from /onboard
├── daily/
│   ├── TEMPLATE.md        # copy for each day
│   └── YYYY-MM-DD.md
├── goals/
│   └── current.md
├── projects/              # active work
├── someday/               # parked ideas
├── archive/               # done or dropped
├── scripts/               # your local automation (private)
└── _engine/               # private lab — experiments, drafts, handoffs
    ├── NOW.md
    ├── BACKLOG.md
    ├── HANDOFF.md
    ├── ENGINE-PIN.md
    ├── experiments/
    ├── drafts/
    ├── handoffs/
    └── archive/
```

## Life folders

| Path | Purpose |
|------|---------|
| `inbox/` | Everything lands here first — `/capture` writes `.md` files; drop any file type |
| `daily/` | One check-in per day — `/daily` |
| `goals/` | Current intentions — edit manually; not required by skills yet |
| `projects/` | Active commitments |
| `someday/` | Ideas you're not committing to now |
| `archive/` | Retired items |
| `scripts/` | Bash helpers you run locally (e.g. Reminders bridge) |

## Engine lab (`_engine/`)

Private workshop for tooling experiments. **Never commit `_engine/` to the public engine repo.**

| File | Purpose |
|------|---------|
| `NOW.md` | What you're building this session |
| `BACKLOG.md` | Parked work — you pick what becomes NOW |
| `HANDOFF.md` | Resume packet — update when you stop |
| `ENGINE-PIN.md` | Public engine repo path/commit when dormant |

Open `~/kairos` as your Cursor workspace. At session start, read `_engine/HANDOFF.md` and `NOW.md`.

## Commands

| Command | Writes | Reads |
|---------|--------|-------|
| `/onboard` | `profile.md` | vault structure |
| `/capture` | `inbox/YYYY-MM-DD-HHMM.md` | — |
| `/daily` | `daily/YYYY-MM-DD.md` | `inbox/`, `profile.md` |

## Setup

```bash
git clone https://github.com/g-strick/KairOS.git ~/code/kairos-engine
cd ~/code/kairos-engine
./setup.sh
./update.sh ~/kairos
cd ~/kairos
```

## Conventions

- One `.md` file per `/capture` — never append to a shared inbox file
- Projects start as one file or folder each
- Promote engine changes one file at a time: `_engine/drafts/` → public engine repo
- Vault content stays private — see [DEVELOPMENT.md](DEVELOPMENT.md)
