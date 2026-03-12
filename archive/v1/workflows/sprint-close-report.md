---
name: sprint-close-report
version: 1.0.0
description: End-of-sprint workflow that generates a comprehensive sprint report with velocity, health, and recommendations.
type: workflow
skills_used:
  - compute-velocity
  - sprint-health-check
  - detect-scope-change
  - generate-sprint-report
  - format-for-audience
  - self-check
  - evaluate-output
estimated_duration: 2-4 minutes
---

# Sprint Close Report

End-of-sprint workflow that produces a comprehensive sprint report suitable for sprint reviews, stakeholder updates, and team retrospectives. Chains analysis skills into a polished, evaluated report.

## Purpose

Replace the 60-90 minute manual process of pulling data from the tracker, computing velocity in a spreadsheet, writing the report, and formatting for different audiences. This workflow produces a complete report with quality validation in under 4 minutes.

## Workflow

```
┌────────────────────────────┐
│  Sprint Data + History     │
│  (current + past sprints)  │
└──────────┬─────────────────┘
           │
     ┌─────┴─────┐
     │  PARALLEL  │
     ├────────────┤
     ▼            ▼
┌──────────┐  ┌──────────────┐
│ Compute  │  │   Sprint     │
│ Velocity │  │ Health Check │
└────┬─────┘  └──────┬───────┘
     │               │
     └───────┬───────┘
             │
             ▼
     ┌───────────────┐
     │   Generate    │
     │ Sprint Report │
     └───────┬───────┘
             │
             ▼
     ┌───────────────┐
     │  Self-Check   │──── pass? ───▶ continue
     └───────┬───────┘      │
             │           fail?
             │              │
             ▼              ▼
     ┌───────────────┐   fix + retry
     │   Evaluate    │   (max 2x)
     │    Output     │
     └───────┬───────┘
             │
             ▼
     ┌───────────────┐
     │  Format for   │
     │  Audience(s)  │
     └───────┬───────┘
             │
             ▼
     ┌───────────────┐
     │    Output:    │
     │ Sprint Report │
     └───────────────┘
```

## Steps

### Step 1: Gather data

Collect:
- **Current sprint tickets**: All tickets with status, assignee, story points, dates
- **Sprint history**: 2-3 previous sprints with committed/completed story points
- **Sprint metadata**: Sprint name, dates, goal

### Step 2: Run analysis in parallel

Execute simultaneously:
1. **compute-velocity**: Calculate velocity trend, predictability, current sprint trajectory
2. **sprint-health-check**: Run the composite health assessment (which internally calls detect-stuck-tickets, detect-scope-change, detect-ghost-done)

### Step 3: Generate sprint report

Feed the analysis results into `generate-sprint-report`. The report skill combines:
- Velocity data and trend from compute-velocity
- RAG status, blockers, scope changes from sprint-health-check
- Executive summary, progress table, recommendations

### Step 4: Quality validation

Run `self-check` (5 binary checks). If 4/5+ pass, proceed.

Then run `evaluate-output` (6-dimension scoring for sprint-report type). If score >= 10/12, proceed. If 7-9/12, fix identified issues and re-evaluate (max 2 iterations). If <7/12, deliver with caveats.

### Step 5: Format for audiences

Generate multiple versions using `format-for-audience`:
1. **Engineering Management** (default): Full operational detail
2. **C-Level** (if requested): Executive summary with RAG and business impact
3. **Engineering Team** (if requested): Action items and specific tickets

## Output

The primary output is a comprehensive sprint report as defined by `generate-sprint-report`. Additional audience-specific versions are generated on request.

Quality metadata is appended:

```
---
Self-check: {N}/5 pass
Evaluation: {N}/12 ({Pass|Iterate|Fail})
Confidence: {High|Medium|Low}
```

## Error Handling

- If velocity history is insufficient (fewer than 2 sprints): generate report without velocity trend. Note: "Velocity trend unavailable — insufficient sprint history."
- If the sprint is still in progress: generate a mid-sprint progress report rather than a close report. Adjust language from "completed" to "projected."
- If evaluate-output fails twice: deliver the best version with a caveat header.
