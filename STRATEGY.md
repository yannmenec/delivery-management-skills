# Strategy — Delivery Management Skills v2.0

> A toolkit of AI agents for Delivery Managers, Scrum Masters, and Program Managers.

## Vision

Delivery Managers spend 30-40% of their time on information gathering and report compilation — work that is repetitive, error-prone, and low-leverage. This project provides AI agents that automate those tasks, giving DMs their time back for the work that actually requires human judgment: unblocking teams, managing stakeholders, and making trade-off decisions.

## Design Principles

### 1. Anyone Can Use It

The primary user is a Delivery Manager who may not write code. Every agent must work by copying a prompt and pasting data into any AI chat. No CLI, no API keys, no dependencies. If it requires a terminal to be useful, it has failed its primary audience.

### 2. Value in 10 Minutes

A new user should go from "what is this?" to "this just saved me an hour" in under 10 minutes. The README shows a real output example before any setup instructions. Sample data is included. The first experience is copy-paste, not configuration.

### 3. Progressive Complexity

Three levels of usage, each unlocking more power without invalidating the previous level:

- **L1 — Paste**: Copy prompt + paste data into any AI chat. Zero setup.
- **L2 — Connected**: Claude Code + MCP fetches data from Jira/GitHub/Slack automatically. One-time config.
- **L3 — Orchestrated**: Agents chain together, run on schedule, post results to Slack. MCP + scheduling.

L1 is never gated behind L2 or L3. Every agent works at L1 forever.

### 4. Prompt-First Architecture

The core product is the **prompt** — a carefully written instruction set in markdown. Everything else (MCP configs, slash commands, scheduling) is an enhancement layer. This means:

- Prompts are portable: they work with Claude, GPT-4, Gemini, Llama, and any future model.
- Prompts are readable: a human can open the prompt and understand exactly what the agent does.
- Prompts are testable: paste prompt + data into any AI, compare output to the example.
- No code runtime: the repo contains markdown, JSON, YAML, and shell scripts. No package.json, no requirements.txt, no build step.

### 5. Real Problems Only

Every agent must trace back to a specific, documented frustration experienced by real delivery managers. No speculative features. No "wouldn't it be cool if" agents. The priority list comes from pain, not imagination.

## Architecture — The Prompt-First Stack

```
┌─────────────────────────────────────────────┐
│  L3: Orchestration Layer                    │
│  Scheduling, chaining, Slack delivery       │
│  (cron + MCP + shell scripts)               │
├─────────────────────────────────────────────┤
│  L2: Connection Layer                       │
│  MCP servers pull data from Jira/GitHub/    │
│  Slack. Claude Code slash commands.         │
│  (mcp/*.json + .claude/commands/)           │
├─────────────────────────────────────────────┤
│  L1: Agent Layer (THE PRODUCT)              │
│  Portable prompts in agents/*/prompt.md     │
│  Config in agents/*/config.yaml             │
│  Examples in agents/*/examples/             │
│  Shared parsers/formatters in lib/          │
├─────────────────────────────────────────────┤
│  Data Layer                                 │
│  JSON from Jira, GitHub, Slack, CI          │
│  Sample data in data/ for testing           │
└─────────────────────────────────────────────┘
```

The agent layer is the core. Everything above it is optional enhancement. Everything below it is input.

## Interface Strategy

### The Interface IS the LLM

There is no custom UI to build or maintain. The user interface is whichever AI assistant the user already has open — Claude, ChatGPT, Gemini, or Copilot. This is a deliberate strategic choice:

- **Zero distribution cost**: no app store, no hosting, no authentication.
- **Zero maintenance UI**: no frontend bugs, no responsive design, no accessibility audits.
- **Maximum reach**: works wherever any LLM works.

### Claude Projects as Primary Non-Dev Path

