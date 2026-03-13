# Watermelon Auditor

> Cross-references Jira ticket statuses against GitHub activity to detect false "Green" reporting and produce a Trust Score.

## The Problem

Every sprint review, the board looks green. Tickets are "Done." Stakeholders are happy. But when you dig into the code, some of those "Done" tickets have no merged PR, no commits, no CI run — nothing. The status is green on the outside, red on the inside. That's a watermelon.

This isn't rare. [44% of software organizations](https://www.standishgroup.com/) still rely on manual spreadsheets and self-reported status to track delivery. The result is a visibility paradox: the more tools you have, the easier it is for status to drift from reality — because nobody is systematically cross-checking the board against the codebase.

The Watermelon Auditor fixes this by matching every Jira ticket to its GitHub trail and computing a Trust Score — the percentage of your sprint status that's backed by actual engineering evidence.

## What You Get

A single-page audit report containing:

- **Trust Score** — one number (0–100%) that tells you how much you can trust your sprint board
- **Ticket-by-ticket classification** — every ticket tagged as Verified, Watermelon, Stale, At Risk, Active, or Unlinked
- **Watermelon details** — each false-green ticket with its Jira status vs. GitHub reality
- **Pattern detection** — overloaded developers, ghost completions, review bottlenecks
- **Recommended actions** — immediate, process improvements, and follow-up audit timing

## Quick Start

### Option A: Use Sample Data (2 minutes)

1. Open [`prompt.md`](prompt.md) and copy everything
2. Open [`examples/sample-input.md`](examples/sample-input.md) and copy the data sections
3. Go to any AI assistant — [Claude](https://claude.ai), [ChatGPT](https://chat.openai.com), [Gemini](https://gemini.google.com)
4. Paste the prompt first, then paste the data
5. Get your Trust Score

The sample data uses Project Mercury (a fictional payment platform migration) with 20 sprint tickets. It contains 3 intentional watermelons, 2 stale items, and 1 CI-failing ticket, producing a Trust Score of 57% (Critical).

### Option B: Use Your Own Data (10 minutes)

**Step 1 — Export Jira sprint data:**

```bash
# Using Jira REST API
curl -u email:token "https://your-site.atlassian.net/rest/api/3/search?jql=sprint%20%3D%20'Sprint%20X'&fields=key,summary,status,assignee,customfield_10028,sprint,created,updated,labels,issuetype,priority"

# Or using jira-cli (https://github.com/ankitpokhrel/jira-cli)
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

**Step 4 — Run the audit:**

Paste the prompt, then paste your data. The agent handles JSON or CSV.

### Option C: Claude Code with MCP (L2)

> Coming soon

With MCP servers configured for Jira and GitHub, Claude Code can fetch data automatically:

```bash
claude /watermelon-audit
```

See the [`mcp/`](../../mcp/) directory for server configuration.

## Example Output

The following was generated from the Project Mercury Sprint 42 sample data (see [`examples/sample-output.md`](examples/sample-output.md) for the full report):

---

### Trust Score: 57% — Critical

**8** of **14** auditable tickets are backed by GitHub activity.

| Classification | Count | Tickets |
|----------------|-------|---------|
| VERIFIED | 5 | MERC-220, MERC-222, MERC-223, MERC-225, MERC-228 |
| ACTIVE | 3 | MERC-230, MERC-231, MERC-232 |
| WATERMELON | 3 | MERC-221, MERC-224, MERC-227 |
| STALE | 2 | MERC-226, MERC-233 |
| AT RISK | 1 | MERC-234 |

**Top findings:**
- **MERC-221** (5 SP) and **MERC-224** (3 SP) — marked Done by Marcus Johnson, but no PR, no branch, no commits exist anywhere in GitHub
- **MERC-227** (2 SP) — marked Done by Tom Mueller, but no code evidence. PCI audit is next week.
- **Marcus Johnson** has 7 tickets assigned, only 1 of 4 "Done" items is verified — classic overload pattern

---

## How It Works

```
Jira Tickets ──┐
               ├── Match ── Classify ── Score ── Detect Patterns ── Report
GitHub PRs ────┘
(+ Commits, CI)
```

1. **Match**: link each Jira ticket to GitHub activity via PR references, branch names, or commit messages
2. **Classify**: apply a decision tree — Done + merged PR = Verified; Done + no PR = Watermelon; etc.
3. **Score**: Trust Score = verified tickets / auditable tickets
4. **Detect**: find systemic patterns (overload, ghost completions, review bottlenecks)
5. **Report**: actionable output with specific ticket IDs, people, and next steps

## Trust Score Interpretation

| Score | Rating | What It Means | What To Do |
|-------|--------|---------------|-----------|
| 80–100% | Healthy | Sprint status is trustworthy | Routine audit cadence (end of sprint) |
| 60–79% | Concerning | Several tickets lack code evidence | Review flagged items with assignees this sprint |
| < 60% | Critical | Systemic gap between board and codebase | Immediate team review; add Definition of Done gates |

## Limitations

- **Code-linked tickets only**: design tasks, documentation, and meetings are excluded from the Trust Score (classified as NON-CODE)
- **Naming convention dependent**: matching relies on ticket IDs appearing in branch names, PR titles, or commit messages. Teams without this convention will see high UNLINKED rates — the audit will flag this with specific recommendations
- **Point-in-time snapshot**: this is a static audit, not real-time monitoring. Run it mid-sprint and end-of-sprint for best coverage.
- **No PR ≠ no work**: some tasks (infrastructure, config changes, vendor portal work) may not produce PRs. The audit flags these as WATERMELON for review, not as definitive proof of false reporting.

## Configuration

See [`config.yaml`](config.yaml) for tunable parameters:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `stale_threshold_hours` | `72` | Hours without commits before flagging In Progress as STALE |
| `watermelon_threshold` | `2` | Minimum watermelons per developer to flag overload pattern |
| `trust_score_healthy` | `80` | Minimum Trust Score for "Healthy" rating |
| `trust_score_concerning` | `60` | Minimum Trust Score for "Concerning" (below = Critical) |
| `non_code_labels` | `[documentation, design, meeting, planning, process]` | Labels that trigger NON-CODE classification |

## Related Agents

- [Morning Scan](../morning-scan/) — daily standup prep with blocker detection
- [Weekly Rewind](../weekly-rewind/) — client-ready weekly status reports
- Blocker Detective (coming soon) — CI/PR blocker analysis and unblock recommendations
