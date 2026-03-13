# Sample Data — Project Mercury

## What is Project Mercury?

Project Mercury is a **fictional** payment platform migration for a mid-size fintech company. The team is migrating from a legacy payment gateway (v2) to a new SDK-based integration (v3), while simultaneously building reconciliation tooling and fraud detection capabilities.

This dataset provides realistic, internally consistent data across Jira, GitHub, Slack, and CI systems — designed to exercise all agents in this toolkit.

## Team Composition

| Name | Username | Role / Specialty |
|------|----------|-----------------|
| Sarah Chen | `sarah.chen` | Backend lead — payment integrations, SDK work |
| Tom Mueller | `tom.mueller` | Backend — API design, transaction processing |
| Priya Sharma | `priya.sharma` | Full-stack — dashboards, frontend, client-facing features |
| Marcus Johnson | `marcus.johnson` | Backend — broad scope, currently overloaded |
| Léa Dubois | `lea.dubois` | Frontend — UI/UX, validation, onboarding |
| Kenji Tanaka | `kenji.tanaka` | DevOps — infrastructure, CI/CD, monitoring |

## Sprint Schedule

| Sprint | Dates | Status |
|--------|-------|--------|
| Sprint 41 | Feb 24 — Mar 7, 2026 | Completed (velocity: 35 SP) |
| Sprint 42 | Mar 10 — Mar 21, 2026 | Active (mid-sprint snapshot as of Mar 12) |

## Dataset Files

| File | Records | Description |
|------|---------|-------------|
| `jira-sprint-42.json` | 20 tickets | Active sprint — mix of Done, In Progress, To Do, Blocked |
| `jira-sprint-41.json` | 14 tickets | Previous sprint — all Done, for velocity comparison |
| `github-prs.json` | 16 PRs | Open and merged PRs across both sprints |
| `github-commits.json` | 50 commits | Two weeks of commit history across all branches |
| `slack-decisions.json` | 9 messages | Team decisions, scope changes, blockers, celebrations |
| `ci-builds.json` | 31 builds | CI build results with pass/fail status and coverage |

## Intentional Anomalies

This data contains deliberately planted signals for agents to detect:

| Signal | Details |
|--------|---------|
| **Watermelon tickets** | MERC-221, MERC-224, MERC-227 — marked Done in Jira but have no matching PR or recent commits |
| **Stale In Progress** | MERC-226, MERC-233 — In Progress with no commits for 3+ days |
| **Review bottleneck** | PR #141, #145 — open > 48h with zero code reviews |
| **Failing CI** | PR #150 (MERC-234) — 4 consecutive build failures on batch-processor branch |
| **Overloaded developer** | Marcus Johnson — 7 assigned tickets in Sprint 42 |
| **Scope creep** | MERC-227 and MERC-237 added mid-sprint (see Slack messages) |
| **External blocker** | MERC-229 — blocked by third-party API vendor delay |

## Cross-Reference Integrity

The datasets are internally consistent:

- Every `linked_prs` reference in Jira matches a PR `number` in `github-prs.json` (except watermelons, which intentionally have none)
- Every PR's `linked_ticket` maps to a valid Jira ticket key
- Every commit `branch` matches a PR `head_branch` or is `main` (for merged work)
- CI builds reference valid PR numbers and branches from `github-prs.json`
- Slack messages reference valid MERC ticket IDs

## Using This Data With Agents

Each agent reads from these files as its input context. To run an agent against this sample data:

1. Navigate to the agent directory (e.g., `agents/watermelon-auditor/`)
2. Reference the data files in the agent's prompt context
3. The agent will analyze the data and produce its report

### Using This Data With Agents

Paste the data sections after the agent prompt in your AI chat:

```
[Paste the contents of agents/watermelon-auditor/prompt.md here]

Here is my Jira sprint data:
[Paste contents of data/jira-sprint-42.json]

Here is my GitHub PR data:
[Paste contents of data/github-prs.json]

Here is my GitHub commit data:
[Paste contents of data/github-commits.json]

Here is my CI build data:
[Paste contents of data/ci-builds.json]
```

For a ready-to-paste example, see the `sample-input.md` file inside 
each agent's `examples/` directory.

## Generating Your Own Data

To create datasets from your real Jira and GitHub:

### From Jira
1. Use JQL to export sprint tickets: `sprint = "Sprint X" AND project = "YOUR_PROJECT"`
2. Export as JSON via the Jira REST API: `GET /rest/api/3/search?jql=...&fields=key,summary,status,assignee,customfield_10028,sprint,created,updated,labels,issuetype,priority`
3. Transform the output to match the schema in `jira-sprint-42.json`

### From GitHub
1. List PRs: `gh pr list --repo your-org/your-repo --json number,title,author,state,createdAt,updatedAt,mergedAt,baseRefName,headRefName,reviews`
2. List commits: `gh api repos/your-org/your-repo/commits --paginate`
3. Transform to match the schema in `github-prs.json` and `github-commits.json`

### From Slack
1. Use the Slack API `conversations.history` endpoint for your team channel
2. Filter for messages with decision-related keywords or specific emoji reactions
3. Structure as shown in `slack-decisions.json`

### From CI
1. Use your CI provider's API (GitHub Actions: `gh run list`, CircleCI: API v2, etc.)
2. Include build status, duration, failed tests, and coverage
3. Match to PR numbers for cross-referencing
