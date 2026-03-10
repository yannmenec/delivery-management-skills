---
name: craft-unblock-message
version: 1.0.0
description: Generates contextual, humble messages designed to unblock stuck tickets. Use when a stuck ticket needs a nudge comment.
category: communication
trigger: Stuck ticket detected, blocker watcher needs a draft comment, DM wants to proactively nudge a ticket.
autonomy: human-in-the-loop
portability: universal
complexity: intermediate
type: generation
inputs:
  - name: ticket_context
    type: structured-text
    required: true
    description: >
      Ticket context: identifier, status, assignee name, days stuck, linked blockers,
      PR info (state, reviewers, CI status, merge conflicts), last activity date,
      recent comments, sprint/milestone deadline if relevant.
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

# Craft Unblock Message

Generate a short, contextual message designed to unblock a stuck ticket. The message uses a **question-first approach**: never demand action, always ask a question that surfaces the real blocker.

## When to Apply

- A stuck ticket has been detected and needs a nudge comment
- A delivery manager wants to proactively reach out about a ticket with no recent activity
- A blocker watcher or similar process needs to draft a comment for human review before posting

## Design Principle: Question-First

Every message MUST lead with a genuine question. The goal is to **surface the blocker**, not to demand updates or assign blame. The assignee may have a valid reason the ticket is stuck; the question invites them to share it.

## Method

### Step 1: Identify the primary context signal

From the provided ticket context, determine the single most relevant signal. Use the context-to-question mapping below.

### Step 2: Select the matching question template

| Context Signal | Question Template |
|----------------|-------------------|
| PR awaiting review (no reviewers assigned) | "Would anyone have bandwidth to review the PR for this one?" |
| PR awaiting review (reviewers assigned, no response) | "Is the PR still waiting on feedback from the reviewers, or has something else come up?" |
| PR with changes requested | "Are the requested changes on the PR still being worked on, or is there a blocker?" |
| PR with CI failing | "Is the failing check something you need help with, or a known flaky test?" |
| PR with merge conflicts | "Do you need help rebasing, or is this waiting on another merge?" |
| Blocked by external team/dependency | "Do we have a contact on {team} who could help with this, or is there another path forward?" |
| Blocked by linked ticket | "Is {blocker_id} still the main blocker, or has the situation changed?" |
| Stale with no activity (no commits, no PR) | "Are there any open questions on this one, or a blocker that hasn't been captured yet?" |
| Recent commits but no PR | "Is this still in development, or ready for review?" |
| Last commit was many days ago | "Has work shifted elsewhere, or is there a blocker we should know about?" |
| Last comment mentions waiting on someone | "Any update from {person/team} on {what they're waiting for}?" |
| Ticket has no comments at all | "Is this still on track, or has something come up?" |
| Sprint/milestone ending soon | "With {N} days left, do you think this can land, or should we carry it over?" |
| High priority and stale | "Given the priority, is there anything blocking this that we should escalate?" |
| Unresolved review threads on PR | "Are the review threads still being discussed, or can some be resolved?" |

### Step 3: Compose the message

- **Sentence 1 (required)**: Context + question. Reference at least one specific piece of data (status duration, linked issue, PR state, last activity). End with the question.
- **Sentence 2 (optional)**: Offer of help. One concrete thing you can do: "Happy to help escalate if needed." / "I can flag this in standup if that helps."
- **Sentence 3 (optional)**: Only if critical extra context (e.g., deadline). Never exceed 3 sentences.

### Step 4: Apply tone and formatting rules

- **Humble**: You are offering help, not demanding answers
- **Supportive**: Assume the assignee is doing their best
- **Concise**: 2 to 3 sentences maximum
- **Plain text**: No bullet points, no markdown, no dashes (use commas or periods instead)
- **Conversational**: Write as a colleague would in a quick message

## Anti-Patterns (NEVER Do These)

| Anti-Pattern | Why It's Bad | Do Instead |
|--------------|-------------|------------|
| Demand action ("Please update ASAP") | Creates defensiveness | Ask if help is needed |
| Blame ("You haven't updated this") | Accusatory | State neutrally: "No activity since {date}" |
| Passive-aggressive ("Just checking in") | Generic, no value | Ask a specific question |
| Ask "Why is this late?" | Confrontational | Ask "Is there a blocker we should know about?" |
| Use dashes (-, --, em dash) | Looks robotic | Use commas or periods |
| Tag multiple people | Creates noise | Address the assignee only |
| Bullet points or lists | Too formal | Write as flowing prose |
| All caps or exclamation marks | Aggressive | Keep calm and neutral |
| Generic "Any update?" | Lazy, no context | Reference data, ask targeted question |
| "This is overdue" | Judgmental | State duration neutrally |

## Good vs Bad Examples

**Good:**
- "This has been in progress for 6 days. Is there something blocking it that I can help with?"
- "The PR has been open for 4 days with no reviewers yet. Would it help if I flag it to the team?"
- "I see {blocker_id} is still open. Is that still the main blocker, or has the situation changed?"
- "No activity since {date}. Are there any open questions on this one?"

**Bad:**
- "This ticket hasn't been worked on." (accusatory, no question)
- "Just checking in on this." (generic, no context, no question)
- "Why is this still in progress?" (confrontational)
- "Please update this ticket." (demanding)

## Output Format

```
Ticket: {identifier}
Assignee: {name}
Primary Signal: {context signal used}

Message:
---
{assignee_first_name}, {Sentence 1: Context + Question}
{Sentence 2: Offer of help, if applicable}
{Sentence 3: Only if critical extra context}
---

Confidence: {High | Medium | Low}
Reason: {one-line justification}
```

If the assignee name is unknown, use "Hi" or omit the greeting. The message body must still lead with the question.

## Self-Evaluation Checklist

Before delivering, verify:

- [ ] **Question-first**: Does the first sentence contain a clear, answerable question?
- [ ] **Contextual**: Does the message reference at least one specific piece of ticket data?
- [ ] **Humble**: Read from the assignee's perspective. Would they feel helped or surveilled?
- [ ] **Concise**: Is the message 3 sentences or fewer?
- [ ] **No dashes**: Does the message contain zero dashes of any kind?
- [ ] **No anti-patterns**: Does it avoid all anti-patterns in the table above?

If any check fails, rewrite before returning.

## Error Handling

- **Sparse context**: If there is no PR, no links, no comments, use the fallback: "Is there anything blocking progress on this that hasn't been captured on the ticket?"
- **No assignee**: Address generically. Flag in the output that the ticket is unassigned.
- **Recent activity**: If the ticket was updated within 24h but still matches "stuck" criteria, prepend: "I see there was recent activity. Feel free to disregard if this is already moving."
