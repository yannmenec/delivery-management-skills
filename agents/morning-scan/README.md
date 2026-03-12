# Morning Scan

> Surfaces blockers and priorities before standup — replacing your 20-minute morning triage ritual.

## What It Does

The Morning Scan prepares a 2-minute briefing that tells a Delivery Manager the 3-5 things they need to know before their first meeting. It checks blocked tickets, failing CI, stale PRs, team workload, and overnight changes — so you don't have to open Jira, GitHub, and Slack separately every morning. Blockers surface first, context follows.

## Quick Start

### Level 1 — Paste (any AI tool, 2 minutes)

1. Copy the entire contents of [`prompt.md`](prompt.md)
2. Copy the sample data from [`examples/input-sample.json`](examples/input-sample.json)
3. Open any AI assistant — [Claude](https://claude.ai), [ChatGPT](https://chat.openai.com), [Gemini](https://gemini.google.com), or GitHub Copilot
4. Paste the prompt first, then paste the data on the next line
5. Read your morning briefing

**Try it now with sample data:**

```
1. Open prompt.md in this directory and copy everything
2. Open examples/input-sample.json and copy everything
3. Go to https://claude.ai (or any AI chat)
4. Paste the prompt, press Enter
5. Paste the JSON data, press Enter
6. You'll get a briefing like the one in examples/output-sample.md
```

**Using your own data instead of the sample:**

Replace the sample JSON with your own exports. The Morning Scan works best with all four data sources (Jira, GitHub PRs, CI builds, commits), but even Jira data alone produces a useful briefing. See [`guides/export-your-data.md`](../../guides/export-your-data.md) for export instructions.

### Level 2 — Connected (Claude Code + MCP)

With MCP configured, Claude Code can fetch fresh data automatically each morning:

```bash
# One-time setup: configure MCP servers (see mcp/README.md)
# Then run:
claude "Fetch today's sprint data and run the morning scan"
```

Or use the built-in slash command with sample data:

```bash
claude /morning-scan
```

See [`guides/quickstart-claude-code.md`](../../guides/quickstart-claude-code.md) for full setup instructions.

### Level 3 — Orchestrated (Automated)

> Coming in H3

Automated morning briefings posted to Slack at 8:30am every workday. The agent fetches fresh data from Jira/GitHub/Slack/CI via MCP, generates the scan, and posts to your team channel before standup.

## Example Output

The following briefing was generated from the sample data in [`examples/input-sample.json`](examples/input-sample.json):

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

## Configuration

See [`config.yaml`](config.yaml) for tunable parameters:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `stale_pr_hours` | `48` | Hours without review before flagging a PR |
| `overload_threshold` | `5` | Active tickets per dev before flagging as overloaded |
| `idle_threshold` | `1` | Active tickets below which a dev is flagged as idle |
| `ci_failure_threshold` | `2` | Consecutive CI failures before flagging a branch |
| `overnight_window_hours` | `16` | How far back to look for overnight changes |
