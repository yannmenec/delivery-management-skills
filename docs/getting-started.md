# Getting Started

Get your first useful output from Delivery Management Skills in under 5 minutes.

## What is a Skill?

A **skill** is a structured prompt document with explicit inputs, outputs, and quality checks. Unlike raw prompts, skills are tested, composable, and versioned units of delivery intelligence. See the [glossary](glossary.md) for more terms.

## Prerequisites

- An AI coding assistant (Cursor, Claude Code, or any tool that can read markdown)
- Git (to clone the repository)
- Bash (for adapter install scripts; on Windows, use WSL or Git Bash)
- Sprint data from your team (or use the included mock data to try it out)

## Step 1: Clone the Repository

```bash
git clone https://github.com/yannmenec/delivery-management-skills.git
```

## Step 2: Install for Your Tool

### Cursor

```bash
bash delivery-management-skills/adapters/cursor/install.sh /path/to/your/workspace
```

Reload Cursor: `Cmd+Shift+P` (macOS) / `Ctrl+Shift+P` (Windows/Linux) > "Reload Window"

### Claude Code

```bash
bash delivery-management-skills/adapters/claude-code/install.sh /path/to/your/project
```

### Any Other Tool

No installation needed. Copy the content of any `SKILL.md` file into your AI assistant's context and follow along.

## Step 3: Try Your First Skill

### Option A: Use Mock Data (quickest)

Ask your AI assistant:

```
Read skills/sprint-operations/detect-stuck-tickets/SKILL.md and run it
against the data in integrations/mock/sprint-data.json
```

You should get a structured list of stuck tickets with severity scores, detection layers, and recommended actions.

### Option B: Use Your Own Data

Paste your sprint ticket data (status, assignee, priority, days in status) and ask:

```
Read skills/sprint-operations/detect-stuck-tickets/SKILL.md and analyze
these sprint tickets for stuck work:

[paste your ticket data here - a table or list is fine]
```

## Step 4: Try a Workflow

For a complete morning briefing:

```
Read workflows/morning-scan.md and run it against integrations/mock/sprint-data.json
```

This chains three detection skills into a prioritized "Needs Attention / Heads Up / Wins" briefing.

## Step 5: Customize (Optional)

### Add Your Team Context

For Cursor: Edit `.cursor/rules/project-context.template.mdc` with your team name, members, sprint calendar, and project tracker details.

For Claude Code: Add a team context section to `CLAUDE.md`.

### Configure Integrations

If you use Jira, GitHub, or Slack with MCP support in your AI tool, skills will automatically use live data instead of requiring manual input. See `integrations/_interface/data-source.md` for details.

## What to Try Next

| Goal | Skill / Workflow |
|------|-----------------|
| "What's stuck?" | `detect-stuck-tickets` |
| "Morning briefing" | Workflow: `morning-scan` |
| "Sprint report for the review" | Workflow: `sprint-close-report` |
| "How fast are we going?" | `compute-velocity` |
| "What are our risks?" | `assess-risk` |
| "Is this epic ready for planning?" | `assess-epic-readiness` |
| "Draft an escalation" | `craft-escalation-memo` |
| "Update for my VP" | `stakeholder-update` → `format-for-audience` |

## Troubleshooting

**Skills are not showing up in Cursor**: Reload the window (`Cmd+Shift+P` / `Ctrl+Shift+P` > "Reload Window"). Check that `.cursor/skills/` contains symlinks to the skill directories.

**Output seems generic**: Make sure you are providing specific sprint data (ticket keys, statuses, dates). The more specific your input, the more specific the output.

**Quality gate fails**: This is working as intended. Review the self-check feedback, address the specific issues, and iterate. Quality gates prevent low-quality outputs from being delivered.
