# Eval: assess-risk — 2026-03-10

## Test Case
risk-assessment-multi-risk

## Model
Reference output (manual analysis of expected results)

## Skill Version
1.0.0

## Golden Output

```
Risk ID: RISK-001
Title: Payment API migration blocked by external dependency
Category: Dependency
Likelihood: 5 (Almost certain)
Impact: 5 (Critical)
Score: 25 — 🔴 Critical
Description: PRJ-201 (Payment API migration, 8 SP, Critical priority) has been Blocked for 3 days. It is blocked by INFRA-90 which is still In Progress with no ETA. With 7 days remaining in Sprint 7, this 8 SP item is at high risk of non-delivery. The external dependency has no visible progress signal.
Mitigation: Escalate INFRA-90 to the infrastructure team lead. Request an ETA by end of day. If no unblock within 48h, prepare a workaround or descope to protect sprint goal.
Owner: Alex (assignee) / DM (escalation)
Status: Open
Date Identified: 2026-03-10
Last Updated: 2026-03-10

Risk ID: RISK-002
Title: Auth refactor stalling with draft PR after 5 days
Category: Execution
Likelihood: 4 (Likely)
Impact: 4 (Major)
Score: 16 — 🔴 Critical
Description: PRJ-202 (User auth refactor, 5 SP, High priority) has been In Progress for 5 days with only a draft PR. No review cycle has started. With 7 days remaining and this being a High-priority item, the likelihood of sprint completion is decreasing. A 5-day draft PR suggests complexity or blockers not yet surfaced.
Mitigation: 1:1 with Maria to understand blockers. If PR needs decomposition, split into smaller reviewable increments. Target PR ready-for-review by end of Day 8.
Owner: Maria (assignee) / Tech Lead (review)
Status: Open
Date Identified: 2026-03-10
Last Updated: 2026-03-10

Risk ID: RISK-003
Title: Billing page redesign unassigned with no owner
Category: Resource
Likelihood: 4 (Likely)
Impact: 3 (Moderate)
Score: 12 — 🟠 High
Description: PRJ-204 (Billing page redesign, 3 SP, Medium priority) has been In Progress for 4 days but has no assignee. Work without an owner is almost certain to stall. With 7 days left and 4 days already elapsed in a phantom "In Progress" state, this ticket is unlikely to complete without intervention.
Mitigation: Assign an owner immediately. If no capacity available (team is at 4/5 due to PTO), descope to next sprint rather than carry unowned work.
Owner: DM (assignment decision)
Status: Open
Date Identified: 2026-03-10
Last Updated: 2026-03-10

Risk ID: RISK-004
Title: Reduced team capacity — 1 member on PTO
Category: Capacity
Likelihood: 5 (Almost certain)
Impact: 2 (Minor)
Score: 10 — 🟠 High
Description: Luca is on PTO, reducing the team from 5 to 4 members (20% capacity reduction). This is a certainty (L:5). The impact is Minor (I:2) because the team's recent velocity (38, 42, 35 — avg 38.3 SP) suggests they can still deliver a reasonable sprint, but the buffer is thinner. Any additional disruption (e.g., the blocked PRJ-201) compounds this.
Mitigation: Ensure sprint commitment accounts for 4-person capacity. Avoid adding scope mid-sprint. If PRJ-201 unblocks late, prioritize it over lower-priority items.
Owner: DM (capacity planning)
Status: Open
Date Identified: 2026-03-10
Last Updated: 2026-03-10

Risk ID: RISK-005
Title: Declining velocity trend over last 3 sprints
Category: Predictability
Likelihood: 3 (Possible)
Impact: 2 (Minor)
Score: 6 — 🟡 Medium
Description: Velocity over the last 3 sprints is 38 → 42 → 35, showing a net decline from the peak and a latest sprint below the 3-sprint average (38.3). While a single dip is not alarming, the downward trend from 42 to 35 (−17%) warrants monitoring. Combined with the current PTO reduction and blocked work, this sprint's delivery could fall further.
Mitigation: Track this sprint's delivered SP at sprint close. If velocity drops below 33 (2 consecutive declines), investigate root causes in the retrospective — potential factors: growing tech debt, review bottlenecks, or scope churn.
Owner: DM (trend monitoring)
Status: Open
Date Identified: 2026-03-10
Last Updated: 2026-03-10
```

