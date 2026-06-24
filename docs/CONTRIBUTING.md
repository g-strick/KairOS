# Contributing to KairOS

Thanks for helping improve the engine. This repo is the **public tool** — never commit vault content (`inbox.md`, `daily/`, `profile.md`, etc.). See [DEVELOPMENT.md](DEVELOPMENT.md) for the engine/vault split.

## Branching strategy

**Default branch:** `master` (integration branch — keep it green).

### GSD phase work (recommended)

This project uses [GSD](https://github.com/anthropics/gsd) for phased delivery. Config uses **phase branching**:

| When | Branch | Example |
|------|--------|---------|
| Executing a phase | `gsd/phase-{NN}-{slug}` | `gsd/phase-01-foundation` |
| Ad-hoc fix outside a phase | `fix/{short-slug}` | `fix/setup-bash-version-check` |
| Docs-only / scope discussion | `docs/{short-slug}` | `docs/lean-scope-cut` |

GSD creates the phase branch automatically when you run `/gsd-execute-phase` (with `git.branching_strategy: "phase"` in `.planning/config.json`).

**After a phase completes:** open a PR from the phase branch → `master`. Prefer **squash merge** for a single clean commit on `master`, unless you need per-plan history for audit.

### Public PRs vs planning noise

`.planning/` holds roadmaps, plans, and state — useful for you, noisy for reviewers.

For PRs that should show **engine code only**:

```bash
/gsd-pr-branch master
```

That creates a clean branch with `.planning/` commits filtered out. Use it before opening a PR to strangers or before `/gsd-ship`.

### Solo / small changes

For a one-off change without running a full phase:

```bash
git checkout master && git pull
git checkout -b fix/short-description
# edit, test, commit
git push -u origin HEAD
gh pr create
```

---

## Commit messages

Use **[Conventional Commits](https://www.conventionalcommits.org/)** — one logical change per commit.

### Format

```
type(scope): imperative subject line

Optional body — why this change, not what every file does.
```

### Types

| Type | Use for |
|------|---------|
| `feat` | New skill, hook, script behavior |
| `fix` | Bug fix |
| `test` | Tests only (including RED before implementation) |
| `docs` | README, CONTRIBUTING, planning docs, skill prose |
| `refactor` | Restructure without behavior change |
| `chore` | Tooling, gitignore, deps — **not** "auto-commit after X" |

### Scope

Keep scopes short and meaningful:

- Phase: `01`, `02`, `phase-01`
- Area: `setup`, `capture`, `hooks`, `help`

### Examples (from this repo)

```
feat(capture): add /capture skill for inbox append
test(setup): assert minimal vault scaffold
docs(02): replan phase 2 as daily proof
fix(hooks): add profile.md to content globs
```

### Avoid

- `chore: auto-commit after complete-milestone` — batch unrelated changes; commit per plan or per logical unit instead
- `T1:`, `T2:` without type — prefer `test(01):` or `feat(01):`
- Messages with no scope when the change is phase-scoped
- Committing vault paths or personal notes — pre-push hook should block; if it doesn't, stop and fix globs first

### GSD execution

During `/gsd-execute-phase`, each plan should produce **atomic commits** (often one per task). Planning docs commit separately when `commit_docs: true`:

```
docs(01): create phase 1 foundation plan
test(01-01): add failing setup scaffold test
feat(01-01): implement setup.sh minimal vault
```

---

## Pull requests

### Before opening

1. Run tests: `bash test/setup.test.sh` and `bash test/m002.test.sh` (add others as they land).
2. Confirm no vault content in the diff: `git diff --name-only master` should not list `inbox.md`, `daily/`, etc.
3. For public-facing PRs, consider `/gsd-pr-branch` to drop `.planning/` churn.

### PR title

Match the **primary commit** or user-facing outcome:

```
feat: ship /capture and /daily skills (phase 2)
fix: anchor gitignore patterns to vault root
docs: lean scope cut and CONTRIBUTING guide
```

### PR body

The template in `.github/pull_request_template.md` is the source of truth. At minimum include:

1. **Summary** — what changed and why (1–3 bullets)
2. **Requirements** — which REQ IDs or phase success criteria are satisfied
3. **Test plan** — commands run and results
4. **Safety** — confirm no private/vault content in the engine tree

### Review expectations

- Small PRs beat large ones — phase branches help
- Squash merge to `master` unless there's a reason to preserve plan-level commits
- Do not merge with failing tests or pre-push hook bypass without explicit reason in the PR

---

## What not to submit

| Never in engine PRs | Why |
|---------------------|-----|
| `~/kairos/` content | Private life data |
| Unrelated scope creep | Keep PRs reviewable |
| AIS-OS / other projects' trademarked framework text | IP hygiene |
| Psychology attribution you cut from product scope | Editorial consistency |

---

## Quick reference

```bash
# Start phase work (GSD creates branch)
/gsd-execute-phase 1

# Tests
bash test/setup.test.sh && bash test/m002.test.sh

# Clean PR branch
/gsd-pr-branch master

# Open PR
gh pr create --base master
```

Questions about scope? See `docs/EXPANSIONS.md` for parked ideas — promote through GSD planning, not drive-by PRs.
