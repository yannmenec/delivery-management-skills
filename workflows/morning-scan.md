---
name: morning-scan
version: 1.0.0
description: Daily sprint scan that detects blockers, ghost-done tickets, and scope changes in one pass.
type: workflow
skills_used:
  - detect-stuck-tickets
  - detect-ghost-done
  - detect-scope-change
  - format-for-audience
  - self-check
estimated_duration: 60-120 seconds
---

# Morning Scan

A daily workflow that gives a Delivery Manager a complete picture of "what needs my attention today" in under 2 minutes. Chains detection skills into a single, prioritized briefing.

## Purpose

Replace the 30-minute morning routine of manually checking the board, reviewing stale tickets, and scanning pull requests. The morning scan surfaces only what changed or needs action.

## Workflow

```
┌───────────────────────┐
│   Sprint Data Input   │
│  (tickets + context)  │
└──────────┬────────────┘
           │
     ┌─────┴─────┐
     │  PARALLEL  │
     ├────────────┤
     │            │
     ▼            ▼
┌─────────┐  ┌──────────┐  ┌──────────────┐
│  Stuck  │  │  Ghost-  │  │    Scope     │
│ Tickets │  │   Done   │  │   Change     │
└────┬────┘  └────┬─────┘  └──────┬───────┘
     │            │               │
     └────────────┼───────────────┘
                  │
                  ▼
         ┌────────────────┐
         │   Prioritize   │
         │   & Merge      │
         └───────┬────────┘
                 │
                 ▼
         ┌────────────────┐
         │  Format for    │
         │  Audience      │
         └───────┬────────┘
                 │
                 ▼
         ┌────────────────┐
         │  Self-Check    │
         └───────┬────────┘
                 │
                 ▼
         ┌────────────────┐
         │    Output:     │
         │ Morning Brief  │
         └────────────────┘
```

## Steps

### Step 1: Gather sprint data

Collect active sprint tickets. If using an integration, query the project tracker. If working manually, the user provides the ticket list.

Required data per ticket: key, summary, status, assignee, priority, days_in_current_status, last_updated, pr_status (if available).

### Step 2: Run detection skills in parallel

Execute these three skills simultaneously — they are independent and share the same input:

1. **detect-stuck-tickets**: Identify blocked, stale, and silent tickets
2. **detect-ghost-done**: Find tickets that appear complete but are in intermediate status
3. **detect-scope-change**: Calculate tickets added/removed since sprint start

### Step 3: Prioritize and merge findings

Combine results into a single prioritized list:

**Needs Attention** (action required today):
- Critical/High severity stuck tickets
- Tickets blocking other tickets
- Ghost-done tickets blocking status accuracy

**Heads Up** (informational, may need action soon):
- Medium severity stuck tickets
- Scope change summary (net additions/removals)
- Ghost-done tickets with no downstream impact

**Wins** (celebrate progress):
- Tickets completed since yesterday
- Blockers resolved

### Step 4: Format for audience

Apply `format-for-audience` with audience = "engineering-team" and format = "markdown" (default).

For Slack delivery, use format = "slack" with these constraints:
- Max 5 bullets per section
- Bold section headers
- Ticket keys as links (if tracker URL is known)
- Tag assignees for action items

### Step 5: Run self-check

Apply `self-check` to the formatted output. Verify:
- Numbers are consistent (stuck count matches listed tickets)
- No empty sections (if no stuck tickets, say so explicitly)
- Evidence referenced (ticket keys, days stuck)
- At least one actionable recommendation

## Output Format

```
## Morning Scan — {date}

**Sprint**: {sprint_name} | Day {N} of {total} | {days_remaining} days remaining

### Needs Attention

{Prioritized list of items requiring action today, with ticket keys, assignees, and specific recommended actions.}

### Heads Up

{Informational items: scope changes, medium-priority stale tickets, process observations.}

### Wins

{Tickets completed, blockers resolved, positive progress since yesterday.}

---
**Summary**: {N} items need attention, {N} heads-up, {N} wins.
**Confidence**: {High|Medium|Low}
```

## Error Handling

- If any sub-skill fails (e.g., PR data unavailable for ghost-done detection): proceed with available results. Note: "{skill} could not complete — {reason}. Findings may be incomplete."
- If sprint data is empty or has no active tickets: return "No active sprint data provided. Morning scan cannot run."
- If all detection skills return no findings: return a positive "All clear" message. Never fabricate findings to make the scan seem useful.
