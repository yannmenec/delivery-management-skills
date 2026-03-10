# Benchmark Methodology

How to run and record before/after comparisons between manual delivery management and agent-assisted workflows.

## What to Measure

| Dimension | Manual Baseline | Agent-Assisted | How to Measure |
|-----------|----------------|---------------|----------------|
| **Time** | Clock the manual process | Clock the agent workflow | Stopwatch from start to final output |
| **Completeness** | Count sections/items covered | Count sections/items covered | Checklist against expected output |
| **Accuracy** | Review for errors against source data | Review for errors against source data | Error count |
| **Items caught** | List items the DM identified | List items the agent identified | Compare lists — note items only one caught |
| **Consistency** | Run twice, compare outputs | Run twice, compare outputs | Diff the two outputs |

## How to Run a Benchmark

1. **Define the task**: Use a specific test case scenario (e.g., "morning scan on mock sprint data").
2. **Manual baseline**: Perform the task manually using only your project tracker and a text editor. Record time and output.
3. **Agent run**: Perform the same task using the skill/workflow. Record time and output.
4. **Compare**: Score both outputs against the same rubric. Note differences.

## Recording Template

```markdown
# Benchmark: {task name} — {date}

## Task
{Description of the delivery task}

## Manual Baseline
- **Time**: {minutes}
- **Score**: {N}/{max} (rubric: {rubric name})
- **Items identified**: {count}
- **Notable gaps**: {what the DM missed}

## Agent-Assisted
- **Time**: {seconds or minutes}
- **Score**: {N}/{max}
- **Items identified**: {count}
- **Notable gaps**: {what the agent missed}

## Comparison
| Dimension | Manual | Agent | Delta |
|-----------|--------|-------|-------|
| Time | {X min} | {Y sec} | {-Z%} |
| Score | {N}/{max} | {N}/{max} | {+/-} |
| Items caught | {N} | {N} | {+/-} |

## Key Insight
{One sentence: what did this benchmark reveal?}
```
