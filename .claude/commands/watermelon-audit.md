Run the Watermelon Auditor on the Project Mercury Sprint 42 data.

## Instructions

Read the agent prompt from agents/watermelon-auditor/prompt.md.
Read the sprint data from data/jira-sprint-42.json.
Read GitHub PRs from data/github-prs.json.
Read GitHub commits from data/github-commits.json.
Read CI builds from data/ci-builds.json.

Cross-reference Jira ticket statuses against GitHub activity to identify
discrepancies. Produce the watermelon audit report in the exact output
format specified in the prompt.

## Modes

### L1 — Paste Mode (no MCP needed)
The default mode. The command reads data from the local `data/` files and
runs the audit using the prompt logic. No external connections required.

### L2 — Connected Mode (MCP)
When Jira and GitHub MCP servers are configured, you can fetch live data
instead of using sample files:

1. Use the Jira MCP to fetch current sprint tickets
2. Use the GitHub MCP to fetch PRs, commits, and CI status
3. Run the audit prompt against the live data

See `mcp/README.md` for MCP server configuration.
