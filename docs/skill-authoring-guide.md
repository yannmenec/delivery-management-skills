# Skill Authoring Guide

How to create a new delivery management skill for this library.

## Skill Structure

Every skill lives in its own directory under a category:

```
skills/{category}/{skill-name}/
├── SKILL.md        # The skill definition (required)
├── eval.md         # Evaluation rubric (recommended)
└── examples/       # Input/output examples (recommended)
    ├── input.md
    └── expected-output.md
```

## SKILL.md Format

### Frontmatter

YAML frontmatter defines machine-readable metadata:

```yaml
---
name: my-skill-name                    # kebab-case, unique
version: 1.0.0                         # semantic versioning
description: >                         # one-line, under 300 chars
  What this skill does and when to use it.
category: sprint-operations            # see categories below
trigger: When this skill should be invoked.
autonomy: supervised                   # autonomous | supervised | human-in-the-loop
portability: universal                 # universal | requires-integration
complexity: intermediate               # basic | intermediate | advanced
type: detection                        # detection | computation | generation | evaluation | enrichment | workflow
inputs:
  - name: input_name
    type: structured-text              # structured-text | number | text | boolean | list | json
    required: true
    default: null                      # optional
    description: What this input contains.
outputs:
  - name: output_name
    type: structured-text
    description: What this produces.
depends_on:                            # optional — skills this skill invokes in its Method
  - detect-stuck-tickets
  - compute-velocity
tools_optional:                        # optional
  - project-tracker
  - version-control
model_compatibility:                   # optional, defaults to all
  - claude
  - gpt-4
  - gemini
  - llama-3
---
```

### Categories

| Category | Purpose |
|----------|---------|
| `sprint-operations` | Sprint-level detection, computation, and health checks |
| `risk-management` | Risk identification, scoring, escalation |
| `reporting` | Report generation, formatting, audience adaptation |
| `planning` | PI/quarter planning, capacity, readiness assessment |
| `communication` | Message crafting for tickets, stakeholders, teams |
| `quality-gates` | Output validation and evaluation |
| `meeting-prep` | Meeting preparation, briefings, agendas |

### Body Sections

| Section | Required | Purpose |
|---------|----------|---------|
| `# Title` | Yes | Clear, descriptive title |
| `## When to Use` | Yes | Trigger scenarios in bullet form |
| `## Method` | Yes | Numbered steps the AI follows |
| `## Output Format` | Yes | Exact template for the output |
| `## Error Handling` | Yes | How to handle missing data, failures, edge cases |
| `## Integration Enhancement` | No | How live integrations improve the skill |

## Quality Checklist

Before submitting a skill, verify:

- [ ] **Frontmatter validates** against `skills/_schema/skill.schema.json`
- [ ] **Tool-agnostic**: No vendor-specific terms (use "project tracker" not "Jira", "version control" not "GitHub")
- [ ] **Works without integration**: Can be used with manually provided data
- [ ] **Method is step-by-step**: Numbered steps, each verifiable
- [ ] **Output format is specific**: Template with placeholders, not vague description
- [ ] **Error handling covers edge cases**: Missing data, empty results, unavailable enrichment
- [ ] **No fabrication instructions**: Skill explicitly tells the agent to say "data unavailable" rather than guess
- [ ] **Confidence mentioned**: Output format includes confidence level
- [ ] **Self-check compatible**: Output can pass the 5-check self-check skill

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Bad | Do This Instead |
|-------------|-------------|----------------|
| Vague method ("analyze the data") | Agent has no clear steps to follow | Numbered steps with specific actions |
| No output template | Every run produces different structure | Exact template with placeholders |
| Assuming integrations | Breaks for users without Jira/GitHub | "If {tool} is available... otherwise, use the provided data" |
| Generic recommendations | "Follow up on blockers" helps no one | "Escalate HRZ-403 — blocked 4 days, 8 SP at risk" |
| No error handling | Agent hallucinates when data is missing | Explicit fallbacks and "data unavailable" notes |
| Vendor-specific terms | Reduces portability | Abstract terminology |

## Naming Conventions

- **Directory name**: `kebab-case` (e.g., `detect-stuck-tickets`)
- **Frontmatter name**: Same as directory name
- **Verbs**: `detect-*`, `compute-*`, `assess-*`, `generate-*`, `craft-*`, `format-*`, `evaluate-*`
- **Be specific**: `detect-stuck-tickets` not `check-tickets`

## Versioning

Use semantic versioning:
- **Major** (2.0.0): Output format changes (breaking for downstream consumers)
- **Minor** (1.1.0): New capability added (e.g., new detection layer)
- **Patch** (1.0.1): Wording improvement, bug fix, clarification

## Testing Your Skill

1. Create a test case in `evals/test-cases/` with known input and expected output
2. Run the skill against the test input using your AI tool
3. Compare output against expected results
4. Run `self-check` on the output — all 5 checks should pass
5. For high-stakes skills, create an `eval.md` rubric and score the output
