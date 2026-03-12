---
name: forecast-completion
version: 1.0.0
description: >
  Estimates completion probability for remaining work using velocity
  distribution and Monte Carlo-style simulation.
category: planning
trigger: Sprint midpoint, PI planning, stakeholder requests for delivery dates
autonomy: autonomous
portability: universal
complexity: intermediate
type: computation
inputs:
  - name: velocity_history
    type: list
    required: true
    description: Velocity values from 3+ recent sprints (story points or task count per sprint).
  - name: remaining_work
    type: number
    required: true
    description: Total story points (or tasks) remaining to complete.
  - name: target_date
    type: text
    required: false
    description: Optional target date to assess probability of completion by.
  - name: sprint_length_days
    type: number
    required: false
    default: 10
    description: Working days per sprint.
outputs:
  - name: forecast
    type: structured-text
    description: Probability distribution with 50th, 80th, and 95th percentile completion estimates.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Forecast Completion

Estimate when remaining work will be completed based on historical velocity, producing probability-based forecasts rather than single-point estimates.

## When to Use

- At sprint midpoint to assess whether the sprint commitment is achievable
- During PI planning to validate epic timelines against capacity
- When stakeholders ask "when will this be done?"

## Method

### Step 1: Validate velocity data

Require at least 3 sprints of velocity data. If fewer: state "Insufficient data for probabilistic forecast — need 3+ sprints." Provide a rough estimate based on average only, with Low confidence.

### Step 2: Compute velocity statistics

From the velocity history, calculate:
- **Mean velocity**: average SP per sprint
- **Standard deviation**: spread of velocity values
- **Min/Max**: range boundaries
- **Coefficient of variation**: std dev / mean (measures predictability)

### Step 3: Simulate completion

Mentally simulate N sprints of future work, drawing velocity from the observed distribution:

1. For each simulated sprint, assume velocity will fall somewhere in the observed range (min to max), with most outcomes near the mean.
2. Accumulate completed SP across simulated sprints until remaining_work reaches zero.
3. Record how many sprints it took.

Produce three estimates:
- **P50 (50th percentile)**: Half of simulations complete by this point. Use: remaining_work / mean_velocity, rounded up.
- **P80 (80th percentile)**: 80% of simulations complete by this point. Use: remaining_work / (mean_velocity - 0.5 * std_dev), rounded up.
- **P95 (95th percentile)**: 95% of simulations complete by this point. Use: remaining_work / min_velocity, rounded up.

### Step 4: Assess target date (if provided)

If a target date is given, calculate sprints until target and determine:
- How many SP can likely be completed by then (at P50, P80, P95)
- Probability of completing all remaining_work by target

### Step 5: State confidence

| Condition | Confidence |
|-----------|-----------|
| 5+ sprints of data, low variance (CV < 0.2) | High |
| 3-4 sprints, or moderate variance (CV 0.2-0.4) | Medium |
| < 3 sprints, or high variance (CV > 0.4) | Low |

## Output Format

```
## Completion Forecast

**Remaining work**: {N} SP
**Based on**: {N} sprints of velocity data (mean: {X} SP, range: {min}-{max} SP)

| Percentile | Sprints to Complete | Estimated Date | Confidence |
|------------|--------------------|----|---|
| P50 (likely) | {N} | {date} | {level} |
| P80 (conservative) | {N} | {date} | {level} |
| P95 (worst case) | {N} | {date} | {level} |

{If target_date provided:}
**Target: {date}** — Probability of completion: {estimate}% (based on {sprints_until_target} sprints at observed velocity)

**Key assumptions**: No scope change, team composition stable, no major blockers. Each assumption that does not hold widens the forecast range.
```

## Error Handling

- **Fewer than 3 velocity data points**: Provide mean-only estimate, state "Low confidence — insufficient data for probabilistic forecast." Recommend gathering more sprint data.
- **Zero remaining work**: "All work is complete. No forecast needed."
- **Highly variable velocity** (CV > 0.5): Flag: "Velocity is highly variable — forecasts have wide uncertainty. Consider investigating the cause of variability before relying on these dates."
- **Remaining work exceeds historical capacity**: If remaining_work > 3x max observed velocity, note: "Remaining work significantly exceeds observed sprint capacity. Consider scope reduction or timeline extension."
