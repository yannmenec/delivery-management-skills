# Changelog

All notable changes to Delivery Management Skills are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-03-10

### Added
- 5 new agentic pattern documents: planner-executor-reviewer, memory-and-state, progressive-enhancement, evaluator-optimizer, control-plane
- Anti-patterns section in orchestrator pattern
- Calibration tracking section in confidence-calibration pattern
- Circuit breaker section in graceful-degradation pattern
- Pattern table in README expanded from 5 to 10 entries

## [1.1.0] - 2026-03-10

### Added
- Chain of Verification (CoVe) phases in `generate-sprint-report`, `stakeholder-update`, and `assess-risk`
- Self-consistency notes in `assess-risk` and `assess-epic-readiness` for ambiguous scoring
- Anti-pattern sections in `generate-sprint-report`, `stakeholder-update`, `craft-escalation-memo`, and `format-for-audience`
- Prompt injection hardening in `self-check` and `evaluate-output` (Input Safety sections)

## [1.0.3] - 2026-03-10

### Added
- Cursor adapter: workflow symlinks in `install.sh`
- Cursor adapter: `uninstall.sh` to cleanly remove symlinks
- Claude Code adapter: mock data symlink (`delivery-skills/mock/`)
- Smoke test checklists in both adapter READMEs

### Fixed
- Claude Code `install.sh`: idempotent re-runs (marker-based duplicate detection)
- Demo scenario paths: use repo-relative `integrations/mock/` for Claude Code examples

## [1.0.2] - 2026-03-10

### Changed
- Replace vendor-specific format names in `format-for-audience` (Slack → Team Chat, Confluence → Wiki)
- Replace tracker-specific language in `detect-stuck-tickets` and `evaluate-output` with generic terms
- Use generic tool names in `skill.schema.json` examples (project-tracker, version-control, team-chat)
- Add skill definition and glossary link to Getting Started guide
- Add Bash/WSL prerequisite note to Getting Started and install scripts
- Use cross-platform keyboard shortcuts in documentation

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
