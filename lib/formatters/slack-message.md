# Slack Message Formatter

> Shared prompt fragment — include this in any agent that outputs to Slack.

## Slack mrkdwn Syntax

Slack uses its own markup format (mrkdwn), **not** standard Markdown. Key differences:

| Element | Slack mrkdwn | Standard Markdown |
|---------|-------------|-------------------|
| Bold | `*bold*` | `**bold**` |
| Italic | `_italic_` | `*italic*` |
| Strikethrough | `~strike~` | `~~strike~~` |
| Code inline | `` `code` `` | `` `code` `` |
| Code block | ` ```code``` ` | ` ```code``` ` |
| Link | `<https://url\|display text>` | `[text](url)` |
| User mention | `<@U12345>` | N/A |
| Channel | `<#C12345>` | N/A |
| Blockquote | `> quoted text` | `> quoted text` |
| Bullet list | `• item` or `- item` | `- item` |

**Do NOT use** standard Markdown bold (`**text**`) or links (`[text](url)`) — they render as literal characters in Slack.

## Message Structure

### Main Message (Thread Parent)

Keep the main message to 3-5 lines maximum. This is what people see in their channel feed.

```
{emoji} *{Agent Name} — {Sprint/Date}*

{1-2 line summary of the most important finding}

{RAG status line}

_Thread below for details →_
```

### Thread Replies (Details)

Put detailed findings in thread replies. Each thread reply covers one topic:

```
*{Section Title}*

• {finding 1}
• {finding 2}
• {finding 3}
```

## RAG Status Line

```
🟢 *Status: Green* — On track, no action needed
🟡 *Status: Amber* — {one-line reason}
🔴 *Status: Red* — {one-line reason}
```

## Formatting Patterns

### Ticket References
Format as bold with link when possible:
```
*<https://yoursite.atlassian.net/browse/MERC-230|MERC-230>* — Migrate webhook handler
```
When URL not available, use bold only: `*MERC-230*`

### Developer Names
Use first names: "Sarah", "Marcus". In Slack, you can mention with `<@USLACKID>` if Slack IDs are available.

### Numbers
Bold key metrics: `*35 SP* completed`, `*87%* pass rate`.

### Severity Indicators

| Severity | Pattern |
|----------|---------|
| Critical | `🚨 {item}` |
| Warning | `⚠️ {item}` |
| Good | `✅ {item}` |
| Info | `ℹ️ {item}` |

## Brevity Rules

1. **No headers in main message** — the bold agent name is the only header
2. **No tables** — Slack tables render poorly; use bullet lists instead
3. **Max 3-5 bullets per section** — if more, summarize and point to full report
4. **No paragraph text** — every line is either a bullet or a status line
5. **Abbreviate where clear** — "SP" not "story points", "PR" not "pull request"
6. **Skip empty sections entirely** — if nothing to report, don't include the section header

## Examples

### Daily Scan Main Message
```
☀️ *Morning Scan — Sprint 42, Day 3*

🟡 *Status: Amber* — 2 stale PRs blocking progress, Marcus at 7 tickets

_3 items need attention today. Details in thread →_
```

### Thread Reply — Blockers
```
*🚨 Blockers & Stale Work*

• *MERC-226* — PR #141 open 4 days, zero reviews (Marcus)
• *MERC-233* — PR #145 open 3 days, zero reviews (Marcus)
• *MERC-229* — Blocked by external vendor (FraudShield API delayed to Mar 24)
```

### Thread Reply — Wins
```
*✅ Wins*

• *MERC-220* merged — Gateway SDK v3 integration complete (Sarah)
• *MERC-225* merged — Audit logging shipped with 88% coverage (Kenji)
• Sprint velocity: *28 SP* done of *78 SP* committed
```

## Anti-Patterns

- Do NOT paste full JSON or raw data into Slack messages
- Do NOT use `@here` or `@channel` — let the agent caller decide notification level
- Do NOT include timestamps in the message body (Slack adds its own)
- Do NOT use more than 2 emoji per line (visual noise)
- Do NOT end with "Let me know if you have questions" — agents don't take questions
