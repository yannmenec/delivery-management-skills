# Demo: Escalation in 60 Seconds

> Time to complete: ~60 seconds
> Skills used: craft-escalation-memo, assess-risk

## Scenario

Your team's critical payment bug (HRZ-403) has been blocked for 4 days by an external dependency on the Platform team (PLAT-892). The Platform team has not started the work. Sprint ends in 8 days. You need to escalate to engineering leadership.

## How to Run

**In any AI tool:**
```
Read skills/risk-management/craft-escalation-memo/SKILL.md and draft an escalation memo.

Situation: HRZ-403 (Critical payment processing timeout bug) has been blocked for 4 days.
It is blocked by PLAT-892 on the Platform team, which is still in To Do status.
My team (Horizon) cannot proceed with HRZ-403 (8 SP) or HRZ-408 (E2E tests, 5 SP) until this is resolved.
Sprint ends in 8 days. The payment reliability milestone is at risk.
```

## Expected Output

```
ESCALATION MEMO

To: Engineering Leadership
From: [Delivery Manager], Horizon Team
Date: 2026-03-13
Priority: High

SITUATION

HRZ-403 (Critical: Payment processing timeout on high-value transactions) has
been blocked since March 9 — 4 days — waiting on PLAT-892 from the Platform
team. PLAT-892 is currently in To Do with no assignee. No communication from
the Platform team on timeline.

IMPACT

- 13 story points directly at risk (HRZ-403: 8 SP + HRZ-408: 5 SP)
- HRZ-408 (E2E payment tests) cannot start until HRZ-403 is resolved
- This represents 18% of the Horizon team's sprint commitment (13 of 71 SP)
- If unresolved by March 17, the payment reliability milestone for the quarter
  is at risk

URGENCY

Decision needed by end of day March 14 (tomorrow). Every additional day of
delay reduces the team's ability to complete, test, and stabilize the payment
fix within the sprint.

ASK

We need one of the following:
1. Platform team to prioritize PLAT-892 and assign it by end of day today
2. A workaround approved: Horizon team implements a temporary fix that bypasses
   the Platform dependency (estimated 3 SP additional effort, introduces tech debt)

SUPPORTING DATA

- HRZ-403 logged: March 5
- Blocked since: March 9
- PLAT-892 status: To Do, unassigned
- Sprint commitment at risk: 18%
- Downstream impact: 1 additional ticket blocked (HRZ-408)
```

## What This Demonstrates

- **Structured escalation**: SITUATION → IMPACT → URGENCY → ASK format
- **Quantified impact**: Story points, percentage of sprint, downstream effects — not "this is important"
- **Specific ask with options**: Two concrete options, not "we need help"
- **Evidence-based**: Every claim traces to specific tickets and dates
- **Professional tone**: Urgent but factual, no blame, no emotion
- **Speed**: From scattered data to a send-ready memo in under 60 seconds

## Before vs After

| | Manual Process | With Escalation Skill |
|---|---|---|
| **Time** | 15-20 min (gather data, structure thoughts, write, review tone) | ~60 seconds |
| **Quality** | Varies — often too vague or too emotional under pressure | Consistently structured, quantified, blame-free |
| **Missing elements** | Often forgets to quantify impact or provide clear options | Framework ensures all 4 elements (Situation, Impact, Urgency, Ask) are present |
| **Tone risk** | Frustration can leak in when writing under pressure | Skill constraints prevent blame and emotional language |
