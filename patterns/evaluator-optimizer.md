# Evaluator-Optimizer

## What It Is

The **evaluator-optimizer** pattern uses one evaluation process to score another process's output, then feeds the score back to trigger revision. The generator and evaluator can be the same model with different prompts, or different models entirely.

```
    ┌──────────┐     ┌──────────────┐     ┌──────────┐
    │GENERATOR │────▶│  EVALUATOR   │────▶│ VERDICT  │
    │          │     │              │     │          │
    │ Produce  │     │ Score on     │     │ Pass?    │
    │ output   │     │ N dimensions │     │ (≥7/10)  │
    └──────────┘     └──────────────┘     └────┬─────┘
         ▲                                      │
         │                               ┌─────┴──────┐
         │                               │ Yes   │ No │
         │                               ▼       ▼    │
         │                          Deliver   Revise   │
         │                                    (max 2x) │
         └────────────────────────────────────────────┘
```

## Why It Matters

- **40% hallucination reduction** reported in production systems using this pattern (Anthropic, 2025).
- **Measurable quality**: The evaluator produces a numeric score, making quality objective rather than subjective.
- **Bounded iteration**: Max 2 revision cycles prevents infinite loops while catching most errors.

## When to Use

| Output Type | Use Evaluator-Optimizer? | Use Self-Check Instead? |
|-------------|------------------------|------------------------|
| Sprint reports, stakeholder updates | Yes | Also (as first gate) |
| Escalation memos, PI reviews | Yes | Also |
| Stuck ticket detection, velocity computation | No | Yes (sufficient) |
| Simple formatting, brief summaries | No | Yes (sufficient) |

Use the evaluator-optimizer for **high-stakes generation** where errors have consequences. Use self-check alone for deterministic or low-stakes outputs.

## How It Works

### Step 1: Generate

The generator skill produces its output following its full method (including any verification phase).

### Step 2: Evaluate

The evaluator skill (`evaluate-output`) scores the output on 6 dimensions:
1. Numeric consistency
2. RAG alignment
3. Template completeness
4. Tone match
5. Cross-reference consistency
6. Guardrails compliance

Total: 0-12 points.

### Step 3: Verdict

| Score | Verdict | Action |
|-------|---------|--------|
| 10-12 | Pass | Deliver as-is |
| 7-9 | Iterate | Feed evaluation feedback to generator, revise, re-evaluate |
| 0-6 | Fail | Major revision needed — deliver with prominent caveats |

### Step 4: Iterate (if needed)

Feed the specific dimension failures back to the generator with instructions to fix only those issues. Re-evaluate. Max 2 iterations total.

## How It Appears in This Repo

- **`skills/quality-gates/evaluate-output/SKILL.md`**: The evaluator skill with 6-dimension scoring.
- **`skills/quality-gates/self-check/SKILL.md`**: Lightweight first gate (5 binary checks).
- **`workflows/sprint-close-report.md`**: Explicitly chains generate → self-check → evaluate-output → iterate.
- **Quality pipeline**: self-check (every output) → evaluate-output (high-stakes) → cite-sources (traceability).

## Pitfalls

- **Evaluator hallucination**: The evaluator can also hallucinate — scoring a flawed output as passing. Mitigate by making evaluation criteria binary and concrete, not subjective.
- **Cost multiplication**: Each iteration doubles the token cost. For token-sensitive deployments, use self-check alone and reserve evaluate-output for the most critical outputs.
- **Infinite revision**: Without a hard max iteration limit, the generate-evaluate loop can cycle indefinitely. Two iterations is the ceiling.
- **Evaluator as blocker**: If the evaluator fails or errors, deliver the output with a note — never block delivery because evaluation could not complete.
