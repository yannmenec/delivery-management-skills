---
name: format-for-audience
version: 1.0.0
description: Adapts delivery content to the target audience's tone, detail level, and format expectations.
category: reporting
trigger: Before sharing any output externally. After generating a report, update, or assessment.
autonomy: autonomous
portability: universal
complexity: basic
type: generation
inputs:
  - name: content
    type: text
    required: true
    description: The delivery content to reformat (report, update, assessment, memo).
  - name: audience
    type: text
    required: true
    description: "Target audience: c-level, product, engineering-management, engineering-team, cross-team, or custom description."
  - name: format
    type: text
    required: false
    description: "Output format: markdown (default), team-chat, email, wiki, presentation-bullets."
outputs:
  - name: formatted_content
    type: text
    description: Content reformatted for the specified audience and channel.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Format for Audience

Adapt delivery management content for specific audiences and output channels. The same sprint data should read differently for a VP than for the engineering team.

## When to Apply

- Before sharing any generated report, update, or assessment
- When the same information needs to reach multiple audiences
- When switching output channels (e.g., converting a detailed report to Slack-friendly bullets)

## Method

### Step 1: Identify audience profile

| Audience | Tone | Detail Level | Focus | Avoid |
|----------|------|-------------|-------|-------|
| **C-Level / VP** | Executive, confident, metrics-first | 3-5 bullets, 1 page max | RAG status, business impact, decisions needed, timeline | Ticket keys, technical jargon, process details |
| **Product** | Feature-oriented, outcome-focused | Per-feature status, 1-2 pages | Completion status, dates, scope changes, user impact | Infrastructure details, code-level issues |
| **Engineering Management** | Detailed, operational | Full report, 2-3 pages | Velocity, capacity, blockers, tech risks, process health | Business strategy, revenue metrics |
| **Engineering Team** | Direct, actionable, specific | Brief, 1 page | Sprint status, priority tickets, review queue, who needs help | High-level strategy, stakeholder politics |
| **Cross-Team** | Neutral, dependency-focused | 1 page | Shared blockers, integration points, timeline alignment | Team-internal details, individual performance |

If the audience is not in this table, ask for a brief description and apply the closest profile.

### Step 2: Transform content

Apply these transformations based on the audience:

**For C-Level / VP:**
- Lead with the RAG status and one-line verdict
- Convert ticket counts to business impact ("3 critical bugs" → "payment flow reliability at risk")
- Remove all ticket keys unless they are specifically requested
- Replace technical terms with business equivalents
- End with a clear ask: decision needed, FYI, or risk acknowledgment

**For Product:**
- Organize by feature or epic, not by ticket type
- Show completion percentage per feature
- Highlight scope changes and their impact on dates
- Include user-facing impact for every risk or blocker
- Link to relevant design docs or specs if available

**For Engineering Management:**
- Keep full operational detail
- Include velocity, capacity, and predictability metrics
- Show blocker details with ticket keys and assignees
- Include tech debt and process improvement signals
- Provide recommendations with clear owners

**For Engineering Team:**
- Be direct and specific
- List action items with ticket keys and owners
- Highlight who needs a review, who is blocked, who has bandwidth
- Skip high-level metrics — focus on "what do I need to do today"
- Keep it under 1 page

**For Cross-Team:**
- Focus exclusively on interface points and dependencies
- Show what your team needs from them and vice versa
- Include timeline commitments and any slips
- Use neutral, professional tone — no blame
- Clearly separate FYI items from action items

### Step 3: Apply format constraints

| Format | Constraints |
|--------|-----------|
| **Markdown** | Headers, tables, bold for key metrics. Standard for detailed reports. |
| **Team Chat** (Slack, Teams, Discord) | Max 5 bullets per section. Bold with `*text*`. No tables (use aligned text). Thread-friendly. |
| **Email** | Subject line + 3-5 paragraph structure. Professional greeting/closing. Key metrics in first paragraph. |
| **Wiki** (Confluence, Notion, etc.) | Wiki-compatible markdown. Link ticket keys to tracker. Use info/warning panels for highlights. |
| **Presentation bullets** | One idea per bullet. Max 6 bullets per slide concept. No full sentences — fragments and metrics. |

### Step 4: Validate transformation

After reformatting, verify:
- No information was fabricated during the transformation
- The core message and RAG status are preserved
- Audience-inappropriate content was removed, not just hidden
- The output length matches the audience expectation

## Output Format

The reformatted content, prefixed with a metadata line:

```
> Formatted for: {audience} | Channel: {format} | Source: {original output type}

{reformatted content}
```

## Error Handling

- If the input content is too sparse to reformat meaningfully: return the original content with a note: "Insufficient content for meaningful reformatting. Consider enriching the source output first."
- If the audience is unknown: ask for clarification. Do not guess — wrong tone is worse than no transformation.
- If the format is not in the supported list: apply markdown as default and note: "Unknown format '{format}' — defaulted to markdown."

## Anti-Patterns

- **NEVER** preserve technical jargon for non-technical audiences. If the source says "PR review bottleneck," the C-level version says "code review delay affecting delivery timeline."
- **NEVER** exceed the target length for an audience. An executive update longer than 5 bullets has failed its purpose.
- **NEVER** strip critical risks when reformatting. A blocker must appear in every audience version — only the framing changes, not the information.
