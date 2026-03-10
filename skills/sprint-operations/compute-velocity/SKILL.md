---
name: compute-velocity
version: 1.0.0
description: Computes team velocity over multiple sprints using story points or task count, with trend analysis.
category: sprint-operations
trigger: Sprint review, capacity planning, forecasting, sprint health check.
autonomy: autonomous
portability: universal
complexity: basic
type: computation
inputs:
  - name: sprint_history
    type: structured-text
    required: true
    description: >
      Data for 2+ completed sprints. Per sprint: name, committed story points,
      completed story points, sprint dates. Optionally: completed task count.
  - name: current_sprint
    type: structured-text
    required: false
    description: >
      Current sprint progress: committed SP, completed SP so far, days elapsed,
      days remaining.
outputs:
  - name: velocity_report
    type: structured-text
    description: >
      Average velocity, sprint-over-sprint trend, predictability score,
      completion ratio, and forecast for current sprint.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Compute Velocity

Calculate team velocity across sprints, identify trends, assess predictability, and forecast current sprint completion.

## When to Apply

- Sprint reviews and retrospectives
- Capacity planning for upcoming sprints or PIs
- Sprint health checks (mid-sprint trajectory assessment)
- Stakeholder updates requiring velocity data

## Method

### Step 1: Calculate per-sprint velocity

For each completed sprint:
- **Velocity** = completed story points (not committed)
- **Completion ratio** = completed / committed (as percentage)

If story points are unavailable, fall back to completed task count. Note the metric used.

### Step 2: Compute averages

- **Average velocity** = mean of last 3 sprints (or all available if fewer than 3)
- **Weighted average** = most recent sprint weighted 50%, previous 30%, before that 20%. This better reflects the team's current capacity.
- Use the **weighted average** as the primary velocity figure. Show the simple average as a reference.

### Step 3: Assess trend

Compare the last 3 sprints:

| Pattern | Trend | Signal |
|---------|-------|--------|
| Each sprint higher than previous | Improving | Team ramping up, process maturing, or scope inflation |
| Each sprint lower than previous | Declining | Capacity loss, increasing complexity, or morale issues |
| Fluctuating (+/- 20%) | Volatile | Estimation inconsistency, variable scope, or team instability |
| Within +/- 10% band | Stable | Healthy, predictable team |

### Step 4: Calculate predictability

**Predictability score** = 1 - (standard deviation / average velocity)

| Score | Rating |
|-------|--------|
| > 0.85 | High — team delivers consistently |
| 0.70 - 0.85 | Medium — some variability, plan with buffer |
| < 0.70 | Low — high variability, commitments are unreliable |

### Step 5: Forecast current sprint (if data provided)

- **Burn rate** = completed SP / days elapsed
- **Projected completion** = burn rate * total sprint days
- **Trajectory** = projected completion / committed SP (as percentage)
- Flag if trajectory < 80% (at risk) or < 60% (off track)

Note: Linear projection is a simplification. Sprint work is typically back-loaded. Adjust interpretation accordingly — a 60% trajectory on Day 3 is less concerning than on Day 8.

### Step 6: Generate insight

Provide one concrete observation based on the data. Examples:
- "Velocity dropped 22% from Sprint 1 to Sprint 2 — correlates with 2 team members on PTO."
- "Completion ratio has been below 80% for 3 consecutive sprints — team may be over-committing."
- "Stable velocity of ~45 SP with high predictability — safe to commit 42-48 SP next sprint."

## Output Format

```
## Velocity Report

**Average velocity**: {weighted_avg} SP (simple avg: {simple_avg} SP)
**Trend**: {Improving|Declining|Volatile|Stable}
**Predictability**: {score} ({High|Medium|Low})

### Sprint-over-Sprint

| Sprint | Committed | Completed | Ratio | Delta |
|--------|-----------|-----------|-------|-------|
| {name} | {committed} SP | {completed} SP | {ratio}% | {+/-N vs previous} |
| ... | ... | ... | ... | ... |

### Current Sprint Trajectory (if applicable)

- **Committed**: {N} SP
- **Completed so far**: {N} SP (Day {X} of {Y})
- **Burn rate**: {N} SP/day
- **Projected completion**: {N} SP ({trajectory}% of commitment)
- **Status**: {On track|At risk|Off track}

### Insight

{One concrete, data-driven observation with recommendation.}

**Confidence**: {High|Medium|Low} — based on {N} sprints of historical data.
```

## Error Handling

- If only 1 sprint of history: compute velocity for that sprint, but note "Insufficient history for trend analysis or predictability scoring. Recommend waiting for 3 sprints."
- If story points are missing: fall back to task count. Note: "Using task count as velocity metric — story point data unavailable."
- If current sprint data is incomplete: skip forecast section. Note: "Current sprint forecast unavailable — missing progress data."
- If committed SP is 0 for any sprint (planning gap): exclude that sprint from averages. Note the exclusion.
