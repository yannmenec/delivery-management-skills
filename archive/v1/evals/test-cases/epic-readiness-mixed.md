# Test Case: Epic Readiness — Mixed Classification

## Skill Under Test

`assess-epic-readiness`

## Scenario

Pre-PI planning review of 3 epics with varying levels of readiness. Tests the full classification spectrum: Ready, Partially Ready, Not Ready.

## Input

```json
{
  "planning_context": {
    "period": "PI 26.3",
    "planning_date": "2026-04-06"
  },
  "epics": [
    {
      "key": "PRJ-E1",
      "summary": "Real-time collaboration",
      "description": "Enable real-time editing of shared documents. Users can see each other's cursors and changes propagate within 500ms. Must support 50 concurrent users per document.",
      "acceptance_criteria": [
        "Users see live cursors of other editors",
        "Changes propagate within 500ms",
        "Supports 50 concurrent users per document",
        "Conflict resolution handles simultaneous edits",
        "Works on mobile and desktop"
      ],
      "child_tickets": 8,
      "estimated_tickets": 8,
      "total_story_points": 34,
      "design_link": "https://figma.com/file/abc123/collab-design",
      "feature_flag": "ff_realtime_collab",
      "dependencies": [{ "key": "INFRA-100", "summary": "WebSocket infrastructure", "status": "Done" }],
      "owner": "Maria"
    },
    {
      "key": "PRJ-E2",
      "summary": "Advanced search",
      "description": "Improve search with filters and relevance ranking.",
      "acceptance_criteria": [
        "Users can filter by date, type, and author"
      ],
      "child_tickets": 3,
      "estimated_tickets": 2,
      "total_story_points": null,
      "design_link": null,
      "feature_flag": null,
      "dependencies": [],
      "owner": "James"
    },
    {
      "key": "PRJ-E3",
      "summary": "Analytics dashboard",
      "description": null,
      "acceptance_criteria": [],
      "child_tickets": 0,
      "estimated_tickets": 0,
      "total_story_points": null,
      "design_link": null,
      "feature_flag": null,
      "dependencies": [{ "key": "DATA-50", "summary": "Data pipeline v2", "status": "To Do" }],
      "owner": null
    }
  ]
}
```

## Expected Results

### PRJ-E1 (Real-time collaboration): Ready

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Description | 2 (Complete) | Clear what/why/constraints with measurable criteria |
| Acceptance Criteria | 2 (Complete) | 5 specific, testable ACs |
| Estimation | 2 (Complete) | 8 tickets, 34 SP — fully estimated |
| Design | 2 (Complete) | Figma link present |
| Feature Flag | 2 (Complete) | `ff_realtime_collab` defined |
| Dependencies | 2 (Clear) | 1 dependency, already Done |
| Owner | 2 (Assigned) | Maria |

Classification: **Ready** (14/14)

### PRJ-E2 (Advanced search): Partially Ready

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Description | 1 (Partial) | Brief — missing constraints, user impact, scope boundaries |
| Acceptance Criteria | 1 (Partial) | Only 1 AC, insufficient for a full epic |
| Estimation | 0 (Missing) | No story points, only 2 of 3 tickets estimated |
| Design | 0 (Missing) | No design link |
| Feature Flag | 0 (Missing) | None defined |
| Dependencies | 2 (Clear) | No dependencies |
| Owner | 2 (Assigned) | James |

Classification: **Partially Ready** (6/14)

### PRJ-E3 (Analytics dashboard): Not Ready

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Description | 0 (Missing) | Null description |
| Acceptance Criteria | 0 (Missing) | Empty array |
| Estimation | 0 (Missing) | No tickets, no SP |
| Design | 0 (Missing) | No link |
| Feature Flag | 0 (Missing) | None |
| Dependencies | 0 (At Risk) | DATA-50 is in To Do — not started |
| Owner | 0 (Missing) | Null |

Classification: **Not Ready** (0/14)

### Aggregate Summary

| Classification | Count | Percentage |
|---------------|-------|-----------|
| Ready | 1 | 33% |
| Partially Ready | 1 | 33% |
| Not Ready | 1 | 33% |

**Planning readiness**: Proceed with caveats — 1 of 3 epics is ready, 1 needs refinement, 1 needs significant work.

## Scoring

- [ ] PRJ-E1 classified as Ready
- [ ] PRJ-E2 classified as Partially Ready
- [ ] PRJ-E3 classified as Not Ready
- [ ] Each dimension scored with rationale
- [ ] Missing dependency (DATA-50 in To Do) flagged as risk for PRJ-E3
- [ ] Specific gaps listed for each non-Ready epic
- [ ] Aggregate summary present with planning readiness recommendation
- [ ] No fabricated data or dimensions
