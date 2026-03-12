# ADR-004: Built-in Evaluation and Quality Gates

## Status

Accepted

## Context

LLM outputs are non-deterministic. A skill that produces excellent output 80% of the time and subtly wrong output 20% of the time is dangerous for delivery management decisions (incorrect velocity, missed blockers, wrong RAG status).

Most prompt libraries ship without any quality assurance mechanism. The user has no way to know if an output is trustworthy.

## Decision

The library includes **built-in evaluation** at three levels:

1. **Skill-level quality gates**: The `self-check` skill (5 binary checks) runs after every skill execution. The `evaluate-output` skill (6-dimension scoring) runs after high-stakes outputs.

2. **Skill-level eval rubrics**: Each skill's directory contains an `eval.md` file that defines pass/fail criteria and scoring rubrics for that skill's output.

3. **Scenario-level test cases**: The `evals/test-cases/` directory contains end-to-end scenarios with known inputs and expected outputs for regression testing.

Quality gates are **skills themselves** — they follow the same format and can be composed into workflows like any other skill.

## Consequences

- **Positive**: Users can trust outputs because quality is verified, not assumed. Confidence levels (High/Medium/Low) are stated on every output.
- **Positive**: Skill authors can regression-test their changes against eval rubrics.
- **Positive**: The evaluation framework is a strong differentiator — no other prompt library has this.
- **Negative**: Evaluation adds latency (an extra LLM call per output). Mitigated by making `self-check` lightweight (5 binary checks, minimal tokens) and reserving `evaluate-output` for high-stakes outputs only.
- **Negative**: Evaluation is itself LLM-based and therefore non-deterministic. Mitigated by using binary pass/fail checks rather than subjective scoring where possible.
