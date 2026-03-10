---
name: detect-stuck-tickets
version: 1.0.0
description: Detects blocked, stale, and silent tickets in the active sprint using multi-layer detection with contextual triage.
category: sprint-operations
trigger: Sprint health check, daily scan, blocker review, standup preparation
autonomy: supervised
portability: universal
complexity: intermediate
type: detection
inputs:
  - name: sprint_tickets
    type: structured-text
    required: true
    description: >
      List of tickets in the active sprint. Each ticket should include:
      key, summary, status, assignee, priority, days_in_current_status,
      last_updated, linked_issues (optional), pr_status (optional).
  - name: threshold_days
    type: number
    required: false
    default: 3
    description: Days without status change before flagging as stale or silent.
  - name: sprint_context
    type: structured-text
    required: false
    description: >
      Sprint metadata: name, start date, end date, days remaining.
      Used to calculate urgency. If not provided, urgency scoring is skipped.
outputs:
  - name: stuck_tickets
    type: structured-text
    description: >
      Prioritized list of stuck tickets with detection layers, severity,
      context, and recommended actions.
  - name: summary
    type: text
    description: >
      One-paragraph summary: count of stuck tickets, breakdown by layer,
      highest-severity items.
tools_optional:
  - project-tracker
  - version-control
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Detect Stuck Tickets

Identify tickets that are blocked, stale, or silently stuck in the active sprint. Produces a prioritized list with detection layers, severity scoring, and recommended next actions.

## When to Apply

- Daily sprint scan or standup preparation
- Blocker review meetings
- Sprint health checks
- Mid-sprint checkpoints
- Any time a Delivery Manager asks "what's stuck?"

## Input

Provide a list of active sprint tickets. Minimum fields per ticket:

| Field | Required | Description |
|-------|----------|-------------|
| `key` | Yes | Ticket identifier (e.g., PROJ-123) |
| `summary` | Yes | Ticket title |
| `status` | Yes | Current status (To Do, In Progress, In Review, Blocked, Done, etc.) |
| `assignee` | Yes | Person assigned |
| `priority` | Yes | Blocker, Critical, High, Medium, Low |
| `days_in_current_status` | Yes | Calendar days in the current status |
| `last_updated` | Yes | Date of most recent activity (comment, status change, field edit) |
| `linked_issues` | No | Blocking/blocked-by relationships with status of linked ticket |
| `pr_status` | No | Pull request state: none, draft, open, approved, merged, CI failing |
| `story_points` | No | Estimate (used for impact scoring) |

If providing data manually, a simple table or structured list is sufficient.

## Method

### Step 1: Run four detection layers

Apply all four layers to every non-Done ticket. A ticket can match multiple layers.

**Layer 0 — Flagged Impediments**
Tickets explicitly flagged with an impediment marker (e.g., red flag in Jira, "blocked" label in Linear).

- Detection: `flagged = true` or `labels contains "impediment"` or `labels contains "blocked"`
- Why it matters: Someone already raised a concern. These need immediate attention regardless of other signals.

**Layer 1 — Explicitly Blocked**
Tickets in a "Blocked" status.

- Detection: `status = "Blocked"` (or equivalent in your tracker)
- Why it matters: Explicit blocks are the clearest signal. Check linked issues to identify what is blocking them.

**Layer 2 — Stale (No Status Change)**
Tickets stuck in the same active status for longer than the threshold.

- Detection: `status in ("In Progress", "In Review", "QA", "Code Review") AND days_in_current_status >= threshold_days`
- Why it matters: No status movement for 3+ days in an active state often signals a hidden blocker the assignee has not flagged.

**Layer 3 — Silent (No Activity)**
Tickets with no updates of any kind (comments, status changes, field edits) for longer than the threshold.

- Detection: `status != "Done" AND status != "To Do" AND days_since_last_update >= threshold_days`
- Exclude: Tickets still in "To Do" status (silence on unstarted work is expected), unless they are Blocker-priority.
- Why it matters: Complete silence on a non-done, started ticket is the strongest signal of being stuck.

### Step 2: Deduplicate and tag

