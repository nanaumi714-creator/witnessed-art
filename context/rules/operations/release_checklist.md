# Release Checklist

Store readiness, policy checks, safety checks, and sign-off items.

## Pre-Beta Compliance Checks
- [ ] **Monetization**: Verify no paywall for basic daily progress.
- [ ] **Monetization**: Ensure only platform-native payment methods (IAP) are used in mobile builds.
- [ ] **Monetization**: Validate ad-reward anti-replay logic (MON-EC-004).
- [ ] **Safety**: Verify Falconsai/nsfw_image_detection is active on all `/progress` calls.
- [ ] **Safety**: Confirm NSFW retry limit (3 times) is enforced.
- [ ] **Transparency**: Privacy Policy and Terms of Service links accessible from Settings.
- [ ] **Transparency**: Pricing for Patron/Creator packs matches Store listing exactly.

## Operational Readiness
- [ ] **Monitoring**: Sentry/Datadog integration active and alerting.
- [ ] **Storage**: S3 Lifecycle policy active (discarding old generation steps).
- [ ] **Infrastructure**: GPU worker auto-scaling/availability verified.

