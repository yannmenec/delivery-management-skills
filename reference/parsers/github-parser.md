# GitHub Data Parser

> Shared prompt fragment — include this in any agent that consumes GitHub PR, commit, or CI data.

## Input Formats

### Pull Requests

Each PR object contains:

| Field | Type | Description |
|-------|------|-------------|
| `number` | number | PR number (e.g., `148`) |
| `title` | string | PR title, typically prefixed with conventional commit type |
| `author` | string | Username who created the PR |
| `status` | string | `open`, `merged`, `closed` |
| `created_at` | string | ISO timestamp of PR creation |
| `updated_at` | string | ISO timestamp of last activity |
| `merged_at` | string or null | ISO timestamp when merged, null if not merged |
| `base_branch` | string | Target branch (usually `main`) |
| `head_branch` | string | Source branch (e.g., `feat/MERC-230-webhook-migration`) |
| `reviews` | array | List of review objects: `{ reviewer, status, submitted_at }` |
| `ci_status` | string | `passing`, `failing`, `pending` |
| `additions` | number | Lines added |
| `deletions` | number | Lines removed |
| `linked_ticket` | string | Jira ticket key this PR implements |

### Commits

Each commit object contains:

| Field | Type | Description |
|-------|------|-------------|
| `sha` | string | Short commit hash |
| `message` | string | Commit message (may include ticket reference in body) |
| `author` | string | Username who authored the commit |
| `date` | string | ISO timestamp |
| `branch` | string | Branch the commit was made on |
| `files_changed` | number | Number of files modified |

### CI Builds

Each build object contains:

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Build identifier |
| `branch` | string | Branch that triggered the build |
| `status` | string | `success` or `failure` |
| `triggered_at` | string | ISO timestamp |
| `duration_seconds` | number | Build duration |
| `pr_number` | number | Associated PR number |
| `failed_tests` | string[] | Names of failing tests (empty if success) |
| `coverage_percent` | number | Code coverage percentage |

## Ticket Correlation

To link GitHub activity back to Jira tickets, use these methods in priority order:

1. **`linked_ticket` field** on PRs — explicit, most reliable
2. **Branch name convention** — extract ticket key from `head_branch` pattern: `{type}/MERC-{NNN}-{slug}`
3. **Commit message** — scan for ticket key patterns (`MERC-NNN`) in the commit message body

When correlating, build a map: `ticket_key → { prs: [...], commits: [...], builds: [...] }`.

## PR Health Analysis

For each open PR, compute:

| Metric | Calculation | Threshold |
|--------|------------|-----------|
| **Age** | `now - created_at` in hours | Warning: > 48h, Critical: > 96h |
| **Review status** | Count of reviews, latest review status | No reviews after 24h = stale |
| **CI health** | Latest `ci_status` | `failing` = blocked |
| **Size** | `additions + deletions` | Warning: > 500 lines, Large: > 1000 lines |
| **Staleness** | `now - updated_at` in hours | Warning: > 48h without activity |

### Review Bottleneck Detection

Flag PRs where:
- `reviews` array is empty AND `created_at` is > 24h ago
- All reviews have `status: "changes_requested"` with no follow-up
- PR has been open > 48h with no approved review

### CI Failure Patterns

From CI build data, identify:
- **Consecutive failures**: 3+ failures on the same branch = likely real issue (not flaky)
- **Flaky tests**: Same test name appears in `failed_tests` intermittently across branches
- **Coverage trends**: Coverage dropping below 80% across builds

## Commit Activity Analysis

### Developer Activity
Group commits by author. For each developer:
- Count commits per day (last 7 days)
- Count unique branches committed to
- Identify last commit timestamp

Flag developers with **5+ active branches** as potentially context-switching too much.

### Branch Freshness
For each open PR's branch, find the most recent commit:
- Last commit > 3 days ago = **stale branch** (work may be stuck)
- Last commit > 7 days ago = **abandoned branch** (needs triage)

## Output Schema

```
pr_summary:
  total_open: number
  total_merged_this_sprint: number
  avg_time_to_merge_hours: number
  review_bottlenecks:
    - pr_number: number
      age_hours: number
      review_count: 0

ci_summary:
  total_builds: number
  pass_rate_pct: number
  avg_duration_seconds: number
  failing_branches:
    - branch: string
      consecutive_failures: number
      failing_tests: string[]

activity_summary:
  - author: string
    commits_7d: number
    active_branches: number
    last_commit: string
    flag: "overloaded" | "active" | "quiet"

ticket_coverage:
  - ticket: string
    has_pr: boolean
    has_recent_commits: boolean
    ci_passing: boolean
```
