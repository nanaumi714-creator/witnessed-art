# Image Progression Rules

- A run progresses only when the user taps Progress.
- Default cadence is 1 step per day.
- A ticket can bypass daily lock.
- No auto-progress background jobs.
- System never declares completion.

## Timezone and Eligibility Rules

| Rule ID | Scenario | Deterministic Rule | Expected Output | Acceptance Test ID |
|---|---|---|---|---|
| PR-TZ-001 | user changes timezone manually | eligibility uses `last_progressed_at` UTC + 24h absolute window | no immediate extra progress from timezone change | E2E-PR-TZ-001 |
| PR-TZ-002 | daylight saving shift | continue using UTC timestamps for lock checks | no drift in eligibility | E2E-PR-TZ-002 |
| PR-TZ-003 | cross-day boundary local midnight | local date change does not unlock progression by itself | locked until UTC window ends unless ticket is used | E2E-PR-TZ-003 |

## Network and Idempotency Rules

| Rule ID | Scenario | Deterministic Rule | Expected Output | Acceptance Test ID |
|---|---|---|---|---|
| PR-NET-001 | request timeout after server accepted job | require idempotency token | follow-up call returns same progression result | E2E-PR-NET-001 |
| PR-NET-002 | concurrent progress taps from two devices | first valid request wins by atomic step update | only one step increment | E2E-PR-NET-002 |
| PR-NET-003 | NSFW-retry path | if output blocked, keep previous image and retry with deterministic seed offset rule | no unsafe image persisted | E2E-PR-NET-003 |
