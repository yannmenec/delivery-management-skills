# Control Plane

## What It Is

The **control plane** pattern exposes a single high-level tool interface to the model while encapsulating modular routing logic internally. Instead of exposing 20 individual skills as 20 separate tools, a control plane exposes one "delivery scan" entry point that routes to the appropriate skills based on intent.

```
    ┌──────────────┐
    │   USER       │
    │   REQUEST    │
    └──────┬───────┘
           │
           ▼
    ┌──────────────────────────────────┐
    │         CONTROL PLANE            │
    │  (single tool interface)         │
    │                                  │
    │  ┌────────┐ ┌────────┐ ┌──────┐ │
    │  │ detect │ │compute │ │assess│ │
    │  │ stuck  │ │velocity│ │ risk │ │
    │  └────────┘ └────────┘ └──────┘ │
    │  ┌────────┐ ┌────────┐ ┌──────┐ │
    │  │ ghost  │ │ scope  │ │format│ │
    │  │ done   │ │ change │ │      │ │
    │  └────────┘ └────────┘ └──────┘ │
    └──────────────────────────────────┘
```

## Why It Matters

- **Tool sprawl**: Models perform worse when presented with 20+ tools. Decision quality degrades as the tool list grows. A single control plane entry point reduces cognitive load.
- **Routing intelligence**: The control plane can analyze intent and select the right skills, rather than relying on the model to know which of 20 tools to call.
- **Extensibility**: Adding a new skill requires updating the control plane's routing logic, not re-training the model's tool understanding.

## When to Use

- When an agent has **10+ skills** available and the model struggles to select the right one
- When you want to **compose skills** without requiring the model to understand composition
- When building an **adapter** that presents a clean interface to a specific AI tool

Do NOT use when the user wants to invoke a specific skill directly — control planes are for intent-based routing, not forced indirection.

## How It Works

### Intent Analysis

The control plane receives the user's request and classifies it:

| Intent Signal | Routes To |
|--------------|-----------|
| "what's stuck" / "blockers" | detect-stuck-tickets |
| "sprint report" / "how are we doing" | sprint-health-check or generate-sprint-report |
| "velocity" / "how fast" | compute-velocity |
| "risks" / "what could go wrong" | assess-risk |
| "morning scan" / "what needs attention" | morning-scan workflow |
| "escalate" / "draft escalation" | craft-escalation-memo |

### Skill Execution

The control plane invokes the selected skill(s) with the available data, collects results, and returns a unified response.

### Composition

For workflow-level intents (e.g., "morning scan"), the control plane orchestrates multiple skills in the correct sequence, handling data flow between them.

## How It Appears in This Repo

- **`adapters/cursor/agents/delivery-agent.md`**: The Cursor adapter's delivery agent acts as a control plane — it analyzes the user's request and routes to the appropriate skill or workflow.
- **`workflows/morning-scan.md`**: A composed workflow that the control plane can invoke as a single unit.
- **Skill metadata**: The `category`, `type`, and `trigger` fields enable intelligent routing.

## Pitfalls

- **Over-abstraction**: If the control plane hides too much, users cannot invoke specific skills when they want to. Always allow direct skill invocation as an alternative.
- **Routing errors**: Misclassified intent routes to the wrong skill. Mitigate by asking for clarification when intent is ambiguous.
- **Single point of failure**: If the control plane errors, all skills become unavailable. Ensure the control plane fails gracefully and allows fallback to direct invocation.
- **Stale routing**: As new skills are added, the routing table must be updated. An outdated routing table means new skills are never invoked.
