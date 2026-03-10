# Planner-Executor-Reviewer

## What It Is

A three-phase execution loop where the agent (1) plans what to do, (2) executes, and (3) reviews its own output against criteria — iterating if needed.

```
    ┌──────────┐     ┌──────────┐     ┌──────────┐
    │   PLAN   │────▶│ EXECUTE  │────▶│  REVIEW  │
    │          │     │          │     │          │
    │ Identify │     │ Gather   │     │ Run      │
    │ data     │     │ data,    │     │ self-    │
    │ needed,  │     │ analyze, │     │ check or │
    │ sequence │     │ generate │     │ evaluate │
    │ steps    │     │ output   │     │ output   │
    └──────────┘     └──────────┘     └────┬─────┘
                                           │
                                    ┌──────┴──────┐
                                    │  Pass?      │
                                    ├─────┬───────┤
                                    │ Yes │  No   │
                                    │     │ (max  │
                                    ▼     │  2x)  │
                               Deliver    ▼
                                      Revise and
                                      re-execute
```

## Why It Matters

- **Single-pass errors**: LLMs frequently miss sections, miscalculate, or misapply tone on first pass. The review phase catches these.
- **Bounded iteration**: Without a max iteration limit, the loop can run indefinitely. Two review passes is the practical optimum — beyond that, diminishing returns.
- **Separation of concerns**: Planning, execution, and review are distinct cognitive tasks. Separating them improves each.

## When to Use

- **Generation tasks** that produce structured output (reports, memos, updates)
- **Multi-step workflows** where the output depends on combining data from several sources
- **High-stakes deliverables** where errors have consequences (escalation memos, executive updates)

Do NOT use for simple lookups, computations, or detections where the output is deterministic.

## How It Works

### Phase 1: Plan

Identify what data is needed, what steps to follow, and what the output should look like. This prevents the executor from guessing or making assumptions.

### Phase 2: Execute

Gather the data, perform the analysis, and generate the output following the plan. This is the core work.

### Phase 3: Review

Apply quality checks against the output:
- **Lightweight**: `self-check` (5 binary checks). For most outputs.
- **Deep**: `evaluate-output` (6-dimension scoring). For high-stakes outputs.

If the review identifies issues and iterations remain (max 2), fix and re-review. Otherwise, deliver with caveats.

## How It Appears in This Repo

- **`workflows/sprint-close-report.md`**: Explicitly structures Plan (identify data) → Execute (gather, analyze, generate report) → Review (run self-check, evaluate-output, iterate if score < 7/10).
- **`skills/reporting/generate-sprint-report/SKILL.md`**: Method follows plan-execute-review with verification phase before self-check.
- **`workflows/pi-readiness-review.md`**: Plans which epics and capacity data to gather before executing the assessment.

## Pitfalls

- **Over-planning**: The plan phase should be 2-3 sentences, not a detailed specification. Over-planning wastes tokens and delays execution.
- **Infinite loops**: Always enforce a max iteration count. Two review passes is sufficient. After that, deliver with noted caveats.
- **Review without criteria**: A review phase that says "check if it's good" is useless. Reviews need specific, binary-checkable criteria.
- **Skipping the plan**: Jumping straight to execution often produces output that misses sections or uses wrong data. The plan ensures completeness.
