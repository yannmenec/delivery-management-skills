# Delivery Management Skills

Composable AI skills for Delivery Managers. Works with Cursor, Claude Code, and any AI coding assistant.

> A modular, tool-agnostic library of delivery management skills that help DMs, Scrum Masters, and Engineering Managers operate faster and better — from daily sprint scans to PI planning, from blocker detection to stakeholder reporting.

---

## The Problem

Delivery Managers spend 50-70% of their time on repetitive analytical work: checking what's stuck, computing velocity, writing sprint reports, preparing for meetings, formatting updates for different audiences. These tasks follow predictable patterns that AI can handle — but no structured, reusable, quality-controlled skill library exists.

This repository fills that gap.

## How It Works

```
You ask a question
        │
        ▼
┌────────────────────┐
│  AI Coding Tool    │    Reads skills from the library,
│  (Cursor, Claude   │──▶ follows the method step-by-step,
│   Code, Codex)     │    validates output with quality gates
└────────────────────┘
        │
        ▼
Structured, actionable output
(reports, recommendations, memos, risk assessments)
```

- **15 skills** covering sprint operations, risk management, reporting, planning, communication, and quality validation
- **3 workflows** that compose skills into end-to-end processes
- **5 agentic patterns** documenting orchestration, verification, and safety techniques
- **2 adapters** (Cursor + Claude Code) with one-command install
- **Built-in evaluation** with rubrics, test cases, and quality gates

## Quick Start

### Option 1: Cursor

```bash
git clone https://github.com/yannmenec/delivery-management-skills.git
bash delivery-management-skills/adapters/cursor/install.sh /path/to/your/workspace
# Reload Cursor: Cmd+Shift+P > "Reload Window"
```

Then ask: *"What's stuck in our sprint?"* with your sprint data.

### Option 2: Claude Code

```bash
git clone https://github.com/yannmenec/delivery-management-skills.git
bash delivery-management-skills/adapters/claude-code/install.sh /path/to/your/project
```

Then ask: *"Run a morning scan against the sprint data"*

### Option 3: Any AI Tool (Manual)

Copy the content of any `SKILL.md` file into your AI assistant's context, provide your data, and follow the instructions. No installation needed.

## See It In Action

### Morning Scan (90 seconds)

> "Run a morning scan against our sprint data"

The AI reads `detect-stuck-tickets`, `detect-ghost-done`, and `detect-scope-change`, runs them against your data, and produces a prioritized briefing:

**Needs Attention**: HRZ-403 blocked 4 days by Platform team (8 SP at risk). HRZ-406 in progress 6 days, PR stale. HRZ-405 in review 5 days, no reviewer.

**Heads Up**: +1 unassigned ticket in scope. HRZ-410 blocks HRZ-402 (dependency chain).

**Win**: Alex Chen closed HRZ-401 (onboarding wizard step 1).

[Full demo walkthrough →](showcase/scenarios/morning-scan-demo.md)

### Sprint Report (2 minutes)

> "Generate a sprint report for the sprint review"

Produces a complete report with RAG status, velocity trend, blockers table, scope changes, and specific recommendations — then validates it through a 5-check quality gate.

[Full demo →](showcase/scenarios/sprint-review-demo.md)

### Escalation Memo (60 seconds)

> "Draft an escalation for the payment blocker"

Produces a structured SITUATION → IMPACT → URGENCY → ASK memo with quantified impact, specific deadline, and concrete options — ready to send to leadership.

[Full demo →](showcase/scenarios/escalation-demo.md)

## Skill Library

### Sprint Operations

| Skill | What It Does |
|-------|-------------|
| [detect-stuck-tickets](skills/sprint-operations/detect-stuck-tickets/) | 4-layer detection: flagged, blocked, stale, silent tickets |
| [compute-velocity](skills/sprint-operations/compute-velocity/) | Velocity trend, predictability score, sprint trajectory |
| [detect-scope-change](skills/sprint-operations/detect-scope-change/) | Tickets added/removed mid-sprint with impact classification |
| [detect-ghost-done](skills/sprint-operations/detect-ghost-done/) | Tickets that are done but stuck in intermediate status |
| [sprint-health-check](skills/sprint-operations/sprint-health-check/) | Composite health assessment with RAG status |
| [workload-balance](skills/sprint-operations/workload-balance/) | Detect uneven work distribution across team members |

### Risk Management

| Skill | What It Does |
|-------|-------------|
| [assess-risk](skills/risk-management/assess-risk/) | Likelihood x impact scoring with RAG and mitigation tracking |
| [craft-escalation-memo](skills/risk-management/craft-escalation-memo/) | Structured escalation: Situation, Impact, Urgency, Ask |

### Reporting

| Skill | What It Does |
|-------|-------------|
| [generate-sprint-report](skills/reporting/generate-sprint-report/) | Full sprint report with velocity, blockers, scope, recommendations |
| [stakeholder-update](skills/reporting/stakeholder-update/) | Concise status update (< 1 page) |
| [format-for-audience](skills/reporting/format-for-audience/) | Adapt tone and format: C-level, product, engineering, team |

### Planning

| Skill | What It Does |
|-------|-------------|
| [assess-epic-readiness](skills/planning/assess-epic-readiness/) | 7-dimension epic maturity scoring for PI planning |
| [compute-capacity](skills/planning/compute-capacity/) | Team capacity from headcount, PTO, and buffer |
| [forecast-completion](skills/planning/forecast-completion/) | Probabilistic completion estimates from velocity distribution |

### Meeting Prep

| Skill | What It Does |
|-------|-------------|
| [standup-brief](skills/meeting-prep/standup-brief/) | Quick morning briefing: happened, stuck, needs attention |

### Communication

