---
name: stakeholder-update
version: 1.0.0
description: >
  Generates a concise stakeholder status update — lighter than a full sprint
  report, focused on what stakeholders need to know.
category: reporting
trigger: Quick status request, weekly stakeholder sync, pre-meeting brief, async status share.
autonomy: supervised
portability: universal
complexity: intermediate
type: generation
inputs:
  - name: sprint_summary
    type: structured-text
    required: true
    description: >
      Condensed sprint data: completion %, trajectory, blocker count, key
      risks, scope change (if any). Can be derived from a full sprint report
      or gathered manually.
  - name: audience
    type: text
    required: false
    default: engineering-management
    description: >
      Target audience: engineering-management (default), c-level, product,
      engineering-team, cross-team. Use format-for-audience for adaptation.
  - name: decisions_pending
    type: structured-text
    required: false
    description: >
      List of decisions needed from stakeholders (decision, owner, urgency).
outputs:
  - name: stakeholder_update
    type: text
    description: >
      Concise update under 1 page: RAG, 3 highlights, risks, decisions, next steps.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Stakeholder Update

Produces a concise, stakeholder-focused status update. Shorter than a full sprint report — typically under 1 page. Answers "What do stakeholders need to know?" rather than "What happened in the sprint?"

For a comprehensive sprint report, use **generate-sprint-report** instead. After generating this update, apply **format-for-audience** to adapt for audiences other than engineering management (C-level, Product, Engineering Team, Cross-team).

## When to Apply

- Quick status request from a stakeholder
- Weekly stakeholder sync preparation
- Pre-meeting brief (standup with leadership, PI sync)
- Async status share (email, Slack, Confluence)

## Difference from Generate Sprint Report

| Aspect | Stakeholder Update | Generate Sprint Report |
|--------|-------------------|------------------------|
| **Length** | < 1 page | 2–3 pages |
| **Focus** | 3 key things + decisions | Full operational detail |
| **Audience** | Stakeholders (default: Eng Mgmt) | Sprint review, full status |
| **Sections** | RAG, highlights, risks, decisions, next steps | All sections (velocity, blockers table, scope, risks, recommendations) |
| **Use case** | "Quick status" | "Full sprint picture" |

## Method

### Step 1: Identify the 3 most important things to communicate

From the provided `sprint_summary`, extract the 3 highest-signal items. Prioritize by:

1. **Impact** — What affects delivery, timeline, or stakeholders most?
2. **Urgency** — What needs attention now vs. later?
3. **Clarity** — What would a stakeholder ask first?

Examples of high-signal items:

- Completion at 45% with 3 days left — sprint at risk
- Critical blocker on payment flow — 8 SP stuck
- Velocity dropped 20% vs. last sprint — team capacity concern
- Scope increased 25% mid-sprint — commitment stretched
- All committed work done — on track for sprint goal

Avoid low-signal items: minor process tweaks, individual ticket status, routine updates.

### Step 2: Assess overall status (RAG)

Determine RAG from the summary:

- **Green**: On track, no critical blockers, trajectory ≥ 80%
- **Amber**: At risk, 1–2 blockers, or trajectory 60–80%
- **Red**: Off track, critical blocker, or trajectory < 60%

Provide a one-line justification citing the primary driver (e.g., "Amber — 2 blockers, trajectory at 65%").

### Step 3: Highlight risks and decisions needed

- **Risks**: List only material risks (those that could affect delivery or require stakeholder awareness). Skip low-severity items.
- **Decisions needed**: From `decisions_pending` or inferred from blockers/risks. For each: what decision, who owns it, by when (if known).

If none: use "None" or omit the section. Do not invent decisions.

### Step 4: Write the update

Assemble in the output format below. Keep total length under 1 page (roughly 300–400 words). Use direct, scannable language. Lead with RAG and the 3 highlights.

### Step 5: Validate length and focus

Before delivering:

- Total length < 1 page
- Exactly 3 highlights (not 2, not 4)
- No ticket-level detail unless critical (e.g., one blocker that defines the RAG)
- Decisions section only if there are actual decisions to make

## Output Format

```
# Stakeholder Update

**Sprint**: {name}
**Date**: {date}
**RAG**: {Green | Amber | Red} — {one-line justification}

---

## Key Highlights

1. **{Highlight 1 title}** — {One sentence. Data-driven, specific.}
2. **{Highlight 2 title}** — {One sentence.}
3. **{Highlight 3 title}** — {One sentence.}

---

## Risks & Blockers

{If any: bullet list of material risks/blockers with one line each.}
{If none: "None."}

---

## Decisions Needed

{If any: table or list — Decision | Owner | Urgency}
{If none: "None."}

---

## Next Steps

- {Action 1}
- {Action 2}

---

**Confidence**: {High | Medium | Low} — {brief justification}
```

## Audience Adaptation

The default output is tuned for **engineering management** — operational detail, velocity, blockers, capacity. For other audiences, apply **format-for-audience** after generating:

- **C-Level / VP**: Lead with RAG and business impact; remove ticket keys; 3–5 bullets max
- **Product**: Focus on feature completion, scope changes, dates; group by epic
- **Engineering Team**: Actionable items, who needs help, review queue; skip strategic risks
- **Cross-Team**: Dependencies, shared blockers, timeline alignment; neutral tone

## Error Handling

- **Missing sprint_summary**: Cannot proceed. Request at minimum: completion %, trajectory, blocker count, RAG driver.
- **Sparse data**: Proceed with available data. Note "Update based on partial data — {what's missing}."
- **No decisions_pending**: Omit or use "None" in Decisions Needed. Do not fabricate decisions.
- **Conflicting RAG signals**: Choose the dominant signal and note "Multiple factors — RAG driven primarily by {factor}."
