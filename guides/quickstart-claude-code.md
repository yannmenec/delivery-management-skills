# Quickstart: Claude Code (L2)

> For developers and technical DMs who want slash commands and automatic data fetching.

Claude Code gives you one-command agent execution via slash commands, plus optional MCP integration to fetch data directly from Jira, GitHub, and Slack.

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed
- Git (to clone the repo)

## Step-by-Step: Sample Data

### 1. Clone the repo

```bash
git clone https://github.com/your-org/delivery-management-skills.git
cd delivery-management-skills
```

### 2. Run an agent with slash commands

The repo includes pre-built slash commands in `.claude/commands/`:

```bash
# Weekly status report from sample data
claude /weekly-rewind

# Morning briefing from sample data
claude /morning-scan

# Watermelon audit (will report "not yet available" until H2)
claude /watermelon-audit
```

### 3. Review the output

Claude Code reads the agent prompt, loads the sample data files, applies the processing logic, and produces the report directly in your terminal.

## Step-by-Step: Your Real Data (with MCP)

MCP (Model Context Protocol) lets Claude Code fetch data from your Jira, GitHub, and Slack accounts automatically — no manual export needed.

### 1. Configure MCP servers

The repo includes MCP configuration templates in `mcp/`:

```bash
ls mcp/
# atlassian.json  github.json  slack.json  README.md
```

See [`mcp/README.md`](../mcp/README.md) for setup instructions. Each config file needs your credentials and project-specific settings.

### 2. Run with live data

Once MCP is configured:

```bash
# Fetch current sprint from Jira and generate weekly report
claude "Fetch the current sprint from Jira for my project and run the weekly rewind agent"

# Fetch this morning's data and run the morning scan
claude "Fetch today's sprint data from Jira, open PRs from GitHub, and CI builds, then run the morning scan"
```

Claude Code will use MCP to pull fresh data, then apply the agent prompt to produce the report.

### 3. Customize for your project

You can create your own slash commands that reference your specific project:

Create `.claude/commands/my-weekly-report.md`:

```markdown
Run the Weekly Rewind agent on my project data.

Read the agent prompt from agents/weekly-rewind/prompt.md.
Fetch the current sprint data from Jira for project MYPROJ.
Fetch open PRs from GitHub for repo my-org/my-repo.
Fetch recent messages from Slack channel #my-team.

Apply the prompt's processing logic and produce the weekly status report.
```

Then run: `claude /my-weekly-report`

## Configuration

### Claude Code permissions

The repo's `.claude/settings.json` controls what Claude Code can read and write:

- **Allowed**: Reading all files, writing to `agents/*/examples/output-*.md`
- **Denied**: Writing to `data/*` (sample data is read-only), writing to `archive/*`

### Agent configuration

Each agent has a `config.yaml` with tunable parameters. You can reference these in your prompts or modify them to match your team's preferences:

```bash
# View Weekly Rewind config
cat agents/weekly-rewind/config.yaml

# View Morning Scan config
cat agents/morning-scan/config.yaml
```

## Tips

- **Start without MCP.** The slash commands work with sample data out of the box. Add MCP later when you want live data.
- **Combine agents.** You can ask Claude Code to run multiple agents in sequence: `claude "Run the morning scan, then the weekly rewind on the same data"`
- **Iterate on output.** After the initial report, follow up: "Make the risks section more detailed" or "Summarize this for a VP audience."
- **Keep the repo updated.** Pull regularly to get new agents and prompt improvements.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `claude` command not found | Install Claude Code CLI: see [docs](https://docs.anthropic.com/en/docs/claude-code) |
| Slash command not recognized | Make sure you're in the repo root directory |
| MCP connection failed | Check credentials in `mcp/*.json` and verify network access |
| Output is truncated | Claude Code has output limits — try running one agent at a time |
