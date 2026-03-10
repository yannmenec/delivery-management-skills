# Orchestrator Pattern

## What It Is

The **orchestrator pattern** uses a router or coordinator that analyzes intent, gathers shared context, and delegates to specialist skills. The orchestrator does not perform the core logic itself—it composes smaller, focused skills and merges their outputs into a coherent result.

```
                    ┌─────────────────────────────────────┐
                    │           ORCHESTRATOR               │
                    │  (morning-scan / sprint-health-check)│
                    │  - Receives intent & sprint data     │
                    │  - Dispatches to specialists         │
                    │  - Merges & prioritizes results      │
                    └──────────────────┬──────────────────┘
                                       │
           ┌───────────────────────────┼───────────────────────────┐
           │                           │                           │
           ▼                           ▼                           ▼
    ┌──────────────┐           ┌──────────────┐           ┌──────────────┐
    │ detect-stuck │           │ detect-ghost │           │ detect-scope │
    │   tickets    │           │    done      │           │   change     │
    │  (specialist)│           │  (specialist)│           │  (specialist)│
    └──────┬───────┘           └──────┬───────┘           └──────┬───────┘
           │                           │                           │
           └───────────────────────────┼───────────────────────────┘
                                       │
                                       ▼
                    ┌─────────────────────────────────────┐
                    │   Merge, Prioritize, Format         │
                    │   format-for-audience → self-check  │
                    └─────────────────────────────────────┘
```

## Why It Matters

- **Separation of concerns**: Each specialist skill has a single responsibility. Stuck-ticket logic lives in `detect-stuck-tickets`, not in the morning scan.
- **Reusability**: Specialists can be invoked by multiple workflows (daily pulse, mid-sprint check, sprint review).
- **Parallelization**: Independent specialists (stuck, ghost-done, scope change) can run in parallel when the orchestrator has the same input.
- **Testability**: Specialists are easier to unit-test than a monolithic "do everything" agent.

## How It Works

1. **Intent analysis**: The orchestrator (or the caller) determines what kind of output is needed—e.g., "morning brief" vs "full sprint health report."
2. **Context gathering**: Shared input (sprint tickets, sprint context) is gathered once and passed to all specialists.
3. **Delegation**: Specialists run in parallel where possible; each returns structured output.
4. **Merge & prioritize**: The orchestrator combines findings into a single prioritized list (Needs Attention, Heads Up, Wins).
5. **Format & verify**: Output is formatted for the target audience and passed through quality gates.

## When to Use It

| Use Orchestrator | Keep Monolithic |
|------------------|-----------------|
| Multiple distinct detection/computation steps | Single, tightly coupled operation |
| Steps share the same input and can run in parallel | Steps have strong sequential dependencies |
| You want specialists reusable elsewhere | Logic is specific to one workflow only |
| Output is a composite of several analyses | Output is a single transformation |

**Tradeoff**: Orchestration adds coordination overhead and more moving parts. For a simple "compute velocity from sprint history" task, a single skill is sufficient. For "what needs my attention today?" you need multiple specialists—orchestration pays off.

## How It Appears in This Repo

- **`workflows/morning-scan.md`**: Orchestrates `detect-stuck-tickets`, `detect-ghost-done`, `detect-scope-change` in parallel, then `format-for-audience` and `self-check`. The workflow explicitly documents the parallel execution and merge logic.
- **`skills/sprint-operations/sprint-health-check/SKILL.md`**: A **composite skill** that acts as an orchestrator. It invokes (or conceptually applies) `detect-stuck-tickets`, `compute-velocity`, `detect-scope-change`, and `detect-ghost-done` in sequence, then computes RAG status and burndown. It produces a full sprint health report with all sections.

## Orchestrator vs Composite Skill

A **workflow** (e.g., `morning-scan`) is a documented composition—it lists skills and order but may be executed by a scheduler or agent that invokes each skill. A **composite skill** (e.g., `sprint-health-check`) is a single SKILL.md that *embodies* the orchestration logic: it describes invoking or applying the logic of sub-skills in sequence. Both achieve composition; the composite skill is self-contained and can be loaded as one unit.

## Pitfalls

- **Over-orchestration**: Don't create an orchestrator for two skills that always run together. The overhead outweighs the benefit.
- **Tight coupling to specialists**: If the orchestrator assumes specific output shapes, changes to a specialist can break the merge logic. Document contracts clearly.
- **Single-agent vs multi-agent**: This library uses a single agent that reads multiple skills. True multi-agent (separate LLM calls per specialist) adds latency and cost—use only when specialists must run in isolation or with different models.
- **Merge logic complexity**: As more specialists are added, the prioritization and merge rules become harder to maintain. Document the merge logic explicitly (e.g., "Needs Attention" vs "Heads Up" criteria) and keep it in one place.
- **Input consistency**: All specialists must receive the same input schema. If one needs `pr_status` and another doesn't, the orchestrator must still pass it through. Document the shared input contract in the workflow.

**Summary**: Use orchestration when you have multiple independent specialists and a composite output. Use a single skill when the task is atomic. The morning-scan and sprint-health-check workflows demonstrate the pattern in practice. Prefer parallel execution where specialists share input.
