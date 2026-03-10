#!/usr/bin/env bash
# Requires Bash. On Windows, use WSL or Git Bash.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

WORKSPACE="${1:-.}"
WORKSPACE="$(cd "$WORKSPACE" && pwd)"

echo "Uninstalling Delivery Management Skills from: $WORKSPACE"

REMOVED=0
for category_dir in "$REPO_ROOT/skills"/*/; do
    category="$(basename "$category_dir")"
    [ "$category" = "_schema" ] && continue
    for skill_dir in "$category_dir"*/; do
        skill="$(basename "$skill_dir")"
        target="$WORKSPACE/.cursor/skills/$skill"
        if [ -L "$target" ]; then rm "$target"; REMOVED=$((REMOVED + 1)); fi
    done
done

for rule_file in "$SCRIPT_DIR/rules/"*.mdc; do
    [ -f "$rule_file" ] || continue
    target="$WORKSPACE/.cursor/rules/$(basename "$rule_file")"
    if [ -L "$target" ]; then rm "$target"; fi
done

for agent_file in "$SCRIPT_DIR/agents/"*.md; do
    [ -f "$agent_file" ] || continue
    target="$WORKSPACE/.cursor/agents/$(basename "$agent_file")"
    if [ -L "$target" ]; then rm "$target"; fi
done

for wf_file in "$REPO_ROOT/workflows/"*.md; do
    [ -f "$wf_file" ] || continue
    target="$WORKSPACE/.cursor/workflows/$(basename "$wf_file")"
    if [ -L "$target" ]; then rm "$target"; fi
done

echo "Removed $REMOVED skill symlinks and associated rules, agents, and workflows."
