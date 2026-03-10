---
name: craft-escalation-memo
version: 1.0.0
description: Generates structured escalation documents for leadership. Evidence-based, professional, urgent without panic.
category: risk-management
trigger: Critical risk requires leadership attention, decision needed beyond team scope, blocker affecting delivery timeline.
autonomy: human-in-the-loop
portability: universal
complexity: advanced
type: generation
inputs:
  - name: escalation_context
    type: structured-text
    required: true
    description: >
      Escalation context: situation description, affected scope (sprint/PI/project),
      quantified impact (delays, revenue, users), deadline or urgency, decision or
      action needed, options if applicable, supporting data (ticket counts, dates,
      metrics).
outputs:
  - name: memo
    type: text
    description: Complete escalation memo ready to send to leadership.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Craft Escalation Memo

Generate a structured escalation document for leadership. The memo must be evidence-based: every claim backed by data. Tone: professional, urgent without panic, factual.

## When to Apply

- A critical risk requires leadership attention or a decision beyond the team's scope
- A blocker is affecting delivery timeline and needs external intervention
- A scope, dependency, or capacity issue requires stakeholder alignment
- A risk assessment has flagged a Red or Critical Red item that needs escalation

## Memo Structure

The memo MUST follow this structure. Each section has a specific purpose.

| Section | Purpose | Length |
|---------|---------|--------|
| **Situation** | What is happening. Facts only, no speculation. | 2–4 sentences |
| **Impact** | Quantified consequences. Numbers, dates, scope. | 2–4 bullets |
| **Urgency** | Deadline or time sensitivity. Why act now. | 1–2 sentences |
| **Ask** | Specific decision or action needed from leadership. | 1–2 sentences |
| **Options** | If applicable, 2–3 alternatives with trade-offs. | Optional, 2–4 bullets |

## Method

### Step 1: Extract and validate evidence

From the provided escalation context, extract:
- **Facts**: What happened, when, who is affected
- **Metrics**: Ticket counts, days delayed, percentage impact, user/revenue numbers
- **Dates**: Deadlines, sprint/PI boundaries, when the issue was first observed
- **Decisions needed**: What exactly must be decided or approved

**Rule**: If a claim cannot be backed by data from the context, either omit it or mark it as "(unverified — needs confirmation)." Never fabricate numbers.

### Step 2: Draft each section

**Situation**
- Lead with the core fact. No preamble.
- Use past tense for what has happened, present for current state.
- Avoid blame. Describe the situation, not who is at fault.

**Impact**
- Use bullets. Each bullet = one quantified consequence.
- Prefer numbers: "3 critical tickets blocked," "Release delayed by 5 days," "~2,000 users affected."
- If quantification is uncertain, use ranges: "Estimated 1–2 week delay."

**Urgency**
- State the deadline or trigger. "Sprint ends Friday." "PI planning in 5 days."
- Explain why waiting is costly. "Decision needed before we can commit to PI scope."

**Ask**
- One clear, actionable request. "Approve budget for contractor." "Confirm we can descope feature X." "Escalate to {team} for unblock."
- Avoid vague asks like "Please advise." Be specific.

**Options**
- Only include if there are genuine alternatives.
- For each option: brief description, trade-off, recommendation if clear.
- If there is only one path, omit this section.

### Step 3: Apply tone rules

- **Professional**: No emotional language, no panic words ("disaster," "catastrophe")
- **Urgent without panic**: Convey seriousness through facts, not exclamation marks
- **Factual**: Every claim traces to the provided context
- **Concise**: Leadership has limited time. Every sentence earns its place.

### Step 4: Validate against anti-patterns

See the anti-patterns table below. Rewrite any section that violates them.

## Good vs Bad Escalation Framing

**Good Situation:**
- "The integration with {external system} has been blocked since {date}. The vendor has not responded to our last 3 escalation attempts. We have 2 critical tickets and 4 high-priority tickets dependent on this."

**Bad Situation:**
- "Things are really bad with the integration." (vague, emotional)
- "The vendor is incompetent and we're stuck." (blame, unprofessional)

**Good Impact:**
- "Release delayed by 5 days (from {date} to {date})"
- "3 critical tickets blocked, affecting ~40% of sprint scope"
- "Estimated revenue impact: {range} if not resolved by {date}"

**Bad Impact:**
- "This will cause major problems." (unquantified)
- "Everything is at risk." (vague)

**Good Ask:**
- "Request: Approve budget for a 2-week contractor to unblock the integration, or authorize descoping features X and Y from the release."

**Bad Ask:**
- "What should we do?" (vague, puts burden on reader)
- "We need help." (not actionable)

## Anti-Patterns (NEVER Do These)

| Anti-Pattern | Why It's Bad | Do Instead |
|--------------|-------------|------------|
| Vague impact ("major issues") | No basis for prioritization | Quantify: tickets, days, users, revenue |
| Blame or finger-pointing | Undermines collaboration | Describe the situation neutrally |
| Emotional language ("disaster") | Reduces credibility | Use factual, measured language |
| Unsupported claims | Leadership cannot act on speculation | Cite data or mark as unverified |
| Vague ask ("Please advise") | No clear next step | State specific decision or action needed |
| Burying the ask | Reader may miss it | Put the ask in a dedicated section |
| Excessive length | Leadership will skim or skip | Keep to 1 page; cut non-essential detail |
| Missing urgency | No reason to act now | State deadline and cost of delay |

## Output Format

```
# Escalation Memo

**Subject**: {one-line summary}
**Date**: {date}
**From**: {role/team}
**To**: {audience}

---

## Situation

{Facts. What is happening. 2–4 sentences.}

## Impact

- {Quantified consequence 1}
- {Quantified consequence 2}
- {Quantified consequence 3}

## Urgency

{Deadline or trigger. Why act now. 1–2 sentences.}

## Ask

{Specific decision or action needed. 1–2 sentences.}

## Options (if applicable)

| Option | Description | Trade-off |
|--------|-------------|-----------|
| A | {brief} | {trade-off} |
| B | {brief} | {trade-off} |

**Recommendation**: {Option X} — {one-line reason}

---

## Supporting Data

{Optional: key metrics, ticket keys, dates for reference}

**Confidence**: {High | Medium | Low} — {one-line justification based on data completeness}
```

## Self-Evaluation Checklist

Before delivering, verify:

- [ ] **Evidence-based**: Can every claim in Situation and Impact be traced to the provided context?
- [ ] **Quantified impact**: Does Impact include at least one number (count, days, percentage)?
- [ ] **Clear ask**: Is the Ask section a single, specific request?
- [ ] **Urgency stated**: Is there a deadline or trigger for action?
- [ ] **No blame**: Is the tone neutral and professional?
- [ ] **No emotional language**: Are there no panic words or exclamation marks?
- [ ] **Concise**: Is the memo under 1 page (excluding supporting data)?

If any check fails, revise before returning.

## Error Handling

- **Insufficient data**: If the context lacks quantification, use "(estimated)" or "(unverified)" and recommend gathering more data before sending. Mark confidence as Low.
- **No clear ask**: If the context does not specify what decision is needed, add a placeholder: "[Ask to be defined: e.g., approve X, escalate to Y, descope Z]" and flag for human completion.
- **Conflicting data**: If the context contains contradictory information, note it: "Context contains conflicting data on {topic}. Recommend verification before sending."
