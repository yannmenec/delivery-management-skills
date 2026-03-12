# Benchmark: Morning Scan — Before vs After

## Task

Identify what needs attention before standup on Day 6 of a 2-week sprint (6-person team, 15 tickets).

## Manual Baseline (Estimated)

| Step | Time | Tool |
|------|------|------|
| Open board, scan ticket statuses | 5 min | Project tracker |
| Check blocked tickets | 3 min | Project tracker |
| Look for stale tickets | 5 min | Project tracker (sort by last update) |
| Check PR status for in-progress work | 5 min | Version control |
| Note scope changes | 2 min | Sprint history |
| Write notes for standup | 5 min | Notepad |
| **Total** | **~25 min** | |

**Common manual gaps:**
- "In Review" tickets with no reviewer rarely noticed
- Ghost-done tickets (PR merged but ticket open) missed entirely
- Dependency chains not traced (only direct blockers seen)
- No systematic prioritization — DM remembers top 3-4 items, misses the rest

## Agent-Assisted (Using morning-scan workflow)

| Step | Time | Tool |
|------|------|------|
| Load data + invoke workflow | 10 sec | AI assistant |
| Agent runs 3 detection skills in parallel | 60 sec | Automated |
| Review briefing | 1 min | Human review |
| **Total** | **~2 min** | |

**Agent advantages:**
- 4-layer stuck detection (flagged, blocked, stale, silent) — catches silent tickets
- Ghost-done detection from PR/version signals
- Scope changes computed from dates
- Prioritized output (Needs Attention > Heads Up > Wins)
- Consistent every morning

## Expected Comparison

| Dimension | Manual | Agent | Delta |
|-----------|--------|-------|-------|
| Time | ~25 min | ~2 min | -92% |
| Items identified | 3-4 | 5-7 | +50-75% |
| Ghost-done detected | 0 | 1+ | From zero |
| Silent tickets caught | 0-1 | 2-3 | From zero |
| Prioritized output | No | Yes | Structured |

Run this benchmark yourself using `evals/test-cases/stuck-tickets-scenario-1.md` and the `morning-scan` workflow.
