# Golden Output: detect-scope-change — scope-change-mid-sprint

Reference-quality output for regression testing. Generated from manual analysis of test case input.

## Input

Test case: `evals/test-cases/scope-change-mid-sprint.md`

## Expected Output

```
Sprint Scope Change
===================
Sprint: Sprint 8 (2026-03-09 — 2026-03-21)
Analysis date: 2026-03-14 (Day 6 of 10)

Original commitment: 5 tickets / 20 SP

Additions (+3 tickets, +8 SP):
  - PRJ-303: Hotfix: checkout crash (2 SP, added 2026-03-11) — Reactive hotfix (Blocker)
  - PRJ-305: Accessibility audit (3 SP, added 2026-03-12) — Unplanned mid-sprint addition
  - PRJ-306: Rate limiter update (3 SP, added 2026-03-13) — Unplanned mid-sprint addition

Removals (-1 ticket, -5 SP):
  - PRJ-308: Legacy migration script (5 SP, removed 2026-03-11) — Descoped to next sprint

Net change: +2 tickets / +3 SP
Current scope: 7 tickets / 23 SP
Stability: Moderate (15% net SP change on 20 SP baseline)
```

**Classification Notes**:
- PRJ-303 distinguished as a reactive hotfix — Blocker priority, created after sprint start, already Done.
- PRJ-305 and PRJ-306 are standard mid-sprint additions, both still To Do.
- PRJ-301, PRJ-302, PRJ-304, PRJ-307 correctly excluded — added on sprint start date.

**Confidence**: High — sprint dates, created dates, and removal data all present.

**Recommendations**:
1. Review PRJ-305 and PRJ-306 (both To Do) — consider deferring to protect committed scope.
2. Track PRJ-303 hotfix as unplanned reactive work for velocity normalization.
3. Monitor burn-down — net +3 SP increase pressures the sprint.

## Verification Checklist

- [x] 3 additions identified (PRJ-303, PRJ-305, PRJ-306)
- [x] 1 removal identified (PRJ-308)
- [x] Net change: +2 tickets, +3 SP
- [x] Stability: Moderate (15%)
- [x] Hotfix distinguished from regular additions
- [x] Original commitment tickets NOT flagged
