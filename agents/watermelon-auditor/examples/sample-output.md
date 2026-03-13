## Watermelon Audit — Sprint 42

**Audit date:** March 12, 2026
**Data sources:** Jira Sprint Data, GitHub PRs, GitHub Commits, CI Builds

### Trust Score: 57% — Critical

**8** of **14** auditable tickets are backed by GitHub activity.

| Classification | Count | Tickets |
|----------------|-------|---------|
| VERIFIED | 5 | MERC-220, MERC-222, MERC-223, MERC-225, MERC-228 |
| ACTIVE | 3 | MERC-230, MERC-231, MERC-232 |
| WATERMELON | 3 | MERC-221, MERC-224, MERC-227 |
| STALE | 2 | MERC-226, MERC-233 |
| AT RISK | 1 | MERC-234 |
| UNLINKED | 0 | — |
| NON-CODE | 0 | — |
| Excluded (To Do / Blocked) | 6 | MERC-229, MERC-235, MERC-236, MERC-237, MERC-238, MERC-239 |

### Watermelons

**MERC-221**: Migrate recurring billing module
- **Jira status:** Done
- **GitHub reality:** No PR, no branch, no commits found matching MERC-221 across all 16 PRs, 50 commits, and all branch names
- **Assignee:** Marcus Johnson
- **Story points:** 5
- **Risk:** 5 SP counted as delivered velocity, but no code evidence exists. If the billing module migration wasn't actually completed, recurring billing features built on top of it will fail.
- **Action:** Review with Marcus whether this was completed outside of GitHub (e.g., configuration change, vendor portal update) or needs to be reopened.

**MERC-224**: Update API rate limiting for payment endpoints
- **Jira status:** Done
- **GitHub reality:** No PR, no branch, no commits found matching MERC-224 across all sources
- **Assignee:** Marcus Johnson
- **Story points:** 3
- **Risk:** 3 SP counted as delivered. Rate limiting is a security-critical feature — if not actually implemented, payment endpoints may be vulnerable to abuse or DDoS.
- **Action:** Review with Marcus. If rate limiting was configured in an API gateway or infrastructure layer (outside this repo), document the evidence. Otherwise, reopen the ticket.

**MERC-227**: Add PCI compliance headers to all responses
- **Jira status:** Done
- **GitHub reality:** No PR, no branch, no commits found matching MERC-227 across all sources
- **Assignee:** Tom Mueller
- **Story points:** 2
- **Risk:** PCI compliance audit is scheduled for next week (per Slack message from Kenji on March 10). If compliance headers are not actually in the codebase, the audit will fail. This was added mid-sprint specifically for the audit deadline.
- **Action:** Urgent — verify with Tom before the PCI auditor visit on Wednesday. Check the staging environment for the expected headers. If missing, this needs immediate development priority.

### Stale / At Risk

**MERC-226**: Refactor payment error handling
- **Jira status:** In Progress
- **GitHub reality:** PR #141 opened March 8, last commit `d0e1f2a` on March 8 at 11:30. Zero code reviews after 4 days. PR has 156 additions and 89 deletions — non-trivial change sitting idle.
- **Assignee:** Marcus Johnson
- **Days since last activity:** 4
- **Risk:** Work appears stalled. The refactor touches error handling across the payment module — without review and merge, other PRs may accumulate conflicts. Marcus has 6 other tickets competing for his attention.

**MERC-233**: Migrate settlement report generator
- **Jira status:** In Progress
- **GitHub reality:** PR #145 opened March 9, last commit `f2a3b4c` on March 9 at 10:00. Zero code reviews after 3 days. PR has 201 additions — substantial work with no feedback loop.
- **Assignee:** Marcus Johnson
- **Days since last activity:** 3
- **Risk:** Same pattern as MERC-226 — open PR, no reviews, developer context-switching across too many items. Settlement reports are needed for reconciliation (downstream of MERC-231).

