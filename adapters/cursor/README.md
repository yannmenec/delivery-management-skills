# Cursor Adapter

Install Delivery Management Skills into [Cursor](https://cursor.com) as native skills, rules, and agent definitions.

## Quick Install

```bash
cd /path/to/your/cursor/workspace
bash /path/to/delivery-management-skills/adapters/cursor/install.sh
```

This creates symlinks from the skill library into your workspace's `.cursor/` directory.

## What Gets Installed

| Source | Destination | Purpose |
|--------|-------------|---------|
| `skills/` | `.cursor/skills/` | All 15+ delivery management skills |
| `adapters/cursor/rules/` | `.cursor/rules/` | Cursor-native rule files |
| `adapters/cursor/agents/` | `.cursor/agents/` | Agent definitions |

## Manual Setup

If you prefer not to use the install script:

1. Copy or symlink `skills/` into `.cursor/skills/` in your workspace
2. Copy `adapters/cursor/rules/*.mdc` into `.cursor/rules/`
3. Copy `adapters/cursor/agents/*.md` into `.cursor/agents/`
4. Reload Cursor (`Cmd+Shift+P` > "Reload Window")

## MCP Configuration (Optional)

For integration-enhanced skills, configure MCP servers in Cursor settings:

| MCP Server | What It Enables |
|-----------|----------------|
| Atlassian | Jira ticket queries, Confluence page search |
| GitHub | PR status, CI checks, code reviews |
| Slack | Team message search, PTO detection |

Skills work without MCP — they just use manually provided data instead.

## Customization

### Project Context

Edit `.cursor/rules/project-context.template.mdc` with your team-specific data:

- Team name and members
- Project tracker key
- Sprint cadence
- Version control repository

### Autonomy Level

Edit `.cursor/rules/autonomy-level.mdc` to control the agent's write permissions:

- **supervised** (default): Agent generates output, you review before any external action
- **autonomous**: Agent can execute read operations automatically
- **human-in-the-loop**: Every action requires explicit approval

## Usage

Once installed, interact with the delivery agent in Cursor's chat:

```
"What's stuck in our sprint?"
"Generate a sprint report"
"Assess the readiness of our epics for next PI"
"Draft an escalation memo for the payment blocker"
```

Or use the slash command for the full daily scan:

```
/morning-scan
```

## Uninstall

```bash
bash /path/to/delivery-management-skills/adapters/cursor/uninstall.sh
```

This removes the symlinks without affecting your other Cursor configuration.
