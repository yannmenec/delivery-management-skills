---
name: sprint-health-check
version: 1.0.0
description: >
  Orchestrates a comprehensive sprint health assessment by combining stuck-ticket
  detection, velocity analysis, scope-change detection, and ghost-done detection.
  Produces a full sprint health report with RAG status.
category: sprint-operations
trigger: Daily sprint scan, mid-sprint checkpoint, sprint review preparation, stakeholder status request
autonomy: supervised
portability: universal
complexity: advanced
type: workflow
inputs:
  - name: sprint_tickets
    type: structured-text
    required: true
    description: >
      Full list of tickets in the active sprint. Each ticket should include:
      key, summary, status, assignee, priority, story_points, days_in_current_status,
      last_updated, created, linked_issues (optional), pr_status (optional),
      fix_version_released (optional), deployment_label (optional).
  - name: sprint_context
    type: structured-text
    required: true
    description: >
      Sprint metadata: name, start_date, end_date, days_elapsed, days_remaining,
      total_days. Used for trajectory and RAG calculation.
  - name: sprint_history
    type: structured-text
    required: false
    description: >
      Data for 2+ completed sprints (name, committed SP, completed SP, dates).
      Required for velocity and trajectory. If missing, trajectory is skipped.
  - name: current_sprint_progress
    type: structured-text
    required: false
    description: >
      Current sprint: committed SP, completed SP so far, days elapsed.
      If not provided, derived from sprint_tickets (sum of Done + ghost-done SP).
  - name: threshold_days
    type: number
    required: false
    default: 3
    description: Days without status change before flagging as stale (for stuck-ticket detection).
outputs:
  - name: sprint_health_report
    type: structured-text
    description: >
      Full sprint health report with all sections: RAG status, stuck tickets,
      velocity/trajectory, scope changes, ghost-done, burndown proxy, actions.
  - name: rag_status
    type: text
    description: >
      Single RAG indicator: Green, Amber, or Red with one-line justification.
depends_on:
  - detect-stuck-tickets
  - compute-velocity
  - detect-scope-change
  - detect-ghost-done
tools_optional:
  - project-tracker
  - version-control
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Sprint Health Check

A composite workflow that orchestrates multiple detection and computation skills to produce a comprehensive sprint health report with RAG status. Works entirely from manually provided data — no live API dependency.

## When to Use

- Daily sprint pulse or standup preparation
- Mid-sprint checkpoint reviews
- Sprint review preparation (day before or day of)
- Stakeholder status requests
- Any time a Delivery Manager asks "how is the sprint going?"

## Sub-Skills Orchestrated

This workflow invokes (or conceptually applies the logic of) these skills in sequence:

1. **detect-stuck-tickets** — Blocked, stale, and silent tickets
2. **compute-velocity** — Velocity trend and current sprint trajectory
3. **detect-scope-change** — Tickets added or removed after sprint start
4. **detect-ghost-done** — Tickets effectively done but not closed

## Method

### Step 1: Gather sprint data

Ensure all required inputs are available. If `sprint_tickets` is incomplete, note which fields are missing and proceed with available data. Flag any critical gaps (e.g., no status, no story points) in the report.

### Step 2: Run stuck-ticket detection

Apply the logic of **detect-stuck-tickets**:

- Layer 0: Flagged impediments
- Layer 1: Explicitly blocked
- Layer 2: Stale (same status ≥ threshold_days)
- Layer 3: Silent (no activity ≥ threshold_days)

Deduplicate, score severity, and sort by priority. Produce a summary: count by layer, story points at risk, highest-severity items.

### Step 3: Compute velocity and trajectory

Apply the logic of **compute-velocity**:

- From `sprint_history`: compute average velocity, trend (Improving/Declining/Volatile/Stable), predictability score
- From `current_sprint_progress` or derived from `sprint_tickets`: compute burn rate, projected completion, trajectory (projected / committed as percentage)

If `sprint_history` is missing: skip velocity section. Note "Velocity analysis unavailable — insufficient historical data."

If current sprint progress is derivable from tickets: sum story points of tickets in Done status (and ghost-done if detected in Step 5) as completed SP; sum all committed tickets' story points as committed SP.

### Step 4: Detect scope changes

Apply the logic of **detect-scope-change**:

- Identify tickets in the sprint where `created` (or equivalent) is **after** `sprint_context.start_date`
- Compute: added count, added story points, scope change percentage = (added SP / original committed SP) × 100
- Classify: stable (< 10%), moderate (10–25%), volatile (> 25%)

If removed tickets are detectable (e.g., from a baseline snapshot), include them. Otherwise note "Removed tickets not detectable from provided data."

### Step 5: Detect ghost-done tickets

Apply the logic of **detect-ghost-done**:

- Tickets with PR merged + fix version released, or PR merged + deployment label, or fix version released + deployment label
- Must not be in terminal status (Done, Closed)
- List each with evidence and recommended close action

Include ghost-done story points in the "effective completed" count for trajectory and burndown.

