# Test Case: Truth Audit — Phantom Progress Detection

## Skill Under Test

`detect-ghost-done` (v1.1.0 — truth audit layer, Step 8)

## Scenario

Day 7 of a 2-week sprint. 10 tickets with varying PR activity levels. Tests the truth audit layer's ability to distinguish genuine progress from phantom progress, and to degrade gracefully when PR data is missing.

## Input

```json
{
  "sprint_context": {
    "name": "Sprint 9",
    "start_date": "2026-03-09",
    "end_date": "2026-03-21",
    "days_remaining": 5
  },
  "sprint_tickets": [
    {
      "key": "AUD-101",
      "summary": "Refactor auth middleware",
      "status": "In Progress",
      "assignee": "Alice",
      "priority": "High",
      "story_points": 5,
      "days_in_current_status": 5,
      "pr_status": "none"
    },
    {
      "key": "AUD-102",
      "summary": "Migrate billing service",
      "status": "In Progress",
      "assignee": "Bob",
      "priority": "Critical",
      "story_points": 8,
      "days_in_current_status": 6,
      "pr_status": "draft"
    },
    {
      "key": "AUD-103",
      "summary": "Dashboard performance fix",
      "status": "In Review",
      "assignee": "Carol",
      "priority": "High",
      "story_points": 5,
      "days_in_current_status": 4,
      "pr_status": "none"
    },
    {
      "key": "AUD-104",
      "summary": "Search API pagination",
      "status": "In Review",
      "assignee": "Dave",
      "priority": "Medium",
      "story_points": 3,
      "days_in_current_status": 6,
      "pr_status": "open"
    },
    {
      "key": "AUD-105",
      "summary": "User settings redesign",
      "status": "In Progress",
      "assignee": "Eve",
      "priority": "High",
      "story_points": 5,
      "days_in_current_status": 2,
      "pr_status": "open"
    },
    {
      "key": "AUD-106",
      "summary": "Notification service refactor",
      "status": "In Review",
      "assignee": "Frank",
      "priority": "High",
      "story_points": 5,
      "days_in_current_status": 1,
      "pr_status": "approved"
    },
    {
      "key": "AUD-107",
      "summary": "Export feature",
      "status": "Done",
      "assignee": "Alice",
      "priority": "Medium",
      "story_points": 3,
      "pr_status": "merged"
    },
    {
      "key": "AUD-108",
      "summary": "Cache layer optimization",
      "status": "In Progress",
      "assignee": "Bob",
      "priority": "Medium",
      "story_points": 3,
      "days_in_current_status": 4,
      "pr_status": "open"
    },
    {
      "key": "AUD-109",
      "summary": "Logging infrastructure",
      "status": "In Progress",
      "assignee": "Carol",
      "priority": "Low",
      "story_points": 2,
      "days_in_current_status": 5
    },
    {
      "key": "AUD-110",
      "summary": "Rate limiter update",
      "status": "To Do",
      "assignee": "Dave",
      "priority": "Medium",
      "story_points": 3,
      "pr_status": "none"
    }
  ]
}
```

## Expected Results — Truth Audit Layer

### Tickets that SHOULD be flagged (4)

| Key | Status | Days | PR Status | Finding | Confidence |
|-----|--------|------|-----------|---------|-----------|
| AUD-101 | In Progress | 5 | none | Phantom progress — 5 days with no PR | Medium |
| AUD-102 | In Progress | 6 | draft | Stale draft — 6 days, PR still in draft after 5-day threshold | Medium-High |
| AUD-103 | In Review | 4 | none | Phantom review — in review 4 days but no reviewable PR | High |
| AUD-104 | In Review | 6 | open | Stale review — PR open 6 days with no completion | Medium |

### Tickets that should NOT be flagged

| Key | Status | Days | PR Status | Reason Not Flagged |
|-----|--------|------|-----------|-------------------|
| AUD-105 | In Progress | 2 | open | Only 2 days — below 3-day threshold, has active PR |
| AUD-106 | In Review | 1 | approved | Only 1 day, PR approved — about to complete |
| AUD-107 | Done | — | merged | Terminal status — excluded from truth audit |
| AUD-108 | In Progress | 4 | open | Has open PR — genuine progress signal despite 4 days |
| AUD-109 | In Progress | 5 | (missing) | PR data missing — graceful degradation, not flagged |
| AUD-110 | To Do | — | none | Not started — truth audit only applies to In Progress / In Review |

### Expected Ghost-Done Findings

None — no tickets have 2+ done signals (merged PR + released version + deployment label).

### Graceful Degradation

AUD-109 has no `pr_status` field. The truth audit should note: "AUD-109 skipped — PR data unavailable" and continue with remaining tickets.

### Summary

- 0 ghost-done tickets (standard detection)
- 4 phantom-progress tickets (truth audit)
- 18 SP at risk from phantom progress (5+8+5+3)

## Scoring

- [ ] 4 phantom-progress tickets detected (AUD-101, AUD-102, AUD-103, AUD-104)
- [ ] Correct finding type per ticket (phantom progress, stale draft, phantom review, stale review)
- [ ] 0 false positives (AUD-105, AUD-106, AUD-107, AUD-108, AUD-109, AUD-110 not flagged)
- [ ] AUD-109 handled via graceful degradation (noted as skipped, not flagged)
- [ ] AUD-108 NOT flagged — has open PR, which is genuine progress
- [ ] SP at risk summed correctly (18 SP)
- [ ] Confidence levels differentiated (Medium through High)
- [ ] Ghost-done section reports "none found" (no 2-signal matches)
