# Test Case: Scope Change — Mid-Sprint Detection

## Skill Under Test

`detect-scope-change`

## Scenario

Day 6 of a 2-week sprint. 3 tickets were added after sprint start and 1 was removed. Tests addition detection, removal detection, and stability classification.

## Input

```json
{
  "sprint_context": {
    "name": "Sprint 8",
    "start_date": "2026-03-09",
    "end_date": "2026-03-21",
    "current_date": "2026-03-14"
  },
  "sprint_tickets": [
    { "key": "PRJ-301", "summary": "Login flow redesign", "status": "In Progress", "story_points": 5, "created": "2026-03-05", "added_to_sprint": "2026-03-09" },
    { "key": "PRJ-302", "summary": "Dashboard analytics", "status": "In Progress", "story_points": 3, "created": "2026-03-07", "added_to_sprint": "2026-03-09" },
    { "key": "PRJ-303", "summary": "Hotfix: checkout crash", "status": "Done", "story_points": 2, "created": "2026-03-11", "added_to_sprint": "2026-03-11", "priority": "Blocker" },
    { "key": "PRJ-304", "summary": "Performance monitoring", "status": "In Progress", "story_points": 5, "created": "2026-03-08", "added_to_sprint": "2026-03-09" },
    { "key": "PRJ-305", "summary": "Accessibility audit", "status": "To Do", "story_points": 3, "created": "2026-03-12", "added_to_sprint": "2026-03-12" },
    { "key": "PRJ-306", "summary": "Rate limiter update", "status": "To Do", "story_points": 3, "created": "2026-03-13", "added_to_sprint": "2026-03-13" },
    { "key": "PRJ-307", "summary": "API docs v2", "status": "In Progress", "story_points": 2, "created": "2026-03-06", "added_to_sprint": "2026-03-09" }
  ],
  "removed_tickets": [
    { "key": "PRJ-308", "summary": "Legacy migration script", "story_points": 5, "removed_date": "2026-03-11", "reason": "Descoped to next sprint" }
  ],
  "original_commitment": {
    "ticket_count": 5,
    "story_points": 20
  }
}
```

## Expected Results

### Additions (3 tickets, +8 SP)

| Key | Summary | SP | Added Date | Classification |
|-----|---------|----|-----------|-|
| PRJ-303 | Hotfix: checkout crash | 2 | Mar 11 | Unplanned — reactive hotfix |
| PRJ-305 | Accessibility audit | 3 | Mar 12 | Unplanned — mid-sprint addition |
| PRJ-306 | Rate limiter update | 3 | Mar 13 | Unplanned — mid-sprint addition |

### Removals (1 ticket, -5 SP)

| Key | Summary | SP | Removed Date | Reason |
|-----|---------|----|-----------|-|
| PRJ-308 | Legacy migration script | 5 | Mar 11 | Descoped to next sprint |

### Summary Metrics

| Metric | Value |
|--------|-------|
| Original commitment | 5 tickets / 20 SP |
| Added | +3 tickets / +8 SP |
| Removed | -1 ticket / -5 SP |
| Net change | +2 tickets / +3 SP |
| Current scope | 7 tickets / 23 SP |
| Stability rating | Moderate (15% net SP change) |

## Scoring

- [ ] 3 additions correctly identified (PRJ-303, PRJ-305, PRJ-306)
- [ ] 1 removal correctly identified (PRJ-308)
- [ ] Net change calculated correctly (+2 tickets, +3 SP)
- [ ] Stability classification reasonable (Moderate or Volatile — 15% change by Day 6)
- [ ] Hotfix (PRJ-303) distinguished from regular scope additions
- [ ] PRJ-301, PRJ-302, PRJ-304, PRJ-307 NOT flagged (added on sprint start date)
- [ ] No fabricated tickets or numbers
