# Delivery Management Skills

**AI agents that automate the painful parts of delivery management.**

Stop spending your Friday afternoons compiling status reports. Stop discovering blockers at standup when it's too late. Stop trusting dashboards that say "everything is green" when it isn't.

This toolkit gives you ready-to-use AI agents that work with any AI assistant — Claude, ChatGPT, Gemini, Copilot — no coding required.

---

## See It In Action (2 minutes)

Here's what the **Weekly Rewind** agent produces from raw sprint data:

---

### Weekly Status Report — Sprint 42, Week of March 10, 2026

#### Highlights

- **Payment gateway SDK v3 integration complete** — the foundation for the entire migration is now merged and passing CI with 88% coverage. All downstream work (webhooks, reconciliation) can build on this.
- **Real-time payment status webhooks deployed** — clients can now receive payment lifecycle notifications, removing a top-3 feature request from the backlog.
- **Transaction reliability improved** — exponential backoff retry logic is in production, reducing failed transaction rates for intermittent gateway errors.

#### Completed (4 items, 16 story points)

**Features**
- **MERC-220**: Payment gateway SDK v3 client — core migration foundation enabling all v3 payment processing (PR #143 merged, 88% coverage)
- **MERC-222**: Retry logic for failed transactions — adds exponential backoff with dead letter queue for unrecoverable failures
- **MERC-225**: Transaction audit logging — structured audit trail for all payment operations, supporting upcoming compliance audit
- **MERC-228**: Payment status webhook endpoint — real-time payment lifecycle notifications for client integrations (PR #153 merged)

#### In Progress (2 items)

- **MERC-231**: Payment reconciliation dashboard — 8 SP, approved and nearing completion. Client demo feedback incorporated (highlight amounts > $1000). On track for completion next week.
- **MERC-226**: Payment error handling refactor — 3 SP, **at risk** — PR #141 has been open since March 8 with zero code reviews. Last update was 4 days ago. Needs reviewer assignment.

#### Risks & Blockers

- **MERC-229**: Fraud detection API integration (Critical, 5 SP) — blocked by external vendor FraudShield, who pushed sandbox availability to March 24. This also blocks downstream ticket MERC-238 (gateway v3 integration tests). — **Action needed**: Escalate with vendor for interim sandbox access or mock API; reassess sprint commitment for this item.
- **MERC-226**: Error handling refactor — PR #141 open for 4+ days with no reviews. Developer Marcus has 3 other active tickets. — **Action needed**: Assign a reviewer (Sarah or Tom) to unblock this PR before end of week.
- **MERC-237**: Currency conversion support (High, 5 SP) — added mid-sprint per client request, blocked by MERC-234 (batch processor). Sprint is now over-committed at 37 SP against a 35 SP velocity. — **Action needed**: Confirm with Product whether this can defer to Sprint 43 if batch processor work slips.

#### Key Decisions

- **SDK v3 direct integration** (March 4, Sarah): Team decided to use the new gateway SDK v3 directly rather than wrapping v2. The v3 SDK's native webhook support eliminates the need for a custom webhook adapter — slightly increased MERC-220 scope but saves rework on MERC-232 downstream.

#### Next Week Outlook

The reconciliation dashboard (MERC-231) should merge early next week once final UI tweaks land. The error handling refactor (MERC-226) needs a reviewer urgently — if unblocked, it can close within a day. The fraud detection integration (MERC-229) will remain blocked until March 24 unless the vendor provides early access. Currency conversion (MERC-237) is unlikely to start this sprint given its dependency on the batch processor.

#### Sprint Health

- Progress: 4/8 items (50%)
- Story Points: 16/37 (43%)
- Blockers: 2 (1 external vendor, 1 internal dependency)
- Overall: **At Risk** — mid-sprint completion is on target, but over-commitment (37 SP vs 35 SP velocity) and the external vendor blocker create delivery risk for the remaining items.

---

**That took 30 seconds.** The manual version takes 2 hours every Friday.

---

## Quick Start (5 minutes)

### Option A: Any AI Tool (no setup)

1. Copy the agent prompt from [`agents/weekly-rewind/prompt.md`](agents/weekly-rewind/prompt.md)
2. Copy the sample data from [`agents/weekly-rewind/examples/input-sample.json`](agents/weekly-rewind/examples/input-sample.json)
3. Paste both into [Claude](https://claude.ai), [ChatGPT](https://chat.openai.com), or any AI assistant
4. Get your report

### Option B: Claude Projects (recommended for non-devs)

1. Create a new [Claude Project](https://claude.ai)
2. Upload the agent prompt files as Project Knowledge
3. Paste your data (or use the sample) in the chat
4. Ask: "Run the weekly rewind on this sprint data"

Full guide: [`guides/quickstart-claude-projects.md`](guides/quickstart-claude-projects.md)

### Option C: Claude Code (for devs)

```bash
# Clone the repo
git clone https://github.com/your-org/delivery-management-skills.git
cd delivery-management-skills

# Run an agent with sample data
claude /weekly-rewind
```

Full guide: [`guides/quickstart-claude-code.md`](guides/quickstart-claude-code.md)

---

## Available Agents

| Agent | What It Does | Frequency | Time Saved |
|-------|-------------|-----------|------------|
| [**Weekly Rewind**](agents/weekly-rewind/) | Generates client-ready weekly status reports | Weekly | ~2h/week |
| [**Morning Scan**](agents/morning-scan/) | Surfaces blockers and priorities before standup | Daily | ~20min/day |
| [**Watermelon Auditor**](agents/watermelon-auditor/) | Verifies Jira status against actual code activity | Per sprint | Trust in data |
| [**Blocker Detective**](agents/blocker-detective/) | Detects stuck PRs, failing CI, overloaded devs | Daily | Early warning |
| [**Sprint Retro Prep**](agents/sprint-retro-prep/) | Pre-populates retrospectives with sprint facts | Per sprint | Better retros |

Agents without a linked README are planned for future horizons.

---

## How It Works

Every agent is a **portable prompt** — a carefully written instruction set that works with any modern AI. No installation. No API keys. No framework dependencies.

**Three levels of usage:**

| Level | For | How | Setup |
|-------|-----|-----|-------|
| **L1 — Paste** | Anyone | Copy prompt + paste data into any AI chat | None |
| **L2 — Connected** | Claude Code users | MCP pulls data from Jira/GitHub/Slack | One-time config |
| **L3 — Orchestrated** | Platform teams | Agents chain together, post to Slack | MCP + scheduling |

Lower levels are never gated behind higher ones. L1 works everywhere, today.

Architecture details: [`STRATEGY.md`](STRATEGY.md)

---

## Using Your Own Data

These agents work with sample data out of the box, but they're designed for your real projects.

[`guides/export-your-data.md`](guides/export-your-data.md) — How to export from Jira, GitHub, and Slack

---

## Contributing

We welcome new agents that target real delivery pain points. Before building:

1. Write a Problem Card (which frustration? which roles? what data?)
2. Build L1 first (paste mode)
3. Test on sample data
4. Keep it portable (2+ LLMs)

Full guidelines: [`STRATEGY.md`](STRATEGY.md)

---

## License

See [`archive/v1/LICENSE`](archive/v1/LICENSE).
