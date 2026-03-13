# Blocker Detective

> Surfaces stuck PRs, failing CI, stale work, and overloaded developers before standup — so your daily ceremony becomes a decision meeting, not status theater.

## The Problem

Every morning, the Scrum Master spends 30-60 minutes manually checking the Jira board, scanning GitHub PRs, reviewing CI pipelines, and reading Slack threads — just to figure out what's actually stuck. By the time standup starts, they've done investigative work that the whole team then repeats verbally. Blockers surface too late. Cross-team delays cascade silently. The standup becomes a status recital instead of a decision forum.

The Blocker Detective fixes this by scanning four data sources before standup and producing a prioritized blocker report with a ready-to-use standup agenda. Instead of asking "what did you do yesterday?", the team walks in knowing exactly which items need decisions.

## What You Get

A single-page pre-standup briefing containing:

- **Critical Blockers** — items requiring immediate action, with specific evidence and recommended next steps
- **Watch List** — items trending toward blocked that need a quick status check
- **Healthy Signals** — brief confirmation of what's on track (calibrates trust in the report)
- **Developer Load Map** — per-developer ticket count and blocker exposure at a glance
- **Suggested Standup Agenda** — the killer feature: a numbered list of discussion topics with who should speak, what signal triggered it, and what decision the team needs to make
- **Recommended Actions** — numbered, assigned to specific people, tied to signal evidence

## Quick Start

### Option A: Use Sample Data (2 minutes)

