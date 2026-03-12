## Morning Scan — March 12, 2026

**Read time: ~2 minutes**

### Needs Attention Now (3)

- **MERC-229**: Fraud detection integration (Critical, 5 SP) — blocked by external vendor FraudShield (sandbox delayed to March 24). Also blocks MERC-238 downstream. — Escalate with vendor for interim access or plan mock API workaround.
- **PR #150 / MERC-234**: Batch payment processor — 4 consecutive CI failures. Failing tests: `test_batch_size_validation`, `test_concurrent_batch_processing`. Coverage dropped to 74.9%. Marcus pushed a race condition fix at 13:00 but CI still failing. — Review test failures with Marcus before standup; may need pair debugging.
- **PR #141 / MERC-226**: Error handling refactor — open since March 8 with zero code reviews (4 days stale). PR #145 (MERC-233, settlement reports) also has no reviews since March 9. Both are Marcus's. — Assign reviewers to both PRs today; suggest Sarah or Tom.

### Overnight Changes

- PR #153 merged by Marcus — payment status webhook endpoint (MERC-228) is complete
- PR #147 merged by Kenji — transaction audit logging (MERC-225) is complete, 88% coverage
- Sarah committed webhook payload transformation for MERC-230
- Priya committed reconciliation summary view for MERC-231
- Marcus pushed 2 fixes for the batch processor (MERC-234) attempting to resolve CI failures

### Today's Focus

1. **MERC-230**: Webhook migration (High, 5 SP) — Sarah, on track. Blocks MERC-235 (monitoring alerts). Active commits today, CI passing.
2. **MERC-234**: Batch processor (High, 5 SP) — Marcus, at risk. CI failing since yesterday. Blocks MERC-237 (currency conversion). Needs test fixes before review can proceed.
3. **MERC-231**: Reconciliation dashboard (High, 8 SP) — Priya, on track. Active commits, CI passing. Largest remaining item by story points.
4. **MERC-233**: Settlement report migration (High, 5 SP) — Marcus, stale. Last updated March 9, PR #145 has no reviews. Needs attention.
5. **MERC-226**: Error handling refactor (Medium, 3 SP) — Marcus, stale. PR #141 waiting 4 days for review.

### Team Load

| Developer | Active | In Review | Status |
|-----------|--------|-----------|--------|
| Marcus    | 4      | 1         | Heavy — 3 In Progress + 1 To Do, 2 PRs awaiting review |
| Sarah     | 1      | 0         | OK (also has 1 Blocked ticket) |
| Priya     | 1      | 0         | OK |
| Kenji     | 0      | 0         | Idle — audit logging merged, monitoring alerts blocked by MERC-230 |

### Build Health

- CI pass rate: 43% (3/7 builds passing)
- Failing branches: `feat/MERC-234-batch-processor` — 4 consecutive failures, coverage at 74.9% (below 80% threshold)
- Persistent failing tests: `test_batch_size_validation`, `test_concurrent_batch_processing`

---
*Generated from Jira, GitHub PRs, CI builds, and commit data. Paste fresher data anytime for an updated scan.*
