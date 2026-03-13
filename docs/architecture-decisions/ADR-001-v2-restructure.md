# ADR-001: V2 Repo Restructure — Agent-Centric Architecture

## Status

Accepted

## Context

The v1 repo was a flat collection of markdown skills, patterns, and workflows. This structure made it unclear how to use the toolkit, what to run first, and how pieces connected. User testing showed that new visitors couldn't get value within 10 minutes.

Specific problems with v1:
- **No clear entry point**: 21 skills in nested category folders with no obvious starting point
- **Disconnected pieces**: Skills, patterns, and workflows referenced each other but had no runtime connection
- **No sample data**: Users had to bring their own Jira/GitHub data to test anything
- **Adapter confusion**: Cursor and Claude Code adapters duplicated configuration logic
- **Hidden dependencies**: Skills depended on each other via `depends_on` fields but this wasn't enforced or visible

## Decision

Restructure around self-contained agent packages. Each agent has its own directory with: prompt, runner, config, and examples. Shared utilities live in `reference/`. V1 content is archived, not deleted.

Key architectural choices:

1. **Agent as the unit of value**: Each agent directory is independently usable — paste the prompt, point it at data, get a report.
2. **Shared parsers and formatters**: Common data parsing (Jira, GitHub) and output formatting (Markdown, Slack) live in `reference/` as prompt fragments that agents include.
3. **Sample data as first-class**: The `data/` directory provides realistic, cross-referenced datasets that work out of the box.
4. **MCP configs as templates**: The `mcp/` directory provides copy-paste configuration for live data connections.
5. **Progressive complexity**: Level 1 (paste prompt + data), Level 2 (MCP live data), Level 3 (orchestrated multi-agent).
6. **Archive, don't delete**: All v1 content moves to `archive/v1/` preserving the original structure for reference.

## Consequences

### Positive
- Clear entry points — each agent is independently discoverable and usable
- Progressive complexity — users can start with sample data and graduate to live MCP
- Testable — sample data enables consistent evaluation of agent output quality
- Extensible — new agents follow a standard package structure

### Negative
- Some v1 content loses visibility (archived, not in main tree)
- Skills that were general-purpose in v1 become embedded in specific agents in v2
- Maintaining consistency across agent packages requires discipline

### Neutral
- Requires maintaining sample data alongside agent prompts
- Contributors need to understand the agent package structure before adding new agents
