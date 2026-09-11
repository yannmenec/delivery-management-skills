# Delivery Management Skills

Ready-to-use AI agent prompts for delivery management: weekly status reports, morning triage,
Jira-vs-GitHub trust checks, and blocker detection. Each agent is a plain-text prompt plus sample
data — paste it into any AI assistant, or run it through Claude Code.

No automated tests, no continuous integration: there is no application code here, only prompts,
config, and sample data to read.

## See it in two minutes

This is real output from the **Weekly Rewind** agent, generated from
[`agents/weekly-rewind/examples/sample-input.json`](agents/weekly-rewind/examples/sample-input.json)
— a fictional Project Mercury sprint. The sample file covers 8 of the 20 tickets in Sprint 42
(37 of the sprint's 78 story points), so the numbers below describe that subset, not the whole
sprint.

> **Highlights**
> - Payment gateway SDK v3 integration complete — merged and passing CI with 88% coverage.
> - Real-time payment status webhooks deployed.
> - Transaction reliability improved with exponential backoff retry logic.
>
> **Sprint Health** (for the 8 tickets in this sample)
> - Progress: 4/8 items (50%)
> - Story Points: 16/37 (43%)
> - Blockers: 2 (1 external vendor, 1 internal dependency)

Full output: [`agents/weekly-rewind/examples/sample-output.md`](agents/weekly-rewind/examples/sample-output.md).

## The four agents

| Agent | What it does | Directory |
|-------|---------------|-----------|
| Weekly Rewind | Generates a weekly status report from sprint data | [`agents/weekly-rewind/`](agents/weekly-rewind/) |
| Morning Scan | Surfaces blockers and priorities before standup | [`agents/morning-scan/`](agents/morning-scan/) |
| Watermelon Auditor | Cross-checks Jira status against GitHub activity | [`agents/watermelon-auditor/`](agents/watermelon-auditor/) |
| Blocker Detective | Detects stuck PRs, failing CI, overloaded developers | [`agents/blocker-detective/`](agents/blocker-detective/) |

Each directory has a `prompt.md` (the agent itself), a `README.md`, and `examples/` with sample
input and output.

## Quick start

1. Copy an agent's `prompt.md`.
2. Copy its sample input from `examples/`.
3. Paste both into Claude, ChatGPT, Gemini, or any AI assistant.
4. Or, with Claude Code: `git clone https://github.com/yannmenec/delivery-management-skills.git`,
   then `claude /weekly-rewind` (commands live in [`.claude/commands/`](.claude/commands/)).

Guides for each path: [`guides/`](guides/).

## Using your own data

Swap the sample JSON for an export of your own Jira, GitHub, or Slack data — see
[`guides/export-your-data.md`](guides/export-your-data.md). To connect an agent directly to your
tools instead of pasting exports, use the MCP configuration templates in [`mcp/`](mcp/)
(Atlassian, GitHub, Slack).

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md).

## License

See [`LICENSE`](LICENSE).
