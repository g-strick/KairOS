# S01: Walking Skeleton: engine structure, bash test harness, interactive setup.sh + full vault scaffold — UAT

**Milestone:** M001
**Written:** 2026-06-23T23:48:06.477Z

## UAT: Phase 1 Wave 1 — Walking Skeleton

### Check 1: Engine directories exist
- [ ] Clone the engine repo (or use local copy) and verify skills/, agents/, hooks/, styles/, templates/ all exist
- [ ] Each directory contains a .gitkeep file

### Check 2: Vault scaffold works
- [ ] Run ./setup.sh with no arguments
- [ ] Accept default path (~/kairos) or provide a custom path
- [ ] Confirm the summary screen and answer 'y'
- [ ] Verify ~/kairos contains: north-star/, goals/5year, goals/yearly, goals/monthly, goals/weekly, daily/, projects/, council/, archive/, inbox.md, habits.md, AGENTS.md

### Check 3: Cancel on existing vault
- [ ] Run ./setup.sh pointing at an existing non-empty vault
- [ ] Select Cancel (option 3)
- [ ] Verify vault contents are unchanged

### Check 4: No-confirm creates nothing
- [ ] Run ./setup.sh with 'n' at the confirm prompt
- [ ] Verify no directories or files were created at the target path

### Check 5: Shellcheck clean
- [ ] shellcheck setup.sh test/lib/assert.sh test/setup.test.sh reports no warnings or errors
