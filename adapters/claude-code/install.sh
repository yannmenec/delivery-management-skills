#!/usr/bin/env bash
# Requires Bash. On Windows, use WSL or Git Bash.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

WORKSPACE="${1:-.}"
WORKSPACE="$(cd "$WORKSPACE" && pwd)"

echo "Installing Delivery Management Skills for Claude Code into: $WORKSPACE"
echo "Source: $REPO_ROOT"
echo ""

if [ -f "$WORKSPACE/CLAUDE.md" ]; then
    echo "WARNING: CLAUDE.md already exists at $WORKSPACE/CLAUDE.md"
    echo "The delivery skills instructions will be appended to the existing file."
    echo ""
    echo "---" >> "$WORKSPACE/CLAUDE.md"
    echo "" >> "$WORKSPACE/CLAUDE.md"
    cat "$SCRIPT_DIR/CLAUDE.md" >> "$WORKSPACE/CLAUDE.md"
else
    cp "$SCRIPT_DIR/CLAUDE.md" "$WORKSPACE/CLAUDE.md"
fi

mkdir -p "$WORKSPACE/delivery-skills"

SKILL_COUNT=0
for category_dir in "$REPO_ROOT/skills"/*/; do
    category="$(basename "$category_dir")"
    [ "$category" = "_schema" ] && continue

    mkdir -p "$WORKSPACE/delivery-skills/$category"

    for skill_dir in "$category_dir"*/; do
        skill="$(basename "$skill_dir")"
        target="$WORKSPACE/delivery-skills/$category/$skill"

        if [ -L "$target" ]; then
            rm "$target"
        elif [ -d "$target" ]; then
            echo "  SKIP: $target exists (not a symlink)"
            continue
        fi

        ln -s "$skill_dir" "$target"
        SKILL_COUNT=$((SKILL_COUNT + 1))
    done
done

mkdir -p "$WORKSPACE/delivery-skills/workflows"
for workflow_file in "$REPO_ROOT/workflows/"*.md; do
    [ -f "$workflow_file" ] || continue
    target="$WORKSPACE/delivery-skills/workflows/$(basename "$workflow_file")"
    if [ -L "$target" ]; then rm "$target"; fi
    ln -s "$workflow_file" "$target"
done

echo "Installed $SKILL_COUNT skills + workflows"
echo "CLAUDE.md configured at $WORKSPACE/CLAUDE.md"
echo ""
echo "Start using: claude 'What is stuck in our sprint?'"
