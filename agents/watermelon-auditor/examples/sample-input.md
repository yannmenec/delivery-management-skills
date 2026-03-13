# Sample Input — Project Mercury Sprint 42

Copy everything below and paste it after the prompt. The data comes from the Project Mercury sample dataset (`data/` directory).

---

## Jira Sprint Data

```json
[
  {
    "key": "MERC-220",
    "summary": "Implement payment gateway SDK v3 client",
    "status": "Done",
    "assignee": "sarah.chen",
    "story_points": 5,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-11",
    "labels": ["payment", "migration"],
    "type": "Story",
    "priority": "High",
    "linked_prs": ["#143"],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-221",
    "summary": "Migrate recurring billing module",
    "status": "Done",
    "assignee": "marcus.johnson",
    "story_points": 5,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-10",
    "labels": ["billing", "migration"],
    "type": "Story",
    "priority": "High",
    "linked_prs": [],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-222",
    "summary": "Add retry logic for failed transactions",
    "status": "Done",
    "assignee": "tom.mueller",
    "story_points": 3,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-11",
    "labels": ["payment", "reliability"],
    "type": "Story",
    "priority": "Medium",
    "linked_prs": ["#144"],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-223",
    "summary": "Update payment confirmation email template",
    "status": "Done",
    "assignee": "lea.dubois",
    "story_points": 2,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-10",
    "labels": ["payment", "notifications"],
    "type": "Task",
    "priority": "Low",
    "linked_prs": ["#146"],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-224",
    "summary": "Update API rate limiting for payment endpoints",
    "status": "Done",
    "assignee": "marcus.johnson",
    "story_points": 3,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-11",
    "labels": ["api", "security"],
    "type": "Task",
    "priority": "Medium",
    "linked_prs": [],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-225",
    "summary": "Add transaction audit logging",
    "status": "Done",
    "assignee": "kenji.tanaka",
    "story_points": 3,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-12",
    "labels": ["payment", "observability"],
    "type": "Story",
    "priority": "Medium",
    "linked_prs": ["#147"],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-226",
    "summary": "Refactor payment error handling",
    "status": "In Progress",
    "assignee": "marcus.johnson",
    "story_points": 3,
    "sprint": "Sprint 42",
    "created": "2026-03-07",
    "updated": "2026-03-08",
    "labels": ["payment", "tech-debt"],
    "type": "Story",
    "priority": "Medium",
    "linked_prs": ["#141"],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-227",
    "summary": "Add PCI compliance headers to all responses",
    "status": "Done",
    "assignee": "tom.mueller",
    "story_points": 2,
    "sprint": "Sprint 42",
    "created": "2026-03-11",
    "updated": "2026-03-11",
    "labels": ["security", "compliance"],
    "type": "Task",
    "priority": "High",
    "linked_prs": [],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-228",
    "summary": "Create payment status webhook endpoint",
    "status": "Done",
    "assignee": "marcus.johnson",
    "story_points": 5,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-12",
    "labels": ["payment", "webhooks"],
    "type": "Story",
    "priority": "High",
    "linked_prs": ["#153"],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-229",
    "summary": "Integrate with external fraud detection API",
    "status": "Blocked",
    "assignee": "sarah.chen",
    "story_points": 5,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-11",
    "labels": ["payment", "fraud-detection"],
    "type": "Story",
    "priority": "Critical",
    "linked_prs": [],
    "blocked_by": ["EXT-API"],
    "blocks": ["MERC-238"]
  },
  {
    "key": "MERC-230",
    "summary": "Migrate webhook handler to new payment gateway",
    "status": "In Progress",
    "assignee": "sarah.chen",
    "story_points": 5,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-12",
    "labels": ["payment", "migration"],
    "type": "Story",
    "priority": "High",
    "linked_prs": ["#148"],
    "blocked_by": [],
    "blocks": ["MERC-235"]
  },
  {
    "key": "MERC-231",
    "summary": "Build payment reconciliation dashboard",
    "status": "In Progress",
    "assignee": "priya.sharma",
    "story_points": 8,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-12",
    "labels": ["payment", "dashboard"],
    "type": "Story",
    "priority": "High",
    "linked_prs": ["#149"],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-232",
    "summary": "Add payment method validation service",
    "status": "In Progress",
    "assignee": "lea.dubois",
    "story_points": 3,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-12",
    "labels": ["payment", "validation"],
    "type": "Story",
    "priority": "Medium",
    "linked_prs": ["#152"],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-233",
    "summary": "Migrate settlement report generator",
    "status": "In Progress",
    "assignee": "marcus.johnson",
    "story_points": 5,
    "sprint": "Sprint 42",
    "created": "2026-03-08",
    "updated": "2026-03-09",
    "labels": ["payment", "migration"],
    "type": "Story",
    "priority": "High",
    "linked_prs": ["#145"],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-234",
    "summary": "Implement batch payment processor",
    "status": "In Progress",
    "assignee": "marcus.johnson",
    "story_points": 5,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-12",
    "labels": ["payment", "batch"],
    "type": "Story",
    "priority": "High",
    "linked_prs": ["#150"],
    "blocked_by": [],
    "blocks": ["MERC-237"]
  },
  {
    "key": "MERC-235",
    "summary": "Set up payment gateway monitoring alerts",
    "status": "To Do",
    "assignee": "kenji.tanaka",
    "story_points": 3,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-10",
    "labels": ["payment", "monitoring"],
    "type": "Task",
    "priority": "Medium",
    "linked_prs": [],
    "blocked_by": ["MERC-230"],
    "blocks": []
  },
  {
    "key": "MERC-236",
    "summary": "Create payment analytics API endpoint",
    "status": "To Do",
    "assignee": "priya.sharma",
    "story_points": 3,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-10",
    "labels": ["payment", "analytics"],
    "type": "Story",
    "priority": "Medium",
    "linked_prs": [],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-237",
    "summary": "Add currency conversion support",
    "status": "To Do",
    "assignee": "marcus.johnson",
    "story_points": 5,
    "sprint": "Sprint 42",
    "created": "2026-03-11",
    "updated": "2026-03-11",
    "labels": ["payment", "i18n"],
    "type": "Story",
    "priority": "High",
    "linked_prs": [],
    "blocked_by": ["MERC-234"],
    "blocks": []
  },
  {
    "key": "MERC-238",
    "summary": "Write integration tests for gateway v3",
    "status": "To Do",
    "assignee": "tom.mueller",
    "story_points": 3,
    "sprint": "Sprint 42",
    "created": "2026-03-10",
    "updated": "2026-03-10",
    "labels": ["payment", "testing"],
    "type": "Task",
    "priority": "Medium",
    "linked_prs": [],
    "blocked_by": [],
    "blocks": []
  },
  {
    "key": "MERC-239",
    "summary": "Add payment method icons to checkout UI",
    "status": "To Do",
    "assignee": "lea.dubois",
    "story_points": 2,
    "sprint": "Sprint 42",
    "created": "2026-03-11",
    "updated": "2026-03-11",
    "labels": ["payment", "ui"],
    "type": "Task",
    "priority": "Low",
    "linked_prs": [],
    "blocked_by": [],
    "blocks": []
  }
]
```

