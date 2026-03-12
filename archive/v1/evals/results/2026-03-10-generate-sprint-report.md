# Eval: generate-sprint-report — 2026-03-10

## Test Case
sprint-report-happy-path

## Model
Reference output (manual analysis of expected results)

## Skill Version
1.0.0

## Golden Output

```
# Sprint Report

**Sprint**: Sprint 26.2-2
**Period**: 2026-03-09 — 2026-03-21
**Report Date**: 2026-03-13
**RAG Status**: Amber — 22.5% completion at midpoint with 1 critical blocker (HRZ-403) and cross-team dependency on Platform

---

## Executive Summary

1. **Progress**: 16 of 71 SP completed (22.5%) at sprint midpoint. 3 tickets Done, 6 actively In Progress (35 SP), but trajectory is below target.
2. **Health**: 1 critical blocker (HRZ-403 — payment timeout) blocked 4 days by PLAT-892 (Platform, To Do). 8 SP at risk. HRZ-405 (8 SP) stale in review for 5 days.
3. **Outlook**: Sprint goal ("Complete user onboarding flow and address critical payment bugs") is at risk unless HRZ-403 is unblocked and stale reviews are cleared. Velocity trend is improving (42 → 47 SP) but current burn rate needs acceleration.

---

## Progress

| Status      | Tickets | Story Points |
|-------------|---------|--------------|
| To Do       | 5       | 12           |
| In Progress | 4       | 22           |
| In Review   | 2       | 13           |
| Done        | 3       | 16           |
| Blocked     | 1       | 8            |

**Total**: 15 tickets, 71 SP committed
**Completion**: 16 / 71 SP (22.5%)

---

## Velocity

- **Average velocity**: 44.5 SP (last 2 sprints)
- **Trend**: Improving (42 → 47 SP over last 2 sprints)
- **Current sprint trajectory**: 22.5% of commitment at midpoint
- **Status**: At risk

| Sprint        | Committed | Completed |
|---------------|-----------|-----------|
| Sprint 26.1-3 | 55        | 42        |
| Sprint 26.2-1 | 50        | 47        |
| Sprint 26.2-2 | 71        | 16 (in progress) |

---

## Blockers & Stuck Tickets

| Key     | Severity | Status      | Days | Assignee       | Action                                              |
|---------|----------|-------------|------|----------------|-----------------------------------------------------|
| HRZ-403 | Critical | Blocked     | 4    | Maria Santos   | Escalate to Platform — blocked by PLAT-892 (To Do)  |
| HRZ-405 | High     | In Review   | 5    | James Wilson   | Expedite code review — 8 SP stale, PR open          |
| HRZ-406 | Critical | In Progress | 6    | Priya Patel    | Follow up — critical bug, 6 days without resolution |

Note: HRZ-408 (E2E tests for payment flow) is indirectly blocked — depends on HRZ-403 resolution.

---

## Scope Changes

- **Added mid-sprint**: 1 ticket, +5 SP (HRZ-415: Add rate limiting to public API endpoints)
- **Scope change**: +7.6% (5 SP added to original 66 SP commitment)
- **Stability**: Stable (< 10%)

---

## Risks

- **Cross-team dependency on Platform** — Red — PLAT-892 is in To Do, no progress visible. Blocks HRZ-403 (8 SP) and indirectly HRZ-408 (5 SP). 13 SP total at risk.
- **Stale review pipeline** — Amber — HRZ-405 in review for 5 days (8 SP). If not merged soon, downstream work is delayed.
- **Sprint goal at risk** — Amber — Payment bugs (HRZ-403, HRZ-406) are part of the sprint goal. HRZ-403 is blocked, HRZ-406 is stale at 6 days.

---

## Recommendations

1. **Escalate HRZ-403 to Platform team** — Owner: Maria Santos / Engineering Manager — PLAT-892 is in To Do with no progress. 8 SP directly blocked, 5 SP indirectly blocked (HRZ-408). Request Platform prioritize PLAT-892 this sprint.
2. **Expedite review of HRZ-405** — Owner: Tech Lead / available reviewer — 8 SP in review for 5 days with PR open. Assign a reviewer today to unblock merge.
3. **Check in on HRZ-406** — Owner: Priya Patel — Critical currency rounding bug, 6 days in progress. Verify if help is needed or if the fix is close to completion.

---

## Caveats

- Only 2 sprints of velocity history available. Trend direction (improving) is indicative but not statistically robust.
- Scope change detection based on test case metadata (HRZ-415 flagged as mid-sprint addition). In production, use Jira created dates.
- Report generated at sprint midpoint — trajectory may shift significantly in the second half.

**Confidence**: Medium — Limited velocity history (2 sprints), 1 critical cross-team dependency with unknown Platform team capacity.
```

