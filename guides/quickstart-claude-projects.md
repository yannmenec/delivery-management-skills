# Quickstart: Claude Projects (L1+)

> For non-dev Delivery Managers who want persistent agent prompts without touching a terminal.

Claude Projects let you upload agent prompts once and reuse them across conversations. You paste fresh data each time, but the prompts are already loaded — no re-copying required.

## Step-by-Step Setup

### 1. Create a Claude Project

1. Go to [claude.ai](https://claude.ai)
2. In the left sidebar, click **Projects**
3. Click **New Project**
4. Name it **"Delivery Management"** (or your team name)

### 2. Upload agent prompts as Project Knowledge

In your new project, click **Add to Project Knowledge** and upload these files:

**Required:**
- `agents/weekly-rewind/prompt.md`
- `agents/morning-scan/prompt.md`
- `agents/watermelon-auditor/prompt.md`
- `agents/blocker-detective/prompt.md`

**Recommended (improves output quality):**
- `reference/formatters/markdown-report.md`

You can upload files directly from the cloned repo, or copy-paste the contents into text files and upload those.

### 3. Start a conversation

Open a new conversation inside the project. The agent prompts are now available as context in every conversation.

### 4. Run an agent

Paste your sprint data (or the sample data from `agents/weekly-rewind/examples/sample-input.json`) and type:

```
Run the weekly rewind on this sprint data.
```

Claude will use the uploaded prompt to process your data and generate the report.

### 5. Run it again next week

Start a new conversation in the same project. The prompts are still loaded. Just paste fresh data and ask for the report.

## Usage Patterns

### Weekly workflow

Every Friday:
1. Export your Jira sprint data (see [`export-your-data.md`](export-your-data.md))
2. Open your Delivery Management project on Claude
3. Start a new conversation
4. Paste the data and say: "Run the weekly rewind"
5. Copy the report to your stakeholder update

### Daily workflow

Every morning:
1. Export current sprint data from Jira
2. Open the project, start a new conversation
3. Paste the data and say: "Run the morning scan"
4. Review the briefing before standup

### Combining agents

You can ask for multiple agents in one conversation:

```
Here's my sprint data: [paste JSON]

First, run the morning scan. Then run the weekly rewind.
```

Claude will produce both outputs using the uploaded prompts.

## Tips

- **You can upload multiple agent prompts** and ask for any of them by name. Claude will use the right one based on your request.
- **The project remembers your prompts across conversations** — you only upload once.
- **Name your conversations** with the date or sprint number for easy reference later (e.g., "Sprint 42 — Week 1 Report").
- **For real data**: export from Jira using the instructions in [`export-your-data.md`](export-your-data.md) and paste the JSON.
- **You can refine the output** by following up: "Make the highlights more concise" or "Add a section about technical debt."

## Limitations

- Claude Projects have a context window limit. For very large sprints (50+ tickets), consider filtering to the current sprint only before pasting.
- Project Knowledge files are read-only — Claude can reference them but not modify them. Upload updated prompts if the agents are updated.
- You still need to manually export and paste data each time. For automatic data fetching, use [Claude Code (L2)](quickstart-claude-code.md).
