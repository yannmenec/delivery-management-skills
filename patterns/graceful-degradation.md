# Graceful Degradation

## What It Is

**Graceful degradation** is the practice of producing useful output even when data is missing, integrations are unavailable, or inputs are incomplete. The skill never fails silently—it always tells the user what's missing and how that affects the output.

```
    ┌─────────────────────────────────────────────────────────────────┐
    │                     DATA REQUEST                                 │
    │                                                                  │
    │   Tier 1 (Core)     Tier 2 (Standard)      Tier 3 (Optional)     │
    │   ─────────────     ─────────────────      ──────────────────     │
    │   sprint_tickets    sprint_history         pr_status             │
    │   sprint_context    github PR data         deployment_label      │
    │   (required)        (enhances)             (enriches)            │
    └─────────────────────────────────────────────────────────────────┘
                                       │
                    ┌──────────────────┼──────────────────┐
                    │                  │                  │
                    ▼                  ▼                  ▼
            ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
            │ Core missing │  │ Standard     │  │ Optional     │
            │ → Cannot     │  │ missing →    │  │ missing →    │
            │   proceed    │  │ Partial      │  │ Proceed,     │
            │   (request   │  │ output with  │  │ note gap     │
            │   data)      │  │ caveats      │  │              │
            └──────────────┘  └──────────────┘  └──────────────┘
```

## Why It Matters

- **Partial output with caveats > no output**: A sprint report without velocity is still useful for blockers and scope change. Failing entirely because velocity data is missing wastes the user's time.
- **Explicit gaps**: Users know what to verify or fetch. "PR data unavailable — code activity not assessed" is actionable; silent omission is not.
- **Fallback chains**: When the primary source fails, try a fallback (e.g., Jira dev panel when GitHub MCP is down). Only when all options fail: skip with a note.

## How It Works

### Tiered Data Model

| Tier | Role | Behavior When Missing |
|------|------|------------------------|
| **Core** | Required for any output | Cannot proceed. Request data and explain which fields are needed. |
| **Standard** | Enhances output significantly | Proceed with partial output. Skip affected sections. Note limitation. |
| **Optional** | Enriches but not essential | Proceed normally. Note gap in output (e.g., "PR data unavailable"). |

### Fallback Chains

Per `data-sources.mdc`:

| Source | Primary | Fallback | Last Resort |
|--------|---------|----------|-------------|
| GitHub | GitHub MCP | Tracker dev panel (PR custom field) | Skip with note |
| Confluence | Atlassian MCP (CQL) | — | Skip with note |
| Slack, Monday | MCP | — | Skip with note |

### Principles

1. **Never fail silently**: If data is missing, say so. Use "Data unavailable: {reason}" or "N/A — {explanation}".
2. **Never fabricate**: Do not invent ticket keys, numbers, or dates. Mark "(unverified)" or "(estimated)" when approximating.
3. **Section presence**: Even if a section has no data, include the header with "None" or "Data unavailable: {reason}". Per output standards: never silently omit sections.

## When to Use It

- **Every skill**: Define which inputs are core vs optional. Document fallbacks for integrations.
- **Workflows**: If a sub-skill fails (e.g., PR data unavailable for ghost-done), proceed with available results and note the gap.

## How It Appears in This Repo

- **`skills/sprint-operations/detect-stuck-tickets/SKILL.md`**: "If PR data is unavailable: skip PR-related analysis and note 'PR data unavailable — code activity not assessed.'" "If sprint context is missing: skip urgency escalation and note 'Sprint timeline unknown.'"
- **`skills/sprint-operations/detect-ghost-done/SKILL.md`**: "If PR, version, or deployment data is unavailable for some tickets, those tickets cannot be evaluated. Note the gap in the output."
- **`skills/sprint-operations/sprint-health-check/SKILL.md`**: Detailed error handling—missing sprint_history → skip velocity, set RAG from other signals; missing created dates → skip scope change section.
- **`workflows/morning-scan.md`**: "If any sub-skill fails: proceed with available results. Note: '{skill} could not complete — {reason}. Findings may be incomplete.'"
- **`.cursor/rules/data-sources.mdc`**: Tiered model (Core/Standard/Domain), fallback chains, freshness thresholds.

## Pitfalls

- **Over-degrading**: Don't skip everything at the first missing field. Distinguish core from optional.
- **Vague caveats**: "Some data was missing" is useless. Specify: "PR status missing for 6 of 10 tickets."
- **Cascading failure**: If the orchestrator fails when one specialist fails, the whole workflow dies. Design orchestrators to merge partial results.
- **Stale data handling**: Per freshness thresholds, data older than 24h (Jira/GitHub), 30d (Confluence), or 7d (Slack/Monday) should be flagged. Don't silently use stale data—note it and consider downgrading confidence.
