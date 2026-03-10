# Eval: detect-scope-change — 2026-03-10

## Test Case
scope-change-mid-sprint

## Model
Reference output (manual analysis of expected results)

## Skill Version
1.0.0

## Golden Output

```
Sprint Scope Change
===================
Sprint: Sprint 8 (2026-03-09 — 2026-03-21)
Total in sprint: 7
Committed (estimated): 5 tickets / 20 SP
Added mid-sprint: 3 tickets / +8 SP
  - PRJ-303: Hotfix: checkout crash (2 SP, created 2026-03-11) — Unplanned reactive hotfix (Blocker)
  - PRJ-305: Accessibility audit (3 SP, created 2026-03-12) — Unplanned mid-sprint addition
  - PRJ-306: Rate limiter update (3 SP, created 2026-03-13) — Unplanned mid-sprint addition
Removed: 1 ticket / -5 SP
  - PRJ-308: Legacy migration script (5 SP, removed 2026-03-11) — Descoped to next sprint
Net change: +2 tickets / +3 SP
Current scope: 7 tickets / 23 SP
Scope stability: Moderate (15% net SP change — 3 SP net on 20 SP baseline)
```

**Classification Notes**:
- PRJ-303 distinguished as a **reactive hotfix** — Blocker priority, created 2 days after sprint start, already Done. This is unplanned work driven by a production incident, not proactive scope expansion.
- PRJ-305 and PRJ-306 are standard mid-sprint additions created on Day 4 and Day 5 respectively. Neither has started (both To Do), suggesting they were added to the sprint backlog without immediate urgency.
- PRJ-301, PRJ-302, PRJ-304, PRJ-307 are NOT flagged — all were added on sprint start date (2026-03-09) and are part of the original commitment.

**Stability Calculation**:
- Net SP change: +8 SP (added) - 5 SP (removed) = +3 SP
- Baseline: 20 SP (original commitment)
- Change ratio: 3 / 20 = 15%
- 15% falls in the Moderate range (10-25%) per the skill's stability thresholds

**Confidence**: High — sprint start date, created dates, and removal data are all present in the input.

**Recommendations**:
1. Review why 2 unplanned tickets (PRJ-305, PRJ-306) were added mid-sprint while still in To Do — consider deferring to next sprint to protect committed scope.
2. The hotfix (PRJ-303) was unavoidable but should be tracked as unplanned reactive work for velocity normalization.
3. The PRJ-308 descope partially offsets additions but the net +3 SP increase pressures the sprint — monitor burn-down.

**Limitations**: Scope change detection is approximate. Tickets moved between sprints (not created) may not be captured via JQL created-date comparison alone.

## Scoring

### Self-Check (5 checks)
| Dimension | Score | Notes |
|-----------|-------|-------|
| Numbers cited | 1/1 | 3 additions (+8 SP = 2+3+3), 1 removal (-5 SP), net +2 tickets / +3 SP, 15% change — all traceable to input |
| No empty sections | 1/1 | All sections populated: additions, removals, summary, classification, stability |
| Evidence referenced | 1/1 | Each ticket references key, created date, SP, and added_to_sprint date from input data |
| Confidence stated | 1/1 | "High" confidence with justification |
| Actionable recommendations | 1/1 | 3 specific recommendations addressing the mid-sprint additions and burn-down risk |

### Total Score: 5/5

### Verdict: Pass

## Observations
- The key discrimination is between tickets added on sprint start date (2026-03-09) vs. after sprint start. PRJ-301, PRJ-302, PRJ-304, PRJ-307 all have `added_to_sprint: 2026-03-09` matching the sprint start — these are part of the original commitment. PRJ-303, PRJ-305, PRJ-306 were created and added after sprint start.
- PRJ-303 is correctly distinguished as a reactive hotfix based on two signals: Blocker priority and the fact it was created + resolved within the sprint (status: Done). This matters for velocity analysis — hotfix SP should be tracked separately from committed delivery.
- Stability rating of Moderate (15%) is unambiguous given the skill's thresholds: <10% = Stable, 10-25% = Moderate, >25% = Volatile. The 15% figure is computed as net SP change (3) divided by baseline commitment (20).
- The removal data (PRJ-308) is explicitly provided in the input — in a real Jira scenario, removal detection would rely on baseline comparison (Approach A) or be noted as undetectable (Approach B). This test case sidesteps the detection limitation by providing the removal directly.
