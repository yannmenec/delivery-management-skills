# Human Approval Gate

## What It Is

The **human approval gate** pattern encodes when agent output requires human review before any external action. Reads (queries, analysis, reports) are safe to run autonomously; writes (posting comments, updating boards, sending messages) need explicit human approval. The `autonomy` field in skill metadata formalizes this.

```
    ┌─────────────────────────────────────────────────────────────────┐
    │                     SKILL EXECUTION                             │
    └─────────────────────────────────────────────────────────────────┘
                                       │
                    ┌──────────────────┼──────────────────┐
                    │                  │                  │
                    ▼                  ▼                  ▼
            ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
            │  autonomous  │  │  supervised  │  │ human-in-the │
            │              │  │              │  │    loop      │
            │ No approval  │  │ Human        │  │ Human        │
            │ needed       │  │ reviews      │  │ approves     │
            │              │  │ output       │  │ before       │
            │ (reads,      │  │ before       │  │ any action   │
            │  analysis)   │  │ sharing      │  │ (posts,      │
            │              │  │              │  │  updates)    │
            └──────────────┘  └──────────────┘  └──────────────┘
```

## Why It Matters

- **Read vs write classification**: Reads (Jira search, velocity computation, stuck-ticket detection) cannot corrupt external state. Writes (add comment, transition ticket, send Slack message) can—they need a gate.
- **Progressive trust**: Start conservative. As confidence builds (correct outputs, no incidents), autonomy can be relaxed. Never relax without evidence.
- **Accountability**: The Delivery Manager remains responsible for what gets posted. The agent proposes; the human disposes.

## How It Works

### Three Autonomy Levels

| Level | Meaning | Example |
|-------|---------|---------|
| **autonomous** | No approval needed. Output can be delivered as-is. | `self-check`, `evaluate-output`, `compute-velocity` |
| **supervised** | Human reviews output before sharing. No external write yet. | `detect-stuck-tickets`, `detect-ghost-done`, `sprint-health-check` |
| **human-in-the-loop** | Human must approve before any action. Output is a draft. | `craft-unblock-message`, `craft-close-message` |

### Read vs Write

- **Read**: Search, fetch, compute, analyze, format. Safe to run without approval.
- **Write**: Add comment, transition status, create ticket, post to Slack, update board. Requires human-in-the-loop.

### Skill Metadata

The `autonomy` field is required in `skills/_schema/skill.schema.json`:

```yaml
autonomy: autonomous | supervised | human-in-the-loop
```

- **autonomous**: "No approval needed."
- **supervised**: "Human reviews output."
- **human-in-the-loop**: "Human approves before any action."

## When to Use It

| Skill Type | Typical Autonomy |
|------------|------------------|
| Detection, computation, evaluation | autonomous or supervised |
| Report generation | supervised (human reviews before sharing) |
| Message drafting (comments, Slack) | human-in-the-loop |
| Any skill that triggers an external write | human-in-the-loop |

## How It Appears in This Repo

- **`skills/_schema/skill.schema.json`**: `autonomy` is a required enum: `autonomous`, `supervised`, `human-in-the-loop`.
- **`skills/sprint-operations/detect-stuck-tickets/SKILL.md`**: `autonomy: supervised` — generates output, human reviews before acting.
- **`skills/communication/craft-unblock-message/SKILL.md`**: `autonomy: human-in-the-loop` — generates the message; the DM decides whether to post it to the ticket.
- **`skills/communication/craft-close-message/SKILL.md`**: Same pattern—draft comment for ghost-done tickets, human posts.
- **`skills/sprint-operations/sprint-health-check/SKILL.md`**: `autonomy: supervised` — composite orchestrator; human reviews the full report.

**Example flow**: `detect-stuck-tickets` (supervised) identifies PROJ-123 as stuck. The DM reviews. They invoke `craft-unblock-message` (human-in-the-loop) with PROJ-123 context. The skill produces a draft comment. The DM edits if needed and posts—or does not post.

## Pitfalls

- **Gate bypass**: Ensure the runtime (adapter, agent framework) respects the autonomy field. A skill marked human-in-the-loop must not auto-post.
- **Over-gating**: Don't mark every skill human-in-the-loop. Detection and computation are low-risk; only writes need the strictest gate.
- **Unclear handoff**: When human-in-the-loop, the output must be clearly a "draft" or "ready to post"—the human must know exactly what action they're approving.
- **Escalation path**: `craft-escalation-memo` is also human-in-the-loop. Escalation memos can have significant impact; the DM must approve before sending. Same principle: generate the content, human decides whether to send.
