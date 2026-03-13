# Jira Data Parser

> Shared prompt fragment — include this in any agent that consumes Jira sprint data.

## Input Format

You will receive Jira ticket data as a JSON array. Each ticket has these fields:

| Field | Type | Description |
|-------|------|-------------|
| `key` | string | Ticket identifier (e.g., `MERC-230`) |
| `summary` | string | One-line description of the work |
| `status` | string | Current workflow status: `To Do`, `In Progress`, `Done`, `Blocked` |
| `assignee` | string | Username of the assigned developer (e.g., `sarah.chen`) |
| `story_points` | number | Estimated effort (Fibonacci: 1, 2, 3, 5, 8, 13) |
| `sprint` | string | Sprint name (e.g., `Sprint 42`) |
| `created` | string | ISO date when ticket was created |
| `updated` | string | ISO date of last modification |
| `labels` | string[] | Categorization tags |
| `type` | string | `Story`, `Task`, `Bug`, `Spike` |
| `priority` | string | `Critical`, `High`, `Medium`, `Low` |
| `linked_prs` | string[] | Associated PR numbers (e.g., `["#148"]`), empty if none |
| `blocked_by` | string[] | Ticket keys or external identifiers blocking this ticket |
| `blocks` | string[] | Ticket keys that this ticket blocks |

## Extraction Instructions

When parsing Jira data, extract and organize:

### 1. Status Distribution
Count tickets by status. Calculate completion percentage: `done_count / total_count * 100`.

### 2. Assignee Workload
Group tickets by assignee. For each person, count:
- Total assigned tickets
- Active tickets (In Progress + To Do)
- Story points committed vs. completed

Flag any developer with **6+ active tickets** as potentially overloaded.

### 3. Ticket Age
Calculate days since creation for non-Done tickets: `today - created`.
Calculate days since last update for In Progress tickets: `today - updated`.

### 4. Dependency Map
Build a directed graph from `blocked_by` and `blocks` fields. Identify:
- Tickets with unresolved blockers
- Chains of blocked tickets (A blocks B blocks C)
- External blockers (non-ticket identifiers in `blocked_by`)

## Anomaly Detection

Flag these patterns:

| Anomaly | Detection Rule | Severity |
|---------|---------------|----------|
| **Watermelon** | Status is `Done` but `linked_prs` is empty | High |
| **Stale In Progress** | Status is `In Progress` and `updated` is 3+ days ago | Medium |
| **Orphan ticket** | Status is `In Progress` but `assignee` is empty | High |
| **Overloaded dev** | Developer has 6+ non-Done tickets | Medium |
| **Missing estimate** | `story_points` is 0 or null for a Story | Low |
| **Late To Do** | Status is `To Do` past sprint midpoint | Medium |
| **Blocked chain** | Ticket blocks another ticket that also has blockers | High |

## Output Schema

After parsing, structure your findings as:

```
sprint_summary:
  name: string
  total_tickets: number
  status_counts: { done: N, in_progress: N, to_do: N, blocked: N }
  total_points: number
  completed_points: number
  completion_pct: number

assignee_summary:
  - name: string
    total: number
    active: number
    completed_points: number
    flag: "overloaded" | "balanced" | "light"

anomalies:
  - ticket: string
    type: string
    severity: "high" | "medium" | "low"
    details: string

blockers:
  - ticket: string
    blocked_by: string
    chain_depth: number
```
