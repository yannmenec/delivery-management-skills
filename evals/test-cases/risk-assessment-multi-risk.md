# Test Case: Risk Assessment — Multiple Risks

## Skill Under Test

`assess-risk`

## Scenario

Mid-sprint assessment with 5 identifiable risks of varying severity. Tests the full scoring matrix (likelihood x impact) and RAG assignment.

## Input

```json
{
  "sprint_context": {
    "name": "Sprint 7",
    "start_date": "2026-03-09",
    "end_date": "2026-03-21",
    "days_remaining": 7
  },
  "sprint_tickets": [
    { "key": "PRJ-201", "summary": "Payment API migration", "status": "Blocked", "assignee": "Alex", "priority": "Critical", "story_points": 8, "days_in_current_status": 3, "linked_issues": [{"type": "is blocked by", "key": "INFRA-90", "status": "In Progress"}] },
    { "key": "PRJ-202", "summary": "User auth refactor", "status": "In Progress", "assignee": "Maria", "priority": "High", "story_points": 5, "days_in_current_status": 5, "pr_status": "draft" },
    { "key": "PRJ-203", "summary": "Search performance", "status": "In Progress", "assignee": "James", "priority": "High", "story_points": 5, "days_in_current_status": 2, "pr_status": "open" },
    { "key": "PRJ-204", "summary": "Billing page redesign", "status": "In Progress", "assignee": null, "priority": "Medium", "story_points": 3, "days_in_current_status": 4 },
    { "key": "PRJ-205", "summary": "API docs update", "status": "To Do", "assignee": "Priya", "priority": "Low", "story_points": 2, "days_in_current_status": 7 }
  ],
  "team_context": {
    "team_size": 5,
    "members_on_pto": ["Luca"],
    "velocity_last_3_sprints": [38, 42, 35]
  }
}
```

## Expected Results

### Expected Risks (5)

| # | Risk | Category | L (1-5) | I (1-5) | Expected Severity | Expected RAG |
|---|------|----------|---------|---------|-------------------|-------------|
| 1 | Payment API blocked by external dependency | Dependency | 4-5 | 5 | 20-25 | Red |
| 2 | Auth refactor stalling — 5 days with draft PR | Execution | 3-4 | 4 | 12-16 | Amber-Red |
| 3 | Unassigned billing redesign with no owner | Resource | 4 | 3 | 12 | Amber |
| 4 | Reduced capacity — 1 team member on PTO | Capacity | 5 | 2-3 | 10-15 | Amber |
| 5 | Declining velocity trend (38, 42, 35) | Predictability | 3 | 2 | 6 | Green-Amber |

### Scoring Criteria

- [ ] 5 risks identified (no fewer, no fabricated ones)
- [ ] Each risk has likelihood (1-5), impact (1-5), and severity (L*I)
- [ ] RAG assignment follows thresholds: 1-4 Green, 5-9 Amber, 10-15 Amber-Red, 16-25 Red
- [ ] Top risks have specific mitigations (not generic)
- [ ] Risk #1 rated highest (Critical + external dependency + blocked)
- [ ] No duplicate risks (blocked dependency is one risk, not two)
- [ ] Confidence level stated (Medium expected — sprint data provided but no historical risk data)

## Scoring

Apply `risk-assessment-rubric.md`. Expected score: 8-12.
