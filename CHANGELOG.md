# Changelog

## [2.2.0] - 2026-03-13

### Added
- **Blocker Detective** agent — surfaces stuck PRs, failing CI, stale work, 
  and developer overload before standup with suggested standup agenda 
  (`agents/blocker-detective/`)
- Claude Code command for blocker-detective (`.claude/commands/blocker-detective.md`)

## [2.1.0] - 2026-03-13

### Added
- **Watermelon Auditor** agent — cross-references Jira ticket status against 
  GitHub activity to detect false "Green" reporting and produce a Trust Score 
  (`agents/watermelon-auditor/`)
- Claude Code command for watermelon-audit (`.claude/commands/watermelon-audit.md`)

### Changed
- Updated Claude Code watermelon-audit command with L1/L2 mode support

## [2.0.0] - 2026-03-12

### Changed
- Complete repo restructure: agent-centric architecture (ADR-001)
- V1 content archived to `archive/v1/`

### Added
- Realistic sample datasets for Project Mercury (2 sprints, 6 data files)
- MCP configuration templates (Atlassian, GitHub, Slack)
- Shared library: parsers and formatters as prompt fragments
- Architecture Decision Records
- Documentation: frustrations reference, research summary

### Removed
- Flat skill structure (replaced by agent packages)
