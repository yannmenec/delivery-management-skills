---
name: standup-brief
version: 1.0.0
description: >
  Generates a quick morning briefing with what happened, what's stuck,
  and what needs attention today.
category: meeting-prep
trigger: Before daily standup or as a morning check-in
autonomy: autonomous
portability: universal
complexity: basic
type: generation
inputs:
  - name: sprint_tickets
    type: structured-text
    required: true
    description: Current sprint tickets with status, assignee, priority, days in status, and recent changes.
  - name: previous_day_snapshot
    type: structured-text
    required: false
    description: Yesterday's ticket statuses (enables "what changed" detection).
outputs:
  - name: standup_brief
    type: structured-text
    description: 3-section briefing (Happened, Stuck, Attention) with ticket-level detail.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Standup Brief

Generate a concise morning briefing that answers three questions: What happened since yesterday? What's stuck? What needs attention today?

## When to Use

- Before daily standup meetings
- As a personal morning check-in for the delivery manager
- When catching up after a day away

## Method

### Step 1: Identify what happened

Compare current ticket statuses against the previous day (if `previous_day_snapshot` provided) or infer from `last_updated` dates:

- Tickets that moved to Done
- Tickets that changed status (To Do → In Progress, In Progress → In Review, etc.)
- New tickets added to the sprint
- PRs merged or opened

List as concrete events: "{Person} completed {ticket} ({SP} SP)" or "{Ticket} moved from In Progress to In Review."

### Step 2: Identify what's stuck

Apply a simplified version of stuck-ticket detection:
- Tickets in Blocked status
- Tickets flagged with impediment markers
- Tickets in the same status for 3+ days with no recent update
- Tickets In Review for 2+ days

For each stuck item, note: ticket key, assignee, days stuck, and why (if detectable from linked issues or labels).

### Step 3: Identify what needs attention today

Based on priority and sprint timeline:
- Unblocking actions needed (who needs to do what)
- Reviews waiting (PRs with no reviewer)
- Approaching deadlines (sprint end within 3 days + work still in To Do)
- Unassigned tickets that should be picked up

### Step 4: Format the briefing

Keep it short — this is a 2-minute read, not a report.

## Output Format

```
## Morning Brief — {date}

### What Happened
- {Event 1}
- {Event 2}
- ...

### What's Stuck
- **{TICKET-KEY}** ({summary}) — {assignee}, stuck {N} days. {Reason if known.}
- ...
{If nothing stuck: "Nothing blocked or stale."}

### Needs Attention Today
1. {Action 1} — {who} — {why it matters}
2. {Action 2} — {who} — {why it matters}
3. ...
{If nothing: "Sprint is on track. No immediate actions needed."}
```

## Error Handling

- **No previous_day_snapshot**: Skip "What Happened" section or infer from `last_updated` dates. Note: "Change detection based on last-updated timestamps — may miss same-day changes."
- **Empty sprint**: "Sprint appears empty. Verify sprint scope or data source."
- **All tickets Done**: "All tickets are complete. Consider pulling from the backlog or starting sprint review prep."
