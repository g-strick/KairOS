# S01: Onboarding, North Star, and Council Agents — UAT

**Milestone:** M002
**Written:** 2026-06-24T02:07:44.502Z

# UAT: M002-S01 — Onboarding, North Star, and Council Agents

## Checklist

| # | Check | Mode | Result |
|---|-------|------|--------|
| 1 | Concierge agent exists with role, principles, skill list | artifact | ✅ |
| 2 | Onboarding skill resolves KAIROS_VAULT, has vault check, writes profile.md | artifact | ✅ |
| 3 | North-star skill resolves KAIROS_VAULT, writes desired.md and dreaded.md | artifact | ✅ |
| 4 | Goals skill resolves KAIROS_VAULT, scaffolds 4 horizons, creates index.md | artifact | ✅ |
| 5 | Three Council agents exist (Life Coach, Strategic Advisor, Accountability Partner) | artifact | ✅ |
| 6 | AGENTS.md updated with crew roster, Council table, skill quick-reference | artifact | ✅ |
| 7 | Verification script runs 18 checks, all pass | runtime | ✅ |
| 8 | All skills are backend-agnostic (no Claude Code-specific syntax) | artifact | ✅ |

## Notes

- All skills use `KAIROS_VAULT` env var with `~/kairos` default — consistent with `setup.sh` from M001.
- Skills use `read -r` for input — works under any agent platform.
- No external API keys or secrets required.
- Council agents are pre-built; onboarding skill can derive custom agents from user's projects (deferred enhancement).
