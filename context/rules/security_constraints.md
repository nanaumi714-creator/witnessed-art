# Security Constraints

- **Authentication**: Firebase Authentication (ID Token) is the primary auth and identity mechanism.
- **Request Integrity**: Rely on Firebase ID Token + `X-Idempotency-Key` (UUID v4) for progression and monetization calls.
- **HMAC Design (Updated)**: Client-side HMAC signatures with shared secrets are prohibited. Server-side validation ensures that only the authorized Firebase user can affect their own `step` development.
- **Rate Limiting**: Enforced by user identity and IP.
- **Signed URL**: All image access is via short-lived (15min) secure signed URLs.
- **NSFW Safety**:
  - Model: Falconsai/nsfw_image_detection
  - Threshold: score > 0.7 for rejection.
  - Retry Policy:
    - If NSFW detected: increment seed by 1 and retry generation up to 3 times.
    - If 3rd retry still fails: maintain previous image and notify user of "Generation Error/Retry pending".


