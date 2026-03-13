# Contributing to delivery-management-skills

Thanks for your interest in contributing! This toolkit is built for 
Delivery Managers, by Delivery Managers.

## Before You Start

Every contribution must map to one of the 5 validated delivery 
frustrations. If it doesn't solve a real problem, it doesn't belong here.

Read [STRATEGY.md](STRATEGY.md) for the full project philosophy, 
architecture decisions, and quality standards.

## Adding a New Agent

1. **Write a Problem Card** — Which frustration does it target? Which 
   roles? What data does it need? See `docs/frustrations.md` for the 
   reference list.

2. **Build L1 first** — Every agent must work in paste mode (copy data 
   + prompt into any AI chat) before getting MCP or orchestration features.

3. **Test on sample data** — If it doesn't produce a compelling output 
   on the Project Mercury data in `data/`, it's not ready.

4. **Keep it portable** — The prompt must work on at least 2 different 
   LLMs (Claude, GPT-4, Gemini). No vendor-specific syntax.

5. **Follow the standard structure:**
   ```
   agents/your-agent/
   ├── README.md          # Product page
   ├── prompt.md          # The portable prompt
   ├── config.yaml        # Metadata + tunable parameters
   └── examples/
       ├── sample-input.md   # Data to paste
       └── sample-output.md  # Expected result
   ```

6. **Match the quality bar** — Use `agents/watermelon-auditor/` as the 
   reference for prompt quality, README structure, and config schema.

## Improving Existing Agents

- Bug fixes and corrections: submit a PR with a clear description
- Prompt improvements: test on sample data AND at least 2 LLMs before submitting
- New data patterns: add to `data/` with cross-reference integrity preserved

## What We Will NOT Build

See [STRATEGY.md — What We Will NOT Build](STRATEGY.md#what-we-will-not-build) 
for explicitly rejected ideas and the reasoning behind each rejection.

## Code of Conduct

Be helpful. Be honest. Be kind. This project serves practitioners who are 
too busy to deal with drama.
