# Benchmark: Sprint Report — Before vs After

## Task

Generate a sprint health report at the end of a 2-week sprint for the Horizon team (6 developers, 15 tickets, 71 SP committed).

## Manual Baseline (Estimated)

| Step | Time | Tool |
|------|------|------|
| Open board, review ticket statuses | 5 min | Project tracker |
| Check each blocked ticket, trace dependencies | 8 min | Project tracker |
| Look up PR status for in-progress tickets | 5 min | Version control |
| Calculate velocity from previous sprints | 5 min | Spreadsheet |
| Count scope changes | 3 min | Sprint history |
| Write the report | 10 min | Document editor |
| **Total** | **~36 min** | |

**Common manual gaps:**
- Silent tickets (no updates, no flag) often missed
- PR status rarely cross-referenced with ticket status
- Scope change detection is approximate ("I think we added some tickets")
- Velocity trend requires digging into historical sprints
- Report format varies sprint-to-sprint

## Agent-Assisted (Using sprint-close-report workflow)

| Step | Time | Tool |
|------|------|------|
| Load data + invoke workflow | 10 sec | AI assistant |
| Agent generates report | 60-90 sec | Automated |
| Review and adjust | 2 min | Human review |
| **Total** | **~3 min** | |

**Agent advantages:**
- Systematic 4-layer stuck ticket detection (catches silent tickets)
- PR status automatically cross-referenced
- Scope change computed from ticket dates
- Velocity computed from full sprint history
- Consistent format every sprint
- Self-check validates quality before delivery

## Expected Comparison

| Dimension | Manual | Agent | Delta |
|-----------|--------|-------|-------|
| Time | ~36 min | ~3 min | -92% |
| Stuck tickets found | 2-3 (obvious ones) | 4-5 (includes silent) | +60-100% |
| Sections covered | 4-5 | 8 (full template) | +60% |
| Consistency | Varies | Identical format | Standardized |

Run this benchmark yourself using `evals/test-cases/sprint-report-happy-path.md` and the `sprint-close-report` workflow.
