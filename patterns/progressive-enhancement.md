# Progressive Enhancement

## What It Is

**Progressive enhancement** means every skill works at three levels of capability, and each level is independently useful:

```
    ┌─────────────────────────────────────────────────────────────────┐
    │ Level 3: FULL (prompt + integration data + automation)          │
    │   Agent queries tracker, enriches with VCS data, auto-posts    │
    │                                                                │
    │ ┌─────────────────────────────────────────────────────────────┐ │
    │ │ Level 2: ENHANCED (prompt + integration data)               │ │
    │ │   Agent uses MCP to pull live data, human reviews output   │ │
    │ │                                                            │ │
    │ │ ┌────────────────────────────────────────────────────────┐ │ │
    │ │ │ Level 1: BASE (prompt + manual data)                   │ │ │
    │ │ │   User pastes data, agent analyzes, outputs report    │ │ │
    │ │ └────────────────────────────────────────────────────────┘ │ │
    │ └─────────────────────────────────────────────────────────────┘ │
    └─────────────────────────────────────────────────────────────────┘
```

## Why It Matters

- **Zero setup friction**: A user can get value from Level 1 in under 2 minutes — clone, paste data, get output.
- **Gradual adoption**: Teams can start with manual data, add integrations when ready, automate when trusted. No big-bang commitment.
- **Resilience**: When an integration is down, the skill degrades to Level 1 rather than failing entirely.

## When to Use

Apply to every skill. The three levels should be a design constraint, not an afterthought. A skill that only works with live API data is not portable and not resilient.

## How It Works

### Level 1: Base (prompt-only)

The skill works with manually provided data. Input can be pasted text, a table, a CSV, or the included mock data. No tools, no APIs, no configuration.

### Level 2: Enhanced (prompt + integration data)

The skill uses MCP or API tools to pull live data from project trackers, version control, or team chat. The output is richer (real-time status, PR data, CI results) but the skill still generates the same output structure.

### Level 3: Full (prompt + integration + automation)

The skill can take action: post comments, update boards, send messages. This level requires explicit human approval (human-in-the-loop autonomy).

### Skill Metadata

The `portability` field in skill metadata indicates the minimum level:
- `universal`: Works at Level 1 (manual data). Most skills.
- `requires-integration`: Needs at least Level 2 (live data source).

## How It Appears in This Repo

- **Every skill** has a `## Input` section that accepts manual data and a note about optional integration enhancement.
- **`integrations/mock/`** provides sample data for Level 1 usage and testing.
- **`integrations/_interface/data-source.md`** documents the abstract interface for Level 2 connectors.
- **`adapters/`** provide tool-specific installation that enables Level 2 and 3.

## Pitfalls

- **Level 2 as prerequisite**: If a skill requires live data to produce any useful output, it violates progressive enhancement. Design the skill to work with pasted data first.
- **Hidden Level 3 in Level 1**: A skill that auto-posts during what should be a read-only analysis breaks the trust model. Automation must be explicit and gated.
- **Mock data rot**: Mock data that drifts from realistic structures becomes useless for testing. Keep mock data realistic and update it when skill inputs change.
