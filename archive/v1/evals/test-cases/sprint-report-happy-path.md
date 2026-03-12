# Test Case: Sprint Report — Happy Path

## Skill Under Test

`generate-sprint-report` (via `sprint-close-report` workflow)

## Scenario

End of a 2-week sprint (Day 10). The team committed 71 SP across 15 tickets. Uses the included mock sprint data from `integrations/mock/sprint-data.json`.

## Input

Use the full `integrations/mock/sprint-data.json` as input. Key characteristics:
- 15 tickets, 71 SP committed
- 3 tickets Done (16 SP), 6 In Progress (35 SP), 1 Blocked (8 SP), 5 To Do (12 SP)
- 1 critical blocker (HRZ-403, cross-team dependency)
- 2 sprints of velocity history (42 SP, 47 SP)
- 1 scope addition mid-sprint (HRZ-415)

## Expected Results

### RAG Status: Amber

Justification: 22.5% completion at midpoint with 1 critical blocker and cross-team dependency. Not Red because 6 tickets are actively In Progress and velocity trend is improving.

### Key Metrics

| Metric | Expected Value | Source |
|--------|---------------|--------|
| Committed | 71 SP / 15 tickets | Sum of all tickets in sprint |
| Completed | 16 SP / 3 tickets | Status = Done |
| Completion % | 22.5% | 16/71 |
| Blocked | 8 SP / 1 ticket | HRZ-403 |
| Velocity trend | Improving (42 → 47 SP) | Sprint history |

### Required Sections

- [ ] Header with RAG, sprint name, dates
- [ ] Summary (3 bullets max)
- [ ] Progress breakdown by status
- [ ] Velocity with trend
- [ ] Blockers table with ticket keys, days stuck, dependency
- [ ] Scope changes (1 addition: HRZ-415)
- [ ] Recommendations (at least 2, referencing specific tickets)
- [ ] Confidence level

### Required Recommendations

1. Escalate HRZ-403 (payment timeout) — blocked by PLAT-892 which is in To Do
2. Get HRZ-405 reviewed — 8 SP in review for 5 days

## Scoring

Apply `sprint-report-rubric.md`. Expected score: 10-12 (Pass).

Additionally:
- [ ] RAG justified with data (not vibes)
- [ ] Every metric traceable to input data
- [ ] No fabricated ticket keys or numbers
- [ ] Recommendations reference specific tickets and owners
- [ ] Confidence stated (Medium expected — only 2 sprints of velocity history)
