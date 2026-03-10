# How to Evaluate Skills

A step-by-step guide for manually evaluating skill output quality using test cases and rubrics.

## 5-Step Process

### Step 1: Select a test case

Choose from `evals/test-cases/`. Each test case specifies the skill under test, input data, and expected results.

### Step 2: Run the skill

Load the test case input into your AI tool and reference the skill:

```
Read skills/{category}/{skill-name}/SKILL.md and run it against this data:
[paste the test case input]
```

### Step 3: Capture the output

Save the complete agent output. Include any self-check or evaluate-output results if the skill triggers them.

### Step 4: Score against the rubric

Use the applicable rubric from `evals/rubrics/`:

| Output Type | Rubric |
|------------|--------|
| Sprint reports | `sprint-report-rubric.md` |
| Risk assessments | `risk-assessment-rubric.md` |
| Escalation memos | `escalation-rubric.md` |
| Other outputs | Use the test case's built-in scoring criteria |

Score each dimension independently. Record the score and a brief justification.

### Step 5: Record results

Save results in `evals/results/` using this naming convention:

```
evals/results/YYYY-MM-DD-{skill-name}.md
```

Template:

```markdown
# Eval: {skill-name} — {date}

## Test Case: {test case name}
## Model: {model used}
## Total Score: {N}/{max}

### Dimension Scores
| Dimension | Score | Notes |
|-----------|-------|-------|
| ... | ... | ... |

### Verdict: Pass / Iterate / Fail

### Notes
{Any observations about the output quality, failure modes, or model behavior}
```

## Tips

- **Run the same test case with different models** to compare output quality across providers.
- **Run the same test case twice with the same model** to assess consistency.
- **Focus on false positives and false negatives** for detection skills (stuck tickets, ghost-done, scope change).
- **Check citation accuracy** for reporting skills — every number should trace to the input data.

## Inter-Evaluator Guidance

If two people evaluate the same output and disagree by more than 2 points on total score, review the specific dimensions where scores diverge. The most common source of disagreement is Recommendation Quality — agree on what "specific and actionable" means before scoring.
