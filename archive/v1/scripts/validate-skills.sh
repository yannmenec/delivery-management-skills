#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
SCHEMA="$REPO_ROOT/skills/_schema/skill.schema.json"
README="$REPO_ROOT/README.md"
CLAUDE_ADAPTER="$REPO_ROOT/adapters/claude-code/CLAUDE.md"
CURSOR_AGENT="$REPO_ROOT/adapters/cursor/agents/delivery-agent.md"

ERRORS=0
WARNINGS=0
SKILL_COUNT=0

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

error() { echo -e "${RED}ERROR${NC}: $1"; ((ERRORS++)); }
warn()  { echo -e "${YELLOW}WARN${NC}:  $1"; ((WARNINGS++)); }
ok()    { echo -e "${GREEN}OK${NC}:    $1"; }

VALID_CATEGORIES="sprint-operations risk-management reporting planning quality-gates communication meeting-prep"
VALID_AUTONOMY="autonomous supervised human-in-the-loop"
VALID_PORTABILITY="universal requires-integration"
VALID_COMPLEXITY="basic intermediate advanced"
VALID_TYPES="detection computation generation evaluation enrichment workflow"
REQUIRED_FIELDS="name version description category autonomy portability complexity type"

echo "============================================"
echo "  Delivery Management Skills — Validator"
echo "============================================"
echo ""

# --- Phase 1: Discover skills ---
echo "--- Phase 1: Skill Discovery ---"
SKILL_FILES=()
while IFS= read -r -d '' f; do
    SKILL_FILES+=("$f")
done < <(find "$SKILLS_DIR" -name "SKILL.md" -not -path "*/_schema/*" -print0 | sort -z)

