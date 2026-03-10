# ADR-002: Tool-Agnostic Core with Adapter Layer

## Status

Accepted

## Context

AI coding assistants have incompatible conventions:

- **Cursor**: `.cursor/skills/`, `.cursor/rules/`, `.cursor/agents/`, MCP tools
- **Claude Code**: `CLAUDE.md` project instructions, MCP tools
- **Codex**: `AGENTS.md`, instruction files
- **Windsurf**: `.windsurfrules`, cascades

A skill library locked to one tool excludes users of all others. A library that tries to support every tool's native format in the core becomes unmaintainable.

## Decision

The **core skill library** (`skills/`, `workflows/`, `patterns/`) is tool-agnostic. It contains no tool-specific syntax, directives, or file structure.

Tool-specific support lives in the **adapter layer** (`adapters/`). Each adapter is a thin translation layer that maps skills into the target tool's native format. Adapters contain install scripts and generated configuration files, not delivery management logic.

## Consequences

- **Positive**: Skills are written once, usable everywhere. Adding a new tool requires only a new adapter, not rewriting skills.
- **Positive**: The core library is stable even as tools change their conventions.
- **Negative**: Users must run an adapter install step rather than just cloning into `.cursor/skills/`. Mitigated by one-command install scripts.
- **Negative**: Some tool-specific features (e.g., Cursor's MCP allowlisting) cannot be expressed in the core. These are documented in the adapter README as tool-specific setup steps.
