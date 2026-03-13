# Reference Library

Standalone reference documents for data schemas, parsing rules, and 
output formatting conventions used across the delivery-management-skills 
toolkit.

## What These Are

These are **reference documents**, not imported dependencies. Each agent 
prompt is self-contained and does not import from this directory. These 
files are useful for:

- Understanding the data schemas agents expect
- Building new agents with consistent conventions
- Uploading to Claude Projects alongside agent prompts for richer context

## Contents

### Parsers
- `parsers/jira-parser.md` — Jira data schema, field descriptions, anomaly detection rules
- `parsers/github-parser.md` — GitHub PR/commit/CI schema and cross-referencing rules

### Formatters
- `formatters/markdown-report.md` — Markdown output conventions for delivery reports
- `formatters/slack-message.md` — Slack message formatting for agent notifications
