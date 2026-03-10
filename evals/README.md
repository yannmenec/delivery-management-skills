# Evaluation Framework

This directory contains the tools for validating skill output quality.

## Structure

```
evals/
├── rubrics/          # Scoring rubrics per output type
├── test-cases/       # Scenario-based tests with known inputs and expected outputs
└── benchmarks/       # Before/after comparisons showing skill effectiveness
```

## How Evaluation Works

### Level 1: Built-in Quality Gates (every run)

Every skill output passes through `self-check` (5 binary checks):
1. Numbers cited with sources
2. No empty sections
3. Evidence referenced from input data
4. Confidence level stated
5. Actionable recommendations included

### Level 2: Deep Evaluation (high-stakes outputs)

Reports, stakeholder updates, and PI plans pass through `evaluate-output` (6-dimension scoring, 0-12 scale):
1. Numeric consistency
2. RAG alignment
3. Template completeness
4. Tone match
5. Cross-reference consistency
6. Guardrails compliance

### Level 3: Scenario Testing (development)

Test cases in `test-cases/` provide known inputs and expected outputs. Use these to validate skill changes and catch regressions.

## Running Evaluations

Currently, evaluation is manual:
1. Feed the test case input into the skill
2. Compare the output against the expected output and rubric
3. Score using the rubric criteria

Automated evaluation tooling is planned for v2.
