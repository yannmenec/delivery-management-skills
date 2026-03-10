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

MARKER="# --- agentic-delivery ---"

if [ -f "$WORKSPACE/CLAUDE.md" ] && grep -q "$MARKER" "$WORKSPACE/CLAUDE.md"; then
    echo "Delivery skills already present in CLAUDE.md — skipping (idempotent)."
elif [ -f "$WORKSPACE/CLAUDE.md" ]; then
    echo "Appending delivery skills instructions to existing CLAUDE.md."
    echo "" >> "$WORKSPACE/CLAUDE.md"
    echo "$MARKER" >> "$WORKSPACE/CLAUDE.md"
    echo "" >> "$WORKSPACE/CLAUDE.md"
    cat "$SCRIPT_DIR/CLAUDE.md" >> "$WORKSPACE/CLAUDE.md"
else
    echo "$MARKER" > "$WORKSPACE/CLAUDE.md"
    echo "" >> "$WORKSPACE/CLAUDE.md"
    cat "$SCRIPT_DIR/CLAUDE.md" >> "$WORKSPACE/CLAUDE.md"
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

if [ -d "$REPO_ROOT/integrations/mock" ]; then
    target="$WORKSPACE/delivery-skills/mock"
    if [ -L "$target" ]; then rm "$target"; fi
    ln -s "$REPO_ROOT/integrations/mock" "$target"
fi

echo "Installed $SKILL_COUNT skills + workflows + mock data"
echo "CLAUDE.md configured at $WORKSPACE/CLAUDE.md"
echo ""
echo "Start using: claude 'What is stuck in our sprint?'"
