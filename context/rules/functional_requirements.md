# Functional Requirements

- User can initialize a run.
- User can progress at most once per 24 hours unless using a ticket.
- User can watch ads to gain progress tickets (max 5).
- Before/After animation is shown during progress.
- Old image is discarded immediately after transition.
- Save slots: free 1, paid up to 5.
- No automatic progression.

## Edge Case Decision Table

| Case ID | Trigger | Precondition | Expected Response | Retry Policy | Audit Requirement | Acceptance Test ID |
|---|---|---|---|---|---|---|
| FR-EC-001 | `POST /progress` timeout | user is eligible now | return retryable error with idempotency key hint | client retry with exponential backoff, max 3 | store request id + user id + timestamp | E2E-FR-EC-001 |
| FR-EC-002 | duplicated `POST /progress` within same second | same user, same step, same idempotency key | process once, return same result payload | no additional retry needed | record deduplicated event | E2E-FR-EC-002 |
| FR-EC-003 | ad reward callback replay | same ad transaction id already consumed | return success with unchanged ticket count | no retry, mark as duplicate | record anti-replay decision | E2E-FR-EC-003 |
| FR-EC-004 | progression request during animation lock | client animation lock active | reject local action, no server call | allow retry after animation ends | UI telemetry event | E2E-FR-EC-004 |