## GitHub Pull Requests

```json
[
  {
    "number": 141,
    "title": "refactor(payment): payment error handling",
    "author": "marcus.johnson",
    "status": "open",
    "created_at": "2026-03-08T09:30:00Z",
    "updated_at": "2026-03-08T11:45:00Z",
    "merged_at": null,
    "base_branch": "main",
    "head_branch": "refactor/MERC-226-error-handling",
    "reviews": [],
    "ci_status": "passing",
    "additions": 156,
    "deletions": 89,
    "linked_ticket": "MERC-226"
  },
  {
    "number": 143,
    "title": "feat(payment): implement gateway SDK v3 client",
    "author": "sarah.chen",
    "status": "merged",
    "created_at": "2026-03-10T10:00:00Z",
    "updated_at": "2026-03-11T17:00:00Z",
    "merged_at": "2026-03-11T17:00:00Z",
    "base_branch": "main",
    "head_branch": "feat/MERC-220-gateway-sdk-v3",
    "reviews": [
      {"reviewer": "tom.mueller", "status": "approved", "submitted_at": "2026-03-11T14:30:00Z"}
    ],
    "ci_status": "passing",
    "additions": 342,
    "deletions": 28,
    "linked_ticket": "MERC-220"
  },
  {
    "number": 144,
    "title": "fix(payment): add retry logic for failed transactions",
    "author": "tom.mueller",
    "status": "merged",
    "created_at": "2026-03-10T11:00:00Z",
    "updated_at": "2026-03-11T16:00:00Z",
    "merged_at": "2026-03-11T16:00:00Z",
    "base_branch": "main",
    "head_branch": "fix/MERC-222-retry-logic",
    "reviews": [
      {"reviewer": "sarah.chen", "status": "approved", "submitted_at": "2026-03-11T11:00:00Z"}
    ],
    "ci_status": "passing",
    "additions": 178,
    "deletions": 45,
    "linked_ticket": "MERC-222"
  },
  {
    "number": 145,
    "title": "feat(payment): migrate settlement report generator",
    "author": "marcus.johnson",
    "status": "open",
    "created_at": "2026-03-09T14:00:00Z",
    "updated_at": "2026-03-09T16:30:00Z",
    "merged_at": null,
    "base_branch": "main",
    "head_branch": "feat/MERC-233-settlement-reports",
    "reviews": [],
    "ci_status": "passing",
    "additions": 201,
    "deletions": 34,
    "linked_ticket": "MERC-233"
  },
  {
    "number": 146,
    "title": "chore(payment): update confirmation email template",
    "author": "lea.dubois",
    "status": "merged",
    "created_at": "2026-03-10T09:00:00Z",
    "updated_at": "2026-03-10T15:30:00Z",
    "merged_at": "2026-03-10T15:30:00Z",
    "base_branch": "main",
    "head_branch": "chore/MERC-223-email-template",
    "reviews": [
      {"reviewer": "priya.sharma", "status": "approved", "submitted_at": "2026-03-10T13:00:00Z"}
    ],
    "ci_status": "passing",
    "additions": 47,
    "deletions": 31,
    "linked_ticket": "MERC-223"
  },
  {
    "number": 147,
    "title": "feat(payment): add transaction audit logging",
    "author": "kenji.tanaka",
    "status": "merged",
    "created_at": "2026-03-11T09:00:00Z",
    "updated_at": "2026-03-12T14:00:00Z",
    "merged_at": "2026-03-12T14:00:00Z",
    "base_branch": "main",
    "head_branch": "feat/MERC-225-audit-logging",
    "reviews": [
      {"reviewer": "tom.mueller", "status": "approved", "submitted_at": "2026-03-12T11:00:00Z"}
    ],
    "ci_status": "passing",
    "additions": 267,
    "deletions": 12,
    "linked_ticket": "MERC-225"
  },
  {
    "number": 148,
    "title": "feat(payment): migrate webhook handler",
    "author": "sarah.chen",
    "status": "open",
    "created_at": "2026-03-11T09:30:00Z",
    "updated_at": "2026-03-12T14:00:00Z",
    "base_branch": "main",
    "head_branch": "feat/MERC-230-webhook-migration",
    "reviews": [
      {"reviewer": "tom.mueller", "status": "approved", "submitted_at": "2026-03-12T11:00:00Z"}
    ],
    "ci_status": "passing",
    "additions": 342,
    "deletions": 128,
    "linked_ticket": "MERC-230"
  },
  {
    "number": 149,
    "title": "feat(payment): build reconciliation dashboard",
    "author": "priya.sharma",
    "status": "open",
    "created_at": "2026-03-10T11:00:00Z",
    "updated_at": "2026-03-12T14:30:00Z",
    "base_branch": "main",
    "head_branch": "feat/MERC-231-reconciliation-dashboard",
    "reviews": [
      {"reviewer": "lea.dubois", "status": "changes_requested", "submitted_at": "2026-03-11T16:00:00Z"},
      {"reviewer": "lea.dubois", "status": "approved", "submitted_at": "2026-03-12T10:30:00Z"}
    ],
    "ci_status": "passing",
    "additions": 612,
    "deletions": 87,
    "linked_ticket": "MERC-231"
  },
  {
    "number": 150,
    "title": "feat(payment): implement batch payment processor",
    "author": "marcus.johnson",
    "status": "open",
    "created_at": "2026-03-10T14:00:00Z",
    "updated_at": "2026-03-12T13:15:00Z",
    "base_branch": "main",
    "head_branch": "feat/MERC-234-batch-processor",
    "reviews": [
      {"reviewer": "sarah.chen", "status": "changes_requested", "submitted_at": "2026-03-11T17:00:00Z"}
    ],
    "ci_status": "failing",
    "additions": 489,
    "deletions": 56,
    "linked_ticket": "MERC-234"
  },
  {
    "number": 152,
    "title": "feat(payment): add payment method validation",
    "author": "lea.dubois",
    "status": "open",
    "created_at": "2026-03-11T10:00:00Z",
    "updated_at": "2026-03-12T11:45:00Z",
    "base_branch": "main",
    "head_branch": "feat/MERC-232-payment-validation",
    "reviews": [
      {"reviewer": "priya.sharma", "status": "approved", "submitted_at": "2026-03-12T09:30:00Z"}
    ],
    "ci_status": "passing",
    "additions": 234,
    "deletions": 19,
    "linked_ticket": "MERC-232"
  },
  {
    "number": 153,
    "title": "feat(payment): create payment status webhook endpoint",
    "author": "marcus.johnson",
    "status": "merged",
    "created_at": "2026-03-10T09:00:00Z",
    "updated_at": "2026-03-12T10:00:00Z",
    "merged_at": "2026-03-12T10:00:00Z",
    "base_branch": "main",
    "head_branch": "feat/MERC-228-payment-webhook",
    "reviews": [
      {"reviewer": "kenji.tanaka", "status": "approved", "submitted_at": "2026-03-11T16:30:00Z"}
    ],
    "ci_status": "passing",
    "additions": 298,
    "deletions": 42,
    "linked_ticket": "MERC-228"
  }
]
```

