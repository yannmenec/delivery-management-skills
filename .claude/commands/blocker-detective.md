Run the Blocker Detective on the Project Mercury Sprint 42 data.

## Instructions

Read the agent prompt from agents/blocker-detective/prompt.md.
Read the sprint data from data/jira-sprint-42.json.
Read GitHub PRs from data/github-prs.json.
Read GitHub commits from data/github-commits.json.
Read CI builds from data/ci-builds.json.

Scan the sprint data for blocker signals: aging PRs, review starvation,
CI failure streaks, stale work, developer overload, blocked tickets, and
ghost sprint items. Produce the blocker report with standup agenda in the
exact output format specified in the prompt.

## Modes

### L1 — Paste Mode (no MCP needed)
The default mode. The command reads data from the local `data/` files and
runs the scan using the prompt logic. No external connections required.

### L2 — Connected Mode (MCP)
When Jira and GitHub MCP servers are configured, you can fetch live data
instead of using sample files:

1. Use the Jira MCP to fetch current sprint tickets
2. Use the GitHub MCP to fetch PRs, commits, and CI status
3. Run the blocker scan against the live data

See `mcp/README.md` for MCP server configuration.