**MERC-234**: Implement batch payment processor
- **Jira status:** In Progress
- **GitHub reality:** PR #150 open with active commits (last: `c9d0e1a` on March 12 at 13:00), but CI has been failing for 2 days. 4 consecutive build failures: build-4515, build-4520, build-4527, build-4531. Failing tests: `test_batch_size_validation`, `test_concurrent_batch_processing`, `test_batch_error_recovery`.
- **Assignee:** Marcus Johnson
- **Days since last activity:** 0 (active today)
- **Risk:** The developer is actively working, but the same core tests keep failing across builds — suggesting an architectural issue in the batch processing approach rather than a simple bug. This ticket blocks MERC-237 (currency conversion support, 5 SP). Sarah requested changes on March 11 that may not have been fully addressed.

### Unlinked Tickets

No In Progress or Done tickets are unlinked in this sprint — all active work has GitHub PR references.

**Notable excluded item:** MERC-229 (Integrate with external fraud detection API, Critical, 5 SP) is Blocked by external vendor FraudShield — sandbox pushed to March 24. No code work is possible until vendor provides access. Blocks MERC-238 downstream.

### Patterns Detected

- **Overloaded developer — Marcus Johnson**: 7 tickets assigned in Sprint 42, spanning Done (3), In Progress (3), and To Do (1). Of his 3 "Done" tickets, only 1 (MERC-228) is verified — the other 2 (MERC-221, MERC-224) have no code evidence. His 2 In Progress items (MERC-226, MERC-233) are stale with PRs that have zero reviews, and his third In Progress item (MERC-234) has persistent CI failures. This is the strongest signal in the audit: one developer is carrying too much work-in-progress, resulting in status updates that outpace actual code delivery.

- **Ghost completions**: MERC-221, MERC-224, and MERC-227 have zero GitHub footprint — no PR, no branch, no commits in any of the 50 commits or 16 PRs in the dataset. These are not partial completions; there is literally no trace of engineering work. This pattern strongly suggests manual Jira status changes (drag to Done) without corresponding code changes. Two of the three are assigned to Marcus, reinforcing the overload signal.

- **Review bottleneck**: PRs #141 and #145 (both from Marcus) have been open for 3–4 days with zero reviews. When a developer opens PRs that nobody reviews, the work stalls, the developer moves on to new tasks, and context is lost. This compounds the overload problem — Marcus can't close old work because nobody reviews it, so he starts new work, which also stalls.

### Recommended Actions

**Immediate (this sprint):**

1. **MERC-227 — verify PCI headers urgently** with Tom Mueller. The PCI audit is next week. If headers are not in staging, this needs same-day attention.
2. **MERC-221, MERC-224 — review with Marcus Johnson** to determine if work was done outside GitHub (infrastructure config, vendor portal) or if tickets should be reopened. If reopened, 8 SP of reported velocity is invalid.
3. **Assign reviewers to PRs #141 and #145** (both Marcus's). Suggested: Sarah Chen for #141 (error handling — she reviewed the original payment code), Tom Mueller for #145 (settlement reports — he designed the transaction model).
4. **Pair on MERC-234's failing tests** — Marcus has been trying to fix `test_batch_size_validation` and `test_concurrent_batch_processing` across 4 builds over 2 days. A second pair of eyes (Sarah, who already requested changes) could identify the architectural issue faster.

**Process improvements (next sprint):**

1. **Add a Definition of Done gate**: tickets cannot move to "Done" without a linked, merged PR — or an explicit `non-code` label for infrastructure/process tasks. This prevents ghost completions.
2. **Set a WIP limit of 3 active tickets per developer** to prevent the overload pattern. Marcus currently has 7 — roughly double a sustainable load.
3. **Implement automated PR review assignment** (e.g., GitHub CODEOWNERS or round-robin) to prevent the review bottleneck where PRs sit for days with no reviewer.

**Follow-up:**

1. Re-audit Sprint 42 in 48 hours after addressing the 3 WATERMELON tickets. Target: Trust Score above 70%.
2. Run the Watermelon Auditor on Sprint 41 data to check if Marcus's pattern (Done tickets without PRs) is new or recurring. Sprint 41 has several Done tickets with empty `linked_prs` (MERC-201, MERC-206, MERC-208–214) that may indicate a longer-term trend.
3. At Sprint 43 planning, review team capacity and redistribute work to reduce single-developer concentration risk.
