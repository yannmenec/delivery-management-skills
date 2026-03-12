---
name: generate-sprint-report
version: 1.0.0
description: >
  Generates a comprehensive sprint report combining velocity, blockers, scope
  changes, risks, and recommendations. The complete end-to-end report for
  sprint reviews and stakeholder communication.
category: reporting
trigger: Sprint review preparation, end-of-sprint reporting, stakeholder request for full sprint status, PI checkpoint.
autonomy: supervised
portability: universal
complexity: advanced
type: generation
inputs:
  - name: sprint_tickets
    type: structured-text
    required: true
    description: >
      Full list of tickets in the sprint. Each ticket should include: key,
      summary, status, assignee, priority, story_points, days_in_current_status,
      last_updated, created (optional), linked_issues (optional), pr_status
      (optional), fix_version_released (optional).
  - name: sprint_context
    type: structured-text
    required: true
    description: >
      Sprint metadata: name, start_date, end_date, days_elapsed, days_remaining,
      total_days, goal (optional).
  - name: sprint_history
    type: structured-text
    required: false
    description: >
      Data for 2+ completed sprints (name, committed SP, completed SP, dates).
      Enables velocity trend and trajectory analysis.
  - name: risk_items
    type: structured-text
    required: false
    description: >
      Pre-identified risks (description, category, mitigation status). If absent,
      risks are inferred from blockers, scope changes, and stuck tickets.
outputs:
  - name: sprint_report
    type: structured-text
    description: >
      Full sprint report with RAG status, executive summary, progress, velocity,
      blockers, scope changes, risks, and recommendations.
depends_on:
  - self-check
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Generate Sprint Report

The "hero" skill for sprint reporting. Produces a comprehensive, end-to-end sprint report suitable for sprint reviews, stakeholder briefings, and PI checkpoints. Works entirely from manually provided data — no live API dependency.

For a lighter, stakeholder-focused update, use **stakeholder-update** instead. After generating this report, apply **format-for-audience** to adapt the content for different audiences (C-level, Product, Engineering Team, Cross-team).

## When to Use

- Sprint review preparation (day before or day of)
- End-of-sprint reporting to stakeholders
- PI checkpoint or mid-PI status
- When a full, detailed sprint picture is required (not just highlights)

## Method

### Step 1: Analyze ticket data by status

Group all tickets by status (To Do, In Progress, In Review, Done, Blocked). For each group:

- **Count** tickets and sum story points
- **Completion ratio** = Done SP / Total committed SP × 100
- Identify tickets with no status change for 3+ days (stale)
- Identify tickets explicitly blocked or flagged as impediments

If story points are missing on some tickets, use ticket count as fallback and note "SP data incomplete — using ticket count for completion ratio."

### Step 2: Compute velocity and completion ratio

If `sprint_history` is provided:

- **Average velocity** = mean of last 3 sprints' completed SP
- **Trend** = Improving | Declining | Volatile | Stable (compare last 3 sprints)
- **Current sprint trajectory** = (completed SP / committed SP) × 100, or projected completion based on burn rate if mid-sprint

If `sprint_history` is missing: skip velocity trend. Compute completion ratio from current sprint data only. Note "Velocity trend unavailable — insufficient historical data."

### Step 3: Identify blockers and stuck tickets

Apply a layered detection approach:

- **Layer 0**: Flagged impediments
- **Layer 1**: Status = Blocked
- **Layer 2**: Stale (same status ≥ 3 days)
- **Layer 3**: Silent (no activity ≥ 3 days)

Deduplicate (a ticket can appear in multiple layers). For each blocker/stuck ticket, capture: key, summary, status, assignee, days stuck, severity (Critical/High/Medium), recommended action.

### Step 4: Assess scope changes

Identify tickets added after sprint start:

- Tickets where `created` (or equivalent) is **after** `sprint_context.start_date`
- Compute: added count, added SP, scope change % = (added SP / original committed SP) × 100
- Classify: stable (< 10%), moderate (10–25%), volatile (> 25%)

If `created` dates are unavailable, note "Scope change detection unavailable — created dates not provided."

### Step 5: Determine RAG status

Evaluate in order; first match wins:

| RAG | Criteria |
|-----|----------|
| **Green** | Trajectory ≥ 80% AND blocker count ≤ 1 AND velocity stable or improving AND scope change ≤ 15% |
| **Amber** | Trajectory 60–80% OR 2+ blockers OR declining velocity OR scope change 15–30% OR ghost-done count > 2 |
| **Red** | Trajectory < 60% OR critical blocker OR sprint goal at risk OR scope change > 30% |

If trajectory cannot be computed, default to Amber with note "Trajectory unknown — RAG based on other signals."

### Step 6: Generate executive summary

Write exactly 3 bullets that capture:

1. **Progress** — Where we are (completion %, trajectory)
2. **Health** — Key risk or win (blockers, velocity, scope)
3. **Outlook** — What to watch or what's needed

Each bullet must be specific and data-driven. No generic filler.

### Step 7: Write recommendations

Produce 2–3 specific, actionable recommendations. Each must include:

- **What** to do (concrete action)
- **Who** should do it (assignee or role)
- **Why** (tied to a specific ticket, blocker, or risk)

Avoid generic advice ("follow up on blockers"). Prefer specific ("Escalate TKT-123 to Platform — blocked 4 days, 8 SP at risk").

### Step 8: Run self-check

Before delivering, apply the **self-check** skill:

- All numbers trace to provided data
- No empty sections
- At least one specific evidence reference
- Confidence level stated
- At least one actionable recommendation

Fix any failing checks before final output.

## Output Format

```
# Sprint Report

**Sprint**: {name}
**Period**: {start_date} — {end_date}
**Report Date**: {date}
**RAG Status**: {Green | Amber | Red} — {one-line justification}

---

## Executive Summary

1. {Progress bullet — completion %, trajectory}
2. {Health bullet — key risk or win}
3. {Outlook bullet — what to watch or what's needed}

---

## Progress

| Status | Tickets | Story Points |
|--------|---------|--------------|
| To Do | {count} | {sp} |
| In Progress | {count} | {sp} |
| In Review | {count} | {sp} |
| Done | {count} | {sp} |
| Blocked | {count} | {sp} |

**Total**: {total_tickets} tickets, {total_sp} SP committed
**Completion**: {done_sp} / {total_sp} SP ({percentage}%)

---

## Velocity

- **Average velocity**: {N} SP (last 3 sprints)
- **Trend**: {Improving | Declining | Volatile | Stable}
- **Current sprint trajectory**: {N}% of commitment
- **Status**: {On track | At risk | Off track}

*(If velocity data missing: "Velocity analysis unavailable.")*

---

## Blockers & Stuck Tickets

| Key | Severity | Status | Days | Assignee | Action |
|-----|----------|--------|------|----------|--------|
| {KEY} | {Critical|High|Medium} | {status} | {N} | {name} | {brief action} |

*(If none: "No blockers or stuck tickets identified.")*

---

## Scope Changes

- **Added mid-sprint**: {count} tickets, +{N} SP
- **Scope change**: {percentage}%
- **Stability**: {stable | moderate | volatile}

*(List added tickets with key, summary. If undetectable: "Scope change detection unavailable.")*

---

## Risks

- {Risk 1} — {RAG} — {mitigation status}
- {Risk 2} — {RAG} — {mitigation status}

*(If none: "No material risks identified.")*

---

## Recommendations

1. {Action} — Owner: {who} — {why}
2. {Action} — Owner: {who} — {why}
3. {Action} — Owner: {who} — {why}

---

## Caveats

{List any data gaps, assumptions, or limitations.}

**Confidence**: {High | Medium | Low} — {justification based on data completeness}
```

## Post-Processing

After generating the report, apply **format-for-audience** to adapt for different audiences:

- **C-Level / VP**: Condense to 3–5 bullets, metrics-first, no ticket keys
- **Product**: Group by feature/epic, highlight scope changes and dates
- **Engineering Team**: Focus on actionable items, review queue, who needs help
- **Cross-Team**: Dependency-focused, neutral tone, shared blockers

## Error Handling

- **Missing sprint_tickets**: Cannot proceed. Request the data and specify required fields.
- **Missing sprint_context**: Proceed with partial report. Note "Sprint dates unknown — trajectory and RAG may be incomplete."
- **Missing sprint_history**: Skip velocity trend. Set RAG based on blockers, scope change, and completion ratio. Note "Velocity unavailable."
- **Empty sprint**: Report "Sprint appears empty. Verify sprint scope or data source."
- **Conflicting data**: If committed SP from context differs from ticket sum, show both and note the discrepancy.
- **Sub-skill logic unavailable**: Skip the affected section and note the limitation. Never fabricate data.

## Verification Phase

After generating the draft report, independently verify before proceeding to self-check:

1. Does the stated velocity match the sum of completed story points from the input data?
2. Does the RAG status follow logically from the blockers, scope changes, and completion ratio?
3. Are all ticket keys referenced in the report present in the input data?
4. Do the recommendations reference specific, real tickets — not generic advice?

If any verification fails, revise the draft before proceeding.

## Anti-Patterns

- **NEVER** report "on track" or Green RAG when active blockers exist without explicitly stating the mitigation plan.
- **NEVER** include a metric that cannot be traced to the provided input data. If you cannot cite it, do not include it.
- **NEVER** end with generic recommendations like "follow up on blockers." Every recommendation must name a ticket, an owner, or a concrete next step.
