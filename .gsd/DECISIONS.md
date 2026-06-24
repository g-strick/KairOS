# Decisions Register

<!-- Append-only. Never edit or remove existing rows.
     To reverse a decision, add a new row that supersedes it.
     Read this file at the start of any planning or research phase. -->

| # | When | Scope | Decision | Choice | Rationale | Revisable? | Made By |
|---|------|-------|----------|--------|-----------|------------|---------|
| D001 | M002 planning | architecture | M002 uses a single slice for all Phase 2 capabilities | All Phase 2 requirements (ONBD-01 through ONBD-05) delivered in one slice (S01) rather than splitting into multiple slices | Phase 2 is small (5 requirements, ~5 files) and the capabilities are tightly coupled — onboarding naturally leads into north-star work. Splitting would add overhead without meaningful parallelism. | Yes | agent |
| D002 | M002 planning | architecture | Council agents are pre-built with standard definitions | Ship three standard Council agents (Life Coach, Strategic Advisor, Accountability Partner) as engine artifacts; onboarding skill can derive additional custom agents from user's projects | Pre-built agents give users immediate value on first use. Custom agents derived from projects can be added later as an enhancement. | Yes | agent |
