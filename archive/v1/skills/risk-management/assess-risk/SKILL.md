---
name: assess-risk
version: 1.0.0
description: Scores delivery risks using likelihood-impact matrix with RAG status and mitigation tracking.
category: risk-management
trigger: Risk review meeting, sprint planning, PI planning, escalation preparation, delivery health check.
autonomy: supervised
portability: universal
complexity: intermediate
type: computation
inputs:
  - name: risk_items
    type: structured-text
    required: true
    description: >
      List of identified risks. Per risk: description, category, affected scope
      (sprint/PI/project), any known mitigation. Can also accept raw context
      (sprint data, blocker list, dependency map) from which to identify risks.
  - name: sprint_context
    type: structured-text
    required: false
    description: Sprint metadata for severity calibration (days remaining, scope, team size).
outputs:
  - name: risk_register
    type: structured-text
    description: >
      Scored risk register with RAG per risk, severity ranking, mitigation
      status, and top-3 recommendations.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Assess Risk

Evaluate delivery risks using a structured likelihood-impact matrix. Produces a scored risk register with RAG status, severity ranking, and actionable mitigation recommendations.

## When to Use

- Sprint planning (identify risks to the sprint goal)
- PI planning (identify risks to PI objectives)
- Mid-sprint checkpoints (reassess known risks)
- Before escalation meetings (quantify the risk you are escalating)
- Periodic risk reviews

## Method

### Step 1: Identify or validate risks

If provided with raw context (sprint data, blockers, dependencies) rather than pre-identified risks, scan for common delivery risk patterns:

| Pattern | Risk Category |
|---------|--------------|
| Critical/Blocker ticket stuck 3+ days | Execution risk |
| External dependency with no confirmed delivery date | Dependency risk |
| Key team member on PTO or overloaded (3+ tickets In Progress) | Capacity risk |
| Scope increased mid-sprint by >15% | Scope risk |
| PR review queue backed up (3+ PRs waiting 2+ days) | Process risk |
| No QA coverage for a critical feature | Quality risk |
| Unclear requirements on high-priority ticket | Requirements risk |
| Integration with external system untested | Technical risk |

### Step 2: Score each risk

Use a 5-point scale for both dimensions:

**Likelihood** (how likely the risk materializes):

| Score | Level | Criteria |
|-------|-------|----------|
| 1 | Rare | <10% chance; no historical precedent |
| 2 | Unlikely | 10-30%; has happened once before |
| 3 | Possible | 30-60%; happens occasionally |
| 4 | Likely | 60-85%; has happened multiple times recently |
| 5 | Almost certain | >85%; currently materializing or imminent |

**Impact** (consequences if the risk materializes):

| Score | Level | Criteria |
|-------|-------|----------|
| 1 | Negligible | Minor delay, no sprint goal impact |
| 2 | Low | 1-2 day delay, minor scope adjustment |
| 3 | Moderate | Sprint goal partially compromised, 1 feature delayed |
| 4 | High | Sprint goal at risk, multiple features delayed, stakeholder impact |
| 5 | Severe | Sprint fails, release delayed, significant stakeholder impact |

**Severity** = Likelihood x Impact (1-25 scale).

### Step 3: Assign RAG status

| Severity Score | RAG | Action |
|----------------|-----|--------|
| 1-4 | Green | Monitor. No immediate action needed. |
| 5-9 | Amber | Mitigate. Active mitigation required this sprint. |
| 10-15 | Red | Escalate. Requires immediate attention and may need external help. |
| 16-25 | Critical Red | Emergency. Stop-the-line — this risk is actively threatening delivery. |

### Step 4: Assess mitigation status

For each risk, classify the current mitigation:

| Status | Definition |
|--------|-----------|
| Mitigated | Active mitigation in place and working |
| In Progress | Mitigation started but not yet effective |
| Planned | Mitigation identified but not started |
| Unmitigated | No mitigation in place |
| Accepted | Risk acknowledged, decision to not mitigate (document rationale) |

### Step 5: Rank and recommend

1. Sort risks by severity (highest first)
2. For the top 3 risks, provide a specific, actionable mitigation recommendation:
   - **What** to do (concrete action, not "monitor the situation")
   - **Who** should do it (role or name if known)
   - **By when** (date or sprint milestone)

## Output Format

```
## Risk Assessment

**Date**: {date}
**Scope**: {sprint name / PI name / project name}
**Overall RAG**: {Green|Amber|Red} — {one-line justification}

### Risk Register

| # | Risk | Category | L | I | Severity | RAG | Mitigation Status |
|---|------|----------|---|---|----------|-----|-------------------|
| 1 | {description} | {category} | {1-5} | {1-5} | {L*I} | {RAG} | {status} |
| 2 | ... | ... | ... | ... | ... | ... | ... |

### Top Risks and Recommendations

**1. {Risk title}** — Severity: {score}, RAG: {status}
- Impact: {what happens if this materializes}
- Current mitigation: {what is being done}
- Recommendation: {specific action} — Owner: {who} — By: {when}

**2. {Risk title}** — Severity: {score}, RAG: {status}
- Impact: {what happens}
- Current mitigation: {status}
- Recommendation: {action} — Owner: {who} — By: {when}

**3. {Risk title}** — Severity: {score}, RAG: {status}
- Impact: {what happens}
- Current mitigation: {status}
- Recommendation: {action} — Owner: {who} — By: {when}

### Summary
- **Total risks**: {count}
- **Distribution**: {N} Red, {N} Amber, {N} Green
- **Unmitigated**: {count} risks with no mitigation in place

**Confidence**: {High|Medium|Low} — {justification based on data completeness}
```

## Error Handling

- If no risks are identified from the provided data: state "No material risks identified from the provided data. This may indicate low risk or insufficient data." Never fabricate risks.
- If likelihood or impact cannot be assessed due to missing data: score conservatively (higher scores) and mark "(estimated — insufficient data for precise scoring)."
- If the same risk appears in multiple categories (e.g., a blocked dependency is both a dependency risk and an execution risk): list it once under the primary category. Note the secondary impact.

## Verification Phase

After scoring all risks, independently verify:

1. Does each risk score have supporting evidence from the provided data?
2. Are there any duplicate risks scored separately that should be merged?
3. Is the likelihood/impact consistent with the risk description (e.g., a risk described as "high probability" should not score 1 on likelihood)?

If any verification fails, revise the scoring before delivering.

## Self-Consistency Note

For RAG assignment and severity scoring, consider whether a slightly different reading of the evidence would change the verdict. If two plausible interpretations yield different RAG statuses, downgrade confidence to Medium and note the ambiguity.
