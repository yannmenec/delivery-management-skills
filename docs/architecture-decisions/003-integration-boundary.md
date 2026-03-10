# ADR-003: Integrations as Optional Enhancement

## Status

Accepted

## Context

Delivery management skills become more powerful with live data from project trackers (Jira, Linear), version control (GitHub, GitLab), and team chat (Slack, Teams). However, live integrations introduce:

- Authentication and secret management complexity
- API versioning and breaking change risk
- Vendor lock-in
- Maintenance burden that scales with the number of supported services

## Decision

Every skill must be **fully functional with manually provided data**. A user can paste sprint data, ticket details, or team information directly into the skill and receive useful output.

Integrations are an **optional enhancement layer** (`integrations/`). They provide:
- Data source interface documentation (what data each skill can use)
- Template queries (e.g., JQL patterns for Jira, GraphQL for GitHub)
- Mock data for testing and demos

Live connectors (MCP servers, API clients) are planned for v2+, not v1.

Skills reference data abstractly ("sprint tickets with status, assignee, and dates") rather than using vendor-specific terminology ("Jira issues with customfield_10028").

## Consequences

- **Positive**: Zero setup friction for first use. Clone, point AI tool at a skill, provide data, get output.
- **Positive**: No vendor lock-in. Skills work with any project tracker, not just Jira.
- **Positive**: No secrets or auth tokens in the repository.
- **Negative**: Users with Jira/GitHub must currently bridge the gap themselves. Mitigated by providing query templates and field mapping documentation.
- **Negative**: Demo scenarios require mock data rather than live data. Mitigated by shipping realistic mock datasets.
