# Delivery Management Skills

**v2 restructure in progress.** Agent packages coming in the next increment (H1-B).

## Current State

This repo has been restructured from a flat skill collection (v1) to an agent-centric architecture (v2). See [ADR-001](docs/architecture-decisions/ADR-001-v2-restructure.md) for the rationale.

### What's here now (H1-A: Foundation)

- `data/` — Realistic sample datasets for a fictional project (Project Mercury)
- `lib/` — Shared parsers and formatters as prompt fragments
- `mcp/` — MCP server configuration templates for Atlassian, GitHub, Slack
- `docs/` — Architecture decisions, research summary, frustrations reference
- `agents/` — Empty directories for the 5 planned agents (created in H1-B)
- `archive/v1/` — All original v1 content preserved for reference

### What's coming next (H1-B: Core Agents)

- `agents/morning-scan/` — Daily sprint briefing
- `agents/watermelon-auditor/` — Detect tickets where status doesn't match reality
- `agents/blocker-detective/` — Surface dependency risks and stuck work
- `agents/weekly-rewind/` — Sprint summary and scope change tracking
- `agents/sprint-retro-prep/` — Data-driven retrospective preparation

## Quick Start

While agents aren't built yet, you can explore the sample data:

1. Read `data/README.md` to understand Project Mercury
2. Browse the JSON files in `data/` to see realistic sprint data with intentional anomalies
3. Check `lib/` for the shared parsing and formatting conventions agents will use

## License

See `archive/v1/LICENSE`.
