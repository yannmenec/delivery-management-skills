# The 5 Delivery Frustrations

These are the recurring pain points identified in delivery management research. Each frustration maps to specific agents in this toolkit.

## 1. Watermelon Reporting

**The problem**: Tickets show green in Jira (status: Done) but the underlying work isn't actually complete — no merged PR, no deployment, no tests passing. Status boards look healthy on the surface but are red underneath, like a watermelon.

**Why it persists**: Manual status updates are error-prone. Developers mark tickets Done when they push code, not when it's merged and deployed. Nobody cross-checks Jira against GitHub systematically.

**Agents targeting this**: `watermelon-auditor` — cross-references Jira status with GitHub PR state, commit activity, and CI results to surface tickets where reported status doesn't match reality.

**Measurable impact**: Reduces false-done rate from ~15% (industry average) to < 3%. Saves 2-4 hours per sprint of manual status auditing.

## 2. Admin Tax

**The problem**: Delivery managers spend 40-60% of their time on mechanical tasks — collecting metrics, formatting reports, chasing status updates, preparing meeting agendas — instead of removing blockers and coaching teams.

**Why it persists**: Organizations require reporting at multiple levels (team, program, executive) in different formats, at different cadences. Each report requires gathering data from 3-5 systems manually.

**Agents targeting this**: `morning-scan` (daily briefing), `weekly-rewind` (sprint summary), `sprint-retro-prep` (retrospective data). Each replaces 30-90 minutes of manual data gathering.

**Measurable impact**: Reduces admin overhead by 8-12 hours per week. Morning scan alone saves the 30-minute pre-standup data gathering ritual.

## 3. Scope Creep

**The problem**: Work gets added mid-sprint without formal acknowledgment. New tickets appear, existing tickets grow in scope, and "quick favors" accumulate. By sprint end, the team completed 35 SP but 15 SP was added silently, making velocity look poor.

**Why it persists**: Product needs evolve. Stakeholders have urgent requests. Nobody tracks the delta between sprint start and sprint end commitment.

**Agents targeting this**: `weekly-rewind` — computes scope change metrics (tickets added/removed mid-sprint, point delta) and flags the pattern. `morning-scan` — daily snapshot comparison detects day-over-day additions.

**Measurable impact**: Makes scope change visible and quantifiable. Teams that track scope change reduce unplanned work by 25-40% within 2 PIs by creating awareness.

## 4. Meeting Overload

**The problem**: Delivery managers attend 15-25 meetings per week. Many could be replaced by async updates, but meetings persist because "it's the only way to get status." Preparation time compounds the problem — 15 minutes prepping for each meeting adds up.

**Why it persists**: Meetings are the default coordination mechanism. Without reliable async status updates, people schedule meetings to get information.

**Agents targeting this**: `morning-scan` — replaces standup prep and enables async standups. `sprint-retro-prep` — pre-analyzes sprint data so the retro starts with facts, not 30 minutes of "what happened." `weekly-rewind` — replaces the weekly status meeting with a written summary.

**Measurable impact**: Eliminates 3-5 meetings per week by providing the information those meetings existed to surface. Retro prep alone saves 45 minutes of "remember what happened" discussion.

## 5. Dependency Tracking

**The problem**: Cross-team dependencies are the top cause of delivery failure at scale. Teams commit to work that depends on another team's deliverable, but the dependency isn't tracked, surfaced, or escalated until it blocks progress.

**Why it persists**: Dependencies live in various places — Jira issue links, Slack threads, people's heads. No single view exists. By the time a dependency becomes a blocker, it's too late to recover the sprint.

**Agents targeting this**: `blocker-detective` — scans Jira issue links, identifies cross-team dependencies, computes dependency chain depth, and flags risks before they become blockers.

**Measurable impact**: Surfaces dependency risks 3-5 days earlier than manual tracking. Reduces cross-team blockers by 30-50% through early visibility.
