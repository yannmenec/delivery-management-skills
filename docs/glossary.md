# Glossary

Key terms used throughout the Delivery Management Skills library.

## Core Concepts

**Skill** — An atomic, reusable unit of delivery management intelligence. Implemented as a structured markdown file (SKILL.md) with metadata, method, and output format.

**Workflow** — A composition of multiple skills into an end-to-end process. Defines execution order, parallel steps, and data flow between skills.

**Adapter** — A thin translation layer that maps the tool-agnostic skill library into a specific AI tool's native format (e.g., Cursor's `.cursor/skills/`, Claude Code's `CLAUDE.md`).

**Pattern** — A reusable agentic design technique documented as a reference. Not executable — it describes how and why a technique works.

## Skill Types

**Detection** — Identifies conditions in the data (stuck tickets, scope changes, ghost-done). Produces findings.

**Computation** — Calculates metrics from data (velocity, capacity, risk scores). Produces numbers with sources.

**Generation** — Creates new content (reports, messages, memos). Produces text following a template.

**Evaluation** — Validates output quality (self-check, evaluate-output). Produces pass/fail verdicts.

**Workflow** — Orchestrates other skills into a multi-step process.

**Enrichment** — Pulls additional data from external sources. Optional enhancement for other skills.

## Autonomy Levels

**Autonomous** — The AI executes the skill and delivers output without approval. Used for safe, read-only operations (compute-velocity, self-check).

**Supervised** — The AI executes and presents output for review. The human decides what to do with it. Used for reports and assessments.

**Human-in-the-loop** — The AI generates a draft but the human must explicitly approve before any external action. Used for messages that will be posted (craft-unblock-message, craft-escalation-memo).

## Quality Concepts

**RAG Status** — Red / Amber / Green assessment of delivery health. Red = off track, Amber = at risk, Green = on track. Must always be justified with specific data.

**Confidence Level** — High / Medium / Low assessment of output reliability based on data completeness. High (>90% data), Medium (70-90%), Low (<70%).

**Self-check** — Lightweight 5-check quality gate that runs on every output: numbers cited, no empty sections, evidence referenced, confidence stated, actionable recommendations.

**Evaluate-output** — Thorough 6-dimension quality evaluation for high-stakes outputs: numeric consistency, RAG alignment, template completeness, tone match, cross-reference consistency, guardrails compliance.

## Sprint Concepts

**Stuck ticket** — A ticket that is not progressing. Detected via 4 layers: flagged impediment, explicitly blocked, stale (same status 3+ days), silent (no activity 3+ days).

**Ghost-done** — A ticket that appears to be completed (PR merged, deployed) but remains in an intermediate status (In Progress, In Review). Distorts sprint metrics.

**Scope change** — Tickets added to or removed from a sprint after the sprint starts. Measured as percentage of original commitment.

**Velocity** — Story points completed per sprint. Used for trend analysis and capacity forecasting.

**Predictability** — How consistently a team delivers against their commitment. Calculated as 1 - (standard deviation / average velocity).
