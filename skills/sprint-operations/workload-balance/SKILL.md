---
name: workload-balance
version: 1.0.0
description: >
  Detects uneven distribution of in-progress work across team members
  and flags overloaded or underloaded individuals.
category: sprint-operations
trigger: Sprint planning review, mid-sprint health check, capacity concerns
autonomy: autonomous
portability: universal
complexity: basic
type: detection
inputs:
  - name: sprint_tickets
    type: structured-text
    required: true
    description: Sprint tickets with assignee, status, story points, and priority.
  - name: team_members
    type: list
    required: false
    description: List of team members (enables detection of unassigned or absent members).
outputs:
  - name: workload_report
    type: structured-text
    description: Per-person workload summary with imbalance flags and recommendations.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Workload Balance

Detect uneven work distribution across team members in the active sprint. Flags individuals who are overloaded or underloaded relative to the team average.

## When to Use

- During sprint planning to validate work distribution
- At mid-sprint to detect emerging imbalances
- When a team member flags capacity concerns
- When tickets are being reassigned and you need to see the current state

## Method

### Step 1: Calculate per-person workload

For each assignee, count:
- **Active tickets**: Tickets in In Progress or In Review (not Done, not To Do)
- **Active SP**: Sum of story points on active tickets
- **Total assigned**: All tickets assigned (any status)
- **Blocked tickets**: Tickets in Blocked status assigned to this person

### Step 2: Compute team statistics

- **Team average active SP**: Total active SP / number of team members with active work
- **Team average active tickets**: Total active tickets / number of active members

### Step 3: Detect imbalances

Flag individuals as:

| Condition | Flag |
|-----------|------|
| Active SP > 1.5x team average | Overloaded |
| Active SP < 0.5x team average AND no tickets in To Do | Underloaded |
| 2+ tickets in Blocked status | Blocked |
| 0 active tickets but sprint is in progress | Idle (may be on PTO or available to help) |

### Step 4: Check for unassigned work

Count tickets with no assignee. If any are In Progress or In Review without an assignee, flag as a concern.

### Step 5: Generate recommendations

Based on detected imbalances:
- If someone is overloaded and someone else is underloaded: suggest redistribution
- If someone is blocked: suggest unblocking actions
- If work is unassigned: suggest assignment
- If balance is healthy: state so

## Output Format

```
## Workload Balance — {sprint name}

### Per-Person Summary

| Member | Active Tickets | Active SP | Blocked | Flag |
|--------|---------------|-----------|---------|------|
| {name} | {N} | {N} | {N} | {flag or "OK"} |
| ... | ... | ... | ... | ... |

**Team average**: {N} active SP / {N} active tickets per person

### Imbalances

{If any:}
- **{name}** is overloaded ({N} SP active vs team avg {N}). Consider reassigning {ticket} to {available person}.
- **{name}** appears underloaded ({N} SP active). Available to pick up {unassigned ticket} or help {overloaded person}.

{If none: "Workload is balanced across the team."}

### Unassigned Work

{If any: list unassigned tickets with priority}
{If none: "All tickets are assigned."}
```

## Error Handling

- **No assignee data**: Cannot compute per-person workload. Note: "Assignee data missing — workload balance cannot be assessed."
- **Single-person team**: Skip balance analysis. Note: "Single assignee — workload balance not applicable."
- **All tickets in To Do**: "No active work detected. Sprint may not have started or all work is in backlog."
- **Missing story points**: Fall back to ticket count. Note: "Story points not available — analysis based on ticket count only."
