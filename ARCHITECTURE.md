# Architecture

This document describes the high-level architecture of **Delivery Management Skills** and the reasoning behind key design decisions.

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     AI Coding Assistant                      │
│              (Cursor, Claude Code, Codex, ...)              │
└──────────────────────────┬──────────────────────────────────┘
                           │ reads
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                     Adapter Layer                            │
│         Translates skills into tool-native format            │
│              adapters/cursor/  adapters/claude-code/         │
└──────────────────────────┬──────────────────────────────────┘
                           │ loads
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                      Core Skills                             │
│      Structured markdown · Tool-agnostic · Composable        │
│                       skills/                                │
├─────────────┬─────────────┬─────────────┬───────────────────┤
│   Sprint    │    Risk     │  Reporting  │    Planning       │
│ Operations  │ Management  │             │                   │
├─────────────┼─────────────┼─────────────┼───────────────────┤
│  Quality    │Communication│  Enrichment │   Workflows       │
│   Gates     │             │  (optional) │  (compositions)   │
└─────────────┴──────┬──────┴─────────────┴───────────────────┘
                     │ optional
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  Integration Layer                            │
│           Mock data · Interface specs · Templates            │
│                    integrations/                              │
└─────────────────────────────────────────────────────────────┘
```

## Core Concepts

### Skills

A **skill** is an atomic, reusable unit of delivery management intelligence. Each skill is a structured markdown file (`SKILL.md`) with:

- **Rich metadata** (YAML frontmatter): name, version, category, autonomy level, portability, complexity, input/output contracts
- **Method**: Step-by-step procedure the AI agent follows
- **Quality criteria**: How to evaluate the output
- **Error handling**: Graceful degradation when data is missing

Skills are tool-agnostic. They contain no Cursor-specific syntax, no Claude Code directives, no vendor-specific API calls. They are pure delivery management logic expressed as structured instructions.

### Workflows

A **workflow** composes multiple skills into an end-to-end process. For example, `morning-scan` chains `detect-stuck-tickets` → `detect-ghost-done` → `detect-scope-change` → `format-for-audience`.

Workflows document:
- Which skills to invoke and in what order
- What data flows between skills
- Which skills can run in parallel
- Quality gates between stages

### Adapters

An **adapter** translates the tool-agnostic skill library into a specific AI tool's native format:

- **Cursor adapter**: Generates `.cursor/skills/`, `.cursor/rules/`, `.cursor/agents/` files
- **Claude Code adapter**: Generates `CLAUDE.md` project instructions
- **Future adapters**: Codex (`AGENTS.md`), Windsurf, etc.

Adapters are thin. They map skill metadata to tool conventions. They do not contain delivery management logic.

### Integrations

**Integrations** connect skills to live data sources (project trackers, version control, team chat). They are strictly optional — every skill works with manually provided data or mock data.

The `integrations/mock/` directory ships with realistic sample data so skills can be demonstrated and tested without any external service.

### Patterns

**Patterns** document reusable agentic design techniques (orchestration, verification, confidence calibration) demonstrated by the skills. They serve as reference material and as proof of engineering depth.

## Design Decisions

Architecture Decision Records live in [`docs/architecture-decisions/`](docs/architecture-decisions/).

| ADR | Title | Status |
|-----|-------|--------|
| [001](docs/architecture-decisions/001-skill-format.md) | Structured Markdown as skill format | Accepted |
| [002](docs/architecture-decisions/002-tool-agnostic-core.md) | Tool-agnostic core with adapter layer | Accepted |
| [003](docs/architecture-decisions/003-integration-boundary.md) | Integrations as optional enhancement | Accepted |
| [004](docs/architecture-decisions/004-evaluation-strategy.md) | Built-in evaluation and quality gates | Accepted |

## Quality Model

Every skill output passes through a quality pipeline:

```
Skill execution
    │
    ▼
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│self-check│────▶│evaluate-output│────▶│  cite-sources │
│ (5 checks│     │  (6 checks)  │     │  (tracing)   │
│  fast)   │     │  (thorough)  │     │              │
└──────────┘     └──────────────┘     └──────────────┘
    │                    │
    ▼                    ▼
  Pass ≥4/5?        Pass ≥7/10?
  Yes → deliver     No → iterate (max 2 passes)
  No → fix + retry  Then deliver with caveats
```

The `self-check` skill runs on every output. The `evaluate-output` skill runs on high-stakes outputs (sprint reports, stakeholder updates, PI plans).
