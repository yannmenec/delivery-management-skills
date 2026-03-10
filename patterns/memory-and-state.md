# Memory and State

## What It Is

**Memory and state** is the practice of persisting key data between agent sessions to enable trend detection, follow-up tracking, and alert deduplication. Without memory, every run is stateless — the agent cannot say "this ticket has been stuck for 3 consecutive days" or "velocity dropped 20% vs last sprint."

```
    Session N-1                    Session N                     Session N+1
    ┌──────────┐                  ┌──────────┐                  ┌──────────┐
    │ Agent    │──── write ──────▶│ State    │──── read ───────▶│ Agent    │
    │ output   │    state file    │ file     │   previous       │ can      │
    │          │                  │          │   state          │ compare  │
    └──────────┘                  └──────────┘                  └──────────┘
                                  {date}.md
```

## Why It Matters

- **Trend detection**: "Velocity has dropped 3 sprints in a row" requires remembering previous velocity values.
- **Alert deduplication**: Without state, the same stuck ticket triggers the same alert every day. With state, repeat alerts are suppressed and persistent issues are escalated.
- **Follow-up tracking**: "Last session recommended escalating PROJ-123 — was it resolved?" requires knowing what was recommended.

## When to Use

- **Daily scans** that run repeatedly and need to detect changes vs. previous state
- **Sprint-over-sprint comparisons** that require historical metrics
- **Alert systems** that must suppress noise and escalate persistence

Do NOT use for one-off analyses or user-initiated ad-hoc queries where historical context adds no value.

## How It Works

### State File Convention

Store state as dated markdown files in a known location:

```
state/{agent-name}/{YYYY-MM-DD}.md
```

Each file contains:
- Key metrics from that session (velocity, blocker count, completion %)
- Alerts sent (ticket key, category, status)
- Recommendations made
- Open follow-ups

### Read-Before-Write

At session start, read the most recent state file. At session end, write the current state. Never read and write the same file in one session — always create a new dated file.

### Retention

Keep the last 10 state files. Older files can be archived or deleted. Most trend comparisons need at most 5-7 sessions of history.

## How It Appears in This Repo

- **`skills/quality-gates/cite-sources/SKILL.md`**: Does not use state, but its citations enable traceability across sessions.
- **Pattern reference**: The `deduplicate-alerts` skill depends on previous state to classify alerts as new, escalated, or suppressed.
- **Adapter convention**: The Cursor adapter creates a `state/` directory convention for session persistence.

## Pitfalls

- **State corruption**: Always use atomic writes (write to temp file, then rename). Never partially write state.
- **Blocking on state failure**: If the state file cannot be read, proceed without history. Never block the agent because state is unavailable.
- **Unbounded state**: Without retention limits, state files accumulate indefinitely. Cap at 10 files.
- **State as database**: State files are for lightweight persistence (key metrics, alert hashes). Do not store full ticket data or large datasets.
