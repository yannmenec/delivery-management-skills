# Weekly Rewind

> Generates a client-ready weekly status report from your sprint data.

## What It Does

The Weekly Rewind scans your completed tickets, in-progress work, blockers, key decisions, and PR activity to produce a narrative status report that a Delivery Manager can send to stakeholders with minimal editing. It categorizes completed work, surfaces risks before they become surprises, and computes sprint health metrics — turning 2 hours of Friday report-writing into 30 seconds of AI processing.

## Quick Start

### Level 1 — Paste (any AI tool, 2 minutes)

1. Copy the entire contents of [`prompt.md`](prompt.md)
2. Copy the sample data from [`examples/input-sample.json`](examples/input-sample.json)
3. Open any AI assistant — [Claude](https://claude.ai), [ChatGPT](https://chat.openai.com), [Gemini](https://gemini.google.com), or GitHub Copilot
4. Paste the prompt first, then paste the data on the next line
5. Read your report

**Try it now with sample data:**

```
1. Open prompt.md in this directory and copy everything
2. Open examples/input-sample.json and copy everything
3. Go to https://claude.ai (or any AI chat)
4. Paste the prompt, press Enter
5. Paste the JSON data, press Enter
6. You'll get a report like the one in examples/output-sample.md
```

**Using your own data instead of the sample:**

Replace the sample JSON with your own Jira export. The minimum required fields per ticket are: `key`, `summary`, `status`, `story_points`, `type`, `priority`. See [`guides/export-your-data.md`](../../guides/export-your-data.md) for export instructions.

### Level 2 — Connected (Claude Code + MCP)

With MCP configured, Claude Code can fetch your data automatically:

```bash
# One-time setup: configure MCP servers (see mcp/README.md)
# Then run:
claude "Fetch the current sprint from Jira and run the weekly rewind"
```

Or use the built-in slash command with sample data:

```bash
claude /weekly-rewind
```

See [`guides/quickstart-claude-code.md`](../../guides/quickstart-claude-code.md) for full setup instructions.

### Level 3 — Orchestrated (Automated)

> Coming in H3

Automated weekly reports via cron + Slack posting. The agent fetches fresh data from Jira/GitHub/Slack via MCP, generates the report, and posts it to your team's Slack channel every Friday at 4pm.

## Example Output

The following report was generated from the sample data in [`examples/input-sample.json`](examples/input-sample.json):

---

## Weekly Status Report — Sprint 42, Week of March 10, 2026

### Highlights

- **Payment gateway SDK v3 integration complete** — the foundation for the entire migration is now merged and passing CI with 88% coverage. All downstream work (webhooks, reconciliation) can build on this.
- **Real-time payment status webhooks deployed** — clients can now receive payment lifecycle notifications, removing a top-3 feature request from the backlog.
- **Transaction reliability improved** — exponential backoff retry logic is in production, reducing failed transaction rates for intermittent gateway errors.

### Completed (4 items, 16 story points)

**Features**
- **MERC-220**: Payment gateway SDK v3 client — core migration foundation enabling all v3 payment processing (PR #143 merged, 88% coverage)
- **MERC-222**: Retry logic for failed transactions — adds exponential backoff with dead letter queue for unrecoverable failures
- **MERC-225**: Transaction audit logging — structured audit trail for all payment operations, supporting upcoming compliance audit
- **MERC-228**: Payment status webhook endpoint — real-time payment lifecycle notifications for client integrations (PR #153 merged)

### In Progress (2 items)

- **MERC-231**: Payment reconciliation dashboard — 8 SP, approved and nearing completion. Client demo feedback incorporated (highlight amounts > $1000). On track for completion next week.
- **MERC-226**: Payment error handling refactor — 3 SP, **at risk** — PR #141 has been open since March 8 with zero code reviews. Last update was 4 days ago. Needs reviewer assignment.

### Risks & Blockers

- **MERC-229**: Fraud detection API integration (Critical, 5 SP) — blocked by external vendor FraudShield, who pushed sandbox availability to March 24. This also blocks downstream ticket MERC-238 (gateway v3 integration tests). — **Action needed**: Escalate with vendor for interim sandbox access or mock API; reassess sprint commitment for this item.
- **MERC-226**: Error handling refactor — PR #141 open for 4+ days with no reviews. Developer Marcus has 3 other active tickets. — **Action needed**: Assign a reviewer (Sarah or Tom) to unblock this PR before end of week.
- **MERC-237**: Currency conversion support (High, 5 SP) — added mid-sprint per client request, blocked by MERC-234 (batch processor). Sprint is now over-committed at 37 SP against a 35 SP velocity. — **Action needed**: Confirm with Product whether this can defer to Sprint 43 if batch processor work slips.

### Key Decisions

- **SDK v3 direct integration** (March 4, Sarah): Team decided to use the new gateway SDK v3 directly rather than wrapping v2. The v3 SDK's native webhook support eliminates the need for a custom webhook adapter — slightly increased MERC-220 scope but saves rework on MERC-232 downstream.

### Next Week Outlook

The reconciliation dashboard (MERC-231) should merge early next week once final UI tweaks land. The error handling refactor (MERC-226) needs a reviewer urgently — if unblocked, it can close within a day. The fraud detection integration (MERC-229) will remain blocked until March 24 unless the vendor provides early access. Currency conversion (MERC-237) is unlikely to start this sprint given its dependency on the batch processor.

### Sprint Health

- Progress: 4/8 items (50%)
- Story Points: 16/37 (43%)
- Blockers: 2 (1 external vendor, 1 internal dependency)
- Overall: **At Risk** — mid-sprint completion is on target, but over-commitment (37 SP vs 35 SP velocity) and the external vendor blocker create delivery risk for the remaining items.

---

## Configuration

See [`config.yaml`](config.yaml) for tunable parameters:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `tone` | `formal` | Report tone — `formal` for executives, `casual` for internal teams |
| `sprint_duration_days` | `10` | Used to calculate stale thresholds |
| `stale_threshold_days` | `3` | Days without PR activity before flagging as stale |
| `max_items_per_section` | `10` | Cap per section before summarizing |
| `sections.*` | all `true` | Toggle individual sections on/off |