| Skill | What It Does |
|-------|-------------|
| [craft-unblock-message](skills/communication/craft-unblock-message/) | Question-first messages to unblock stuck tickets |
| [craft-close-message](skills/communication/craft-close-message/) | Evidence-based suggestions to close ghost-done tickets |

### Quality Gates

| Skill | What It Does |
|-------|-------------|
| [self-check](skills/quality-gates/self-check/) | 5-check quality validation on every output |
| [evaluate-output](skills/quality-gates/evaluate-output/) | 6-dimension deep evaluation for high-stakes outputs |
| [cite-sources](skills/quality-gates/cite-sources/) | Inline source citations to eliminate hallucination risk |

## Workflows

Workflows compose multiple skills into end-to-end processes:

| Workflow | Skills Composed | Time |
|----------|----------------|------|
| [Morning Scan](workflows/morning-scan.md) | detect-stuck + ghost-done + scope-change + format | ~90s |
| [Sprint Close Report](workflows/sprint-close-report.md) | velocity + health-check + report + self-check + evaluate | ~2-3 min |
| [PI Readiness Review](workflows/pi-readiness-review.md) | epic-readiness + capacity + risk + format | ~3-5 min |

## Architecture

Skills are **tool-agnostic** structured markdown with rich metadata. Adapters translate them into each AI tool's native format. Integrations are optional — every skill works with manually provided data.

```
┌─────────────────────────────┐
│    AI Tool (Cursor, etc.)   │
└─────────────┬───────────────┘
              │
      ┌───────┴───────┐
      │  Adapter       │   Thin translation layer
      └───────┬───────┘
              │
      ┌───────┴───────┐
      │  Core Skills   │   Tool-agnostic markdown
      │  + Workflows   │   Composable, tested, versioned
      │  + Quality     │   Built-in evaluation
      └───────┬───────┘
              │ optional
      ┌───────┴───────┐
      │ Integrations   │   Mock data (v1), live connectors (v2+)
      └───────────────┘
```

[Full architecture documentation →](ARCHITECTURE.md) | [Design decisions (ADRs) →](docs/architecture-decisions/)

### Design Principles

1. **Tool-agnostic by default** — Skills contain no vendor-specific syntax
2. **Useful before integrations** — Works with pasted data, no API keys required
3. **Modular and composable** — Skills are atomic units, workflows compose them
4. **Human-in-the-loop by default** — Write actions always require approval
5. **Evaluation-driven quality** — Built-in quality gates validate every output
6. **Progressive enhancement** — Base: prompt-only → Enhanced: with integrations → Full: automated

### Agentic Patterns

The library demonstrates proven agentic design techniques:

| Pattern | What It Is | Where It Appears |
|---------|-----------|-----------------|
| [Orchestrator](patterns/orchestrator-pattern.md) | Route to specialists based on intent | sprint-health-check, morning-scan |
| [Verifier](patterns/verifier-pattern.md) | Validate output before delivery | self-check, evaluate-output |
| [Confidence Calibration](patterns/confidence-calibration.md) | Explicit uncertainty signaling | Every skill output |
| [Graceful Degradation](patterns/graceful-degradation.md) | Partial output over no output | All enrichment paths |
| [Human Approval Gate](patterns/human-approval-gate.md) | Gate write actions on approval | craft-unblock-message, escalation-memo |
| [Planner-Executor-Reviewer](patterns/planner-executor-reviewer.md) | Plan → execute → review loop with bounded iteration | sprint-close-report workflow |
| [Evaluator-Optimizer](patterns/evaluator-optimizer.md) | Score output, revise if below threshold | evaluate-output → generate-sprint-report |
| [Memory and State](patterns/memory-and-state.md) | Cross-session persistence for trends | Alert deduplication, velocity tracking |
| [Progressive Enhancement](patterns/progressive-enhancement.md) | Base → enhanced → full capability levels | Every skill (manual → integration → automation) |
| [Control Plane](patterns/control-plane.md) | Single entry point routing to specialists | Cursor delivery-agent |

## Evaluation Framework

Every output is validated. No trust without verification.

- **Self-check** (5 checks, every output): Numbers cited, no empty sections, evidence referenced, confidence stated, actionable recommendations
- **Evaluate-output** (6 dimensions, high-stakes): Numeric consistency, RAG alignment, template completeness, tone match, cross-reference consistency, guardrails
- **Rubrics** (per output type): Scoring criteria for [sprint reports](evals/rubrics/sprint-report-rubric.md), [risk assessments](evals/rubrics/risk-assessment-rubric.md), [escalation memos](evals/rubrics/escalation-rubric.md)
- **Test cases**: Known-input/expected-output scenarios for [regression testing](evals/test-cases/)

## Integration Strategy

**v1 (current)**: Skills work with manually provided data or [mock datasets](integrations/mock/). No API keys, no setup, no vendor lock-in.

**v2 (planned)**: Optional connectors for Jira, GitHub, and Slack via MCP protocol. Skills reference a [common data interface](integrations/_interface/data-source.md) — connectors are interchangeable.

Skills never call vendor APIs directly. They describe what data they need; the integration layer provides it.

## Documentation

- [Getting Started](docs/getting-started.md) — First useful output in 5 minutes
- [Skill Authoring Guide](docs/skill-authoring-guide.md) — How to create a new skill
- [Architecture](ARCHITECTURE.md) — System design and design decisions
- [Architecture Decision Records](docs/architecture-decisions/) — Why things are the way they are

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

We welcome:
- New skills following the [skill authoring guide](docs/skill-authoring-guide.md)
- New adapters for AI tools not yet supported
- Evaluation test cases and rubrics
- Bug reports and quality improvements

## License

[Apache 2.0](LICENSE) — Use freely, even in commercial settings.
