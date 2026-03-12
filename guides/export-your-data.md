# Export Your Data

> How to get real data from Jira, GitHub, Slack, and CI into the format our agents expect.

The agents in this toolkit work with JSON data. This guide shows you how to export from each source. Pick the method that matches your access level — you don't need all sources, and any single source produces useful results.

---

## Jira

### Option A: Jira REST API (recommended)

The most reliable method. Requires a Jira API token.

**1. Create an API token:**
Go to [id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens) and create a token.

**2. Export sprint tickets:**

```bash
curl -s -u your.email@company.com:YOUR_API_TOKEN \
  "https://your-domain.atlassian.net/rest/api/3/search?jql=sprint%20%3D%20%22Sprint%2042%22&fields=key,summary,status,assignee,customfield_10028,issuetype,priority,labels,created,updated&maxResults=50" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
tickets = []
for issue in data['issues']:
    f = issue['fields']
    tickets.append({
        'key': issue['key'],
        'summary': f.get('summary', ''),
        'status': f.get('status', {}).get('name', ''),
        'assignee': (f.get('assignee') or {}).get('displayName', 'Unassigned'),
        'story_points': f.get('customfield_10028', 0),
        'sprint': 'Sprint 42',
        'created': (f.get('created') or '')[:10],
        'updated': (f.get('updated') or '')[:10],
        'labels': f.get('labels', []),
        'type': f.get('issuetype', {}).get('name', ''),
        'priority': f.get('priority', {}).get('name', ''),
        'linked_prs': [],
        'blocked_by': [],
        'blocks': []
    })
print(json.dumps(tickets, indent=2))
" > my-sprint-data.json
```

Replace `your-domain`, `your.email@company.com`, `YOUR_API_TOKEN`, and `Sprint 42` with your values. The `customfield_10028` is the story points field — yours may differ (check Jira admin or use the API to discover custom fields).

**3. Use with an agent:**

```
# Copy the agent prompt, then paste your exported JSON
cat agents/weekly-rewind/prompt.md
cat my-sprint-data.json
# Paste both into your AI tool
```

### Option B: Jira CSV Export

1. Open your Jira board
2. Click the **...** menu > **Export** > **Export CSV (all fields)**
3. Convert CSV to JSON matching the expected schema:

```bash
python3 -c "
import csv, json, sys
reader = csv.DictReader(open('jira-export.csv'))
tickets = []
for row in reader:
    tickets.append({
        'key': row.get('Issue key', ''),
        'summary': row.get('Summary', ''),
        'status': row.get('Status', ''),
        'assignee': row.get('Assignee', 'Unassigned'),
        'story_points': int(row.get('Story Points', 0) or 0),
        'type': row.get('Issue Type', ''),
        'priority': row.get('Priority', ''),
        'labels': row.get('Labels', '').split(',') if row.get('Labels') else [],
        'linked_prs': [],
        'blocked_by': [],
        'blocks': []
    })
print(json.dumps(tickets, indent=2))
" > my-sprint-data.json
```

### Option C: Manual Copy-Paste

If you don't have API access, you can copy ticket information directly from the Jira board view. The agents can work with less structured data — paste what you have and the AI will do its best. For better results, format it as a simple list:

```
PROJ-101: Implement login page — Done — 3 SP — sarah.chen — Story
PROJ-102: Fix password reset bug — In Progress — 2 SP — tom.mueller — Bug
PROJ-103: Database migration — Blocked by PROJ-100 — 5 SP — priya.sharma — Story
```

---

## GitHub

### Option A: GitHub CLI (recommended)