## Scoring

### Rubric Dimensions (or Self-Check)
| Dimension | Weight | Score | Weighted | Notes |
|-----------|--------|-------|----------|-------|
| RAG Accuracy | 3 | 2/2 | 6 | Amber correctly justified: 22.5% completion at midpoint + 1 critical blocker (HRZ-403). Not Red because 6 tickets actively In Progress and velocity improving. Not Green because completion < 80% trajectory and critical blocker exists. |
| Velocity Accuracy | 2 | 2/2 | 4 | Numbers match input: Sprint 26.1-3 completed 42 SP, Sprint 26.2-1 completed 47 SP. Trend correctly identified as Improving. Average (44.5 SP) mathematically correct. |
| Blocker Specificity | 2 | 2/2 | 4 | HRZ-403 identified with: ticket key, severity (Critical), days stuck (4), assignee (Maria Santos), blocking dependency (PLAT-892, Platform team, To Do). Includes indirect impact on HRZ-408. |
| Scope Change | 1 | 2/2 | 2 | 1 addition correctly identified: HRZ-415 (rate limiting, 5 SP). Scope change percentage computed (7.6%). Stability classified as Stable (< 10%). |
| Recommendations | 2 | 2/2 | 4 | 3 specific recommendations: escalate HRZ-403 (names PLAT-892, Maria, 8+5 SP at risk), expedite HRZ-405 review (5 days stale, 8 SP), check HRZ-406 (6 days, critical). All reference ticket keys, assignees, and concrete actions. |
| Completeness | 1 | 2/2 | 2 | All 8 required sections present: Header/RAG, Executive Summary, Progress, Velocity, Blockers, Scope Changes, Risks, Recommendations, Caveats with Confidence level. |

### Total Score: 22/22

### Verdict: Pass

## Observations

- **RAG calibration**: Amber is the correct call. 22.5% at midpoint with a critical blocker meets Amber criteria. The active In Progress count (6 tickets, 35 SP) provides enough momentum signal to avoid Red, despite trajectory math suggesting ~45% projected completion.
- **Velocity data limitation**: Only 2 sprints of history means average velocity (44.5 SP) and trend (improving) are directional but not statistically robust. The report correctly notes this in Caveats and sets Confidence to Medium.
- **Blocker cascade**: HRZ-403 → HRZ-408 dependency chain is correctly identified. Total at-risk SP (13) includes both direct (8 SP) and indirect (5 SP) impact.
- **Scope change is minimal**: +1 ticket, +5 SP, 7.6% — correctly classified as Stable. This does not materially affect the sprint outlook.
- **Sprint goal alignment**: The report correctly connects blockers (HRZ-403, HRZ-406) back to the sprint goal ("address critical payment bugs"), adding context beyond raw metrics.
- **Test case note**: The test case description (`sprint-report-happy-path.md`) summarizes status groups as "3 Done/16 SP, 6 In Progress/35 SP, 5 To Do/12 SP". The raw `sprint-data.json` shows slightly different per-status breakdowns (Done: 11 SP, In Progress: 26 SP, In Review: 13 SP, To Do: 13 SP). The golden output uses the test case expected results as specified. Future eval runs against live data should verify status grouping logic.
