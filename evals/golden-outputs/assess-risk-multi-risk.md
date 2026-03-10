# Golden Output: assess-risk — risk-assessment-multi-risk

Reference-quality output for regression testing. Generated from manual analysis of test case input.

## Input

Test case: `evals/test-cases/risk-assessment-multi-risk.md`

## Expected Output

```
Risk Register — Sprint 7 (7 days remaining)

RISK-001: Payment API blocked by external dependency
  Category: Dependency
  Likelihood: 5 (Almost certain) | Impact: 5 (Critical) | Score: 25 — Red
  Source: PRJ-201 Blocked 3 days, blocked by INFRA-90 (In Progress, no ETA)
  Mitigation: Escalate INFRA-90 to infra team lead, request ETA by EOD.
    If no unblock within 48h, prepare workaround or descope.
  Owner: Alex / DM (escalation)

RISK-002: Auth refactor stalling — 5 days with draft PR
  Category: Execution
  Likelihood: 4 (Likely) | Impact: 4 (Major) | Score: 16 — Red
  Source: PRJ-202 In Progress 5 days, PR still draft, no review started
  Mitigation: 1:1 with Maria to surface blockers.
    If PR needs decomposition, split into smaller reviewable increments.
  Owner: Maria / Tech Lead

RISK-003: Billing redesign unassigned — no owner
  Category: Resource
  Likelihood: 4 (Likely) | Impact: 3 (Moderate) | Score: 12 — Amber
  Source: PRJ-204 In Progress 4 days, assignee is null
  Mitigation: Assign owner immediately. If no capacity (4/5 due to PTO),
    descope to next sprint.
  Owner: DM (assignment)

RISK-004: Reduced capacity — Luca on PTO
  Category: Capacity
  Likelihood: 5 (Certain) | Impact: 2 (Minor) | Score: 10 — Amber
  Source: team_context.members_on_pto = ["Luca"], team at 4/5
  Mitigation: Ensure commitment accounts for 4-person capacity.
    Avoid adding scope. Prioritize if PRJ-201 unblocks late.
  Owner: DM (capacity planning)

RISK-005: Declining velocity trend
  Category: Predictability
  Likelihood: 3 (Possible) | Impact: 2 (Minor) | Score: 6 — Yellow
  Source: velocity [38, 42, 35] — latest sprint below 3-sprint avg (38.3)
  Mitigation: Track delivered SP at sprint close. If velocity drops below 33,
    investigate in retro (tech debt, review bottlenecks, scope churn).
  Owner: DM (trend monitoring)
```

**Overall RAG**: Red — two Critical-rated risks (RISK-001, RISK-002) with reduced capacity.

**Story points at risk**: 16 SP (PRJ-201: 8 + PRJ-202: 5 + PRJ-204: 3)

**Confidence**: Medium — sprint data complete, no historical risk register for trend comparison.

## Verification Checklist

- [x] 5 risks identified (dependency, execution, resource, capacity, predictability)
- [x] L x I scores computed correctly (25, 16, 12, 10, 6)
- [x] RAG matches severity thresholds
- [x] Mitigations are specific to each risk's context
- [x] Every risk traces to input data (ticket keys, PTO list, velocity array)
- [x] No fabricated risks or data
