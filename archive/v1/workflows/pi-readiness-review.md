---
name: pi-readiness-review
version: 1.0.0
description: Pre-planning workflow that assesses whether epics, capacity, and dependencies are ready for PI commitment.
type: workflow
skills_used:
  - assess-epic-readiness
  - compute-capacity
  - assess-risk
  - format-for-audience
  - self-check
estimated_duration: 3-5 minutes
---

# PI Readiness Review

Pre-planning workflow that answers the question: "Are we ready to enter PI planning?" Evaluates epic maturity, team capacity, and dependency risks to produce a readiness verdict with specific gaps to close.

## Purpose

Prevent teams from entering PI planning sessions with half-baked epics, unknown capacity, or unresolved dependencies. This workflow runs 1-2 weeks before planning and surfaces what still needs preparation.

## Workflow

```
┌─────────────────────────────────┐
│  Epics + Team Data + Deps       │
│  (candidate epics for the PI)   │
└──────────────┬──────────────────┘
               │
         ┌─────┴─────┐
         │  PARALLEL  │
         ├────────────┤
         ▼            ▼            ▼
  ┌────────────┐ ┌──────────┐ ┌──────────┐
  │   Epic     │ │ Compute  │ │  Assess  │
  │ Readiness  │ │ Capacity │ │   Risk   │
  └─────┬──────┘ └────┬─────┘ └────┬─────┘
        │              │            │
        └──────────────┼────────────┘
                       │
                       ▼
              ┌────────────────┐
              │   Synthesize   │
              │   Readiness    │
              │    Verdict     │
              └───────┬────────┘
                      │
                      ▼
              ┌────────────────┐
              │   Self-Check   │
              └───────┬────────┘
                      │
                      ▼
              ┌────────────────┐
              │    Output:     │
              │  PI Readiness  │
              │    Report      │
              └────────────────┘
```

## Steps

### Step 1: Gather inputs

Collect:
- **Candidate epics**: Epics being considered for the PI, with descriptions, acceptance criteria, child tickets, and dependencies
- **Team data**: Team members, roles, allocation, known PTO for the PI period
- **PI dates**: Start date, end date, sprint boundaries within the PI
- **Known dependencies**: Cross-team or external dependencies related to candidate epics

### Step 2: Run assessments in parallel

Execute simultaneously:

1. **assess-epic-readiness**: Score each candidate epic across 7 readiness dimensions
2. **compute-capacity**: Calculate plannable capacity for the PI (accounting for PTO, buffer)
3. **assess-risk**: Identify risks to the PI from dependencies, capacity gaps, technical unknowns

### Step 3: Synthesize readiness verdict

Combine the three assessments into an overall PI readiness verdict:

| Verdict | Criteria |
|---------|----------|
| **Ready** | ≥80% of epics are Ready, capacity covers estimated scope, no Red risks |
| **Conditionally Ready** | 50-80% of epics Ready, capacity is tight, or 1-2 Amber risks |
| **Not Ready** | <50% of epics Ready, capacity gap, or Red risks unmitigated |

For "Conditionally Ready," list the specific conditions that must be met before planning:
- Epics that need readiness gaps closed (with specific gaps)
- Capacity adjustments needed
- Risks that need mitigation

### Step 4: Compute commitment guidance

Based on capacity and velocity:
- **Maximum scope**: What the team could deliver if everything goes perfectly (plannable capacity in SP)
- **Recommended commitment**: Maximum scope minus buffer for risk (typically 80-85% of maximum)
- **Stretch target**: Items beyond commitment that can be pulled in if capacity allows

### Step 5: Run self-check

Validate the report for numeric consistency, evidence, and actionable recommendations.

## Output Format

```
## PI Readiness Review

**PI**: {PI name/number}
**Dates**: {start} to {end} ({N} sprints)
**Team**: {team name}
**Review Date**: {date}

### Verdict: {Ready | Conditionally Ready | Not Ready}

{One-paragraph justification with key data points.}

### Epic Readiness

| Epic | Score | Classification | Key Gaps |
|------|-------|---------------|----------|
| {title} | {N}/14 | {Ready|Partial|Not Ready} | {gaps or "None"} |
| ... | ... | ... | ... |

**Summary**: {N} Ready, {N} Partially Ready, {N} Not Ready out of {total} epics.

### Capacity

| Metric | Value |
|--------|-------|
| Plannable capacity | {N} dev-days (~{N} SP) |
| Estimated scope | {N} SP (from estimated epics) |
| Coverage ratio | {%} |

{Interpretation: "Capacity covers estimated scope with {N}% buffer" or "Capacity gap of {N} SP — descope or add capacity needed."}

### Risks

| Risk | Severity | RAG | Mitigation |
|------|----------|-----|-----------|
| {description} | {score} | {RAG} | {status} |
| ... | ... | ... | ... |

### Commitment Guidance

- **Recommended commitment**: ~{N} SP across {N} epics
- **Stretch**: {N} SP ({epic names})
- **Buffer**: {N}% reserved for unplanned work

### Actions Before Planning

1. {Specific action — e.g., "Close readiness gaps on Epic X: add acceptance criteria and identify dependencies"}
2. {Specific action — e.g., "Confirm Platform team delivery date for dependency PLAT-123"}
3. {Specific action}

**Confidence**: {High|Medium|Low} — {justification}
```

## Error Handling

- If no epics are provided: report cannot be generated. Return: "No candidate epics provided — PI readiness review requires at least one epic to evaluate."
- If capacity data is incomplete: compute capacity with available data and note assumptions.
- If this is the team's first PI: note "No historical PI data available — commitment guidance is based on sprint velocity only."