**Overall RAG**: 🔴 Red — driven by RISK-001 (Payment API blocked, severity 25) and RISK-002 (auth refactor stalling, severity 16). Two Critical-rated risks in a single sprint with reduced capacity demands immediate attention.

**Story points at risk**: 16 SP (PRJ-201: 8 SP + PRJ-202: 5 SP + PRJ-204: 3 SP) directly tied to the top 3 risks.

**Confidence**: Medium — sprint data is complete but no historical risk register is available for trend comparison.

## Scoring

### Rubric Dimensions (risk-assessment-rubric.md)
| Dimension | Score | Notes |
|-----------|-------|-------|
| Risk Identification Completeness | 2/2 | All 5 material risks identified from input: blocked dependency (PRJ-201→INFRA-90), stalling execution (PRJ-202), unassigned ticket (PRJ-204), PTO capacity gap (Luca), velocity decline (38→42→35). No fabricated risks. Categories appropriate. |
| Scoring Accuracy | 2/2 | Likelihood and impact well-calibrated with differentiation: L ranges from 3 to 5, I ranges from 2 to 5. Blocked external dependency correctly rated highest (L:5, I:5 = 25). PTO correctly rated high likelihood but low impact (L:5, I:2 = 10). Velocity scored conservatively (L:3, I:2 = 6). All L×I products computed correctly. |
| RAG Consistency | 2/2 | RAGs match severity thresholds from the skill spec: 25 → 🔴 (16-25 range), 16 → 🔴, 12 → 🟠 (10-15 range), 10 → 🟠, 6 → 🟡 (5-9 range). Overall RAG of Red correctly reflects the two Critical-rated risks. |
| Mitigation Quality | 1/2 | All 5 risks have specific mitigations tied to the risk context (not generic "monitor" advice). Owners identified for each. However, some deadlines are soft ("by end of Day 8", "within 48h") rather than explicit calendar dates, and RISK-005 mitigation is conditional rather than immediately actionable. |
| Evidence and Grounding | 2/2 | Every risk traces to specific input data: PRJ-201 key + INFRA-90 link + 3 days blocked, PRJ-202 + 5 days + draft PR, PRJ-204 + null assignee, Luca PTO from team_context, velocity array [38, 42, 35]. No unsupported claims. |

### Total Score: 9/10

### Verdict: Pass

## Observations
- RISK-001 and RISK-002 both land in the 🔴 Critical range but for different reasons: one is an explicit external block, the other is a silent execution risk. The skill correctly differentiates the categories (Dependency vs. Execution).
- RISK-003 (unassigned ticket) is a subtle find — the ticket is "In Progress" with no assignee, which is a resource risk that many assessments would miss. The `null` assignee in the input data is the key signal.
- RISK-004 (PTO) likelihood of 5 is correct — PTO is a certainty, not a probability. Impact of 2 is reasonable given the team can still function at 80% capacity.
- RISK-005 velocity scoring could be debated: the sequence 38→42→35 shows one increase then one decrease, not a monotonic decline. Scoring it at L:3 (Possible) is conservative and appropriate rather than alarmist.
- Mitigation quality scored 1/2 because while mitigations are contextual and reference specific tickets, some lack firm calendar deadlines. In a production risk register, "escalate by EOD" should specify the date (e.g., "escalate by 2026-03-10 EOD"). This is a common gap in AI-generated risk outputs.
- The test case does not provide historical risk register data, so trend comparison is unavailable — correctly reflected in the Medium confidence rating.