Merge results across layers. If a ticket matches multiple layers, list all matching layers (e.g., "Blocked + Silent"). Remove duplicates by ticket key.

### Step 3: Enrich with context

For each stuck ticket, gather:

- **Blocking chain**: If blocked, what is the blocker's status? Is the blocker itself blocked? (surface transitive blocks)
- **PR status**: If available, classify as:
  - No PR → needs a nudge to start work
  - Draft PR → work in progress, may not need intervention yet
  - PR open, awaiting review → review bottleneck
  - PR approved, not merged → merge conflict or process gap
  - CI failing → technical blocker
- **Last meaningful activity**: Last comment or status change (not automated field updates)
- **Story points at risk**: Sum of story points for stuck tickets (impact indicator)

### Step 4: Score severity

Assign each stuck ticket a severity: Critical, High, Medium.

| Severity | Criteria |
|----------|----------|
| Critical | Blocker/Critical priority AND blocked 3+ days, OR blocking other tickets |
| High | In Progress 5+ days with no PR, OR Blocked with no linked resolution |
| Medium | Stale 3-4 days but has recent PR activity, OR Silent with low priority |

If sprint context is available, escalate severity by one level for any ticket stuck with 3 or fewer days remaining in the sprint.

### Step 5: Sort and prioritize

1. Critical severity first, then High, then Medium
2. Within same severity: higher priority tickets first (Blocker > Critical > High > Medium > Low)
3. Within same priority: more days stuck first

### Step 6: Generate recommended actions

For each stuck ticket, recommend one specific action:

| Situation | Recommended Action |
|-----------|-------------------|
| Blocked, blocker is known | "Escalate blocker {BLOCKER-KEY} — it has been in {status} for {N} days" |
| Blocked, no linked blocker | "Ask {assignee} to identify and link the blocker" |
| Stale, no PR | "Check in with {assignee} — no code activity detected" |
| Stale, PR awaiting review | "Find a reviewer for PR #{number} — open {N} days" |
| Stale, CI failing | "CI is failing on PR #{number} — needs technical attention" |
| Silent, low priority | "Confirm {ticket} is still in scope for this sprint" |
| Silent, high priority | "Urgent: {ticket} has had zero activity for {N} days" |

## Output Format

```
## Stuck Tickets: {count} found

**Summary**: {count} tickets stuck across {layer_count} detection layers.
{story_points_at_risk} story points at risk. Highest severity: {max_severity}.

---

### [{KEY}] {summary}
- **Severity**: {Critical|High|Medium}
- **Layers**: {Flagged|Blocked|Stale|Silent} (comma-separated if multiple)
- **Status**: {current_status} for {days_in_current_status} days
- **Assignee**: {assignee}
- **Priority**: {priority}
- **Story Points**: {sp} (or "unestimated")
- **Last Activity**: {last_updated} ({days_ago} days ago)
- **PR Status**: {status} (or "No PR")
- **Blocking Chain**: {blocker_key → its_status} (or "None")
- **Recommended Action**: {specific action from Step 6}

---

(repeat for each stuck ticket, sorted by severity)

### Risk Summary
- **Story points at risk**: {total} SP ({percentage}% of sprint commitment)
- **Tickets blocking others**: {list}
- **Longest stuck**: {KEY} — {N} days in {status}
```

## Error Handling

- If no tickets are stuck: report "No stuck tickets detected" — this is a valid, positive outcome. Do not fabricate findings.
- If `days_in_current_status` is missing: estimate from `last_updated` field as a fallback. Note the approximation.
- If PR data is unavailable: skip PR-related analysis and note "PR data unavailable — code activity not assessed."
- If sprint context is missing: skip urgency escalation and note "Sprint timeline unknown — severity not adjusted for remaining days."

## Integration Enhancement

When connected to a live project tracker, this skill can automatically:
- Execute status-based queries instead of scanning provided data
- Retrieve full ticket history for more accurate staleness detection
- Pull PR/CI data from version control for code activity analysis
- Check team chat for recent mentions of stuck tickets

See `integrations/_interface/data-source.md` for the integration contract.
