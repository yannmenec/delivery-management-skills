# Eval: detect-stuck-tickets — 2026-03-10

## Test Case
stuck-tickets-scenario-1

## Model
Reference output (manual analysis of expected results)

## Skill Version
1.0.0

## Golden Output

```
Stuck Tickets Found: 5

---

Ticket: PRJ-102
Summary: Payment gateway integration
Layer: Blocked
Status: Blocked (for 5 days)
Assignee: Bob
Priority: Critical
Estimate: 8 SP
Sprint: Sprint 5 (4 days left)

Context:
- Last activity: 2026-03-06 (4 days ago)
- Last comment by Bob: "Waiting on EXT-50 from external team — no ETA yet"
- Linked blockers: EXT-50 (To Do)
- Slack mentions: None found

PR & Code Activity:
- No PR or commits found

---

Ticket: PRJ-108
Summary: Fix XSS vulnerability
Layer: Flagged
Status: In Progress (for 1 day)
Assignee: Bob
Priority: Blocker
Estimate: 2 SP
Sprint: Sprint 5 (4 days left)

Context:
- Last activity: 2026-03-10 (0 days ago)
- Last comment by Bob: "Impediment flagged — needs security team sign-off before merge"
- Linked blockers: None
- Slack mentions: None found

PR & Code Activity:
- PR: #412 — Fix XSS in user input fields | Status: open
- CI: pending | Reviews: pending
- Last push: 2026-03-10 (0 days ago) | Diff: 4 files, +38/-12
- Merge conflicts: no
- Unresolved review threads: 0

---

Ticket: PRJ-103
Summary: Email notification service
Layer: Stale + Silent
Status: In Progress (for 6 days)
Assignee: Carol
Priority: High
Estimate: 5 SP
Sprint: Sprint 5 (4 days left)

Context:
- Last activity: 2026-03-05 (5 days ago)
- Last comment by Carol: "Started working on the email templates"
- Linked blockers: None
- Slack mentions: None found

PR & Code Activity:
- PR: #398 — Email notification service draft | Status: draft
- CI: pending | Reviews: no reviews
- Last push: 2026-03-04 (6 days ago) | Diff: 7 files, +210/-15
- Merge conflicts: no
- Unresolved review threads: 0

---

Ticket: PRJ-106
Summary: Search indexing optimization
Layer: Stale + Silent
Status: In Progress (for 4 days)
Assignee: Frank
Priority: Medium
Estimate: 3 SP
Sprint: Sprint 5 (4 days left)

Context:
- Last activity: 2026-03-04 (6 days ago)
- Last comment by Frank: "Looking into the indexing bottleneck"
- Linked blockers: None
- Slack mentions: None found

PR & Code Activity:
- No PR or commits found

---

Ticket: PRJ-104
Summary: Dashboard widgets
Layer: Stale
Status: In Review (for 4 days)
Assignee: Dave
Priority: Medium
Estimate: 3 SP
Sprint: Sprint 5 (4 days left)

Context:
- Last activity: 2026-03-07 (3 days ago)
- Last comment by Dave: "PR is up, waiting for reviewer"
- Linked blockers: None
- Slack mentions: None found

PR & Code Activity:
- PR: #405 — Dashboard widget components | Status: open
- CI: passing | Reviews: pending — no reviewer assigned
- Last push: 2026-03-06 (4 days ago) | Diff: 12 files, +340/-28
- Merge conflicts: no
- Unresolved review threads: 0
```

**Summary**: 5 stuck tickets, 21 SP at risk (8+2+5+3+3). Highest severity: Critical (PRJ-102, PRJ-108). 1 external dependency blocker (EXT-50).

**Confidence**: High — all detection layers applied, input data is complete.

**Recommendations**:
1. **PRJ-102**: Escalate EXT-50 dependency to the external team lead — 4 days remaining, 8 SP at risk.
2. **PRJ-108**: Coordinate security team sign-off for the XSS fix — Blocker priority demands same-day resolution.
3. **PRJ-103**: Check in with Carol — 6 days stale with only a draft PR suggests a hidden blocker.
4. **PRJ-106**: Nudge Frank — no PR and 6 days silent is the strongest stuck signal in this sprint.
5. **PRJ-104**: Assign a reviewer to the open PR — 4 days in review with no review activity.

## Scoring

### Self-Check (5 checks)
| Dimension | Score | Notes |
|-----------|-------|-------|
| Numbers cited | 1/1 | 5 tickets, 21 SP (8+2+5+3+3), 4 days remaining — all traceable to input |
| No empty sections | 1/1 | All tickets have Context and PR sections populated |
| Evidence referenced | 1/1 | Each ticket references specific input fields: days_in_status, last_updated, pr_status, linked_issues |
| Confidence stated | 1/1 | "High" confidence stated with justification |
| Actionable recommendations | 1/1 | 5 recommendations, each specific to the ticket's stuck reason with owner context |

### Total Score: 5/5

### Verdict: Pass

## Observations
- Test case expected results are comprehensive and well-specified — all 5 detections are unambiguous given the input data.
- PRJ-108 is an interesting edge case: only 1 day in status but flagged as impediment with Blocker priority. The skill correctly detects it via Layer 0 (Flagged) rather than Layer 2 (Stale), which would miss it.
- PRJ-107 and PRJ-112 (both To Do) are correctly excluded — silence on unstarted work is expected per the skill spec. PRJ-107 is Low priority so the Blocker-priority TO DO exception does not apply.
- PRJ-103 matches both Stale (In Progress 6 days > 3-day threshold) and Silent (last updated 5 days ago > 3-day threshold), correctly tagged with both layers.
- PRJ-106 similarly matches both Stale and Silent — 4 days in status and 6 days since last update, with no PR activity reinforcing the stuck signal.
- No false positives: PRJ-101, PRJ-105, PRJ-107, PRJ-109, PRJ-110, PRJ-111, PRJ-112 all correctly excluded with clear rationale.