For users who want a persistent setup without touching a terminal, [Claude Projects](https://claude.ai) is the recommended path:

1. Create a project, upload agent prompts as Project Knowledge.
2. The prompts persist across conversations — no re-pasting.
3. Paste new data each time, or connect via MCP for auto-fetch.

This gives non-technical DMs a "workspace" without any code.

### Claude Code for Developer DMs

Developers and technical DMs use Claude Code with:
- Slash commands (`.claude/commands/`) for one-command execution.
- MCP servers for automatic data fetching.
- The full repo context for agent customization.

## 3-Horizon Roadmap

### H1: Foundation + Core Agents (Current)

Establish the repo structure, sample data, shared libraries, and the first two agents.

| Deliverable | Status | Effort |
|-------------|--------|--------|
| Repo structure (data, lib, mcp, docs) | Done (H1-A) | 1 day |
| Project Mercury sample dataset | Done (H1-A) | 1 day |
| Shared parsers and formatters | Done (H1-A) | 0.5 day |
| Weekly Rewind agent | Done (H1-B) | 1 day |
| Morning Scan agent | Done (H1-B) | 1 day |
| README product page | Done (H1-B) | 0.5 day |
| User guides (paste, Claude Projects, Claude Code) | Done (H1-B) | 0.5 day |
| Claude Code commands | Done (H1-B) | 0.5 day |

### H2: Expanded Agent Suite

Build the remaining priority agents and add cross-referencing capabilities.

| Deliverable | Status | Effort |
|-------------|--------|--------|
| Watermelon Auditor agent | Planned | 1 day |
| Blocker Detective agent | Planned | 1 day |
| Sprint Retro Prep agent | Planned | 1 day |
| Agent evaluation framework (golden outputs, rubrics) | Planned | 1 day |
| Multi-agent composition patterns | Planned | 0.5 day |

### H3: Orchestration + Automation

Enable scheduled, unattended agent execution with output delivery.

| Deliverable | Status | Effort |
|-------------|--------|--------|
| Cron-based scheduling for daily/weekly agents | Planned | 1 day |
| Slack delivery integration | Planned | 1 day |
| Agent chaining (morning scan feeds blocker detective) | Planned | 1 day |
| Confluence report publishing | Planned | 0.5 day |
| Historical trend tracking (velocity, blockers over time) | Planned | 1 day |

## Priority Agents

Selected based on documented frustrations from real Delivery Managers (see [`docs/frustrations.md`](docs/frustrations.md)):

| Agent | Pain Point | Frequency | Users | Priority |
|-------|-----------|-----------|-------|----------|
| **Weekly Rewind** | Friday status reports take 2h of copy-paste | Weekly | DM, PM, stakeholders | H1 |
| **Morning Scan** | Morning triage across 3 tools takes 20min | Daily | DM, Scrum Master | H1 |
| **Watermelon Auditor** | Jira says "Done" but no code was shipped | Per sprint | DM, Engineering Lead | H2 |
| **Blocker Detective** | Blockers discovered too late at standup | Daily | DM, Scrum Master | H2 |
| **Sprint Retro Prep** | Retros start cold with no data | Per sprint | Scrum Master | H2 |

## What We Will NOT Build

1. **A Jira dashboard replacement** — Jira's UI already shows boards and metrics. We process data, not display it.
2. **A project management tool** — We don't store state, track assignments, or manage workflows. We analyze snapshots.
3. **A developer productivity tracker** — We surface team-level patterns (overload, bottlenecks), not individual performance metrics. No leaderboards.
4. **An LLM framework or SDK** — No LangChain, no agent framework, no orchestration library. The prompts are the product.
5. **A real-time monitoring system** — We produce point-in-time reports from data snapshots, not live dashboards.

## Quality Standards

### Agent Quality

Every agent must meet these criteria before shipping:

- **Portable**: works with at least 2 different LLMs (Claude + GPT-4 minimum).
- **Graceful degradation**: partial data produces partial reports with clear warnings, never errors.
- **Correct field references**: every field name in the prompt must match the actual JSON schema in `data/`.
- **Example-driven**: includes `input-sample.json` (real data subset) and `output-sample.md` (realistic output).
- **Documented**: README with L1/L2/L3 usage paths, configuration reference.

### Prompt Quality

- No vendor-specific syntax (no XML tags, no system prompts, no tool-use markup).
- Clear role definition, explicit input format, step-by-step processing logic, exact output template.
- Handles missing fields gracefully (skip, don't error).
- Never invents data — if it's not in the input, it's not in the output.

### Output Quality

- Business-first language: "Payment API deployed to staging" not "Merged PR #148".
- Evidence-based: every claim references a specific ticket key, PR number, or data point.
- Actionable: risks include suggested next steps with owners.
- Appropriately scoped: daily scans are ~15 lines, weekly reports are ~80 lines.

## Success Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Time to first value | < 10 minutes | New user follows README to first report |
| Report accuracy | Zero hallucinated tickets | Compare output to input data |
| LLM portability | 2+ LLMs | Test each agent on Claude + GPT-4 |
| User adoption | 5+ DMs using weekly | Track via feedback / GitHub stars |
| Agent coverage | 5 agents by end of H2 | Count shipped agents |

## Repo Structure

```
delivery-management-skills/
├── agents/                   # Agent packages (the product)
│   ├── weekly-rewind/        # Weekly status report generator
│   │   ├── prompt.md         # Core portable prompt
│   │   ├── config.yaml       # Tunable parameters
│   │   ├── README.md         # Usage guide (L1/L2/L3)
│   │   └── examples/         # Input sample + output sample
│   ├── morning-scan/         # Daily morning briefing
│   ├── watermelon-auditor/   # Status vs reality auditor (H2)
│   ├── blocker-detective/    # Stuck work detector (H2)
│   └── sprint-retro-prep/   # Retro data preparation (H2)
├── data/                     # Sample datasets (Project Mercury)
├── lib/                      # Shared prompt fragments
│   ├── parsers/              # Data parsing conventions
│   └── formatters/           # Output formatting standards
├── mcp/                      # MCP server configurations (L2)
├── docs/                     # Architecture decisions, research
├── guides/                   # User guides by persona
├── .claude/                  # Claude Code integration
│   ├── commands/             # Slash commands
│   └── settings.json         # Permissions
├── archive/v1/               # Original v1 content (preserved)
├── README.md                 # Product page (start here)
├── STRATEGY.md               # This file
└── CHANGELOG.md              # Release history
```

## Contributing

### Adding a New Agent

1. **Write a Problem Card**: Document the frustration, affected roles, required data sources, and expected output. File it as a GitHub issue or add to `docs/frustrations.md`.

2. **Build L1 first**: Create `agents/{name}/prompt.md` that works as a copy-paste prompt in any AI chat. This is the minimum viable agent.

3. **Test on sample data**: Create `examples/input-sample.json` from existing `data/` files and generate `examples/output-sample.md`. Verify the output is useful and accurate.

4. **Keep it portable**: Test on at least 2 LLMs. No vendor-specific syntax in the prompt.

5. **Add config and docs**: Create `config.yaml` for tunable parameters and `README.md` with L1/L2/L3 usage paths.

6. **Submit for review**: Open a PR with the full agent package. Include the output-sample.md as evidence of quality.

### Improving an Existing Agent

- Field name changes must be verified against `data/` schemas.
- Output format changes must update both `prompt.md` and `examples/output-sample.md`.
- New processing logic must include test cases in the input sample that exercise it.

### What Makes a Good Agent

- Solves a specific, recurring pain point (not a one-off task).
- Produces output a DM can use directly (not raw data to interpret).
- Works with partial data (graceful degradation).
- Fits the 3-level architecture (L1 paste, L2 connected, L3 orchestrated).
