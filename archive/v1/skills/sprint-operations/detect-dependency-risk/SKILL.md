---
name: detect-dependency-risk
version: 1.0.0
description: >
  Detects cross-team and external dependency risks by analyzing issue links.
  Classifies risk by blocking ticket status, days to sprint end, and story
  points at stake. Surfaces risks before they cascade.
category: sprint-operations
trigger: Sprint health check, morning scan, mid-sprint checkpoint, dependency review, PI planning
autonomy: supervised
portability: universal
complexity: intermediate
type: detection
inputs:
  - name: sprint_tickets
    type: structured-text
    required: true
    description: >
      List of tickets in the active sprint. Each ticket must include: key,
      summary, status, assignee, priority, story_points, linked_issues.
      linked_issues should include: type ("blocks", "is blocked by"),
      key, status, and optionally team (owning team name).
  - name: sprint_context
    type: structured-text
    required: true
    description: >
      Sprint metadata: name, start_date, end_date, days_remaining.
      Used for urgency classification.
  - name: team_name
    type: text
    required: false
    description: >
      The name of the team whose sprint is being analyzed. Used to
      distinguish cross-team from intra-team dependencies. If not
      provided, all "blocks"/"is blocked by" links are analyzed.
outputs:
  - name: dependency_risks
    type: structured-text
    description: >
      Prioritized list of dependency risks with blocking ticket, blocked
      ticket, teams involved, risk level, and recommended action.
  - name: summary
    type: text
    description: >
      One-paragraph summary: count of at-risk dependencies, total SP
      exposed, highest-risk items.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Detect Dependency Risk

Analyzes issue links in sprint tickets to identify dependencies that could block delivery. Focuses on cross-team and external dependencies where the blocking ticket is not yet complete. Produces a risk-ranked dependency table with recommended actions.

## When to Use

- Daily sprint scan (to catch new dependency risks early)
- Mid-sprint checkpoints (to assess delivery risk from dependencies)
- Sprint planning (to identify dependency risks before committing)
- Cross-team synchronization meetings
- PI-level dependency reviews

## What Is a Dependency Risk?

A dependency risk exists when a sprint ticket depends on another ticket (via `blocks` or `is blocked by` links) and the blocking ticket is **not yet in a terminal status** (Done, Closed). The risk level depends on:

1. **Blocking ticket status**: Is it not started, in progress, or itself blocked?
2. **Days remaining in sprint**: How much time is left for the dependency to resolve?
3. **Story points at stake**: How much work is blocked downstream?
4. **Cross-team vs intra-team**: Cross-team dependencies carry higher risk due to coordination overhead.

## Method

### Step 1: Extract all dependency links

Scan all `linked_issues` across sprint tickets. Collect links where:
- `type` is `"blocks"` or `"is blocked by"`

For each link, record:
- **Blocking ticket**: the ticket that must complete first
- **Blocked ticket**: the ticket waiting on the blocker
- **Blocker status**: current status of the blocking ticket
- **Blocker team**: team owning the blocking ticket (from `team` field, or inferred from ticket key prefix)

Normalize direction: if ticket A `blocks` ticket B, then A is the blocker and B is the blocked ticket. If ticket C `is blocked by` ticket D, then D is the blocker and C is the blocked ticket.

### Step 2: Filter to active risks

Exclude dependencies where:
- The blocking ticket is already Done or Closed (resolved dependency)
- Both tickets are in the same sprint and assigned to the same person (personal sequencing, not a team risk)

### Step 3: Classify dependency type

| Classification | Criteria |
|---------------|---------|
| **External** | Blocking ticket belongs to a different team (different `team` field or different key prefix) |
| **Intra-team** | Both tickets belong to the same team |
| **Cascading** | The blocking ticket is itself blocked by another ticket (dependency chain) |

### Step 4: Score risk level

For each active dependency, compute risk based on:

| Factor | Low (1) | Medium (2) | High (3) |
|--------|---------|-----------|---------|
| Blocker status | In Progress / In Review | To Do | Blocked |
| Days remaining | > 5 days | 3-5 days | < 3 days |
| SP at stake | < 5 SP | 5-8 SP | > 8 SP |
| Dependency type | Intra-team | External | Cascading |

**Risk score** = sum of the four factor scores (4-12 range).

| Risk Score | Risk Level | RAG |
|-----------|-----------|-----|
| 4-5 | Low | Green |
| 6-7 | Medium | Amber |
| 8-9 | High | Red |
| 10-12 | Critical | Red (escalate) |

### Step 5: Determine recommended action

| Risk Level | Recommended Action |
|-----------|-------------------|
| Low | Monitor — dependency is progressing normally |
| Medium | Check in with blocker owner — confirm ETA and communicate to blocked team |
| High | Escalate to both team leads — establish daily sync on the blocking item |
| Critical | Escalate to management — prepare contingency plan (descope, workaround, or re-sequence) |

For cross-team dependencies, always recommend explicit communication regardless of risk level.

### Step 6: Detect dependency chains

If a blocking ticket is itself blocked by another ticket, flag the chain:
- Example: PLAT-100 blocks HRZ-200, but PLAT-100 is blocked by INFRA-50
- Chain: INFRA-50 → PLAT-100 → HRZ-200
- Risk level: automatically High or Critical (cascading factor = 3)

### Step 7: Compile summary

Count total dependency risks by level. Sum story points exposed. Identify the highest-risk dependency for the executive summary.

## Output Format

```
## Dependency Risks: {count} active dependencies

**Summary**: {count} dependency risks found, {critical_count} critical, {high_count} high.
{total_sp} SP at risk from unresolved dependencies with {days_remaining} days remaining.

---

### DEP-{N}: [{blocked_key}] blocked by [{blocker_key}]

- **Blocked ticket**: {blocked_key} — {blocked_summary} ({blocked_sp} SP, {blocked_status})
- **Blocking ticket**: {blocker_key} — {blocker_summary} ({blocker_status})
- **Blocker team**: {team_name or "same team"}
- **Dependency type**: {External | Intra-team | Cascading}
- **Risk level**: {Low | Medium | High | Critical} (score: {N}/12)

**Risk factors**:
- Blocker status: {status} ({score}/3)
- Days remaining: {days} ({score}/3)
- SP at stake: {sp} ({score}/3)
- Type: {type} ({score}/3)

{If cascading: "**Chain**: {chain description}"}

**Recommended Action**: {action from Step 5}

---

### Dependency Risk Summary

| Risk Level | Count | SP Exposed |
|-----------|-------|-----------|
| Critical | {N} | {SP} |
| High | {N} | {SP} |
| Medium | {N} | {SP} |
| Low | {N} | {SP} |

**Confidence**: {High | Medium | Low} — {justification}
```

## Error Handling

- **No linked_issues on any ticket**: Report "No dependency links found in sprint data. Dependency risk detection requires `linked_issues` with `blocks` / `is blocked by` link types." Do not fabricate dependencies.
- **No blocking dependencies (all resolved or no links)**: Report "No active dependency risks — all linked blockers are resolved." This is a positive outcome.
- **Missing team data**: Cannot classify as cross-team vs intra-team. Treat all as "unknown team" and note: "Team ownership data unavailable — all dependencies treated as potential cross-team risks."
- **Blocker ticket not in sprint**: This is normal for cross-team dependencies. Use the blocker's status from the link data. Note if the status may be stale: "Blocker status from link data — verify current status with owning team."
- **Circular dependencies**: If A blocks B and B blocks A, flag as: "Circular dependency detected between {A} and {B} — requires manual resolution." Classify as Critical.
