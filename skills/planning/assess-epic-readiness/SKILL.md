---
name: assess-epic-readiness
version: 1.0.0
description: Evaluates whether epics are ready for PI or quarter planning by scoring 7 readiness dimensions.
category: planning
trigger: PI planning preparation, quarterly planning, backlog grooming, epic review.
autonomy: supervised
portability: universal
complexity: intermediate
type: evaluation
inputs:
  - name: epics
    type: structured-text
    required: true
    description: >
      List of epics to evaluate. Per epic: title, description, acceptance criteria,
      child tickets (with estimates if available), linked design artifacts,
      technical approach notes, identified dependencies, rollout strategy.
  - name: readiness_standard
    type: text
    required: false
    description: >
      Custom readiness expectations. If not provided, the default 7-dimension
      framework is used.
outputs:
  - name: readiness_report
    type: structured-text
    description: >
      Per-epic scorecard with dimension scores, overall classification
      (Ready / Partially Ready / Not Ready), and specific gaps to address.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Assess Epic Readiness

Evaluate whether epics meet a quality bar for planning commitment. Prevents teams from committing to poorly defined work that will derail mid-sprint.

## When to Apply

- Before PI or quarterly planning sessions
- During backlog grooming when epics are promoted to "ready for planning"
- When a Delivery Manager needs to assess whether a set of epics is plannable
- As a gate before adding epics to a PI commitment table

## Method

### Step 1: Score each epic across 7 dimensions

For each epic, evaluate these dimensions independently. Score each: Ready (2), Partial (1), Missing (0).

**Dimension 1 — Problem Statement and User Value**

Does the epic clearly articulate what problem it solves and why it matters?

| Score | Criteria |
|-------|----------|
| 2 (Ready) | Clear problem statement, target user identified, business value articulated, success metrics defined |
| 1 (Partial) | Problem is understood but vaguely stated, or value is assumed but not quantified |
| 0 (Missing) | No description, or description is a technical task with no user context |

**Dimension 2 — Acceptance Criteria**

Are the conditions for "done" clearly defined?

| Score | Criteria |
|-------|----------|
| 2 (Ready) | Testable acceptance criteria listed (3+ criteria for a typical epic), edge cases considered |
| 1 (Partial) | Some criteria exist but are vague ("it should work well") or incomplete |
| 0 (Missing) | No acceptance criteria defined |

**Dimension 3 — Breakdown and Estimation**

Has the epic been decomposed into plannable child tickets with estimates?

| Score | Criteria |
|-------|----------|
| 2 (Ready) | Child tickets created, 80%+ have story point estimates, total scope is clear |
| 1 (Partial) | Some child tickets exist but <50% estimated, or breakdown is too coarse |
| 0 (Missing) | No child tickets, or epic is a single monolithic item |

**Dimension 4 — Design and UX**

Are design decisions made and artifacts available?

| Score | Criteria |
|-------|----------|
| 2 (Ready) | Design artifacts linked (mockups, wireframes, prototypes), design review completed |
| 1 (Partial) | Design direction agreed but artifacts incomplete, or design review pending |
| 0 (Missing) | No design work started, or "TBD" noted |

For backend-only epics with no UI component, score this dimension based on API contract or data model design instead. Note: "No UX component — scored on technical design."

**Dimension 5 — Technical Approach**

Is the implementation approach understood?

| Score | Criteria |
|-------|----------|
| 2 (Ready) | Technical approach documented or spiked, major risks identified, architecture reviewed |
| 1 (Partial) | General approach agreed but not documented, or spike needed for a specific area |
| 0 (Missing) | No technical discussion, or approach is "figure it out during the sprint" |

**Dimension 6 — Dependencies**

Are external dependencies identified and their status known?

| Score | Criteria |
|-------|----------|
| 2 (Ready) | All dependencies identified, linked, owners confirmed, delivery timelines agreed |
| 1 (Partial) | Dependencies identified but not all confirmed, or timelines are tentative |
| 0 (Missing) | Dependencies not assessed, or "probably no dependencies" without verification |

**Dimension 7 — Rollout Strategy**

Is there a plan for how this reaches users?

| Score | Criteria |
|-------|----------|
| 2 (Ready) | Feature flag strategy defined, rollout phases planned, rollback plan documented |
| 1 (Partial) | Will use feature flags but phases not defined, or rollback approach is "revert the PR" |
| 0 (Missing) | No rollout plan, or assumption of big-bang release |

For teams not using feature flags or progressive rollout, adjust this dimension to assess release planning (which version, what release notes, any migration steps).

### Step 2: Classify each epic

| Total Score (out of 14) | Classification |
|--------------------------|---------------|
| 12-14 | **Ready** — can be committed to in planning |
| 8-11 | **Partially Ready** — can be planned with identified gaps as prerequisites |
| 0-7 | **Not Ready** — requires significant preparation before commitment |

### Step 3: Identify specific gaps

For each epic scoring below Ready, list the specific gaps that need to be addressed. Be concrete:
- Bad: "Needs better acceptance criteria"
- Good: "Acceptance criteria missing for the error handling and edge cases (only happy path defined)"

### Step 4: Generate aggregate summary

Across all evaluated epics:
- Count by classification (Ready / Partially Ready / Not Ready)
- Identify the most common gap across epics (e.g., "4 of 6 epics lack dependency analysis")
- Assess overall planning readiness: can planning proceed, or should it be delayed?

## Output Format

```
## Epic Readiness Assessment

**Date**: {date}
**Scope**: {planning period — e.g., "PI 26.3" or "Q2 2026"}
**Epics evaluated**: {count}

### Summary

| Classification | Count | Percentage |
|---------------|-------|-----------|
| Ready | {n} | {%} |
| Partially Ready | {n} | {%} |
| Not Ready | {n} | {%} |

**Planning readiness**: {Ready to proceed | Proceed with caveats | Delay recommended}
**Most common gap**: {description}

---

### {Epic Title}

**Classification**: {Ready|Partially Ready|Not Ready} ({score}/14)

| Dimension | Score | Notes |
|-----------|-------|-------|
| Problem & Value | {0-2} | {detail} |
| Acceptance Criteria | {0-2} | {detail} |
| Breakdown & Estimation | {0-2} | {detail} |
| Design & UX | {0-2} | {detail} |
| Technical Approach | {0-2} | {detail} |
| Dependencies | {0-2} | {detail} |
| Rollout Strategy | {0-2} | {detail} |

**Gaps to address**:
1. {specific gap with recommendation}
2. {specific gap with recommendation}

---

(repeat for each epic)

**Confidence**: {High|Medium|Low} — {justification}
```

## Error Handling

- If epic data is sparse (title only, no description): score all dimensions as 0 (Missing) and classify as Not Ready. Note: "Insufficient data to evaluate — epic has no description or child tickets."
- If a dimension is not applicable (e.g., no UX for a backend migration): score it as Ready (2) and note "N/A — no UX component." Do not penalize epics for dimensions that genuinely do not apply.
- If fewer than 3 epics are provided: evaluate individually but note "Small sample — aggregate patterns may not be meaningful."

## Self-Consistency Note

For borderline epics (near the Ready/Partially Ready or Partially Ready/Not Ready threshold), consider whether a slightly different weighting of the dimensions would change the classification. If it would, note the ambiguity and downgrade confidence to Medium.