## GitHub Commits (optional — improves staleness detection)

```json
[
  {"sha": "d0e1f2a", "message": "refactor(payment): add error mapping layer\n\nMERC-226", "author": "marcus.johnson", "date": "2026-03-08T11:30:00Z", "branch": "refactor/MERC-226-error-handling", "files_changed": 3},
  {"sha": "f2a3b4c", "message": "feat(payment): add settlement data aggregation\n\nMERC-233", "author": "marcus.johnson", "date": "2026-03-09T10:00:00Z", "branch": "feat/MERC-233-settlement-reports", "files_changed": 6},
  {"sha": "b4c5d6e", "message": "feat(payment): add gateway SDK v3 client wrapper\n\nMERC-220", "author": "sarah.chen", "date": "2026-03-10T10:00:00Z", "branch": "feat/MERC-220-gateway-sdk-v3", "files_changed": 6},
  {"sha": "f8a9b0c", "message": "feat(payment): implement SDK v3 authentication\n\nMERC-220", "author": "sarah.chen", "date": "2026-03-10T15:00:00Z", "branch": "feat/MERC-220-gateway-sdk-v3", "files_changed": 4},
  {"sha": "f4a5b6c", "message": "test(payment): add unit tests for SDK v3 client\n\nMERC-220", "author": "sarah.chen", "date": "2026-03-11T10:00:00Z", "branch": "feat/MERC-220-gateway-sdk-v3", "files_changed": 3},
  {"sha": "c1d2e3f", "message": "feat(payment): add webhook signature validation\n\nMERC-230", "author": "sarah.chen", "date": "2026-03-11T09:15:00Z", "branch": "feat/MERC-230-webhook-migration", "files_changed": 4},
  {"sha": "e9f0a1b", "message": "feat(payment): implement webhook retry queue\n\nMERC-230", "author": "sarah.chen", "date": "2026-03-11T14:30:00Z", "branch": "feat/MERC-230-webhook-migration", "files_changed": 3},
  {"sha": "a7b8c9e", "message": "feat(payment): add webhook payload transformation\n\nMERC-230", "author": "sarah.chen", "date": "2026-03-12T10:15:00Z", "branch": "feat/MERC-230-webhook-migration", "files_changed": 4},
  {"sha": "b0c1d2e", "message": "feat(payment): scaffold reconciliation dashboard\n\nMERC-231", "author": "priya.sharma", "date": "2026-03-10T11:00:00Z", "branch": "feat/MERC-231-reconciliation-dashboard", "files_changed": 7},
  {"sha": "e5f6a7c", "message": "feat(payment): add reconciliation summary view\n\nMERC-231", "author": "priya.sharma", "date": "2026-03-12T09:30:00Z", "branch": "feat/MERC-231-reconciliation-dashboard", "files_changed": 5},
  {"sha": "d0e1f2b", "message": "feat(payment): add export to CSV for reconciliation\n\nMERC-231", "author": "priya.sharma", "date": "2026-03-12T14:00:00Z", "branch": "feat/MERC-231-reconciliation-dashboard", "files_changed": 3},
  {"sha": "a5b6c7d", "message": "feat(payment): add card number validation\n\nMERC-232", "author": "lea.dubois", "date": "2026-03-11T10:00:00Z", "branch": "feat/MERC-232-payment-validation", "files_changed": 4},
  {"sha": "b8c9d0f", "message": "feat(payment): add CVV validation rules\n\nMERC-232", "author": "lea.dubois", "date": "2026-03-12T11:30:00Z", "branch": "feat/MERC-232-payment-validation", "files_changed": 2},
  {"sha": "e7f8a9b", "message": "feat(payment): scaffold batch processor service\n\nMERC-234", "author": "marcus.johnson", "date": "2026-03-10T14:00:00Z", "branch": "feat/MERC-234-batch-processor", "files_changed": 5},
  {"sha": "f6a7b8d", "message": "fix(payment): handle batch size limits\n\nMERC-234", "author": "marcus.johnson", "date": "2026-03-12T09:45:00Z", "branch": "feat/MERC-234-batch-processor", "files_changed": 2},
  {"sha": "c9d0e1a", "message": "fix(payment): fix race condition in batch processor\n\nMERC-234", "author": "marcus.johnson", "date": "2026-03-12T13:00:00Z", "branch": "feat/MERC-234-batch-processor", "files_changed": 3}
]
```

