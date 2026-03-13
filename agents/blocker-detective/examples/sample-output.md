## Blocker Detective — Sprint 42

**Scan date:** March 12, 2026
**Data sources:** Jira Sprint Data, GitHub PRs, GitHub Commits, CI Builds
**Sprint health:** 🔴 Action Required

### 🔴 Critical Blockers

**PR #141** (MERC-226): Refactor payment error handling
- **Signal:** Aging PR + Review Starvation — open 4 days with zero code reviews
- **Duration:** 96 hours since PR opened (March 8 at 09:30), last commit `d0e1f2a` on March 8 at 11:30
- **Assignee:** Marcus
- **Impact:** 156 additions and 89 deletions sitting idle. This refactor touches payment error handling across the module — other PRs may accumulate merge conflicts the longer this waits. Marcus has 6 other tickets competing for his attention.
- **Action:** Assign a reviewer immediately. Suggested: Sarah (she reviewed the original payment code in PR #143).

**PR #145** (MERC-233): Migrate settlement report generator
- **Signal:** Aging PR + Review Starvation — open 3 days with zero code reviews
- **Duration:** 72 hours since PR opened (March 9 at 14:00), last commit `f2a3b4c` on March 9 at 10:00
- **Assignee:** Marcus
- **Impact:** 201 additions with no feedback loop. Settlement reports are needed downstream for reconciliation (MERC-231). Without review, this blocks a critical path.
- **Action:** Assign a reviewer. Suggested: Tom (he designed the transaction data model used by settlement reports).

**MERC-234** (PR #150): Implement batch payment processor
- **Signal:** CI Failure Streak — 4 consecutive build failures after a passing build
- **Duration:** CI red for 2 days (since March 11 at 10:45). Build history: build-4509 (success, March 10), then build-4515 (failure), build-4520 (failure), build-4527 (failure), build-4531 (failure).
- **Failing tests:** `test_batch_size_validation`, `test_concurrent_batch_processing` (persistent across all 4 failures), `test_batch_error_recovery` (appeared in builds 4520-4527, resolved in 4531)
- **Assignee:** Marcus
- **Impact:** Blocks MERC-237 (Add currency conversion support, 5 SP). Sarah requested changes on PR #150 on March 11 that may not be fully addressed. Same core tests keep failing, suggesting an architectural issue in the async batch processing approach rather than a simple bug fix.
- **Action:** Pair with Marcus on the failing tests. Sarah already flagged issues in her review — use that as a starting point.

**MERC-226**: Refactor payment error handling
- **Signal:** Stale Work — last commit 4 days ago, ticket still In Progress
- **Duration:** 96 hours since last commit (`d0e1f2a` on March 8 at 11:30). PR #141 has had zero activity since.
- **Assignee:** Marcus
- **Impact:** Work appears abandoned. Combined with review starvation on PR #141, this ticket is stuck from both sides — no new work pushed and no review received.
- **Action:** Covered by PR #141 action above. Getting a review will either unblock Marcus or reveal the work is deprioritized.

**Marcus Johnson**: Developer Overload
- **Signal:** Developer Overload — 7 tickets assigned in Sprint 42 (critical threshold: 6)
- **Breakdown:** Done: 3 (MERC-221, MERC-224, MERC-228), In Progress: 3 (MERC-226, MERC-233, MERC-234), To Do: 1 (MERC-237)
- **Impact:** Marcus has 2 stale PRs with zero reviews (#141, #145), 1 PR with 4 consecutive CI failures (#150), and 1 To Do blocked by his own CI-failing ticket (MERC-237). His In Progress items cannot advance because he is spread across too many contexts simultaneously.
- **Action:** Redistribute at least 2 of Marcus's items. MERC-226 (error handling refactor, 3 SP) or MERC-233 (settlement reports, 5 SP) are candidates — both have open PRs that another developer could take over after review.

**MERC-229**: Integrate with external fraud detection API
- **Signal:** Blocked Ticket — status "Blocked", external dependency `EXT-API` (FraudShield sandbox unavailable until March 24)
- **Duration:** Blocked since vendor delay notification. No code work is possible.
- **Assignee:** Sarah
- **Impact:** 5 SP of planned work cannot start. Blocks MERC-238 (Write integration tests for gateway v3, 3 SP) downstream. Sarah has redirected to MERC-230 (webhook migration) in the meantime.
- **Action:** Confirm March 24 sandbox date with FraudShield. Consider pulling a backlog item to replace MERC-229's sprint capacity (8 SP total blocked: MERC-229 + MERC-238).

### 🟡 Watch List

**MERC-233**: Migrate settlement report generator
- **Signal:** Stale Work — last commit 3 days ago (March 9 at 10:00), ticket In Progress
- **Assignee:** Marcus
- **Trending:** 74 hours since last activity. Will cross the critical threshold (96 hours / 4 days) by tomorrow morning if no commits are pushed. Already flagged above for Review Starvation on PR #145.

**MERC-237**: Add currency conversion support
- **Signal:** Dependency Chain — blocked by MERC-234 which has 4 consecutive CI failures
- **Assignee:** Marcus
- **Trending:** Cannot start until MERC-234's CI is green and the PR merges. If CI failures persist through tomorrow, MERC-237 (5 SP) is at risk of not starting this sprint. Combined with Marcus's overload, this ticket may need to be moved to the next sprint.

### 🟢 Healthy Signals

- **5** tickets verified Done with merged PRs and passing CI (MERC-220, MERC-222, MERC-223, MERC-225, MERC-228)
- **3** In Progress tickets with active commits today and passing CI (MERC-230, MERC-231, MERC-232)
- **4** PRs merged in the last 2 days (#143, #144, #146, #147)
- **3** open PRs with approved reviews and passing CI, ready to merge (#148, #149, #152)
- CI pass rate: 87% (27 of 31 builds passing across all branches)

### 👤 Developer Load Map

| Developer | Sprint Tickets | In Progress | Blocker Exposure | Status |
|-----------|---------------|-------------|-----------------|--------|
| Marcus | 7 | 3 | 5 (3🔴 + 2🟡) | 🔴 Overloaded |
| Sarah | 3 | 1 | 1 (1🔴) | 🟢 Balanced |
| Tom | 3 | 0 | 0 | 🟢 Balanced |
| Lea | 3 | 1 | 0 | 🟢 Balanced |
| Priya | 2 | 1 | 0 | 🟢 Balanced |
| Kenji | 2 | 0 | 0 | 🟢 Balanced |

### 📋 Suggested Standup Agenda

1. **Marcus's workload**: 7 tickets, 2 stale PRs, 4 CI failures
   - **Why:** Developer Overload (🔴) compounded by Stale Work and CI Failure Streak — all signals converge on one developer drowning in context switches
   - **Lead:** Marcus + Delivery Manager
   - **Decision needed:** Which 2 items should be reassigned, and who picks them up? Candidates: MERC-226 (3 SP, has open PR) and MERC-233 (5 SP, has open PR).

2. **PR reviews for #141 and #145**: Zero reviews after 3-4 days
   - **Why:** Review Starvation (🔴) — two PRs with 357 combined additions sitting idle, blocking Marcus's In Progress items from advancing
   - **Lead:** Sarah and Tom (suggested reviewers)
   - **Decision needed:** Who reviews #141 (error handling refactor, 156+89 lines)? Who reviews #145 (settlement report migration, 201+34 lines)?

3. **MERC-234 CI failures**: Same tests failing across 4 builds over 2 days
   - **Why:** CI Failure Streak (🔴) — `test_batch_size_validation` and `test_concurrent_batch_processing` persist across all 4 failures. Sarah already requested changes on PR #150. This blocks MERC-237 (5 SP).
   - **Lead:** Marcus + Sarah
   - **Decision needed:** Schedule a pair session today to investigate the architectural issue, or rethink the async batch approach?

4. **MERC-226 and MERC-233 staleness**: No progress for 3-4 days
   - **Why:** Stale Work (🔴 MERC-226 at 96 hours, 🟡 MERC-233 at 74 hours) — both are Marcus's items with PRs that have zero reviews
   - **Lead:** Marcus
   - **Decision needed:** Are these blocked on reviews (assign reviewers), deprioritized (update status to reflect reality), or being actively worked on (push commits)?

5. **MERC-229 external blocker**: FraudShield sandbox delayed to March 24
   - **Why:** Blocked Ticket (🔴) — 5 SP cannot start, blocks 3 SP downstream (MERC-238). Sarah has pivoted to MERC-230 but the sprint has an 8 SP gap.
   - **Lead:** Sarah
   - **Decision needed:** Pull a backlog item to fill the capacity gap, or accept the gap and focus on closing other In Progress items?

*Estimated discussion time: 12-15 minutes for 5 items.*

### Recommended Actions

1. **Sarah** — Review PR #141 (MERC-226, payment error handling, 156+89 lines) — zero reviews after 4 days, Marcus cannot advance
2. **Tom** — Review PR #145 (MERC-233, settlement report migration, 201+34 lines) — zero reviews after 3 days, blocks reconciliation work
3. **Sarah + Marcus** — Pair on MERC-234 failing tests today — same tests failing across 4 builds over 2 days, Sarah's review comments on PR #150 may identify the root cause
4. **Delivery Manager** — Redistribute 2 of Marcus's items (MERC-226 and/or MERC-233) — 7 tickets is unsustainable and is causing cascading stale work
5. **Sarah** — Confirm FraudShield sandbox date (March 24) with vendor — if delayed further, MERC-229 (5 SP) and MERC-238 (3 SP) need sprint replanning
6. **Marcus** — Update MERC-226 and MERC-233 status — if deprioritized, move to backlog; if blocked on reviews, actions 1 and 2 above resolve it

---
*Generated from Jira Sprint Data, GitHub PRs, GitHub Commits, CI Builds. Thresholds: all defaults. Adjust in config.yaml.*
