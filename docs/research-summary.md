# Research Summary — Cheat Sheet

One-page actionable digest of the delivery management AI research. For contributors building agents.

## Key Stats

- **40-60%** of a delivery manager's time goes to mechanical admin tasks (data gathering, report formatting, status chasing)
- **~15%** of "Done" tickets in the average sprint are watermelons (status doesn't match reality)
- **3-5 days** earlier is when dependency risks could be surfaced with systematic scanning
- **8-12 hours/week** recoverable through automated daily scans and report generation
- **25-40%** reduction in unplanned work when scope change is made visible and tracked

## Top 5 Agents to Build (Priority Order)

| # | Agent | Frustration Solved | Complexity | Value |
|---|-------|--------------------|------------|-------|
| 1 | **Morning Scan** | Admin Tax, Meeting Overload | Low | High |
| 2 | **Watermelon Auditor** | Watermelon Reporting | Medium | High |
| 3 | **Blocker Detective** | Dependency Tracking | Medium | High |
| 4 | **Weekly Rewind** | Admin Tax, Scope Creep | Medium | Medium |
| 5 | **Sprint Retro Prep** | Meeting Overload | Low | Medium |

The order reflects a build-on-foundation approach: Morning Scan establishes the data pipeline, Watermelon Auditor and Blocker Detective build on the same data for deeper analysis, and Weekly Rewind and Sprint Retro Prep compose outputs from the earlier agents.

## What to Build

### Must-Have Capabilities
- **Cross-system correlation**: Jira status vs. GitHub PR state vs. CI results — this is the foundation of trust detection
- **Anomaly detection**: Stale tickets, review bottlenecks, overloaded developers, orphan PRs
- **Scope tracking**: Delta between sprint start commitment and current state
- **Dependency scanning**: Issue link traversal to surface cross-team blocking risks
- **Actionable output**: Every finding includes a recommended next step and an owner

### Design Principles
- **Data over opinions**: Every claim must trace to a ticket key, PR number, or metric
- **Progressive complexity**: Level 1 = paste prompt + sample data. Level 2 = MCP live data. Level 3 = orchestrated multi-agent
- **Confidence-aware**: Agents state their confidence level and flag missing data sources
- **Human-in-the-loop**: Agents recommend, humans decide — especially for status transitions and escalations

## What NOT to Build (5 Overhyped Ideas)

| Idea | Why It Fails |
|------|-------------|
| **Auto-assign tickets** | Ignores team context, developer preferences, and growth goals. Creates resentment. Leave assignment to humans. |
| **Predict sprint completion date** | Requires modeling unknowns (sick days, scope changes, external blockers) that make predictions unreliable. Focus on surfacing risks instead of predicting outcomes. |
| **Auto-close stale tickets** | Data quality isn't good enough. Closing a ticket that's actually in progress (but poorly updated) causes more harm than a stale ticket sitting open. Recommend closing; don't auto-close. |
| **Generate sprint goals from backlog** | Sprint goals require product strategy context that doesn't live in Jira. AI can summarize what's planned but shouldn't set direction. |
| **Replace standups entirely** | Standups serve social and team-building functions beyond status exchange. Replace the *status* portion with async data, keep the *human* portion synchronous. |

## Build Sequence

```
H1-A: Foundation (repo structure, sample data, shared lib)     ← YOU ARE HERE
H1-B: Core agents (morning-scan, watermelon-auditor, blocker-detective)
H1-C: Composition agents (weekly-rewind, sprint-retro-prep)
H2:   MCP live integration, evaluation framework, orchestration
```

## Contributing

When adding a new agent:
1. Start from the agent package template (defined in H1-B)
2. Write the prompt using shared parsers from `lib/parsers/`
3. Format output using shared formatters from `lib/formatters/`
4. Test against sample data in `data/` before connecting to live MCP
5. Add evaluation criteria and golden output examples
