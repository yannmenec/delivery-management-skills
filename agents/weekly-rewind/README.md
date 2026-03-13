# 📊 Weekly Rewind

> Generates a client-ready weekly status report from your sprint data.

## The Problem

Delivery Managers spend 2+ hours every Friday compiling status updates from Jira, Slack, and GitHub into a client-ready report. They open three tools, cross-reference tickets against PRs, summarize decisions from Slack threads, compute sprint health metrics by hand, and format everything into prose that stakeholders can actually read. The Weekly Rewind does this in 30 seconds — it scans your completed tickets, in-progress work, blockers, key decisions, and PR activity to produce a narrative status report you can send to stakeholders with minimal editing.

## What You Get

A single-page weekly status report containing:

- **Highlights** — the 3 most important things that happened this week, in business language
- **Completed work** — items finished this sprint with story points and evidence
- **In Progress** — active work with risk flags for stale or blocked items
- **Risks & Blockers** — issues that need attention, with recommended actions
- **Key Decisions** — team decisions captured from Slack (when Slack data is provided)
- **Next Week Outlook** — what to expect in the coming week
- **Sprint Health** — progress percentage, story points, blocker count, overall status

## Quick Start

### Option A: Use Sample Data (2 minutes)

1. Open [`prompt.md`](prompt.md) and copy everything
2. Open [`examples/sample-input.json`](examples/sample-input.json) and copy the data
3. Go to any AI assistant — [Claude](https://claude.ai), [ChatGPT](https://chat.openai.com), [Gemini](https://gemini.google.com)
4. Paste the prompt first, then paste the data
5. Get your report

The sample data uses Project Mercury (a fictional payment platform migration) with 8 sprint tickets, 4 PRs, and 3 Slack decisions. Compare your output to [`examples/sample-output.md`](examples/sample-output.md).

### Option B: Use Your Own Data (10 minutes)

**Step 1 — Export Jira sprint data:**

Replace the sample JSON with your own Jira export. The minimum required fields per ticket are: `key`, `summary`, `status`, `story_points`, `type`, `priority`. See [`guides/export-your-data.md`](../../guides/export-your-data.md) for export instructions.

**Step 2 — (Optional) Add GitHub PRs and Slack decisions:**

Adding PR data enables stale PR detection and cross-referencing. Slack data enables the Key Decisions section.

**Step 3 — Run the report:**

Paste the prompt first, then paste your data into any AI assistant.

### Option C: Claude Code with MCP (L2)

With MCP configured, Claude Code can fetch your data automatically:

```bash
claude "Fetch the current sprint from Jira and run the weekly rewind"
```

Or use the built-in slash command with sample data:

```bash
claude /weekly-rewind
```

See [`guides/quickstart-claude-code.md`](../../guides/quickstart-claude-code.md) for full setup instructions.

> **L3 — Orchestrated (coming in H3):** Automated weekly reports via cron + Slack posting. The agent fetches fresh data from Jira/GitHub/Slack via MCP, generates the report, and posts it to your team's Slack channel every Friday at 4pm.

## Example Output

The following report was generated from the sample data in [`examples/sample-input.json`](examples/sample-input.json):

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

## How It Works

1. **Parse**: read Jira tickets, GitHub PRs, and Slack messages from the provided data
2. **Categorize**: group tickets by status (completed, in progress, blocked, to do)
3. **Cross-reference**: match PRs to tickets for evidence-based status and stale detection
4. **Analyze**: compute sprint health metrics, identify risks, flag scope changes
5. **Narrate**: produce a business-language report with highlights, risks, and next steps

## Configuration

See [`config.yaml`](config.yaml) for tunable parameters:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `tone` | `formal` | Report tone — `formal` for executives, `casual` for internal teams |
| `sprint_duration_days` | `10` | Used to calculate stale thresholds |
| `stale_threshold_days` | `3` | Days without PR activity before flagging as stale |
| `max_items_per_section` | `10` | Cap per section before summarizing |
| `sections.*` | all `true` | Toggle individual sections on/off |

## Limitations

- Context window limits may truncate reports for very large sprints (30+ tickets)
- Narrative quality varies by LLM — Claude and GPT-4 produce the most natural prose
- Accuracy depends entirely on input data quality — garbage in, garbage out
- Does not verify ticket status against code activity (use Watermelon Auditor for that)

## Related Agents

- [Morning Scan](../morning-scan/) — Daily standup preparation (complements weekly cadence)
- [Watermelon Auditor](../watermelon-auditor/) — Verifies reported status against GitHub activity
- [Blocker Detective](../blocker-detective/) — Surfaces stuck work before standup
