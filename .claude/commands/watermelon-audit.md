Run the Watermelon Auditor on the Project Mercury Sprint 42 data.

Read the agent prompt from agents/watermelon-auditor/prompt.md.
Read the sprint data from data/jira-sprint-42.json.
Read GitHub PRs from data/github-prs.json.
Read GitHub commits from data/github-commits.json.
Read CI builds from data/ci-builds.json.

Cross-reference Jira ticket statuses against GitHub activity to identify
discrepancies. Produce the watermelon audit report in the exact output
format specified in the prompt.

Note: If agents/watermelon-auditor/prompt.md does not exist yet, inform
the user that this agent is planned for H2 and is not yet available.