### Step 6: Compute burndown proxy

- **Ideal burndown**: (days_elapsed / total_days) × committed SP
- **Actual burndown**: completed SP (including ghost-done)
- **Variance**: actual − ideal (positive = ahead, negative = behind)

If sprint is in early days (< 30% elapsed), note that burndown is less meaningful until mid-sprint.

### Step 7: Determine RAG status

Apply the following criteria. Evaluate in order; the first match wins.

| RAG | Criteria |
|-----|----------|
| **Green** | Trajectory ≥ 80% AND blocker count ≤ 1 AND velocity stable or improving AND scope change ≤ 15% |
| **Amber** | Trajectory 60–80% OR 2+ blockers OR declining velocity OR scope change 15–30% OR ghost-done count > 2 |
| **Red** | Trajectory < 60% OR critical blocker OR sprint goal at risk OR scope change > 30% |

If trajectory cannot be computed (no historical or current progress data), default to Amber with note "Trajectory unknown — RAG based on other signals."

### Step 8: Format report

Assemble all sections into the output format below. Ensure every section is present; if a section has no data, use "None" or "N/A" with a brief explanation.

### Step 9: Run self-check

Before delivering, verify:

- All numbers trace to provided data (no fabricated values)
- RAG justification cites specific criteria from the table
- At least 2–3 recommended actions with owners where applicable
- Data gaps or assumptions are explicitly noted

## RAG Criteria (Reference)

| RAG | Trajectory | Blockers | Velocity | Scope Change |
|-----|------------|----------|----------|--------------|
| **Green** | ≥ 80% | ≤ 1 | Stable or improving | ≤ 15% |
| **Amber** | 60–80% | 2+ | Declining | 15–30% |
| **Red** | < 60% | Critical | — | > 30% |

## Output Format

```
# Sprint Health Report

**Sprint**: {name}
**Date**: {report_date}
**Days elapsed**: {X} of {Y} ({Z}% through)

---

## RAG Status: {Green | Amber | Red}

**Justification**: {One-line explanation citing specific criteria.}

---

## 1. Stuck Tickets

**Summary**: {count} stuck across {layer_count} layers. {story_points_at_risk} SP at risk.

| Key | Severity | Layers | Status | Days | Assignee | Action |
|-----|----------|--------|--------|------|----------|--------|
| {KEY} | {Critical|High|Medium} | {layers} | {status} | {N} | {name} | {brief action} |

*(If none: "No stuck tickets detected.")*

---

## 2. Velocity & Trajectory

- **Average velocity**: {N} SP (last 3 sprints)
- **Trend**: {Improving|Declining|Volatile|Stable}
- **Current sprint**: Committed {N} SP, Completed {N} SP (effective: {N} including ghost-done)
- **Burn rate**: {N} SP/day
- **Projected completion**: {N} SP ({trajectory}% of commitment)
- **Status**: {On track|At risk|Off track}

*(If velocity data missing: "Velocity analysis unavailable.")*

---

## 3. Scope Change

- **Added mid-sprint**: {count} tickets, +{N} SP
- **Removed**: {count or "unknown"}
- **Scope change**: {percentage}%
- **Stability**: {stable|moderate|volatile}

*(List added tickets with key, summary, created date.)*

---

## 4. Ghost-Done

- **Count**: {N} tickets ({M} SP)
- **Impact**: Completion underreported by {N} SP

| Key | Status | Evidence | Action |
|-----|--------|----------|--------|
| {KEY} | {status} | {signals} | {recommended action} |

*(If none: "No ghost-done tickets detected.")*

---

## 5. Burndown Proxy

- **Ideal (to date)**: {N} SP
- **Actual**: {N} SP
- **Variance**: {+/-N} SP ({ahead|behind})

---

## 6. Recommended Actions

1. {Action} — Owner: {assignee or "DM"}
2. {Action} — Owner: {assignee or "DM"}
3. {Action} — Owner: {assignee or "DM"}

---

## Caveats

{List any data gaps, assumptions, or limitations.}
```

## Error Handling

- **Missing sprint_tickets**: Cannot proceed. Request the data and explain which fields are required.
- **Missing sprint_context**: Proceed with partial report. Note "Sprint dates unknown — trajectory and RAG may be incomplete." Use placeholder dates if the user can approximate.
- **Missing sprint_history**: Skip velocity and trajectory. Set RAG based on stuck tickets, scope change, and ghost-done only. Note "Velocity unavailable — RAG based on other signals."
- **Empty sprint**: If no tickets in sprint, report "Sprint appears empty. Verify sprint scope or data source."
- **Conflicting data**: If committed SP from context differs from sum of ticket SP, show both and note "Discrepancy: context says {X} SP, ticket sum is {Y} SP. Using {chosen} for trajectory."
- **Sub-skill logic unavailable**: If any sub-skill cannot be applied (e.g., no created dates for scope change), skip that section and note the limitation. Never fabricate sub-skill outputs.
