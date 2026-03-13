# Quickstart: Paste Mode (L1)

> Use any AI tool — Claude, ChatGPT, Gemini, Copilot — with zero setup.

This is the simplest way to use Delivery Management Skills. You copy a prompt, paste your data, and get a report. No accounts, no CLI, no configuration.

## Step-by-Step: Your First Report

### 1. Pick an agent

Start with **Weekly Rewind** — it produces the most immediately useful output (a stakeholder-ready status report).

| Agent | Best for | File |
|-------|----------|------|
| Weekly Rewind | Friday status reports | `agents/weekly-rewind/prompt.md` |
| Morning Scan | Daily standup prep | `agents/morning-scan/prompt.md` |
| Watermelon Auditor | Verifying Jira status against GitHub activity — detecting false "Green" reporting | `agents/watermelon-auditor/prompt.md` |
| Blocker Detective | Surfacing stuck PRs, failing CI, stale work before standup | `agents/blocker-detective/prompt.md` |

### 2. Copy the prompt

Open the agent's `prompt.md` file and copy the **entire contents**. This is the instruction set that tells the AI how to process your data.

For Weekly Rewind: [`agents/weekly-rewind/prompt.md`](../agents/weekly-rewind/prompt.md)

### 3. Copy the sample data

Open the agent's example input file and copy the **entire contents**.

For Weekly Rewind: [`agents/weekly-rewind/examples/sample-input.json`](../agents/weekly-rewind/examples/sample-input.json)

### 4. Open your AI tool

Go to any of these:
- [Claude](https://claude.ai) (recommended — handles long context well)
- [ChatGPT](https://chat.openai.com)
- [Google Gemini](https://gemini.google.com)
- [GitHub Copilot Chat](https://github.com/features/copilot)

### 5. Paste and run

In the AI chat:

1. **Paste the prompt** (the contents of `prompt.md`)
2. **Press Enter** (or add a blank line)
3. **Paste the data** (the contents of `sample-input.json`)
4. **Press Enter** to generate

The AI will produce a formatted status report. Compare it to the expected output in `agents/weekly-rewind/examples/sample-output.md`.

### 6. Read your report

The output is a markdown-formatted report you can:
- Copy into an email or Slack message
- Paste into Confluence or Notion
- Save as a `.md` file

## Using Your Own Data

The sample data is from a fictional project (Project Mercury). To use your real sprint data:

### Quick method: paste raw data

Most AI tools can handle imperfect data. You can paste:
- A Jira board export (CSV or JSON)
- A list of tickets copied from the Jira UI
- GitHub PR URLs or a `gh pr list` output
- Slack messages copied from your team channel

The agent prompt is designed to work with whatever you provide. More structured data = better report.

### Structured method: match the JSON format

For the best results, format your data to match the expected schema. See [`export-your-data.md`](export-your-data.md) for exact commands to export from Jira, GitHub, and Slack.

The minimum required fields per Jira ticket:

```json
{
  "key": "PROJ-123",
  "summary": "Ticket title",
  "status": "Done",
  "story_points": 3,
  "type": "Story",
  "priority": "Medium"
}
```

Additional fields (`assignee`, `linked_prs`, `blocked_by`, `labels`, etc.) enable richer analysis but are not required.

## Tips

- **Start with just Jira data.** The agents work with a single data source. Add GitHub PRs and Slack messages later for richer reports.
- **Longer context = better results.** Claude and GPT-4 handle the full prompt + 20 tickets + PRs comfortably. For smaller-context models, reduce the data to 10-15 tickets.
- **Re-run weekly.** The value compounds when you generate reports consistently — you can compare week-over-week and spot trends.
- **Edit the output.** The report is a starting point, not a final product. Add your own commentary, remove sections that aren't relevant, adjust the tone for your audience.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| AI produces a generic response | Make sure you pasted the full prompt *before* the data |
| Report is missing sections | Check that your data includes the required fields for that section |
| AI says "I can't process this" | Try a different AI tool, or reduce the data size |
| Output doesn't match expected format | Some models follow formatting instructions less precisely — Claude and GPT-4 are most reliable |
