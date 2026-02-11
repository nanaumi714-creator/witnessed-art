# Test Strategy

## Overview
This document ensures every functional requirement (FR), edge case (EC), and non-functional requirement (NFR) is verified before the implementation phase ends.

## Requirement-to-Test Matrix

| Requirement ID | Test ID | Test Title | Pass Criteria | Evidence Requirement |
|---|---|---|---|---|
| FR-001 | TEST-FR-001 | Initial Run Generation | New user can tap "Create" and see a Step 0 image. | Screenshot of UI + backend DB record check. |
| FR-002 | TEST-FR-002 | Daily Progress Flow | Button is locked for 24h, unlocks correctly, advances step. | Log of `last_progressed_at` updates. |
| FR-003 | TEST-FR-003 | Before/After Animation | Transition shows "Emerald Wash" timings (1.4s/1.1s). | Screen recording with frame analysis. |
| FR-004 | TEST-FR-004 | Image Save Slots | Slots can be filled up to max limit (1 for free). | Screenshot of Saved List UI with count. |
| FR-005 | TEST-FR-005 | Run Reset | 3s long press triggers reset and wipes current run data. | UI interaction recording + DB wipe check. |
| FR-006 | TEST-FR-006 | Ad Reward Tickets | Watching an ad increases ticket count by 1 (max 5). | Ad completion callback log + UI ticket update. |
| FR-007 | TEST-FR-007 | Push Notifications | User receives notification 24h after last progress. | FCM message delivery report. |
| FR-008 | TEST-FR-008 | User Settings | Notification toggle and time changes persist. | Local storage/DB change verification. |
| FR-EC-001 | TEST-EC-001 | Progress Timeout | Client retries with exponential backoff on 500/timeout. | Network log showing retries and same response. |
| FR-EC-003 | TEST-EC-003 | Ad Reward Replay | Sending same ad transaction ID does not double count. | Backend audit log showing "Duplicate Rejection". |
| PR-TZ-001 | TEST-PR-001 | Timezone Change | Changing device TZ does not allow immediate progress. | System clock override test + lock status check. |
| PR-NET-003 | TEST-PR-003 | NSFW Filter Path | Prompting NSFW image triggers seed+1 retry up to 3 times. | Image generation log showing trigger and offset. |
| MON-EC-001 | TEST-MON-001| Purchase Timeout | Valid purchase with backend timeout grants entitlement later. | Retried verification log in background. |

## Test Evidence Template
Each test execution must record:
1. **Timestamp**:
2. **Environment**: (iOS / Android / API-Dev)
3. **Tester**: AI Agent / Human
4. **Command/Instruction**:
5. **Expected Result**:
6. **Actual Result**:
7. **Artifacts**: (Logs, Screenshots, Recordings)
8. **Status**: (PASS / FAIL)

## Acceptance Criteria for Release
- [ ] 100% of P0 Tests passed.
- [ ] 0 Critical/High bugs remaining.
- [ ] Performance targets (img2img < 30s) met on stable network.
- [ ] Safety Filter false negative rate = 0 (manual review of 50 samples).
