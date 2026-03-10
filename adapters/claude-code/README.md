# Claude Code Adapter

Install Delivery Management Skills into [Claude Code](https://docs.anthropic.com/en/docs/claude-code) using the `CLAUDE.md` project instructions format.

## Quick Install

```bash
cd /path/to/your/project
bash /path/to/delivery-management-skills/adapters/claude-code/install.sh
```

This copies the `CLAUDE.md` file and creates a `delivery-skills/` directory with all skills.

## What Gets Installed

| Source | Destination | Purpose |
|--------|-------------|---------|
| `adapters/claude-code/CLAUDE.md` | `./CLAUDE.md` | Project instructions for Claude Code |
| `skills/` | `./delivery-skills/` | All delivery management skills |
| `workflows/` | `./delivery-skills/workflows/` | Composed workflows |

## Usage

Once installed, use Claude Code normally:

```
"Read delivery-skills/sprint-operations/detect-stuck-tickets/SKILL.md and run it against our sprint data"
"Morning scan — check what needs attention today"
"Generate a sprint report using the data in sprint-data.json"
```

Claude Code will read the `CLAUDE.md` instructions and follow the skill library conventions.

## MCP Configuration (Optional)

Claude Code supports MCP servers for live data. Configure in your Claude Code settings if you want integration-enhanced skills.

## Customization

Edit the `CLAUDE.md` file to add your team context (team name, members, sprint calendar, project keys).

## Smoke Test

After installing, verify everything works:

- [ ] `ls delivery-skills/` shows category directories (sprint-operations, reporting, etc.)
- [ ] `ls delivery-skills/workflows/` shows workflow files
- [ ] `ls delivery-skills/mock/` shows sprint-data.json and team-roster.json
- [ ] `CLAUDE.md` contains the delivery skills instructions
- [ ] In Claude Code: "Read `delivery-skills/sprint-operations/detect-stuck-tickets/SKILL.md` and summarize it" returns a coherent summary
