# Changelog

All notable changes to Delivery Management Skills are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-03-10

### Added
- `cite-sources` quality gate skill — inline source citations to eliminate hallucination risk
- `evals/benchmarks/` directory with README stub

### Fixed
- Replaced internal project key reference (`LIVE-123`) with generic `PROJ-123` in human-approval-gate pattern
- Replaced vendor-specific custom field IDs in graceful-degradation pattern and ADR-003 with generic descriptions

## [1.0.0] - 2026-03-10

### Added

**Skills (15)**
- `detect-stuck-tickets` — 4-layer detection: flagged, blocked, stale, silent
- `compute-velocity` — Sprint velocity with trend and predictability
- `detect-scope-change` — Scope additions/removals with impact classification
- `detect-ghost-done` — Tickets done but stuck in intermediate status
- `sprint-health-check` — Composite sprint assessment with RAG
- `assess-risk` — Likelihood x impact scoring with mitigation tracking
- `craft-escalation-memo` — Structured SITUATION/IMPACT/URGENCY/ASK memos
- `generate-sprint-report` — Full sprint report with velocity, blockers, recommendations
- `stakeholder-update` — Concise status update (< 1 page)
- `format-for-audience` — Tone and format adaptation for 5 audience types
- `assess-epic-readiness` — 7-dimension epic maturity scoring
- `compute-capacity` — Team capacity from headcount, PTO, and buffer
- `craft-unblock-message` — Question-first messages to unblock tickets
- `craft-close-message` — Evidence-based ghost-done close suggestions
- `self-check` — 5-check quality gate (every output)
- `evaluate-output` — 6-dimension deep evaluation (high-stakes outputs)

**Workflows (3)**
- Morning Scan — daily prioritized sprint briefing
- Sprint Close Report — end-of-sprint comprehensive report
- PI Readiness Review — pre-planning readiness assessment

**Patterns (5)**
- Orchestrator, Verifier, Confidence Calibration, Graceful Degradation, Human Approval Gate

**Adapters (2)**
- Cursor adapter with install script, rules, and agent definitions
- Claude Code adapter with CLAUDE.md and install script

**Evaluation**
- 3 rubrics (sprint report, risk assessment, escalation memo)
- 1 test case with known input/expected output
- Mock data (sprint data, team roster)

**Documentation**
- README, ARCHITECTURE.md, 4 ADRs, Getting Started, Skill Authoring Guide, CONTRIBUTING.md
