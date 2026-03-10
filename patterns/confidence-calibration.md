# Confidence Calibration

## What It Is

**Confidence calibration** is the practice of explicitly signaling uncertainty in agent output. Instead of presenting findings as definitive, every skill output includes a confidence level (High, Medium, Low) with a brief justification based on data completeness, source freshness, and sample size.

```
    ┌─────────────────────────────────────────────────────────────┐
    │                    SKILL OUTPUT                             │
    │                                                             │
    │  ## Stuck Tickets: 3 found                                   │
    │  ...                                                        │
    │                                                             │
    │  ---                                                        │
    │  **Confidence**: Medium                                     │
    │  **Reason**: PR data unavailable for 2 of 3 tickets —       │
    │  code activity not fully assessed.                          │
    └─────────────────────────────────────────────────────────────┘
```

## Why It Matters

- **False confidence is worse than stated uncertainty**: A wrong number presented confidently damages trust. A number with "Medium confidence — estimated from last_updated" lets the user calibrate their reliance.
- **Actionable transparency**: Users can decide whether to act immediately or verify first. High confidence → act. Low confidence → double-check.
- **Reduces overclaiming**: LLMs tend to sound confident even when uncertain. Requiring an explicit confidence assessment forces the agent to reason about data quality.

## How It Works

### Thresholds

| Level | Data Completeness | Typical Conditions |
|-------|-------------------|--------------------|
| **High** | >90% of needed data available | All core fields present, sources fresh (<24h for Jira/GitHub), sufficient sample size |
| **Medium** | 70–90% available | Some optional fields missing, one source stale, or small sample |
| **Low** | <70% available | Critical data missing, multiple sources stale, or very small sample |

### Justification Factors

- **Data completeness**: Are required fields present? Are optional enrichment fields (PR status, deployment label) available?
- **Source freshness**: Per `data-sources.mdc`, Jira/GitHub <24h = fresh; Confluence <30d; Slack/Monday <7d. Stale data downgrades confidence.
- **Sample size**: Velocity from 1 sprint vs 5 sprints; risk assessment from 3 tickets vs 30.

### Where It Appears

Every skill output must include a confidence assessment. The `self-check` skill explicitly validates this in **Check 4: Confidence Stated**.

## When to Use It

- **Always**: Every skill and workflow output should end with a confidence line.
- **Downgrade when**: Data is missing, sources are stale, or the agent had to estimate or infer.

## How It Appears in This Repo

- **`skills/quality-gates/self-check/SKILL.md`**: Check 4 requires "Confidence level present with reason" and defines High (>90%), Medium (70–90%), Low (<70%).
- **`workflows/morning-scan.md`**: Output format includes `**Confidence**: {High|Medium|Low}`.
- **`skills/sprint-operations/sprint-health-check/SKILL.md`**: RAG determination includes fallbacks (e.g., "Trajectory unknown — RAG based on other signals") which implicitly affect confidence.
- **`skills/communication/craft-unblock-message/SKILL.md`**: Outputs include `confidence` and `Reason` fields.

## Pitfalls

- **Generic justifications**: "Low confidence due to incomplete data" is unhelpful. Specify *what* is missing (e.g., "PR data unavailable for 5 of 8 tickets").
- **Overconfidence**: Defaulting to High when data is thin. When in doubt, downgrade.
- **Ignoring confidence**: If the UI or downstream process hides the confidence line, users cannot calibrate. Surface it prominently.

### Combining with RAG

When an output includes both RAG (Red/Amber/Green) and confidence, they serve different purposes. RAG describes *outcome* (sprint on track or not); confidence describes *data quality* (how much we trust the analysis). A report can be "Amber" with "High confidence" (we're sure things are at risk) or "Amber" with "Low confidence" (we think things are at risk but our data is thin).

### Confidence in Specialist Outputs

Specialist skills (e.g., `detect-ghost-done`) may output per-item confidence (e.g., "High" for a ticket with PR merged + fix version released). The orchestrator then aggregates: if most specialists have high-confidence findings, the overall report confidence can be High; if many findings are low-confidence or data is sparse, the overall confidence should be Medium or Low.

### When to Downgrade

Downgrade from High to Medium when: one optional data source is missing; one source is stale; sample size is small (e.g., velocity from 2 sprints). Downgrade to Low when: core data is missing; multiple sources are stale; the agent had to estimate or infer critical values.

**Summary**: Every skill output should include a confidence line. The self-check skill enforces this. Calibrate thresholds based on data completeness, freshness, and sample size. When in doubt, downgrade.
