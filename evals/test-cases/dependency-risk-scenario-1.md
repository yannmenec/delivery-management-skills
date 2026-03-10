# Test Case: Dependency Risk — Mixed Sprint

## Skill Under Test

`detect-dependency-risk`

## Scenario

Day 7 of a 2-week sprint with 8 tickets. The data contains cross-team dependencies, an intra-team dependency, a cascading chain, and a resolved dependency. Tests all classification types and risk scoring.

## Input

```json
{
  "sprint_context": {
    "name": "Sprint 10",
    "start_date": "2026-03-09",
    "end_date": "2026-03-21",
    "days_remaining": 5
  },
  "team_name": "Horizon",
  "sprint_tickets": [
    {
      "key": "HRZ-501",
      "summary": "Payment gateway integration",
      "status": "Blocked",
      "assignee": "Alice",
      "priority": "Critical",
      "story_points": 8,
      "linked_issues": [
        { "type": "is blocked by", "key": "PLAT-200", "status": "To Do", "team": "Platform" }
      ]
    },
    {
      "key": "HRZ-502",
      "summary": "Checkout flow redesign",
      "status": "In Progress",
      "assignee": "Bob",
      "priority": "High",
      "story_points": 5,
      "linked_issues": [
        { "type": "is blocked by", "key": "HRZ-501", "status": "Blocked" }
      ]
    },
    {
      "key": "HRZ-503",
      "summary": "Notification service update",
      "status": "In Progress",
      "assignee": "Carol",
      "priority": "High",
      "story_points": 5,
      "linked_issues": [
        { "type": "is blocked by", "key": "MSG-300", "status": "In Progress", "team": "Messaging" }
      ]
    },
    {
      "key": "HRZ-504",
      "summary": "User profile migration",
      "status": "In Progress",
      "assignee": "Dave",
      "priority": "Medium",
      "story_points": 3,
      "linked_issues": [
        { "type": "is blocked by", "key": "HRZ-505", "status": "In Review" }
      ]
    },
    {
      "key": "HRZ-505",
      "summary": "Database schema update",
      "status": "In Review",
      "assignee": "Dave",
      "priority": "Medium",
      "story_points": 3,
      "linked_issues": [
        { "type": "blocks", "key": "HRZ-504", "status": "In Progress" }
      ]
    },
    {
      "key": "HRZ-506",
      "summary": "Analytics dashboard",
      "status": "In Progress",
      "assignee": "Eve",
      "priority": "Medium",
      "story_points": 3,
      "linked_issues": [
        { "type": "is blocked by", "key": "DATA-400", "status": "Done", "team": "Data" }
      ]
    },
    {
      "key": "HRZ-507",
      "summary": "SSO integration",
      "status": "To Do",
      "assignee": "Frank",
      "priority": "High",
      "story_points": 8,
      "linked_issues": [
        { "type": "is blocked by", "key": "AUTH-500", "status": "Blocked", "team": "Identity" }
      ]
    },
    {
      "key": "HRZ-508",
      "summary": "API documentation update",
      "status": "In Progress",
      "assignee": "Alice",
      "priority": "Low",
      "story_points": 2,
      "linked_issues": []
    }
  ]
}
```

## Expected Results

### Dependencies that SHOULD be flagged (4)

| # | Blocked | Blocker | Type | Blocker Status | Risk Level | Score Range | Key Signals |
|---|---------|---------|------|---------------|-----------|-------------|-------------|
| 1 | HRZ-501 (8 SP) | PLAT-200 (Platform) | External | To Do | Critical | 10-12 | Blocker not started, 5 days left, 8 SP at stake, external team |
| 2 | HRZ-502 (5 SP) | HRZ-501 (Blocked) | Cascading | Blocked | Critical | 10-12 | Chain: PLAT-200 → HRZ-501 → HRZ-502, blocker itself blocked |
| 3 | HRZ-507 (8 SP) | AUTH-500 (Identity) | External | Blocked | Critical | 10-12 | Blocker is Blocked, external team, 8 SP, 5 days left |
| 4 | HRZ-503 (5 SP) | MSG-300 (Messaging) | External | In Progress | Medium-High | 6-8 | Blocker is progressing but external, 5 SP, 5 days left |

### Dependencies that should NOT be flagged

| Blocked | Blocker | Reason |
|---------|---------|--------|
| HRZ-504 | HRZ-505 | Intra-team, same assignee (Dave), blocker In Review — personal sequencing |
| HRZ-506 | DATA-400 | Blocker is Done — resolved dependency |
| HRZ-508 | — | No dependency links |

### Cascading Chain

PLAT-200 (To Do, Platform) → HRZ-501 (Blocked, Horizon) → HRZ-502 (In Progress, Horizon)

This chain means HRZ-502's 5 SP and HRZ-501's 8 SP are both at risk from a single upstream blocker (PLAT-200) that hasn't even started.

### Summary Metrics

- 4 active dependency risks
- 3 Critical, 1 Medium-High (approximate)
- 26 SP at risk (8 + 5 + 8 + 5)
- 1 cascading chain (depth 2)

## Scoring

- [ ] 4 dependencies detected (HRZ-501→PLAT-200, HRZ-502→HRZ-501, HRZ-507→AUTH-500, HRZ-503→MSG-300)
- [ ] HRZ-504→HRZ-505 excluded (same assignee, intra-team)
- [ ] HRZ-506→DATA-400 excluded (resolved — blocker is Done)
- [ ] HRZ-508 excluded (no links)
- [ ] Cascading chain detected (PLAT-200 → HRZ-501 → HRZ-502)
- [ ] Risk scores differentiate Critical from Medium dependencies
- [ ] Cross-team correctly identified for PLAT-200 (Platform), AUTH-500 (Identity), MSG-300 (Messaging)
- [ ] Recommended actions are specific (escalation for Critical, check-in for Medium)
- [ ] SP at risk summed correctly
- [ ] No fabricated dependencies or teams