SKILL_COUNT=${#SKILL_FILES[@]}
echo "Found $SKILL_COUNT skills"
echo ""

# --- Phase 2: Validate each skill ---
echo "--- Phase 2: Skill Validation ---"

SKILL_NAMES=()

for skill_file in "${SKILL_FILES[@]}"; do
    rel_path="${skill_file#$REPO_ROOT/}"
    skill_dir="$(basename "$(dirname "$skill_file")")"

    # Extract frontmatter (between first and second ---)
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_file" | sed '1d;$d')
    if [ -z "$frontmatter" ]; then
        error "$rel_path: No YAML frontmatter found"
        continue
    fi

    # Helper: extract simple scalar value from frontmatter
    get_field() {
        echo "$frontmatter" | grep -E "^${1}:" | head -1 | sed "s/^${1}:[[:space:]]*//" | sed 's/^"\(.*\)"$/\1/' | sed "s/^'\(.*\)'$/\1/"
    }

    # Check required fields
    for field in $REQUIRED_FIELDS; do
        val=$(get_field "$field")
        if [ -z "$val" ]; then
            error "$rel_path: Missing required field '$field'"
        fi
    done

    name=$(get_field "name")
    version=$(get_field "version")
    description=$(get_field "description")
    category=$(get_field "category")
    autonomy=$(get_field "autonomy")
    portability=$(get_field "portability")
    complexity=$(get_field "complexity")
    type_val=$(get_field "type")

    if [ -n "$name" ]; then
        SKILL_NAMES+=("$name")

        # Name pattern check
        if ! echo "$name" | grep -qE '^[a-z][a-z0-9-]+$'; then
            error "$rel_path: name '$name' does not match pattern ^[a-z][a-z0-9-]+$"
        fi

        # Name matches directory name
        if [ "$name" != "$skill_dir" ]; then
            warn "$rel_path: name '$name' does not match directory '$skill_dir'"
        fi
    fi

    # Version pattern check
    if [ -n "$version" ] && ! echo "$version" | grep -qE '^\d+\.\d+\.\d+$'; then
        # macOS grep may not support \d
        if ! echo "$version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
            error "$rel_path: version '$version' does not match semver pattern"
        fi
    fi

    # Description length check
    if [ -n "$description" ]; then
        desc_len=${#description}
        if [ "$desc_len" -gt 300 ]; then
            error "$rel_path: description length ($desc_len) exceeds 300 characters"
        fi
    fi

    # Enum checks
    if [ -n "$category" ]; then
        if ! echo "$VALID_CATEGORIES" | grep -qw "$category"; then
            error "$rel_path: category '$category' not in allowed values"
        fi
    fi

    if [ -n "$autonomy" ]; then
        if ! echo "$VALID_AUTONOMY" | grep -qw "$autonomy"; then
            error "$rel_path: autonomy '$autonomy' not in allowed values"
        fi
    fi

    if [ -n "$portability" ]; then
        if ! echo "$VALID_PORTABILITY" | grep -qw "$portability"; then
            error "$rel_path: portability '$portability' not in allowed values"
        fi
    fi

    if [ -n "$complexity" ]; then
        if ! echo "$VALID_COMPLEXITY" | grep -qw "$complexity"; then
            error "$rel_path: complexity '$complexity' not in allowed values"
        fi
    fi

    if [ -n "$type_val" ]; then
        if ! echo "$VALID_TYPES" | grep -qw "$type_val"; then
            error "$rel_path: type '$type_val' not in allowed values"
        fi
    fi

    # Check for inputs/outputs arrays (at least the key must be present)
    if ! echo "$frontmatter" | grep -q "^inputs:"; then
        error "$rel_path: Missing 'inputs' field"
    fi
    if ! echo "$frontmatter" | grep -q "^outputs:"; then
        error "$rel_path: Missing 'outputs' field"
    fi

    # Structural checks on the body (everything after the closing --- of frontmatter)
    body=$(awk 'BEGIN{c=0} /^---$/{c++; if(c==2){found=1; next}} found{print}' "$skill_file")

    if ! echo "$body" | grep -q "^## When to Use"; then
        error "$rel_path: Missing '## When to Use' section"
    fi

    if ! echo "$body" | grep -q "^## Method"; then
        error "$rel_path: Missing '## Method' section"
    fi

    if ! echo "$body" | grep -q "^## Output Format"; then
        error "$rel_path: Missing '## Output Format' section"
    fi

    if ! echo "$body" | grep -q "^## Error Handling"; then
        error "$rel_path: Missing '## Error Handling' section"
    fi

    # Check model_compatibility uses multi-line format
    if echo "$frontmatter" | grep -qE '^model_compatibility: \['; then
        warn "$rel_path: model_compatibility uses inline array format; prefer multi-line"
    fi

    ok "$rel_path"
done

echo ""

# --- Phase 3: depends_on resolution ---
echo "--- Phase 3: Dependency Resolution ---"
for skill_file in "${SKILL_FILES[@]}"; do
    rel_path="${skill_file#$REPO_ROOT/}"
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_file" | sed '1d;$d')

    # Extract depends_on entries
    in_depends=false
    while IFS= read -r line; do
        if echo "$line" | grep -q "^depends_on:"; then
            in_depends=true
            continue
        fi
        if $in_depends; then
            if echo "$line" | grep -qE '^  - '; then
                dep=$(echo "$line" | sed 's/^  - //')
                found=false
                for sn in "${SKILL_NAMES[@]}"; do
                    if [ "$sn" = "$dep" ]; then
                        found=true
                        break
                    fi
                done
                if ! $found; then
                    error "$rel_path: depends_on references non-existent skill '$dep'"
                fi
            else
                in_depends=false
            fi
        fi
    done <<< "$frontmatter"
done
ok "Dependency resolution complete"
echo ""

# --- Phase 4: Count consistency ---
echo "--- Phase 4: Count Consistency ---"

# Check README badge
readme_count=$(grep -oE 'skills-[0-9]+' "$README" | head -1 | grep -oE '[0-9]+')
if [ -n "$readme_count" ] && [ "$readme_count" -ne "$SKILL_COUNT" ]; then
    error "README badge says $readme_count skills, but found $SKILL_COUNT"
else
    ok "README badge count matches ($SKILL_COUNT)"
fi

# Check README "At a Glance"
glance_count=$(grep -oE '\*\*[0-9]+ skills\*\*' "$README" | grep -oE '[0-9]+')
if [ -n "$glance_count" ] && [ "$glance_count" -ne "$SKILL_COUNT" ]; then
    error "README 'At a Glance' says $glance_count skills, but found $SKILL_COUNT"
else
    ok "README 'At a Glance' count matches ($SKILL_COUNT)"
fi

# Check Claude adapter skill count (count lines with delivery-skills/ path)
if [ -f "$CLAUDE_ADAPTER" ]; then
    claude_skill_count=$(grep -cE '^\- `delivery-skills/.+/`' "$CLAUDE_ADAPTER" || true)
    if [ "$claude_skill_count" -ne "$SKILL_COUNT" ]; then
        error "Claude adapter lists $claude_skill_count skills, but found $SKILL_COUNT"
    else
        ok "Claude adapter skill count matches ($SKILL_COUNT)"
    fi
fi

# Check all skill names appear in Cursor agent routing or general presence
if [ -f "$CURSOR_AGENT" ]; then
    ok "Cursor agent file exists"
fi

echo ""

# --- Phase 5: Workflow validation ---
echo "--- Phase 5: Workflow Validation ---"
WORKFLOW_DIR="$REPO_ROOT/workflows"
if [ -d "$WORKFLOW_DIR" ]; then
    for wf in "$WORKFLOW_DIR"/*.md; do
        wf_rel="${wf#$REPO_ROOT/}"
        wf_frontmatter=$(sed -n '/^---$/,/^---$/p' "$wf" | sed '1d;$d')

        # Extract skills_used
        in_skills=false
        while IFS= read -r line; do
            if echo "$line" | grep -q "^skills_used:"; then
                in_skills=true
                continue
            fi
            if $in_skills; then
                if echo "$line" | grep -qE '^  - '; then
                    skill_ref=$(echo "$line" | sed 's/^  - //')
                    found=false
                    for sn in "${SKILL_NAMES[@]}"; do
                        if [ "$sn" = "$skill_ref" ]; then
                            found=true
                            break
                        fi
                    done
                    if ! $found; then
                        error "$wf_rel: skills_used references non-existent skill '$skill_ref'"
                    fi
                else
                    in_skills=false
                fi
            fi
        done <<< "$wf_frontmatter"

        ok "$wf_rel"
    done
fi
echo ""

# --- Summary ---
echo "============================================"
echo "  Validation Summary"
echo "============================================"
echo "  Skills found:  $SKILL_COUNT"
echo "  Errors:        $ERRORS"
echo "  Warnings:      $WARNINGS"
echo "============================================"

if [ "$ERRORS" -gt 0 ]; then
    echo -e "${RED}FAILED${NC}: $ERRORS error(s) found. Fix before merging."
    exit 1
else
    echo -e "${GREEN}PASSED${NC}: All checks passed."
    exit 0
fi
