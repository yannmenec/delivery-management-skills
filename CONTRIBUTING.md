# Contributing

Thank you for considering a contribution to Delivery Management Skills.

## What We Welcome

- **New skills** following the [skill authoring guide](docs/skill-authoring-guide.md)
- **New adapters** for AI tools not yet supported (Codex, Windsurf, etc.)
- **Evaluation test cases** and rubrics
- **Bug reports** and quality improvements
- **Documentation** improvements

## How to Contribute

### For Skills

1. Read the [skill authoring guide](docs/skill-authoring-guide.md)
2. Create your skill in the appropriate category under `skills/`
3. Run the validation script: `bash scripts/validate-skills.sh` — it must pass with 0 errors
4. Include at least one example (input + expected output)
5. Run the `self-check` skill against your skill's output
6. Open a pull request with a clear description of the skill's purpose

### Validation Script

Run `bash scripts/validate-skills.sh` before every PR. It checks:

- YAML frontmatter presence and required fields
- Field values match schema enums (category, autonomy, portability, complexity, type)
- Name pattern and directory name consistency
- Version follows semver
- Description length within limit
- Required body sections present (`## When to Use`, `## Method`, `## Output Format`, `## Error Handling`)
- `model_compatibility` uses multi-line format
- `depends_on` references resolve to existing skills
- Skill counts match README and adapters
- Workflow `skills_used` references resolve to existing skills

### For Adapters

1. Create a directory under `adapters/{tool-name}/`
2. Include a `README.md` with installation instructions
3. Include an `install.sh` script
4. Map the skill library into the tool's native format
5. Test with at least 3 skills end-to-end

### For Bug Reports

1. Open an issue describing:
   - Which skill or workflow
   - What input you provided
   - What output you expected
   - What output you got
   - Which AI tool and model you used

## Quality Bar

We maintain a high quality bar. Contributions will be reviewed for:

- **Tool-agnosticism**: No vendor-specific terms in core skills
- **Specificity**: Concrete methods, not vague instructions
- **Completeness**: Output format, error handling, and confidence level all present
- **Originality**: Not copied from proprietary systems
- **Usefulness**: Solves a real delivery management problem

## Code of Conduct

Be professional, constructive, and respectful. This is a technical project — focus on the work, not the person.

## License

By contributing, you agree that your contributions will be licensed under the project's [Apache 2.0 license](LICENSE).
