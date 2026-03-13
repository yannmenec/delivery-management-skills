# 🌅 Morning Scan

> Surfaces blockers and priorities before standup — replacing your 20-minute morning triage ritual.

## The Problem

Every morning, a Delivery Manager opens Jira, GitHub, and Slack separately, scanning for blocked tickets, failing CI, stale PRs, and overnight changes — just to figure out the 3-5 things they need to know before standup. This manual triage takes 20+ minutes and is easy to miss things. The Morning Scan prepares a 2-minute briefing that tells you what needs attention, who's overloaded, and what changed overnight — so you walk into standup already informed.

## What You Get

A pre-standup briefing containing:

- **Needs Attention Now** — blocked tickets, failing CI, stale PRs requiring immediate action
- **Overnight Changes** — PRs merged, commits pushed, and progress made since yesterday
- **Today's Focus** — prioritized list of in-flight items with status and risk level
- **Team Load** — per-developer ticket count and workload status
- **Build Health** — CI pass rate, failing branches, persistent test failures

## Quick Start

### Option A: Use Sample Data (2 minutes)

1. Open [`prompt.md`](prompt.md) and copy everything
2. Open [`examples/sample-input.json`](examples/sample-input.json) and copy the data
3. Go to any AI assistant — [Claude](https://claude.ai), [ChatGPT](https://chat.openai.com), [Gemini](https://gemini.google.com)
4. Paste the prompt first, then paste the data
5. Get your morning briefing

The sample data uses Project Mercury (a fictional payment platform migration) with 10 sprint tickets, 5 PRs, 7 CI builds, and 5 commits. Compare your output to [`examples/sample-output.md`](examples/sample-output.md).

### Option B: Use Your Own Data (10 minutes)

**Step 1 — Export Jira sprint data:**

Replace the sample JSON with your own Jira export. The Morning Scan works best with all four data sources (Jira, GitHub PRs, CI builds, commits), but even Jira data alone produces a useful briefing. See [`guides/export-your-data.md`](../../guides/export-your-data.md) for export instructions.

**Step 2 — (Optional) Add GitHub, CI, and commit data:**

Adding PR data enables stale PR detection. CI data enables the Build Health section. Commit data enables overnight activity tracking.

**Step 3 — Run the scan:**

Paste the prompt first, then paste your data into any AI assistant.

### Option C: Claude Code with MCP (L2)

With MCP configured, Claude Code can fetch fresh data automatically each morning:

```bash
claude "Fetch today's sprint data and run the morning scan"
```

Or use the built-in slash command with sample data:

```bash
claude /morning-scan
```

See [`guides/quickstart-claude-code.md`](../../guides/quickstart-claude-code.md) for full setup instructions.

> **L3 — Orchestrated (coming in H3):** Automated morning briefings posted to Slack at 8:30am every workday. The agent fetches fresh data from Jira/GitHub/Slack/CI via MCP, generates the scan, and posts to your team channel before standup.

## Example Output

The following briefing was generated from the sample data in [`examples/sample-input.json`](examples/sample-input.json):

---

## Morning Scan — March 12, 2026

**Read time: ~2 minutes**

### Needs Attention Now (3)

- **MERC-229**: Fraud detection integration (Critical, 5 SP) — blocked by external vendor FraudShield (sandbox delayed to March 24). Also blocks MERC-238 downstream. — Escalate with vendor for interim access or plan mock API workaround.
- **PR #150 / MERC-234**: Batch payment processor — 4 consecutive CI failures. Failing tests: `test_batch_size_validation`, `test_concurrent_batch_processing`. Coverage dropped to 74.9%. Marcus pushed a race condition fix at 13:00 but CI still failing. — Review test failures with Marcus before standup; may need pair debugging.
- **PR #141 / MERC-226**: Error handling refactor — open since March 8 with zero code reviews (4 days stale). PR #145 (MERC-233, settlement reports) also has no reviews since March 9. Both are Marcus's. — Assign reviewers to both PRs today; suggest Sarah or Tom.

### Overnight Changes

- PR #153 merged by Marcus — payment status webhook endpoint (MERC-228) is complete
- PR #147 merged by Kenji — transaction audit logging (MERC-225) is complete, 88% coverage
- Sarah committed webhook payload transformation for MERC-230
- Priya committed reconciliation summary view for MERC-231
- Marcus pushed 2 fixes for the batch processor (MERC-234) attempting to resolve CI failures

### Today's Focus

1. **MERC-230**: Webhook migration (High, 5 SP) — Sarah, on track. Blocks MERC-235 (monitoring alerts). Active commits today, CI passing.
2. **MERC-234**: Batch processor (High, 5 SP) — Marcus, at risk. CI failing since yesterday. Blocks MERC-237 (currency conversion). Needs test fixes before review can proceed.
3. **MERC-231**: Reconciliation dashboard (High, 8 SP) — Priya, on track. Active commits, CI passing. Largest remaining item by story points.
4. **MERC-233**: Settlement report migration (High, 5 SP) — Marcus, stale. Last updated March 9, PR #145 has no reviews. Needs attention.
5. **MERC-226**: Error handling refactor (Medium, 3 SP) — Marcus, stale. PR #141 waiting 4 days for review.

### Team Load

| Developer | Active | In Review | Status |
|-----------|--------|-----------|--------|
| Marcus    | 4      | 1         | Heavy — 3 In Progress + 1 To Do, 2 PRs awaiting review |
| Sarah     | 1      | 0         | OK (also has 1 Blocked ticket) |
| Priya     | 1      | 0         | OK |
| Kenji     | 0      | 0         | Idle — audit logging merged, monitoring alerts blocked by MERC-230 |

### Build Health

- CI pass rate: 43% (3/7 builds passing)
- Failing branches: `feat/MERC-234-batch-processor` — 4 consecutive failures, coverage at 74.9% (below 80% threshold)
- Persistent failing tests: `test_batch_size_validation`, `test_concurrent_batch_processing`

---
*Generated from Jira, GitHub PRs, CI builds, and commit data. Paste fresher data anytime for an updated scan.*

---

## How It Works

1. **Parse**: read Jira tickets, GitHub PRs, CI builds, and commit data from the provided input
2. **Triage**: identify blocked tickets, failing CI, stale PRs, and idle developers
3. **Prioritize**: rank items by severity — blockers first, then at-risk, then on-track
4. **Map load**: count active tickets per developer and flag overload or idle states
5. **Report**: produce a 2-minute briefing with immediate actions, priorities, and team status

## Configuration

See [`config.yaml`](config.yaml) for tunable parameters:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `stale_pr_hours` | `48` | Hours without review before flagging a PR |
| `overload_threshold` | `5` | Active tickets per dev before flagging as overloaded |
| `idle_threshold` | `1` | Active tickets below which a dev is flagged as idle |
| `ci_failure_threshold` | `2` | Consecutive CI failures before flagging a branch |
| `overnight_window_hours` | `16` | How far back to look for overnight changes |

## Limitations

- Best results with all 5 data sources; useful but less comprehensive with Jira alone
- Stale PR detection depends on accurate timestamps in exported data
- Does not detect blockers communicated only in Slack threads (use full Slack export for partial coverage)
- Team load calculation counts tickets, not effort — a developer with 2 large items may be more loaded than one with 4 small items

## Related Agents

- [Weekly Rewind](../weekly-rewind/) — Weekly client reports (uses similar data, different cadence)
- [Watermelon Auditor](../watermelon-auditor/) — Trust verification of reported status
- [Blocker Detective](../blocker-detective/) — Deeper blocker analysis with standup agenda