1. Open [`prompt.md`](prompt.md) and copy everything
2. Open [`examples/sample-input.md`](examples/sample-input.md) and copy the data sections
3. Go to any AI assistant — [Claude](https://claude.ai), [ChatGPT](https://chat.openai.com), [Gemini](https://gemini.google.com)
4. Paste the prompt first, then paste the data
5. Get your blocker report with standup agenda

The sample data uses Project Mercury (a fictional payment platform migration) with 20 sprint tickets, 16 PRs, 50 commits, and 31 CI builds. It contains 2 stale PRs with zero reviews, 4 consecutive CI failures, 1 overloaded developer, and 1 externally blocked ticket.

### Option B: Use Your Own Data (10 minutes)

**Step 1 — Export Jira sprint data:**

```bash
# Using Jira REST API
curl -u email:token "https://your-site.atlassian.net/rest/api/3/search?jql=sprint%20%3D%20'Sprint%20X'&fields=key,summary,status,assignee,customfield_10028,sprint,created,updated,labels,issuetype,priority"

# Or using jira-cli
jira sprint list --board YOUR_BOARD --current --plain
```

Transform the output to match the schema in [`prompt.md`](prompt.md) (Section: Source 1).

**Step 2 — Export GitHub PR data:**

```bash
# Using GitHub CLI
gh pr list --repo your-org/your-repo --state all --json number,title,author,state,createdAt,updatedAt,mergedAt,baseRefName,headRefName,reviews,additions,deletions --limit 50

# For CI status per PR
gh pr checks <pr-number> --repo your-org/your-repo
```

**Step 3 — (Optional) Export commits and CI builds** for richer detection. See field schemas in [`prompt.md`](prompt.md).

**Step 4 — Run the scan:**

Paste the prompt, then paste your data. The agent handles JSON or CSV.

### Option C: Claude Code with MCP (L2)

> Coming soon

With MCP servers configured for Jira and GitHub, Claude Code can fetch data automatically:

```bash
claude /blocker-detective
```

See the [`mcp/`](../../mcp/) directory for MCP server configuration.

## Example Output

The following was generated from the Project Mercury Sprint 42 sample data (see [`examples/sample-output.md`](examples/sample-output.md) for the full report):

---

### Sprint health: Action Required

**6 critical items, 2 warnings** across 20 sprint tickets.

| Signal | Items | Severity |
|--------|-------|----------|
| Aging PR + Review Starvation | PR #141, PR #145 | Critical |
| CI Failure Streak | MERC-234 (4 consecutive failures) | Critical |
| Stale Work | MERC-226 (4 days), MERC-233 (3 days) | Critical / Warning |
| Developer Overload | marcus.johnson (7 tickets) | Critical |
| Blocked Ticket | MERC-229 (external vendor) | Critical |

**Top standup agenda items:**
1. Marcus's workload — 7 tickets, needs redistribution
2. PR reviews for #141 and #145 — who can review?
3. MERC-234 CI failures — pair session or rethink?
4. MERC-229 vendor blocker — swap in backlog item?

---

## Signal Reference

| Signal | What It Detects | Warning Threshold | Critical Threshold |
|--------|----------------|-------------------|-------------------|
| Aging PR | PR open too long without merge | > 48 hours | > 72 hours |
| Review Starvation | PR waiting for review with zero reviewers | > 24 hours, 0 reviews | > 48 hours, 0 reviews |
| CI Failure Streak | Consecutive build failures on same branch | 2 consecutive | 3+ consecutive |
| Stale Work | In Progress ticket with no recent commits | > 2 days | > 4 days |
| Developer Overload | Too many tickets assigned to one person | 4+ sprint tickets | 6+ sprint tickets |
| Blocked Ticket | Explicit blocker or external dependency | Blocked by red-signal ticket | "Blocked" status or external dep |
| Ghost Sprint Item | In Progress with zero activity | — | > 3 days, no commits or PR activity |

## How It Works

```
Jira Tickets ──────┐
GitHub PRs ────────┤
GitHub Commits ────┼── Match ── Evaluate 7 Signals ── Build Load Map ── Generate Agenda ── Report
CI Builds ─────────┘
```

1. **Match**: link each Jira ticket to GitHub activity via PR references, branch names, or commit messages (same 4-step hierarchy as the Watermelon Auditor)
2. **Evaluate**: apply 7 signal detectors with configurable thresholds
3. **Load Map**: compute per-developer ticket count and blocker exposure
4. **Agenda**: prioritize findings into a ready-to-use standup discussion list
5. **Report**: actionable output with specific IDs, people, evidence, and next steps

## Configuration

All thresholds are defined in [`config.yaml`](config.yaml) and referenced by name in the prompt. Adjust them for your team's norms:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `pr_age_warning_hours` | `48` | Hours before an open PR triggers a warning |
| `pr_age_critical_hours` | `72` | Hours before an open PR triggers a critical alert |
| `review_wait_warning_hours` | `24` | Hours with zero reviews before warning |
| `review_wait_critical_hours` | `48` | Hours with zero reviews before critical |
| `ci_failure_streak_warning` | `2` | Consecutive CI failures for warning |
| `ci_failure_streak_critical` | `3` | Consecutive CI failures for critical |
| `stale_work_warning_days` | `2` | Days without commits on In Progress ticket for warning |
| `stale_work_critical_days` | `4` | Days without commits for critical |
| `developer_load_warning` | `4` | Sprint tickets per developer for warning |
| `developer_load_critical` | `6` | Sprint tickets per developer for critical |
| `ghost_sprint_item_days` | `3` | Days with zero activity on In Progress ticket |

For a larger team (15+ devs) or longer sprints (3 weeks), consider raising `developer_load_warning` to 5 and `stale_work_warning_days` to 3.

## Limitations

- **Code-linked signals only**: the Blocker Detective works with Jira, GitHub, and CI data. It cannot detect blockers surfaced only in Slack conversations, email, or verbal communication. Combine with the [Morning Scan](../morning-scan/) for Slack-aware coverage.
- **No cross-team visibility**: dependency detection is limited to `blocked_by` and `blocks` fields within the sprint data. Cross-team delays on separate boards are invisible unless explicitly linked.
- **No time estimates**: cannot detect estimation overruns. Sprint dates and story points are used for context, not for deadline prediction.
- **Point-in-time snapshot**: this is a static scan, not real-time monitoring. Run it daily before standup for best results.
- **Human blockers invisible**: approval chains, stakeholder decisions, and organizational friction have no data signal. The report focuses on engineering-visible blockers.

## Related Agents

- [Watermelon Auditor](../watermelon-auditor/) — detects false "Done" reporting by cross-referencing Jira status against GitHub activity
- [Morning Scan](../morning-scan/) — daily standup prep with Slack-aware blocker detection and overnight change summary
- [Weekly Rewind](../weekly-rewind/) — client-ready weekly status reports with sprint health assessment
