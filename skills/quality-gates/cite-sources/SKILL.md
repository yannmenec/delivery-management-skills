---
name: cite-sources
version: 1.0.0
description: >
  Annotates agent output with inline source citations to eliminate
  hallucination risk. Ensures every metric, claim, and ticket reference
  is traceable to a specific data source.
category: quality-gates
trigger: Final step before delivering any agent output
autonomy: autonomous
portability: universal
complexity: basic
type: evaluation
inputs:
  - name: agent_output
    type: structured-text
    required: true
    description: The full text output to annotate with source citations
outputs:
  - name: cited_output
    type: structured-text
    description: The agent output with inline citations added after every metric, claim, and ticket reference
tools_optional: []
model_compatibility: [claude, gpt-4, gemini, llama-3]
---

# Cite Sources

## Purpose

Ensures every claim, metric, and recommendation in an agent's output is traceable to a specific data source. Eliminates hallucination risk by enforcing citation discipline.

## When to Use

Apply as the last quality step before delivering output, after `self-check` or `evaluate-output`. Particularly important for reports, stakeholder updates, and any output containing numbers or ticket references.

## Method

1. **Scan the output** for every number, percentage, metric, ticket reference, date, and factual claim.

2. **For each item, attach a source citation** using one of these formats:

   | Claim Type | Citation Format |
   |------------|----------------|
   | Ticket counts | `(source: query "sprint in openSprints() AND status = Done" returned N tickets)` |
   | Story points | `(source: story points field on PROJ-123)` |
   | Percentages | `(source: 18 done / 24 total = 75%)` |
   | PR/CI data | `(source: PR #456, status: merged)` |
   | Dates | `(source: sprint end date from tracker)` |
   | Recommendations | `(based on: 3 tickets blocked >5 days)` |

3. **Citation placement** — append inline after the claim:
   ```
   Velocity: 34 SP (source: sum of story points on Done tickets in Sprint 1)
   ```

4. **Unsourceable claims** — if a claim cannot be traced to provided data:
   - Mark it: `(unverified — no data source available)`
   - Or remove it and note: "Metric omitted: {what} — source data unavailable"
   - Never leave an unsourced numeric claim in the output.

5. **Citation density target**: every numeric value and every factual assertion should have a citation. Narrative summaries and recommendations need at least one supporting citation.

## Output Format

The original agent output with inline citations added. No structural changes to the report format — citations are appended inline.

## Error Handling

- **No data sources provided**: Note "Citations cannot be verified — no source data available" at the top of the output. Pass through unchanged.
- **Mixed sourced/unsourced**: Cite what can be cited, mark the rest `(unverified)`. Never silently pass unsourced claims.
- **Conflicting sources**: If two data points disagree, note both: "Velocity: 34 SP (source A) vs 31 SP (source B) — discrepancy noted."
