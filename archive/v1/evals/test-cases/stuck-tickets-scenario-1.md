# Test Case: Stuck Tickets — Mixed Sprint

## Skill Under Test

`detect-stuck-tickets`

## Scenario

A 2-week sprint at Day 8 with 12 tickets. The data contains a mix of healthy tickets, explicitly blocked tickets, stale tickets, and silent tickets. Tests all 4 detection layers.

## Input

```json
{
  "sprint_context": {
    "name": "Sprint 5",
    "start_date": "2026-03-02",
    "end_date": "2026-03-14",
    "days_remaining": 4
  },
  "threshold_days": 3,
  "sprint_tickets": [
    { "key": "PRJ-101", "summary": "User login flow", "status": "Done", "assignee": "Alice", "priority": "High", "story_points": 5, "days_in_current_status": 2, "last_updated": "2026-03-09", "pr_status": "merged" },
    { "key": "PRJ-102", "summary": "Payment gateway integration", "status": "Blocked", "assignee": "Bob", "priority": "Critical", "story_points": 8, "days_in_current_status": 5, "last_updated": "2026-03-06", "linked_issues": [{"type": "is blocked by", "key": "EXT-50", "status": "To Do"}], "pr_status": "none" },
    { "key": "PRJ-103", "summary": "Email notification service", "status": "In Progress", "assignee": "Carol", "priority": "High", "story_points": 5, "days_in_current_status": 6, "last_updated": "2026-03-05", "pr_status": "draft" },
    { "key": "PRJ-104", "summary": "Dashboard widgets", "status": "In Review", "assignee": "Dave", "priority": "Medium", "story_points": 3, "days_in_current_status": 4, "last_updated": "2026-03-07", "pr_status": "open" },
    { "key": "PRJ-105", "summary": "API rate limiting", "status": "In Progress", "assignee": "Eve", "priority": "High", "story_points": 5, "days_in_current_status": 2, "last_updated": "2026-03-09", "pr_status": "open" },
    { "key": "PRJ-106", "summary": "Search indexing optimization", "status": "In Progress", "assignee": "Frank", "priority": "Medium", "story_points": 3, "days_in_current_status": 4, "last_updated": "2026-03-04", "pr_status": "none" },
    { "key": "PRJ-107", "summary": "Data export feature", "status": "To Do", "assignee": "Alice", "priority": "Low", "story_points": 3, "days_in_current_status": 8, "last_updated": "2026-03-02", "pr_status": "none" },
    { "key": "PRJ-108", "summary": "Fix XSS vulnerability", "status": "In Progress", "assignee": "Bob", "priority": "Blocker", "story_points": 2, "days_in_current_status": 1, "last_updated": "2026-03-10", "pr_status": "open", "labels": ["impediment"] },
    { "key": "PRJ-109", "summary": "User profile settings", "status": "Done", "assignee": "Carol", "priority": "Medium", "story_points": 3, "days_in_current_status": 4, "last_updated": "2026-03-07", "pr_status": "merged" },
    { "key": "PRJ-110", "summary": "Audit log implementation", "status": "In Progress", "assignee": "Dave", "priority": "High", "story_points": 5, "days_in_current_status": 1, "last_updated": "2026-03-10", "pr_status": "draft" },
    { "key": "PRJ-111", "summary": "Cache invalidation fix", "status": "In Review", "assignee": "Eve", "priority": "High", "story_points": 3, "days_in_current_status": 1, "last_updated": "2026-03-10", "pr_status": "approved" },
    { "key": "PRJ-112", "summary": "Onboarding tutorial", "status": "To Do", "assignee": null, "priority": "Medium", "story_points": 5, "days_in_current_status": 8, "last_updated": "2026-03-02", "pr_status": "none" }
  ]
}
```

## Expected Results

### Tickets that SHOULD be detected (5)

| Key | Expected Layers | Severity | Rationale |
|-----|----------------|----------|-----------|
| PRJ-102 | Blocked | Critical | Explicitly Blocked, Critical priority, 5 days, external dependency in To Do, 4 days left in sprint |
| PRJ-108 | Flagged | Critical | Flagged impediment, Blocker priority — even though only 1 day in status, the flag + priority warrants Critical |
| PRJ-103 | Stale + Silent | High | In Progress 6 days, last updated 6 days ago, draft PR suggests work stalled |
| PRJ-106 | Stale + Silent | High | In Progress 4 days, last updated 7 days ago, no PR — strongest silent signal |
| PRJ-104 | Stale | Medium | In Review 4 days, PR open but no review activity |

### Tickets that should NOT be detected

| Key | Rationale |
|-----|-----------|
| PRJ-101 | Done — not in scope |
| PRJ-105 | In Progress only 2 days, recently updated, has open PR — healthy |
| PRJ-107 | To Do status — silence on unstarted work is expected (and not Blocker priority) |
| PRJ-109 | Done |
| PRJ-110 | In Progress only 1 day, recently updated — healthy |
| PRJ-111 | In Review only 1 day, PR approved — about to move |
| PRJ-112 | To Do, unassigned — not started, not stuck (unassigned is a separate concern) |

### Expected Summary

- 5 stuck tickets found
- 21 story points at risk (8 + 2 + 5 + 3 + 3)
- Highest severity: Critical (PRJ-102, PRJ-108)
- 1 external dependency blocker (EXT-50)

## Scoring

Use the `self-check` skill on the output. All 5 checks should pass. Additionally:

- [ ] Correct ticket count (5)
- [ ] Correct detection layers per ticket
- [ ] Severity scoring accounts for sprint days remaining (4 days)
- [ ] Recommended actions are specific to each ticket's situation
- [ ] Story points at risk are summed correctly
- [ ] No false positives (healthy tickets not flagged)
- [ ] No false negatives (stuck tickets not missed)
