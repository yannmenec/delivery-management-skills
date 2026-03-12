---
name: detect-ghost-done
version: 1.1.0
description: >
  Detects ghost-done tickets (done but not closed) and phantom-progress tickets
  (claiming progress but no code activity). Surfaces status hygiene issues
  that inflate WIP and distort sprint metrics. Includes truth audit layer.
category: sprint-operations
trigger: Sprint health check, status hygiene review, velocity accuracy, sprint report
autonomy: supervised
portability: universal
complexity: intermediate
type: detection
inputs:
  - name: sprint_tickets
    type: structured-text
    required: true
    description: >
      List of tickets in the sprint. Each ticket must include: key, summary,
      status, assignee, story_points. Optionally: pr_status, fix_version_released,
      deployment_label, days_in_current_status.
  - name: terminal_statuses
    type: list
    required: false
    description: >
      List of status names that count as "Done" (e.g., Done, Closed, Won't Fix).
      Default: ["Done", "Closed", "Won't Fix"].
  - name: qa_stale_threshold_days
    type: number
    required: false
    default: 5
    description: >
      Days in QA with PR merged before flagging as ghost-done.
      QA tickets with merged PR but no release/deployment need this threshold.
outputs:
  - name: ghost_done_tickets
    type: structured-text
    description: >
      List of ghost-done tickets with evidence, confidence, and recommended
      close action.
  - name: metrics_impact
    type: structured-text
    description: >
      Impact on sprint metrics: velocity underreported by X SP, completion %
      underreported, effective completion count.
tools_optional:
  - project-tracker
  - version-control
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Detect Ghost-Done Tickets

Identifies tickets that are effectively complete (code merged, version released, or deployed) but still sit in an intermediate status like In Progress, In Review, or QA. These represent status hygiene issues that inflate work-in-progress and underreport velocity and completion.

## When to Use

- Sprint health checks and status hygiene reviews
- Sprint report preparation (to correct completion metrics)
- Velocity accuracy assessment
- Any time completion % seems lower than actual delivery

## What is a Ghost-Done Ticket?

A ticket that satisfies **at least two** of the following conditions but is **not** in a terminal status (Done, Closed, Won't Fix):

| Signal | Description | How to Check (from provided data) |
|--------|-------------|-----------------------------------|
| **PR merged** | Pull request (or merge request) has been merged to the main branch | `pr_status = "merged"` or equivalent |
| **Fix version released** | The target release/version has been shipped | `fix_version_released = true` |
| **Deployment complete** | Ticket has a deployment label (e.g., deployed-prod, deploymentPROD) | `deployment_label = true` or `labels` contains deployment marker |

**Why two signals?** A merged PR alone does not mean "done" — QA or product validation may still be needed. Two or more signals together indicate high confidence that the work is shipped.

**Exception**: A ticket in QA with a merged PR but no released version and no deployment label is **not** ghost-done — it genuinely needs QA or PM validation. Such tickets are better handled by stuck-ticket detection (stale QA). Only flag as ghost-done when at least two signals are present.

## Input

Provide a list of sprint tickets. Required and optional fields:

| Field | Required | Description |
|-------|----------|-------------|
| `key` | Yes | Ticket identifier |
| `summary` | Yes | Ticket title |
| `status` | Yes | Current status (e.g., In Progress, In Review, QA, Done) |
| `assignee` | Yes | Person assigned |
| `story_points` | No | Estimate (for metrics impact; use 0 if missing) |
| `pr_status` | No | none, draft, open, approved, merged, closed |
| `fix_version_released` | No | true if the fix version has been released |
| `deployment_label` | No | true if ticket has a deployment-to-production marker |
| `days_in_current_status` | No | Days in current status (for QA-stale rule) |

If PR, version, or deployment data is unavailable for some tickets, those tickets cannot be evaluated for ghost-done. Note the gap in the output.

## Method

### Step 1: Filter to non-terminal tickets

Exclude all tickets whose `status` is in `terminal_statuses` (default: Done, Closed, Won't Fix). Only non-terminal tickets can be ghost-done.

### Step 2: Check for PR merged but ticket not Done

For each non-terminal ticket:

- If `pr_status = "merged"`: this is one signal. Proceed to check other signals.
- If `pr_status` is missing: cannot use this signal. Rely on fix_version and deployment only.

### Step 3: Check for ticket in QA 5+ days with PR merged

Tickets in a QA (or equivalent validation) status with a merged PR may be waiting for formal sign-off. If they have been in QA for `qa_stale_threshold_days` or more **and** have a merged PR **and** (fix version released OR deployment label), treat as ghost-done.

- If in QA, PR merged, but no fix_version_released and no deployment_label: **do not** flag as ghost-done. Flag instead as "stale in QA — needs validation" (handled by stuck-ticket detection).
- If in QA, PR merged, and (fix_version_released OR deployment_label): flag as ghost-done. Suggested action: "Verify QA passed, then transition to Done."

### Step 4: Check for deployment/release labels

For each ticket:

- If `fix_version_released = true`: one signal
- If `deployment_label = true` (or labels contain a deployment marker): one signal

Combine with PR status. A ticket with fix_version_released + deployment_label (and no PR data) still qualifies if both are true — the work is clearly shipped.

### Step 5: Apply minimum-signal rule

A ticket is ghost-done only if it has **at least two** of:

1. PR merged
2. Fix version released
3. Deployment label

| Signals matched | Confidence | Flag? |
|-----------------|------------|-------|
| PR merged + fix version released | High | Yes |
| PR merged + deployment label | High | Yes |
| Fix version released + deployment label | High | Yes |
| All three | Very High | Yes |
| Only one signal | Low | No — skip |

### Step 6: Determine recommended action

For each ghost-done ticket, suggest a specific action based on current status:

| Current Status | Recommended Action |
|----------------|-------------------|
| QA | Verify QA/PM validation passed, then transition to Done |
| In Review, Code Review | PR is already merged — transition to Done |
| In Progress | Code is merged and deployed — transition to Done |
| To Do | Unusual — flag for review (possible data issue) |

### Step 7: Compute metrics impact

- **Velocity underreported by**: sum of story points of ghost-done tickets
- **Completion % underreported by**: (ghost_done_count / total_sprint_tickets) × 100
- **Effective completion**: Done count + ghost_done count (and effective completed SP = Done SP + ghost_done SP)

## Output Format

```
## Ghost-Done Tickets: {count} found

**Impact**: {sum_sp} story points underreported in velocity. Completion underreported by {percentage}%.

---

### [{KEY}] {summary}

- **Current Status**: {status} (should be Done)
- **Assignee**: {assignee}
- **Story Points**: {sp}

**Evidence**:
- PR: {merged | open | none | unknown}
- Fix version released: {yes | no | unknown}
- Deployment label: {yes | no | unknown}
- Signals matched: {N}/3
- Confidence: {High | Very High}

**Recommended Action**: {action from Step 6}

---

(repeat for each ghost-done ticket)

### Metrics Impact

- **Velocity underreported by**: {N} SP
- **Completion underreported by**: {N} tickets ({percentage}% of sprint)
- **Effective completed**: {done_count + ghost_done_count} tickets, {done_sp + ghost_done_sp} SP
```

### Step 8: Truth Audit — PR Activity Cross-Reference (Progressive Enhancement)

This step activates only when `pr_status` and `days_in_current_status` data are available. It detects **phantom-progress** tickets — tickets that report In Progress or In Review but show no corresponding code activity, indicating the reported status may not reflect reality.

For each non-terminal ticket where `pr_status` is available:

| Current Status | PR Status | Days in Status | Finding |
|----------------|-----------|---------------|---------|
| In Progress | `none` | > 3 days | **Phantom progress** — ticket claims active work but no PR exists after 3+ days |
| In Progress | `draft` | > 5 days | **Stale draft** — PR started but no review cycle after 5 days |
| In Review | `none` or `draft` | > 3 days | **Phantom review** — ticket in review but no reviewable PR |
| In Review | `open` | > 5 days | **Stale review** — PR open for review but no progress after 5 days |

For each finding, classify:

| Phantom Type | Confidence | Implication |
|-------------|-----------|-------------|
| In Progress + no PR > 3 days | Medium | Possible hidden blocker or task not yet started |
| In Progress + draft PR > 5 days | Medium-High | Complexity or blocker not surfaced |
| In Review + no reviewable PR > 3 days | High | Status is incorrect or PR was abandoned |
| In Review + stale open PR > 5 days | Medium | Review bottleneck or abandoned review |

**Output truth audit findings separately from ghost-done findings** — these are different problems. Ghost-done tickets need to move forward to Done. Phantom-progress tickets need investigation.

**Graceful degradation**: If `pr_status` is missing for all tickets, skip this step entirely and note: "Truth audit skipped — PR data unavailable." If available for some tickets, run on those and note partial coverage.

## Truth Audit Output Format

```
## Truth Audit: {count} phantom-progress tickets found

{If 0: "All In Progress and In Review tickets show consistent PR activity. No phantom-progress detected."}

---

### [{KEY}] {summary}

- **Claimed Status**: {status} ({days} days)
- **Actual PR Activity**: {pr_status} — {interpretation}
- **Assignee**: {assignee}
- **Story Points**: {sp}
- **Finding**: {Phantom progress | Stale draft | Phantom review | Stale review}
- **Confidence**: {Medium | Medium-High | High}

**Recommended Action**: {action — e.g., "Check in with assignee to understand actual progress and surface any hidden blockers."}

---
```

## Error Handling

- **No ghost-done tickets**: Report "No ghost-done tickets detected." This is a valid, positive outcome. Do not fabricate findings.
- **Missing pr_status for all tickets**: Rely on fix_version_released and deployment_label only. Note "PR data unavailable — detection based on version and deployment signals only."
- **Missing fix_version_released and deployment_label**: Cannot detect ghost-done via those signals. If PR merged is the only signal, do not flag (need two signals). Note "Version and deployment data unavailable — ghost-done detection limited."
- **Ambiguous status names**: If the tracker uses non-standard names (e.g., "Ready for Release" instead of "Done"), include them in `terminal_statuses` when provided. Otherwise use the default list and note "If your tracker uses different Done-equivalent statuses, provide them in terminal_statuses."
- **Ticket in To Do flagged as ghost-done**: Unusual. Flag for human review: "Ticket {KEY} appears ghost-done but is in To Do — possible data issue."
- **Conflicting signals**: E.g., PR merged but fix_version not released. Trust the stronger evidence. If two of three signals say "done," flag it and note any discrepancy in the evidence section.
