---
name: compute-capacity
version: 1.0.0
description: Computes team capacity for a sprint or PI from headcount, PTO, and run-rate buffer.
category: planning
trigger: Sprint planning, PI planning, capacity review, resource allocation.
autonomy: autonomous
portability: universal
complexity: basic
type: computation
inputs:
  - name: team_members
    type: structured-text
    required: true
    description: >
      List of team members with role and availability. Per member: name, role
      (developer, QA, designer, etc.), allocation percentage (default 100%).
  - name: period
    type: structured-text
    required: true
    description: >
      Time period: start date, end date, known holidays.
  - name: pto_schedule
    type: structured-text
    required: false
    description: >
      Planned time off. Per entry: person, dates, duration in days.
  - name: buffer_percentage
    type: number
    required: false
    default: 20
    description: >
      Percentage of capacity reserved for meetings, support, incidents, and
      unplanned work. Default 20%. Typical range: 15-30%.
  - name: velocity_per_dev_day
    type: number
    required: false
    description: >
      Story points per developer-day (historical average). If provided, capacity
      is also expressed in story points.
outputs:
  - name: capacity_report
    type: structured-text
    description: >
      Gross capacity, net capacity after PTO, plannable capacity after buffer,
      per-person breakdown, optional SP conversion.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Compute Capacity

Calculate how much work a team can realistically take on in a sprint or PI. Prevents over-commitment by accounting for PTO, holidays, and operational overhead.

## When to Use

- Sprint planning: "How much can we commit to?"
- PI planning: "What is our capacity for the next 6 weeks?"
- Mid-sprint: "We lost a team member — what is our adjusted capacity?"
- Resource discussions: "What happens if we add/remove a developer?"

## Method

### Step 1: Calculate business days

Count the number of business days (Monday-Friday) in the period. Subtract public holidays.

```
business_days = weekdays_in_period - public_holidays
```

### Step 2: Calculate gross capacity

Sum available developer-days across the team, accounting for allocation percentage.

```
gross_capacity = Σ (business_days × allocation_percentage) for each team member
```

Only count roles that deliver work directly (developers, QA engineers with development tasks). Exclude Scrum Masters, Product Owners, and managers unless they also deliver.

### Step 3: Subtract PTO

For each team member with planned time off:

```
net_capacity = gross_capacity - Σ (pto_days × allocation_percentage) for each person
```

### Step 4: Apply run-rate buffer

Reserve capacity for meetings, support rotations, incident response, code reviews, and unplanned work.

```
plannable_capacity = net_capacity × (1 - buffer_percentage / 100)
```

**Buffer guidance**:

| Buffer % | Appropriate When |
|----------|-----------------|
| 15% | Mature team, low meeting load, no on-call |
| 20% | Typical team (default) |
| 25% | Team with on-call rotation or heavy support duties |
| 30% | New team, many meetings, cross-team dependencies, or high interrupt rate |

### Step 5: Convert to story points (optional)

If `velocity_per_dev_day` is provided:

```
plannable_sp = plannable_capacity × velocity_per_dev_day
```

If not provided, you can derive it from velocity history:

```
velocity_per_dev_day = average_sprint_velocity / average_sprint_dev_days
```

Note this conversion in the output. SP conversion is an approximation — do not present it with false precision.

### Step 6: Generate per-person breakdown

Show each team member's available days after PTO. This helps identify:
- Team members with zero availability (full PTO in the period)
- Uneven distribution that affects pairing or knowledge coverage
- Periods within the sprint/PI where capacity drops significantly

## Output Format

```
## Capacity Report

**Period**: {start_date} to {end_date}
**Team**: {team_name} ({member_count} members)

### Summary

| Metric | Value |
|--------|-------|
| Business days | {N} |
| Gross capacity | {N} dev-days |
| PTO deduction | -{N} dev-days |
| Net capacity | {N} dev-days |
| Buffer ({buffer}%) | -{N} dev-days |
| **Plannable capacity** | **{N} dev-days** |
| Plannable SP (estimated) | ~{N} SP |

### Per-Person Breakdown

| Name | Role | Allocation | PTO Days | Available Days |
|------|------|-----------|----------|---------------|
| {name} | {role} | {%} | {N} | {N} |
| ... | ... | ... | ... | ... |
| **Total** | | | **{N}** | **{N}** |

### Capacity Notes

- {Any notable observations: e.g., "Week of Mar 16 has only 3 developers available due to overlapping PTO"}
- {Buffer rationale: e.g., "20% buffer applied — standard for this team. Consider 25% if on-call rotation starts this sprint."}

**Confidence**: {High|Medium|Low} — {justification}
```

## Error Handling

- If PTO schedule is not provided: compute capacity assuming zero PTO. Note prominently: "PTO data not provided — capacity assumes full availability. Actual capacity is likely lower."
- If allocation percentages are missing: assume 100% for all members. Note: "Allocation assumed at 100% — adjust if team members are shared across projects."
- If the period has zero business days (e.g., holiday week): return 0 capacity with note.
- If velocity data is unavailable for SP conversion: omit the SP row. Note: "Story point conversion unavailable — no velocity baseline provided."
