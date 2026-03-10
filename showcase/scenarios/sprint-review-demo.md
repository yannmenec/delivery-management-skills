# Demo: Sprint Review Report

> Time to complete: ~2-3 minutes
> Skills used: compute-velocity, sprint-health-check, generate-sprint-report, self-check, evaluate-output

## Scenario

It is the last day of Sprint 26.2-2. You need to prepare a sprint report for the sprint review meeting and a separate executive summary for your VP. The Horizon team committed to 71 SP across 15 tickets.

## How to Run

**In Cursor:**
```
Read workflows/sprint-close-report.md and generate a sprint report using integrations/mock/sprint-data.json
```

**In Claude Code:**
```
Generate a sprint close report using the workflow in delivery-skills/workflows/sprint-close-report.md and data from integrations/mock/sprint-data.json
```

## Expected Output (Summary)

The sprint report should include:

### RAG: Amber

Justification: 3 completed tickets (16 SP) out of 15 (71 SP committed) at Day 6, with 1 critical blocker and a cross-team dependency. Trajectory is below 60% but sprint is only at midpoint — Amber rather than Red because back-loading is typical.

### Key Metrics

- **Committed**: 71 SP across 15 tickets
- **Completed**: 16 SP (3 tickets Done) — 22.5% of commitment
- **In Progress**: 35 SP (6 tickets)
- **Blocked**: 8 SP (1 ticket)
- **Velocity trend**: Improving (42 → 47 SP over last 2 sprints)
- **Predictability**: Medium (small sample size)

### Blockers

| Ticket | Summary | Days Stuck | Dependency |
|--------|---------|-----------|-----------|
| HRZ-403 | Payment timeout | 4 days | PLAT-892 (Platform, To Do) |

### Recommendations

1. Escalate HRZ-403 to Platform team lead — the blocker has not been started and 8 SP + downstream E2E tests (HRZ-408, 5 SP) are at risk
2. Get HRZ-405 reviewed — 8 SP in review for 5 days with no reviewer assigned
3. Check in with Priya on HRZ-406 — Critical bug in progress 6 days, PR stale

### VP Version (via format-for-audience)

After generating the full report, apply `format-for-audience` with audience = "c-level":

> **Sprint 26.2-2 Status: Amber**
>
> The team is mid-sprint with 22% of planned work completed. One critical payment bug is blocked by an external team dependency — escalation in progress. Onboarding feature is on track. Key risk: if the Platform team does not unblock the payment fix this week, the payment reliability milestone slips.

## What This Demonstrates

- **Workflow composition**: Velocity + health check + report + quality validation in sequence
- **Quality gates in action**: Self-check validates the report, evaluate-output scores it
- **Audience adaptation**: Same data produces a detailed engineering report and a 4-line executive summary
- **Evidence-based RAG**: Amber status is justified with specific data, not vibes
- **Confidence calibration**: Medium confidence noted due to only 2 sprints of velocity history
