# Golden Output: detect-stuck-tickets — stuck-tickets-scenario-1

Reference-quality output for regression testing. Generated from manual analysis of test case input.

## Input

Test case: `evals/test-cases/stuck-tickets-scenario-1.md`

## Expected Output

```
Stuck Tickets Found: 5

---

Ticket: PRJ-102
Summary: Payment gateway integration
Layer: Blocked
Status: Blocked (5 days)
Assignee: Bob
Priority: Critical
Estimate: 8 SP
Blocked by: EXT-50 (To Do — external team)
Last updated: 2026-03-06 (4 days ago)
PR: none
Severity: Critical — external dependency in To Do with 4 days remaining

---

Ticket: PRJ-108
Summary: Fix XSS vulnerability
Layer: Flagged
Status: In Progress (1 day)
Assignee: Bob
Priority: Blocker
Estimate: 2 SP
Flag: impediment label
Last updated: 2026-03-10 (today)
PR: open
Severity: Critical — Blocker priority with impediment flag

---

Ticket: PRJ-103
Summary: Email notification service
Layer: Stale + Silent
Status: In Progress (6 days)
Assignee: Carol
Priority: High
Estimate: 5 SP
Last updated: 2026-03-05 (5 days ago)
PR: draft (stale)
Severity: High — 6 days in progress, draft PR with no recent pushes

---

Ticket: PRJ-106
Summary: Search indexing optimization
Layer: Stale + Silent
Status: In Progress (4 days)
Assignee: Frank
Priority: Medium
Estimate: 3 SP
Last updated: 2026-03-04 (6 days ago)
PR: none
Severity: High — no PR and 6 days since last update

---

Ticket: PRJ-104
Summary: Dashboard widgets
Layer: Stale
Status: In Review (4 days)
Assignee: Dave
Priority: Medium
Estimate: 3 SP
Last updated: 2026-03-07 (3 days ago)
PR: open (no reviewer assigned)
Severity: Medium — in review 4 days with no review activity
```

**Summary**: 5 stuck tickets, 21 SP at risk (8+2+5+3+3). Highest severity: Critical (PRJ-102, PRJ-108). 1 external dependency blocker (EXT-50).

**Confidence**: High — all detection layers applied, input data is complete.

**Recommendations**:
1. **PRJ-102**: Escalate EXT-50 to the external team lead — 4 days remaining, 8 SP at risk.
2. **PRJ-108**: Coordinate security team sign-off — Blocker priority demands same-day resolution.
3. **PRJ-103**: Check in with Carol — 6 days stale with draft PR suggests hidden blocker.
4. **PRJ-106**: Nudge Frank — no PR and 6 days silent is the strongest stuck signal.
5. **PRJ-104**: Assign a reviewer to the open PR — 4 days in review with no activity.

## Verification Checklist

- [x] 5 tickets detected (PRJ-102, PRJ-108, PRJ-103, PRJ-106, PRJ-104)
- [x] 0 false positives (PRJ-101, 105, 107, 109, 110, 111, 112 excluded)
- [x] Correct layers per ticket
- [x] 21 SP at risk (8+2+5+3+3)
- [x] Severity accounts for days remaining (4)
- [x] Specific recommendations per ticket
