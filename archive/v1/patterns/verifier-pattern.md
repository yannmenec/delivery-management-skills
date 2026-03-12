# Verifier Pattern

## What It Is

The **verifier pattern** separates verification of agent output from generation. Instead of trusting the agent's output blindly, a dedicated verification step validates it before delivery. This implements a **planner-executor-reviewer** loop: plan what to do, execute, review output, iterate if needed.

```
    ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
    │   PLAN      │────▶│   EXECUTE   │────▶│   REVIEW    │
    │ (skill      │     │ (skill      │     │ (verifier   │
    │  logic)     │     │  runs)      │     │  skill)     │
    └─────────────┘     └─────────────┘     └──────┬──────┘
                                                   │
                                    ┌──────────────┴──────────────┐
                                    │                             │
                                    ▼                             ▼
                            ┌───────────────┐             ┌───────────────┐
                            │    PASS       │             │   FAIL        │
                            │  Deliver      │             │  Fix & retry  │
                            └───────────────┘             │  (max N times)│
                                                          └───────┬───────┘
                                                                  │
                                                                  ▼
                                                          After max iterations:
                                                          Deliver with caveats
```

## Why It Matters

- **Catches hallucinations**: Numbers without sources, fabricated ticket keys, and inconsistent metrics are caught before they reach stakeholders.
- **Enforces standards**: Template completeness, tone match, and guardrails (no PII, no fabrication) are validated systematically.
- **Bounded iteration**: Max iteration limits prevent infinite fix-retry loops and ensure delivery even when perfect output is unreachable.

## How It Works

Two verification levels exist:

| Level | Skill | Checks | When to Use |
|-------|-------|--------|-------------|
| **Lightweight** | `self-check` | 5 binary checks | Every skill execution |
| **Thorough** | `evaluate-output` | 6-dimension scoring (0–2 each) | High-stakes outputs only |

### Lightweight: self-check (5 binary checks)

1. **Numbers cited**: Every numeric value has a traceable source or "(estimated)" marker.
2. **No empty sections**: Every section header has content (or "Data unavailable: {reason}").
3. **Evidence referenced**: At least one specific data reference (ticket key, date, metric).
4. **Confidence stated**: High/Medium/Low with justification.
5. **Actionable recommendations**: At least one specific, actionable recommendation.

### Thorough: evaluate-output (6 dimensions)

1. Numeric consistency (cross-reference with source data)
2. RAG alignment (status matches underlying data)
3. Template completeness (all expected sections present)
4. Tone match (appropriate for audience)
5. Cross-reference consistency (same facts reported consistently)
6. Guardrails compliance (no PII, no fabrication, freshness noted)

**Verdict logic**: 10–12 = Pass; 7–9 = Iterate (max 2 iterations); 0–6 = Fail (substantial revision). After 2 iterations without reaching 10+, deliver with caveats.

## When to Use It

- **self-check**: Final step of every skill and workflow. Low overhead, catches ~80% of common defects.
- **evaluate-output**: Sprint reports, stakeholder updates, PI plans, risk assessments—any output shared externally or used for decision-making.

## How It Appears in This Repo

- **`skills/quality-gates/self-check/SKILL.md`**: Defines the 5 binary checks, pass/fail criteria, and the rule that self-check should never block delivery—if it fails, fix and retry; if the check itself errors, deliver with a note.
- **`skills/quality-gates/evaluate-output/SKILL.md`**: Defines the 6 dimensions, scoring (0–2), verdict table, and max 2 iterations. Explicitly states: do not run on every output—use for high-stakes only.

## Pitfalls

- **Verifier overload**: Running `evaluate-output` on every output adds latency and cost. Reserve it for high-stakes deliverables.
- **Infinite loops**: Always enforce max iterations (e.g., 2 for evaluate-output). Without bounds, the agent can retry indefinitely.
- **Verifier as bottleneck**: If the verifier is too strict, valid outputs may be rejected. Calibrate thresholds (e.g., 4/5 for self-check, 10/12 for evaluate-output) based on real usage.
- **Self-verification vs external verifier**: The same LLM can run both generation and verification, but may miss its own blind spots. For critical outputs, consider a second pass with a different prompt or a separate evaluation call. The library uses a single agent with explicit checklists to mitigate this.

**Summary**: Run self-check on every output; run evaluate-output on high-stakes outputs. Enforce max iterations (2 for evaluate-output) to prevent infinite loops. Deliver with caveats when the threshold cannot be reached. Never block delivery indefinitely.
