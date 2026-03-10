# Demo: Morning Scan

> Time to complete: ~90 seconds
> Skills used: detect-stuck-tickets, detect-ghost-done, detect-scope-change, format-for-audience

## Scenario

It is Monday morning, Day 6 of a 2-week sprint. You are the Delivery Manager for the Horizon team (6 developers). You want to know what needs your attention before standup.

## How to Run

Point your AI assistant at the morning-scan workflow and the sample sprint data:

**In Cursor:**
```
Read workflows/morning-scan.md and run it against the data in integrations/mock/sprint-data.json
```

**In Claude Code:**
```
Read delivery-skills/workflows/morning-scan.md and run it against delivery-skills/mock/sprint-data.json
```

**Manual (any tool):**
```
I need a morning sprint scan. Here is my sprint data: [paste contents of integrations/mock/sprint-data.json]
```

## Expected Output

The morning scan should produce a briefing with three sections:

### Needs Attention (3 items)

1. **HRZ-403** (Payment processing timeout) — Blocked 4 days, Critical priority, blocked by PLAT-892 which is still in To Do on the Platform team. 8 SP at risk. **Action**: Escalate to Platform team — the blocker has not been started.

2. **HRZ-406** (Currency rounding error) — In Progress 6 days, Critical priority, PR open but no movement. **Action**: Check in with Priya Patel — code is up for review but may be stuck.

3. **HRZ-405** (Notification service refactor) — In Review 5 days, PR open, no review activity. 8 SP at risk. **Action**: Find a reviewer — this PR has been waiting 5 days.

### Heads Up (2 items)

1. **Scope change**: HRZ-415 (rate limiting) is unassigned and in To Do — confirm whether it is in scope.
2. **HRZ-410** (Design token migration) has been In Progress for 4 days and blocks HRZ-402. Monitor.

### Wins (1 item)

1. Alex Chen closed HRZ-401 (Onboarding wizard step 1) — 5 SP completed.

## What This Demonstrates

- **Multi-layer detection**: Blocked (HRZ-403), Stale (HRZ-405, HRZ-406), and dependency chain (HRZ-410 → HRZ-402) all detected in one pass
- **Severity-aware prioritization**: Critical priority tickets surface first
- **Actionable recommendations**: Each item has a specific next step, not generic "follow up"
- **Positive findings included**: Wins section celebrates progress
- **Grounded output**: Every claim references a specific ticket, person, and data point

## Before vs After

| | Manual Process | With Morning Scan |
|---|---|---|
| **Time** | 25-35 min (open board, check each ticket, cross-reference PRs, write notes) | ~90 seconds |
| **Coverage** | Usually checks top 5-6 tickets, misses silent ones | Scans all 15 tickets systematically across 4 detection layers |
| **Consistency** | Depends on DM's energy level and attention | Same thoroughness every morning |
| **Blind spots** | Often misses stale In Review tickets and dependency chains | Detects stale reviews, transitive blocks, and ghost-done tickets |
| **Output** | Mental notes or bullet points in a doc | Structured briefing with severity, context, and specific actions |
