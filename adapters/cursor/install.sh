#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

WORKSPACE="${1:-.}"
WORKSPACE="$(cd "$WORKSPACE" && pwd)"

echo "Installing Delivery Management Skills into: $WORKSPACE"
echo "Source: $REPO_ROOT"
echo ""

mkdir -p "$WORKSPACE/.cursor/skills"
mkdir -p "$WORKSPACE/.cursor/rules"
mkdir -p "$WORKSPACE/.cursor/agents"

SKILL_COUNT=0
for category_dir in "$REPO_ROOT/skills"/*/; do
    category="$(basename "$category_dir")"
    [ "$category" = "_schema" ] && continue

    for skill_dir in "$category_dir"*/; do
        skill="$(basename "$skill_dir")"
        target="$WORKSPACE/.cursor/skills/$skill"

        if [ -L "$target" ]; then
            rm "$target"
        elif [ -d "$target" ]; then
            echo "  SKIP: $target already exists (not a symlink). Remove manually to update."
            continue
        fi

        ln -s "$skill_dir" "$target"
        SKILL_COUNT=$((SKILL_COUNT + 1))
    done
done

for rule_file in "$SCRIPT_DIR/rules/"*.mdc; do
    [ -f "$rule_file" ] || continue
    target="$WORKSPACE/.cursor/rules/$(basename "$rule_file")"
    if [ -L "$target" ]; then
        rm "$target"
    fi
    ln -s "$rule_file" "$target"
done

for agent_file in "$SCRIPT_DIR/agents/"*.md; do
    [ -f "$agent_file" ] || continue
    target="$WORKSPACE/.cursor/agents/$(basename "$agent_file")"
    if [ -L "$target" ]; then
        rm "$target"
    fi
    ln -s "$agent_file" "$target"
done

echo "Installed $SKILL_COUNT skills"
echo "Reload Cursor (Cmd+Shift+P > 'Reload Window') to pick up changes."
