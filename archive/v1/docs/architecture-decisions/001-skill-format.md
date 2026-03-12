# ADR-001: Structured Markdown as Skill Format

## Status

Accepted

## Context

We need a format for encoding delivery management skills that is:

1. Readable by any LLM without preprocessing
2. Editable by humans in any text editor
3. Parseable by tooling for validation and metadata extraction
4. Portable across AI coding assistants (Cursor, Claude Code, Codex)

Options considered: JSON, YAML, Python classes, plain markdown, structured markdown with YAML frontmatter.

## Decision

Each skill is a **SKILL.md** file using **YAML frontmatter** for machine-readable metadata and **structured markdown sections** for the skill body.

Frontmatter fields follow the schema defined in `skills/_schema/skill.schema.json` and include: name, version, description, category, autonomy level, portability, complexity, input/output contracts, and optional tool dependencies.

Body sections follow a fixed structure: When to Apply, Input, Output, Method, Output Format, Error Handling.

## Consequences

- **Positive**: Any AI assistant can read the skill directly. No parsing library needed. Version control diffs are clean. Contributors need only markdown knowledge.
- **Positive**: YAML frontmatter enables automated validation, catalog generation, and adapter translation.
- **Negative**: No runtime type checking on inputs/outputs. Mitigated by evaluation rubrics and test cases.
- **Negative**: Markdown is less strict than code — a skill could have structural issues that pass linting. Mitigated by the JSON Schema for frontmatter and the skill authoring guide.