Requires [GitHub CLI](https://cli.github.com/) installed and authenticated.

**Export PRs:**

```bash
gh pr list --repo your-org/your-repo --state all --limit 20 \
  --json number,title,author,state,createdAt,updatedAt,mergedAt,baseRefName,headRefName,reviews,additions,deletions \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
prs = []
for pr in data:
    reviews_list = []
    for r in pr.get('reviews', []):
        reviews_list.append({
            'reviewer': r.get('author', {}).get('login', ''),
            'status': r.get('state', '').lower(),
            'submitted_at': r.get('submittedAt', '')
        })
    status_map = {'OPEN': 'open', 'MERGED': 'merged', 'CLOSED': 'closed'}
    prs.append({
        'number': pr['number'],
        'title': pr['title'],
        'author': pr['author']['login'],
        'status': status_map.get(pr.get('state', ''), 'open'),
        'created_at': pr.get('createdAt', ''),
        'updated_at': pr.get('updatedAt', ''),
        'merged_at': pr.get('mergedAt'),
        'base_branch': pr.get('baseRefName', ''),
        'head_branch': pr.get('headRefName', ''),
        'reviews': reviews_list,
        'ci_status': 'passing',
        'additions': pr.get('additions', 0),
        'deletions': pr.get('deletions', 0),
        'linked_ticket': ''
    })
print(json.dumps(prs, indent=2))
" > my-github-prs.json
```

**Export commits:**

```bash
gh api repos/your-org/your-repo/commits --paginate -q '.[] | {
  sha: .sha[:7],
  message: .commit.message,
  author: .author.login,
  date: .commit.author.date,
  branch: "main",
  files_changed: 0
}' | python3 -c "
import json, sys
commits = [json.loads(line) for line in sys.stdin]
print(json.dumps(commits[:50], indent=2))
" > my-github-commits.json
```

### Option B: GitHub REST API

```bash
curl -s -H "Authorization: Bearer YOUR_GITHUB_TOKEN" \
  "https://api.github.com/repos/your-org/your-repo/pulls?state=all&per_page=20" \
  > raw-prs.json
```

Then transform to match the expected schema (same field names as Option A).

### Option C: Manual

Copy the PR list from your repo's Pull Requests page. Include PR number, title, author, and status. The agent can work with a simple list format.

---

## Slack

### Option A: Slack API (workspace admin)

Requires a Slack app with `channels:history` scope.

```bash
curl -s -H "Authorization: Bearer xoxb-YOUR-TOKEN" \
  "https://slack.com/api/conversations.history?channel=CHANNEL_ID&limit=20" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
messages = []
for msg in data.get('messages', []):
    messages.append({
        'channel': '#your-channel',
        'author': msg.get('user', 'unknown'),
        'timestamp': msg.get('ts', ''),
        'text': msg.get('text', ''),
        'reactions': [r['name'] for r in msg.get('reactions', [])],
        'thread_replies': msg.get('reply_count', 0),
        'tags': []
    })
print(json.dumps(messages, indent=2))
" > my-slack-messages.json
```

You'll need to manually add `tags` (like `#decision`, `#blocker`) or filter for messages that contain those keywords.

### Option B: Manual Copy-Paste

Copy key decision messages from your team channel. Format them as:

```json
[
  {
    "channel": "#my-team",
    "author": "sarah",
    "timestamp": "2026-03-11T10:00:00Z",
    "text": "Decision: We will use approach X for the migration because...",
    "reactions": [],
    "thread_replies": 5,
    "tags": ["#decision"]
  }
]
```

Focus on messages tagged with or containing: decisions, blockers, scope changes, and celebrations.

---

## CI Builds

### GitHub Actions

```bash
gh run list --repo your-org/your-repo --limit 30 \
  --json databaseId,headBranch,conclusion,createdAt,updatedAt \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
builds = []
for run in data:
    builds.append({
        'id': f\"build-{run['databaseId']}\",
        'branch': run.get('headBranch', ''),
        'status': 'success' if run.get('conclusion') == 'success' else 'failure',
        'triggered_at': run.get('createdAt', ''),
        'duration_seconds': 0,
        'pr_number': 0,
        'failed_tests': [],
        'coverage_percent': 0
    })
print(json.dumps(builds, indent=2))
" > my-ci-builds.json
```

### Other CI Providers

For CircleCI, Jenkins, GitLab CI, or others: use their respective APIs and transform the output to match the schema above. The key fields are `branch`, `status` (`success`/`failure`), `triggered_at`, and `failed_tests`.

---

## Combining Sources

Agents accept multiple data sources in a single JSON object:

```json
{
  "jira_tickets": [...],
  "github_prs": [...],
  "slack_decisions": [...],
  "ci_builds": [...]
}
```

You can include any combination. Missing sources are handled gracefully — the agent skips sections that require data it doesn't have.

---

## Tips

- **Start with just Jira.** It's the most impactful source and produces 80% of the report value.
- **Add GitHub PRs second.** They enable cross-referencing (are tickets really "Done"?) and PR health analysis.
- **Slack is optional but valuable.** Decisions and scope changes add rich context to weekly reports.
- **CI data is optional.** Most useful for the Morning Scan's "Build Health" section.
- **Re-export weekly.** The agents work on point-in-time snapshots. Fresh data = fresh insights.
