# Markdown Report Formatter

> Shared prompt fragment — include this in any agent that outputs a markdown report.

## Standard Report Structure

Every report must follow this structure:

```markdown
# {Agent Name} — {Sprint/Date Context}

> Generated: {YYYY-MM-DD HH:MM} | Sprint: {Sprint Name} | Team: {Team Name}

## TL;DR

{2-3 sentence executive summary. Lead with the most important finding.}

## Status: {RAG Indicator}

{One-line justification for the RAG status.}

---

{Main report sections — agent-specific content goes here.}

---

## Recommended Actions

1. **{Action}** — {Owner} — {Why it matters}
2. **{Action}** — {Owner} — {Why it matters}
3. **{Action}** — {Owner} — {Why it matters}

## Stats

| Metric | Value |
|--------|-------|
| {metric} | {value} |

---

*Source: {data sources used} | Confidence: {High/Medium/Low}*
```

## RAG Status Indicators

Use these emoji indicators consistently:

| Status | Emoji | When to Use |
|--------|-------|-------------|
| Green | 🟢 | On track, no blockers, velocity healthy |
| Amber | 🟡 | Minor risks, 1-2 blockers with mitigations, velocity slightly off |
| Red | 🔴 | Critical blockers, velocity significantly below target, scope risk |

For inline items within sections:

| Meaning | Indicator |
|---------|-----------|
| Healthy / On track | ✅ |
| Warning / Needs attention | ⚠️ |
| Critical / Blocked | 🚨 |
| Information / Neutral | ℹ️ |

## Section Formatting Rules

### Tables
Use tables for structured comparisons. Always include headers. Align numbers right.

### Lists
Use numbered lists for ranked items (actions, priorities). Use bullet lists for unordered sets.

### Ticket References
Always format Jira tickets as bold inline references: **MERC-230**. Include the summary on first mention: **MERC-230** (Migrate webhook handler).

### Developer Names
Use first names only in reports: "Sarah" not "sarah.chen". Map usernames to display names before rendering.

### Numbers and Percentages
- Always include units: "35 SP", "87% pass rate", "4.2 days"
- Round percentages to one decimal place
- Use comparison when prior data exists: "35 SP (↑ from 32 SP last sprint)"

## Tone Guidelines

- **Professional but human**: Not robotic, not casual. Write like a competent team lead giving a briefing.
- **Concise**: Every sentence earns its place. No filler phrases like "It's worth noting that..." or "It should be mentioned that...".
- **Actionable**: End sections with what should happen next, not just observations.
- **Evidence-based**: Every claim references specific ticket keys, PR numbers, or data points.
- **Balanced**: Celebrate wins alongside flagging risks. Don't make reports purely negative.

## Length Guidelines

| Report Type | Target Length |
|-------------|-------------|
| Daily scan / pulse | 15-25 lines |
| Mid-sprint check | 40-60 lines |
| Sprint review | 80-120 lines |
| PI review | 150-200 lines |

## Confidence Footer

Every report must end with a confidence statement:

- **High confidence**: All data sources available, data < 24h old
- **Medium confidence**: Some data sources unavailable or stale; state which ones
- **Low confidence**: Critical data missing; state what's missing and impact on findings
