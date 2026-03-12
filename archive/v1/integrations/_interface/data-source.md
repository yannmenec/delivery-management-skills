# Data Source Interface

This document defines the abstract interface that integration connectors should implement. Skills reference data through these abstractions — they never call vendor-specific APIs directly.

## Purpose

By defining a common data interface, skills remain tool-agnostic while integrations provide the actual data. A Jira connector and a Linear connector both satisfy the same interface, so skills work with either.

## Core Data Types

### Sprint Tickets

The most common data requirement. Used by sprint-operations and reporting skills.

```
get_sprint_tickets(sprint_id?) → [Ticket]

Ticket:
  key: string              # e.g., "PROJ-123"
  summary: string          # ticket title
  type: string             # Story, Bug, Task, Spike, Sub-task
  status: string           # To Do, In Progress, In Review, Blocked, Done, etc.
  assignee: string | null  # person name
  priority: string         # Blocker, Critical, High, Medium, Low
  story_points: number | null
  days_in_current_status: number
  last_updated: date
  created_date: date
  labels: [string]
  linked_issues: [Link]
  pr_status: string | null # none, draft, open, approved, merged, ci-failing

Link:
  type: string             # "blocks", "is blocked by", "relates to"
  key: string
  status: string
```

### Sprint Metadata

```
get_sprint_info(sprint_id?) → Sprint

Sprint:
  name: string
  start_date: date
  end_date: date
  goal: string | null
  state: string            # active, closed, future
```

### Velocity History

```
get_velocity_history(sprint_count: number) → [SprintVelocity]

SprintVelocity:
  sprint_name: string
  committed_points: number
  completed_points: number
  start_date: date
  end_date: date
```

### Team Roster

```
get_team_members() → [TeamMember]

TeamMember:
  name: string
  role: string
  allocation_percentage: number  # 0-100
  tracker_id: string | null
  chat_id: string | null
```

### Epic Data

```
get_epics(filter?) → [Epic]

Epic:
  key: string
  title: string
  description: string | null
  status: string
  acceptance_criteria: string | null
  child_tickets: [Ticket]
  dependencies: [Link]
  story_points_total: number | null
  story_points_completed: number | null
```

## Integration Contract

A connector implements this interface by:

1. Mapping vendor-specific fields to the common types above
2. Handling authentication (never stored in skill files)
3. Implementing graceful degradation (return partial data with caveats if some fields are unavailable)
4. Respecting rate limits and token budgets

## Mock Provider

The `integrations/mock/` directory provides sample data in JSON format that conforms to these types. Use it for testing and demos.

## Planned Connectors (v2+)

| Connector | Protocol | Status |
|-----------|----------|--------|
| Jira | MCP (Atlassian) | Planned |
| Linear | REST API | Planned |
| GitHub | MCP or REST | Planned |
| Slack | MCP | Planned |
| Mock | Local JSON files | Available (v1) |
