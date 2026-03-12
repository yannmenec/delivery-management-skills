# Integrations

Everything in this directory is **optional**. Core skills work without any integration.

## Current Status

| Connector | Protocol | Status |
|-----------|----------|--------|
| **Mock** | Local JSON files | Available (v1) |
| Jira | MCP (Atlassian) | Planned (v2) |
| Linear | REST API | Planned (v2) |
| GitHub | MCP or REST | Planned (v2) |
| Slack | MCP | Planned (v2) |

## How It Works

Skills reference data abstractly ("sprint tickets with status, assignee, and dates"). They never call vendor APIs directly. The integration layer provides data through a [common interface](/_interface/data-source.md).

For v1, this means:
- Use the **mock data** in `mock/` for demos and testing
- **Provide data manually** by pasting it into the AI tool
- If your AI tool has **MCP integrations** configured, skills can benefit from live data — but they do not require it

## Mock Data

The `mock/` directory contains realistic sample data for a fictional team (Horizon, 6 members, 2-week sprints):

- `sprint-data.json` — 15 tickets in an active sprint with velocity history
- `team-roster.json` — Team members, roles, allocation, PTO schedule

This data is designed to demonstrate all skill capabilities, including edge cases (blocked tickets, stale PRs, ghost-done, scope changes, dependency chains).

## Adding a Connector (v2+)

See `_interface/data-source.md` for the interface contract a connector must satisfy. A connector:

1. Implements the data types defined in the interface
2. Handles authentication (never stored in skill files)
3. Implements graceful degradation (partial data with caveats on failure)
4. Respects rate limits
