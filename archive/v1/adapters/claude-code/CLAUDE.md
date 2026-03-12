# Delivery Management Skills

You have access to a library of delivery management skills in the `delivery-skills/` directory. Use these skills when asked about sprint health, blockers, velocity, risks, reports, planning, or any delivery management topic.

## How to Use Skills

1. When a user asks a delivery management question, identify the relevant skill from the list below
2. Read the skill's `SKILL.md` file and follow its Method section step by step
3. Use the data provided by the user, or query integrations if available
4. Validate your output by reading and applying `delivery-skills/quality-gates/self-check/SKILL.md`
5. State your confidence level (High/Medium/Low) based on data completeness

## Available Skills

### Sprint Operations
- `delivery-skills/sprint-operations/detect-stuck-tickets/` — Find blocked, stale, and silent tickets
- `delivery-skills/sprint-operations/compute-velocity/` — Calculate velocity and trend
- `delivery-skills/sprint-operations/detect-scope-change/` — Identify scope changes mid-sprint
- `delivery-skills/sprint-operations/detect-ghost-done/` — Find tickets that are done but not closed
- `delivery-skills/sprint-operations/sprint-health-check/` — Composite sprint health assessment
- `delivery-skills/sprint-operations/workload-balance/` — Detect uneven work distribution across team
- `delivery-skills/sprint-operations/detect-dependency-risk/` — Cross-team dependency risk detection

### Risk Management
- `delivery-skills/risk-management/assess-risk/` — Score risks with likelihood x impact matrix
- `delivery-skills/risk-management/craft-escalation-memo/` — Draft structured escalation documents

### Reporting
- `delivery-skills/reporting/generate-sprint-report/` — Full sprint report with RAG status
- `delivery-skills/reporting/stakeholder-update/` — Concise stakeholder status update
- `delivery-skills/reporting/format-for-audience/` — Adapt tone and format for different audiences

### Planning
- `delivery-skills/planning/assess-epic-readiness/` — Evaluate epic maturity for planning
- `delivery-skills/planning/compute-capacity/` — Calculate team capacity
- `delivery-skills/planning/forecast-completion/` — Probabilistic completion estimates from velocity distribution

### Meeting Prep
- `delivery-skills/meeting-prep/standup-brief/` — Quick morning briefing for standup prep

### Communication
- `delivery-skills/communication/craft-unblock-message/` — Draft messages to unblock stuck tickets
- `delivery-skills/communication/craft-close-message/` — Suggest closing ghost-done tickets

### Quality Gates
- `delivery-skills/quality-gates/self-check/` — 5-check quality validation (run on every output)
- `delivery-skills/quality-gates/evaluate-output/` — 6-dimension deep evaluation (run on high-stakes outputs)
- `delivery-skills/quality-gates/cite-sources/` — Inline source citations to eliminate hallucination risk

## Workflows

For multi-step processes, read the workflow file and follow its composition:
- `delivery-skills/workflows/morning-scan.md` — Daily sprint scan
- `delivery-skills/workflows/sprint-close-report.md` — End-of-sprint report
- `delivery-skills/workflows/pi-readiness-review.md` — PI planning readiness check

## Quality Standards

- Always run self-check before delivering output
- Never fabricate ticket keys, names, dates, or metrics
- If data is missing, say so explicitly — never guess
- State confidence level on every output
