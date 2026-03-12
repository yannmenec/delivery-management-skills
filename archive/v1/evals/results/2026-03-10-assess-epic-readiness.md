# Eval: assess-epic-readiness — 2026-03-10

## Test Case
epic-readiness-mixed

## Model
Reference output (manual analysis of expected results)

## Skill Version
1.0.0

## Golden Output

```
Epic Readiness Assessment
=========================
Project: PRJ
Epics assessed: 3

Ready: 1
Partially Ready: 1
Not Ready: 1

---

PRJ-E1 — Real-time collaboration
Readiness: READY
Owner: Maria
Team: —
PI: 26.3
Children: 8 (8 with AC, 8 with estimates)
Description: PASS — Clear scope with measurable constraints (500ms latency, 50 concurrent users, business impact stated)
AC Coverage: 100% PASS — 5 specific, testable acceptance criteria
Estimates: 100% PASS — 8/8 tickets estimated, 34 SP total
Figma: PASS — https://figma.com/file/abc123/collab-design
Feature Flag: PASS — ff_realtime_collab
Dependencies: PASS
  INFRA-100: WebSocket infrastructure — Done

---

PRJ-E2 — Advanced search
Readiness: PARTIALLY READY
Owner: James
Team: —
PI: 26.3
Children: 3 (1 with AC, 2 with estimates)
Description: PARTIAL — Brief description ("Improve search with filters and relevance ranking"), missing constraints, user impact, and scope boundaries
AC Coverage: 33% FAIL — Only 1 acceptance criterion ("Users can filter by date, type, and author"), insufficient for a full epic
Estimates: 0% FAIL — No story points assigned (total_story_points: null), only 2 of 3 tickets estimated
Figma: FAIL — No design link for a search UI feature
Feature Flag: FAIL — None defined for a user-facing feature
Dependencies: PASS — No dependencies declared

Gaps:
- Description needs expansion: add scope boundaries, performance constraints, user impact
- AC coverage insufficient: 1 criterion for an entire epic — needs 3+ testable ACs
- No story point estimates assigned to any ticket
- No Figma design link — search UI requires design specs
- No feature flag defined — user-facing feature should be flaggable

---

PRJ-E3 — Analytics dashboard
Readiness: NOT READY
Owner: Unassigned
Team: —
PI: 26.3
Children: 0
Description: FAIL — Null description
AC Coverage: N/A FAIL — No children, empty acceptance criteria array
Estimates: N/A FAIL — No tickets, no story points
Figma: FAIL — No design link
Feature Flag: FAIL — None defined
Dependencies: FAIL
  DATA-50: Data pipeline v2 — To Do (not started, at risk)

Gaps:
- No description — epic purpose and scope are undefined
- No child tickets — epic has no breakdown at all
- No acceptance criteria
- No estimates
- No design link
- No feature flag
- Dependency DATA-50 is in To Do — not started, blocks this epic
- No owner assigned — nobody accountable for readiness

---

Aggregate Summary

| Classification    | Count | Percentage |
|-------------------|-------|------------|
| Ready             | 1     | 33%        |
| Partially Ready   | 1     | 33%        |
| Not Ready         | 1     | 33%        |

Planning readiness: Proceed with caveats — 1 of 3 epics is ready for commitment.
PRJ-E2 needs refinement (estimation, design, feature flag) before it can be committed.
PRJ-E3 requires significant work and should not enter the PI plan until description,
breakdown, estimates, and owner are in place. DATA-50 dependency must be resolved.
```

## Scoring

### Rubric Dimensions (or Self-Check)
| Dimension | Weight | Score | Weighted | Notes |
|-----------|--------|-------|----------|-------|
| All numbers trace to provided data | 1 | 1/1 | 1 | Child counts (8, 3, 0), SP (34, null, null), AC counts (5, 1, 0), dependency statuses (Done, To Do) all from input JSON |
| No empty sections | 1 | 1/1 | 1 | All 3 epics assessed with all 7 dimensions, gaps listed for non-Ready, aggregate summary present |
| At least one specific evidence reference | 1 | 1/1 | 1 | Figma URL, feature flag name `ff_realtime_collab`, dependency keys INFRA-100 and DATA-50 cited |
| Confidence level stated | 1 | 1/1 | 1 | Planning readiness recommendation with per-epic actionable guidance |
| At least one actionable recommendation | 1 | 1/1 | 1 | Specific gaps per epic: expand description, add ACs, assign owner, resolve DATA-50 dependency |

### Total Score: 5/5

### Verdict: Pass

## Observations

- **PRJ-E1** is a clean Ready — all 7 dimensions score 2/2 (14/14). Description has measurable constraints, 5 ACs, full estimation, Figma link, feature flag, dependency already Done, and owner assigned. No gaps.
- **PRJ-E2** scores 6/14 (Description 1, AC 1, Estimation 0, Design 0, Feature Flag 0, Dependencies 2, Owner 2). The owner and lack of dependencies keep it from Not Ready. Key failure: zero story points despite having 3 child tickets. Only 1 AC is a significant gap for a full epic.
- **PRJ-E3** scores 0/14 — every dimension fails. Null description, no children, no AC, no SP, no design, no flag, unassigned, and its only dependency (DATA-50) is in To Do. This epic is not plannable.
- The 3-epic test case exercises the full classification spectrum (Ready / Partially Ready / Not Ready) and boundary conditions (null fields, empty arrays, dependency status variants).
- No fabricated data detected — all values trace directly to the input JSON structure.
