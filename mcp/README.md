# MCP Configuration Templates

Model Context Protocol (MCP) servers connect AI agents to live data sources. These templates configure the three primary integrations used by delivery management agents.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) or [Cursor](https://cursor.sh) installed
- Node.js 18+ (for `npx` MCP server execution)
- API credentials for each service you want to connect

## Setup

### 1. Atlassian (Jira + Confluence)

**What you need:**
- Atlassian site URL (e.g., `https://yourcompany.atlassian.net`)
- User email associated with your Atlassian account
- API token — generate at https://id.atlassian.com/manage-profile/security/api-tokens

**Permissions required:**
- Jira: Browse Projects, Read issues (for sprint data, ticket details)
- Confluence: Read pages (for retro notes, PI plans, documentation)

**Configuration:**
Copy `atlassian.json` to your Claude Code or Cursor MCP config directory and replace:
- `YOUR_ATLASSIAN_SITE` with your site name (e.g., `mycompany`)
- `YOUR_EMAIL@example.com` with your Atlassian email
- `YOUR_ATLASSIAN_API_TOKEN` with your generated API token

### 2. GitHub

**What you need:**
- Personal Access Token (PAT) — generate at https://github.com/settings/tokens
- Fine-grained tokens recommended with these permissions:
  - Repository access: read (for PRs, commits, branches)
  - Pull requests: read (for review status, CI checks)

**Configuration:**
Copy `github.json` to your MCP config directory and replace:
- `YOUR_GITHUB_TOKEN` with your PAT

### 3. Slack

**What you need:**
- Slack Bot Token (`xoxb-...`) — create a Slack app at https://api.slack.com/apps
- Slack Team ID — find in your workspace settings or via the Slack API

**Bot permissions required (OAuth scopes):**
- `channels:history` — read messages in public channels
- `channels:read` — list channels
- `search:read` — search messages
- `users:read` — resolve user names

**Configuration:**
Copy `slack.json` to your MCP config directory and replace:
- `YOUR_SLACK_BOT_TOKEN` with your bot token
- `YOUR_SLACK_TEAM_ID` with your workspace team ID

## Installing in Claude Code

Add each server to your Claude Code MCP configuration:

```bash
# Verify Claude Code is installed
claude --version

# Add Atlassian MCP server
claude mcp add atlassian -- npx -y @anthropic/atlassian-mcp@latest \
  --atlassian-site-url "https://YOUR_SITE.atlassian.net" \
  --atlassian-user-email "you@example.com" \
  --atlassian-api-token "YOUR_TOKEN"

# Add GitHub MCP server
claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=YOUR_TOKEN -- \
  npx -y @anthropic/github-mcp@latest

# Add Slack MCP server
claude mcp add slack -e SLACK_BOT_TOKEN=xoxb-YOUR_TOKEN -e SLACK_TEAM_ID=YOUR_ID -- \
  npx -y @anthropic/slack-mcp@latest
```

## Installing in Cursor

In Cursor, MCP servers are configured in `.cursor/mcp.json` at your project root. Merge the contents of each template file into that configuration.

## Verification

After adding servers, verify they're connected:

```bash
# List all configured MCP servers
claude mcp list

# Test Atlassian connection
claude mcp call atlassian searchJiraIssuesUsingJql '{"cloudId": "YOUR_CLOUD_ID", "jql": "project = MERC ORDER BY created DESC", "maxResults": 1}'
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `npx: command not found` | Install Node.js 18+ from https://nodejs.org |
| `401 Unauthorized` (Atlassian) | Verify API token is valid, email matches the token owner |
| `401 Unauthorized` (GitHub) | Verify PAT hasn't expired, has required repository permissions |
| `missing_scope` (Slack) | Add required OAuth scopes to your Slack app, reinstall to workspace |
| MCP server times out | Check network connectivity, ensure `npx` can download packages |
| `EACCES` permission error | Run `npx` without `sudo`, check npm cache permissions |

## Using Sample Data Instead

If you don't have API access or want to test agents offline, use the sample data in `../data/`. The agents are designed to work with both live MCP data and static JSON files.