## CI Build Results (optional — improves risk detection)

```json
[
  {"id": "build-4506", "branch": "feat/MERC-220-gateway-sdk-v3", "status": "success", "triggered_at": "2026-03-10T10:15:00Z", "duration_seconds": 234, "pr_number": 143, "failed_tests": [], "coverage_percent": 86.2},
  {"id": "build-4517", "branch": "feat/MERC-220-gateway-sdk-v3", "status": "success", "triggered_at": "2026-03-11T10:15:00Z", "duration_seconds": 238, "pr_number": 143, "failed_tests": [], "coverage_percent": 88.3},
  {"id": "build-4508", "branch": "fix/MERC-222-retry-logic", "status": "success", "triggered_at": "2026-03-10T11:15:00Z", "duration_seconds": 176, "pr_number": 144, "failed_tests": [], "coverage_percent": 87.9},
  {"id": "build-4501", "branch": "refactor/MERC-226-error-handling", "status": "success", "triggered_at": "2026-03-07T16:10:00Z", "duration_seconds": 198, "pr_number": 141, "failed_tests": [], "coverage_percent": 81.4},
  {"id": "build-4502", "branch": "refactor/MERC-226-error-handling", "status": "success", "triggered_at": "2026-03-08T11:40:00Z", "duration_seconds": 205, "pr_number": 141, "failed_tests": [], "coverage_percent": 82.1},
  {"id": "build-4515", "branch": "feat/MERC-234-batch-processor", "status": "failure", "triggered_at": "2026-03-11T10:45:00Z", "duration_seconds": 298, "pr_number": 150, "failed_tests": ["test_batch_size_validation", "test_concurrent_batch_processing"], "coverage_percent": 75.2},
  {"id": "build-4520", "branch": "feat/MERC-234-batch-processor", "status": "failure", "triggered_at": "2026-03-11T15:15:00Z", "duration_seconds": 305, "pr_number": 150, "failed_tests": ["test_batch_size_validation", "test_concurrent_batch_processing", "test_batch_error_recovery"], "coverage_percent": 74.5},
  {"id": "build-4527", "branch": "feat/MERC-234-batch-processor", "status": "failure", "triggered_at": "2026-03-12T10:00:00Z", "duration_seconds": 289, "pr_number": 150, "failed_tests": ["test_batch_size_validation", "test_concurrent_batch_processing", "test_batch_error_recovery"], "coverage_percent": 75.0},
  {"id": "build-4531", "branch": "feat/MERC-234-batch-processor", "status": "failure", "triggered_at": "2026-03-12T13:15:00Z", "duration_seconds": 301, "pr_number": 150, "failed_tests": ["test_batch_size_validation", "test_concurrent_batch_processing"], "coverage_percent": 74.9},
  {"id": "build-4513", "branch": "feat/MERC-230-webhook-migration", "status": "success", "triggered_at": "2026-03-11T09:25:00Z", "duration_seconds": 245, "pr_number": 148, "failed_tests": [], "coverage_percent": 85.6},
  {"id": "build-4528", "branch": "feat/MERC-230-webhook-migration", "status": "success", "triggered_at": "2026-03-12T10:30:00Z", "duration_seconds": 248, "pr_number": 148, "failed_tests": [], "coverage_percent": 86.5}
]
```
