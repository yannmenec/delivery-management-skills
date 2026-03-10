---
name: craft-close-message
version: 1.0.0
description: Generates messages suggesting a ghost-done ticket be transitioned to Done. Helpful tone, evidence-based, always asks rather than commands.
category: communication
trigger: Ghost-done ticket detected, ticket appears complete but status not updated, DM wants to nudge status hygiene.
autonomy: human-in-the-loop
portability: universal
complexity: intermediate
type: generation
inputs:
  - name: ticket_context
    type: structured-text
    required: true
    description: >
      Ticket context: identifier, current status, assignee name, evidence signals
      (PR merged date, version released, deployment confirmed, subtasks done),
      epic context if applicable (child completion count).
outputs:
  - name: message
    type: text
    description: The message ready to post as a comment on the ticket.
  - name: confidence
    type: text
    description: High | Medium | Low with one-line reason.
model_compatibility:
  - claude
  - gpt-4
  - gemini
  - llama-3
---

# Craft Close Message

Generate a short, evidence-based message suggesting that a ghost-done ticket (one that appears complete but is not yet marked Done) be transitioned to Done. Tone: helpful, not commanding. Always ask; never assume or auto-close.

## When to Apply

- A ghost-done ticket has been detected (PR merged, version released, or all subtasks done, but status still open)
- A delivery manager wants to nudge status hygiene without sounding accusatory
- A process has identified tickets that may be ready to close and needs a draft message for human review

## Design Principles

1. **Evidence-based**: Every message must cite specific evidence. Never suggest closing without data.
2. **Question-first**: Ask whether it can be closed. Never tell someone to close it.
3. **Helpful, not commanding**: Assume there may be a valid reason it's still open (QA pending, monitoring, etc.).
4. **Never auto-close**: The message is a nudge for the assignee to act. The agent never performs the transition.

## Method

### Step 1: Gather and rank evidence

From the provided ticket context, collect all available ghost-done signals. Rank them by strength:

| Priority | Evidence | Strength | How to phrase |
|----------|----------|----------|---------------|
| 1 | PR merged | Strongest | "The PR was merged on {date}" or "The PR is merged" |
| 2 | Version released | Strong | "{version} was released on {date}" or "{version} shipped" |
| 3 | Deployment confirmed | Strong | "Deployment to production is confirmed" or "Deployed on {date}" |
| 4 | All subtasks done | Moderate | "All {N} subtasks are Done" or "All children under this epic are closed" |

**Rule**: Include at least two pieces of evidence. When multiple are present, prefer the highest-priority ones for brevity.

### Step 2: Compose the message

- **Sentence 1 (required)**: Evidence + question. Combine the evidence naturally and end with a question: "Can this be moved to Done?" / "Is there anything still pending, or can this go to Done?"
- **Sentence 2 (optional)**: Only if genuinely useful. E.g., "Happy to help if there's a remaining step I'm not seeing." / "If QA is still pending, no rush at all."

Keep the message to 1–2 sentences. One sentence is sufficient.

### Step 3: Adapt to current status

| Current Status | Question angle |
|----------------|----------------|
| QA | Ask if QA is complete; the ticket may legitimately need validation |
| In Review | Note the PR is already merged; review is moot |
| In Progress | Note PR merged and deployed; is there remaining work? |
| To Do | Unusual; ask if this was completed outside the normal flow |

For epics: "All {N} child tickets are Done. Can the epic itself be moved to Done?"

### Step 4: Apply tone and formatting rules

- **Humble**: You are asking a question, not telling someone to close
- **Concise**: 1 to 2 sentences maximum
- **Plain text**: No bullet points, no markdown, no dashes (use commas or periods)
- **Conversational**: Write as a colleague would in a quick message

## Anti-Patterns (NEVER Do These)

| Anti-Pattern | Why It's Bad | Do Instead |
|--------------|-------------|------------|
| Auto-close or assume it's done | You may not see pending steps | Always ask |
| "Please close this" | Imperative, not a question | Ask if it can be moved to Done |
| "This is done, right?" | Presumptuous | State evidence, ask genuinely |
| "Any update?" | Generic, no value | Reference specific evidence |
| "You forgot to close this" | Accusatory | Ask a neutral question |
| No evidence | Unsupported suggestion | Always cite at least two signals |
| Using dashes | Looks robotic | Use commas or periods |
| Bullet points or lists | Too formal | Write as prose |

## Good vs Bad Examples

**Good:**
- "It looks like this might be ready to close. The PR was merged on {date} and {version} was released. Can we move this to Done?"
- "The PR is merged and deployment is confirmed. Is there anything still pending, or can this be transitioned to Done?"
- "All 8 child tickets under this epic are Done. Can the epic itself be moved to Done?"
- "PR merged on {date}, {version} shipped. Is QA complete and ready to close?"

**Bad:**
- "Can you close this ticket?" (no evidence)
- "This should be Done." (statement, not a question)
- "Please move this to Done. The PR is merged." (imperative, uses dash)
- "Why is this still open?" (confrontational)
- "Just checking in on this." (generic, no evidence)

## Output Format

```
Ticket: {identifier}
Assignee: {name}
Current Status: {status}
Evidence Used: {list of signals, e.g. PR merged, version released}

Message:
---
{assignee_first_name}, {Sentence 1: Evidence + Question}
{Sentence 2: Only if needed}
---

Confidence: {High | Medium | Low}
Reason: {e.g. "High: PR merged + version released" or "Medium: version released only"}
```

If the assignee name is unknown, use "Hi" or omit the greeting.

## Self-Evaluation Checklist

Before delivering, verify:

- [ ] **Is it a question?** Does the first sentence end with a question mark?
- [ ] **Evidence-based?** Does the message reference at least two ghost-done signals?
- [ ] **Humble?** Read from the assignee's perspective. Would they feel helped or nagged?
- [ ] **Concise?** Is the message 2 sentences or fewer?
- [ ] **No dashes?** Does the message contain zero dashes?
- [ ] **No auto-close?** The message suggests; it does not perform the transition.
- [ ] **Status-aware?** Does the question angle match the ticket's current status?

If any check fails, rewrite before returning.

## Error Handling

- **Sparse evidence**: If only one weak signal is available, use the fallback: "The fix version for this appears released and the PR seems merged. Is there anything still pending, or can this be moved to Done?" Mark confidence as Low.
- **No assignee**: Address generically. Flag in the output that the ticket is unassigned.
- **Recent update**: If the ticket was updated within 24h, prepend: "I see there was recent activity. Feel free to disregard if this is already being handled."
