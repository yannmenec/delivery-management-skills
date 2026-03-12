---
name: detect-scope-change
version: 1.0.0
description: >
  Detects tickets added to or removed from the sprint after sprint start.
  Computes scope change percentage and classifies impact for sprint stability assessment.
category: sprint-operations
trigger: Sprint health check, scope stability review, predictability assessment, sprint report
autonomy: autonomous
portability: universal
complexity: basic
type: detection
inputs:
  - name: sprint_tickets
    type: structured-text
    required: true
    description: >
      List of tickets currently in the sprint. Each ticket must include:
      key, summary, story_points (or estimate), created (date created),
      added_to_sprint (date added to sprint — if available; otherwise use created as proxy).
  - name: sprint_start_date
    type: text
    required: true
    description: >
      Sprint start date (YYYY-MM-DD or ISO 8601). Tickets created or added
      after this date are considered "added mid-sprint."
  - name: removed_tickets
    type: structured-text
    required: false
    description: >
      Optional. List of tickets that were in the sprint at start but have since
      been removed (e.g., from a baseline snapshot or planning record).
      Each: key, summary, story_points, removed_date.
outputs:
  - name: scope_changes
    type: structured-text
    description: >
      Added tickets, removed tickets (if detectable), net SP change,
      scope change percentage, and impact classification.
  - name: impact_classification
    type: text
    description: >
      One of: stable, moderate, significant, critical — based on scope change percentage.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Detect Scope Change

Identifies tickets added to or removed from the sprint after sprint start. Computes scope change percentage and classifies impact. Works entirely from manually provided data — no live project tracker required.

## When to Use

- Sprint health checks and mid-sprint reviews
- Scope stability analysis for predictability reporting
- Sprint report preparation
- Retrospective data (e.g., "how much did scope change this sprint?")

## Input

Provide a list of sprint tickets. Minimum required fields:

| Field | Required | Description |
|-------|----------|-------------|
| `key` | Yes | Ticket identifier |
| `summary` | Yes | Ticket title |
| `story_points` | Yes* | Estimate (*use 0 if unestimated; note in output) |
| `created` | Yes | Date the ticket was created (YYYY-MM-DD or ISO 8601) |
| `added_to_sprint` | No | Date added to sprint; if absent, `created` is used as proxy |

**Note**: Using `created` as a proxy for "added" works when tickets are created at sprint planning. If your process creates tickets in backlog and moves them into the sprint later, `added_to_sprint` is more accurate. When in doubt, use `created` and note the limitation.

## Method

### Step 1: Identify tickets added after sprint start

For each ticket in `sprint_tickets`:

- Use `added_to_sprint` if available; otherwise use `created`
- If that date is **strictly after** `sprint_start_date`, the ticket is **added mid-sprint**

Edge case: If the date equals sprint start, the ticket is **not** considered added (it was part of planning). Only dates after the start date count.

Produce a list: `added_tickets` with key, summary, story_points, date_added.

### Step 2: Identify tickets removed (if data available)

If `removed_tickets` is provided:

- These are tickets that were in the sprint at start but are no longer in the current `sprint_tickets` list
- Sum their story points for `removed_sp`

If `removed_tickets` is not provided:

- Set `removed_count = 0`, `removed_sp = 0`
- Note in output: "Removed tickets not detectable — no baseline or planning record provided."

### Step 3: Compute scope change percentage

- **Original committed SP** = total SP of current sprint − added SP + removed SP  
  Equivalently: sum of SP for tickets that were in sprint at start (i.e., not in added_tickets, plus any removed).
- **Simpler formula**: `original_sp = current_total_sp - added_sp + removed_sp`
- **Scope change (added)** = (added_sp / original_sp) × 100
- **Scope change (removed)** = (removed_sp / original_sp) × 100
- **Net scope change** = added_sp − removed_sp
- **Net scope change %** = (net_scope_change / original_sp) × 100

If `original_sp` is 0 (empty sprint at start), set scope change % to 0 and note "Sprint had no initial commitment."

### Step 4: Classify impact

| Scope Change % (absolute) | Classification | Meaning |
|---------------------------|----------------|---------|
| < 10% | **Stable** | Minimal scope creep; sprint commitment is reliable |
| 10–15% | **Moderate** | Some scope change; monitor but not alarming |
| 15–30% | **Significant** | Notable scope change; may affect sprint goal and velocity accuracy |
| > 30% | **Critical** | Major scope change; sprint predictability is compromised |

Use the **larger** of added % and removed % (or net % if that better reflects impact) for classification. When both added and removed exist, consider the net impact: e.g., +20% added and −10% removed = net +10% (moderate), but the churn itself may warrant "significant" — use judgment and note the rationale.

## Output Format

```
## Scope Change Report

**Sprint start**: {sprint_start_date}
**Total tickets in sprint**: {count}
**Total story points**: {current_total_sp}

---

### Added Mid-Sprint

**Count**: {added_count} tickets
**Story points**: +{added_sp} SP

| Key | Summary | SP | Date Added |
|-----|---------|-----|------------|
| {KEY} | {summary} | {sp} | {date} |

*(If none: "No tickets added after sprint start.")*

---

### Removed

**Count**: {removed_count} tickets (or "Unknown — no baseline provided")
**Story points**: −{removed_sp} SP

| Key | Summary | SP | Date Removed |
|-----|---------|-----|--------------|
| {KEY} | {summary} | {sp} | {date} |

*(If unknown: "Removed tickets cannot be detected from provided data.")*

---

### Summary

- **Original committed SP** (estimated): {original_sp}
- **Net change**: {+/-N} SP ({net_change_percentage}%)
- **Impact**: {stable | moderate | significant | critical}

**Interpretation**: {One-sentence explanation of what this means for the sprint.}
```

## Error Handling

- **Missing sprint_start_date**: Cannot compute. Request the date. If the user provides "sprint 2 of PI 26.2," infer from a calendar if possible, or ask for the exact date.
- **Missing created/added_to_sprint on tickets**: For each ticket missing the field, exclude it from added-ticket detection and note "Ticket {KEY} missing creation date — excluded from scope change analysis."
- **All tickets missing dates**: Report "Scope change detection unavailable — no creation or addition dates provided."
- **Story points missing**: Use 0 for that ticket and note "Unestimated tickets counted as 0 SP — scope change may be understated."
- **removed_tickets provided but empty**: Treat as "no removals" — removed_count = 0, removed_sp = 0.
- **original_sp = 0**: Avoid division by zero. Set scope change % to 0. Note "Sprint had no initial commitment — scope change % not meaningful."
