---
phase: 01-foundation
plan: 03
type: summary
status: complete
---

# Plan 01-03 Summary — Engine/Vault Safety Mechanisms

## Objective

Ship the two safety mechanisms that make the engine/vault boundary structural rather than careful: an allowlist-based `update.sh` (engine→vault sync that copies only explicitly-listed safe paths) and a pre-push hook on the engine repo that aborts a push if any tracked file matches a content-glob safety list.

## What was done

### Task 1: Failing tests (RED)
- Created `test/update.test.sh` — tests allowlist positive (allowlisted content syncs), allowlist negative (non-allowlisted files do NOT sync), strict overwrite (engine wins), and non-interactive mode via env override
- Created `test/pre-push.test.sh` — tests abort on content-glob match, allow on safe tree, and message output names offending file
- Added `assert_not_exists` function to `test/lib/assert.sh` for negative assertions

### Task 2: Allowlist sync + manifest (GREEN)
- Created `templates/allowlist.txt` — canonical list of engine paths update.sh may copy: `skills/`, `agents/`, `hooks/`, `styles/`, `templates/`, `AGENTS.md`
- Created `update.sh` — allowlist-based engine→vault sync script that:
  - Reads the allowlist from `templates/allowlist.txt`
  - Resolves engine source from args, env var, or git repo detection
  - Copies only allowlisted paths with strict overwrite (engine wins)
  - Never uses symlinks
  - Supports non-interactive mode via `KAIROS_VAULT` and `GSD_ENGINE_ROOT` env vars
- `test/update.test.sh` passes all 12 assertions (GREEN)

### Task 3: Pre-push hook + installer (GREEN)
- Created `hooks/content-globs.txt` — vault content glob safety list: `daily/`, `north-star/`, `goals/`, `projects/`, `council/`, `archive/`, `inbox.md`, `habits.md`, `desired.md`, `dreaded.md`
- Created `hooks/pre-push` — pre-push hook that:
  - Scans `git ls-files` against content-glob patterns
  - Exits non-zero (aborts push) when a match is found
  - Prints clear message naming offending file(s)
  - Exits zero when no matches found
- Created `install-hooks.sh` — installs the pre-push hook into `.git/hooks/pre-push`
- `test/pre-push.test.sh` passes all assertions (GREEN)

## Test results

### update.test.sh
```
TEST 1: Allowlist positive — allowlisted content syncs (PASS)
TEST 2: Allowlist negative — non-allowlisted files do NOT sync (PASS)
TEST 3: Strict overwrite — engine version wins (PASS)
TEST 4: Non-interactive mode via env override (PASS)
Assertions: 12 passed, 0 failed
```

### pre-push.test.sh
```
TEST 1: Abort — tracked file matching content glob causes hook to fail (PASS)
TEST 2: Allow — safe tree causes hook to pass (PASS)
TEST 3: Message — on abort, output names offending file (PASS)
Assertions: All passed, 0 failed
```

## Shellcheck

All scripts pass shellcheck with no errors:
- `update.sh` — clean
- `install-hooks.sh` — clean
- `hooks/pre-push` — clean
- `hooks/content-globs.txt` — disabled SC2148/SC2287 (data file, not a script)
- `test/update.test.sh` — SC1091 info only (sourceable library)
- `test/pre-push.test.sh` — SC1091 info only (sourceable library)

## Artifacts produced

| File | Purpose |
|------|---------|
| `update.sh` | Allowlist-based engine→vault sync script |
| `templates/allowlist.txt` | Canonical safe-paths allowlist |
| `hooks/pre-push` | Pre-push content-glob safety hook |
| `hooks/content-globs.txt` | Content-glob safety list |
| `install-hooks.sh` | Installs pre-push hook into `.git/hooks` |
| `test/update.test.sh` | Allowlist sync test suite |
| `test/pre-push.test.sh` | Pre-push hook test suite |
| `test/lib/assert.sh` | Added `assert_not_exists` function |

## Verification

- [x] `bash test/update.test.sh` — all 12 assertions pass (GREEN)
- [x] `bash test/pre-push.test.sh` — all assertions pass (GREEN)
- [x] `shellcheck` reports no errors on all scripts
- [x] `templates/allowlist.txt` lists all 6 safe paths
- [x] `hooks/content-globs.txt` includes all vault content paths
- [x] `update.sh` uses copy semantics, not symlinks
- [x] `update.sh` reads engine source from config/env, not hardcoded
- [x] Pre-push hook aborts on content-glob match and names offender
- [x] Pre-push hook passes safe trees with exit zero

## Notes

- The allowlist is intentionally strict: adding a new engine file does NOT propagate until its path is added to `templates/allowlist.txt`. This is the desired behavior — worst-case failure is "forgot to publish a feature" (annoying), never a leak.
- The pre-push hook is the last line of defense before private content reaches the public remote. It is backstopped by `.gitignore` exclusions and physically-separate vault directories.
- `git push --no-verify` deliberately bypasses pre-push hooks. This is an intentional developer override, accepted and documented.