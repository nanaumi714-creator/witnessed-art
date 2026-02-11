# Decisions Log

## Entry Template
- id:
- date:
- owner:
- source_question_id:
- decision:
- impact:
- follow_up:

## Entries

### D-001
- id: D-001
- date: 2026-02-10
- owner: coordinator
- source_question_id: none
- decision: Introduce structured open-question lifecycle with owner/status/SLA fields.
- impact: Reduces unresolved ambiguity and improves deterministic handoff.
- follow_up: Apply the same structure to future dynamic operation docs.

### D-002
- id: D-002
- date: 2026-02-11
- owner: security_agent
- source_question_id: Q-001
- decision: Adopt Falconsai/nsfw_image_detection with 0.7 threshold and 3-retry seed+1 policy.
- impact: Ensures store compliance while minimizing user friction for false positives.
- follow_up: Monitor false positive rate during Beta.

### D-003
- id: D-003
- date: 2026-02-11
- owner: monetization_agent
- source_question_id: Q-002
- decision: Define Patron Pack ($2.99) and Creator Pack ($9.99) with slot and cosmetic rewards.
- impact: Establishes clear revenue streams and user value tiers.
- follow_up: Finalize SKU strings for App Store/Google Play.

### D-004
- id: D-004
- date: 2026-02-11
- owner: coordinator
- source_question_id: Q-003
- decision: Set Beta success benchmark at 30% 7-day retention and 15% 14-day completion.
- impact: Provides clear go/no-go criteria for product continuation.
- follow_up: Implement tracking hooks in Week 1 development.

### D-005
- id: D-005
- date: 2026-02-11
- owner: flutter_agent
- source_question_id: none
- decision: Adopt "Emerald Wash" design theme (Aqua Mist background, Emerald Core accent).
- impact: Establishes a calm, organic, and premium brand aesthetic consistent with "slow AI" philosophy.
- follow_up: Ensure Flutter implementation follows the precise animation and color specifications.

### D-006
- id: D-006
- date: 2026-02-11
- owner: backend_agent
- source_question_id: none
- decision: Formalized REST API contract with 6 core endpoints using Firebase Auth and HMAC signatures for progression.
- impact: Enables frontend-backend development alignment and deterministic security.
- follow_up: Implement HMAC verification middleware in FastAPI.

### D-007
- id: D-007
- date: 2026-02-11
- owner: ai_pipeline_agent
- source_question_id: none
- decision: Defined 5-phase SDXL img2img progression (denoise 0.95 -> 0.30) and strict before-image cleanup policy.
- impact: Ensures consistent artistic evolution and storage cost control.
- follow_up: Validate SDXL phase parameters with manual test runs.

### D-008
- id: D-008
- date: 2026-02-11
- owner: security_agent
- source_question_id: none
- decision: Remove client-side HMAC secret; rely on Firebase ID Token + X-Idempotency-Key + Server-side validation.
- impact: Eliminates risk of secret leakage in client builds while maintaining request integrity.
- follow_up: Update API documentation to remove 'signature' field.

### D-009
- id: D-009
- date: 2026-02-11
- owner: backend_agent
- source_question_id: none
- decision: Define `seed` as signed 64-bit integer (range 0 to 2^63-1) generated via SHA256 of UUID4 or equivalent CSPRNG.
- impact: Ensures database compatibility (PostgreSQL BIGINT) and reproducible AI generation.
- follow_up: Ensure seed range normalization in generation worker.

### D-010
- id: D-010
- date: 2026-02-11
- owner: ai_pipeline_agent
- source_question_id: none
- decision: Atomic backend cleanup; delete 'Before' image immediately upon 'After' image persistence success.
- impact: Guarantees storage cost control and state atomicity regardless of client lifecycle.
- follow_up: Implement S3 deletion call in the `/progress` finalization logic.




