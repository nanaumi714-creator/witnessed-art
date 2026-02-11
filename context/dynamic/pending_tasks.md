# Pending Tasks

## Execution Order (Resolve-All Plan)

### Phase 1: Blocker Resolution (Must complete before implementation)
- [x] **P0 | T-001 | owner: security_agent**
  - Requirement links: FR-002, FR-003, App Store/Google Play safety rule #1
  - Task: Finalize NSFW threshold and retry policy in security constraints.
  - Output files: `context/rules/security_constraints.md`, `context/dynamic/decisions_log.md`
  - Done when: explicit threshold, retry limit, and reject behavior are documented and approved.

- [x] **P0 | T-002 | owner: monetization_agent**
  - Requirement links: FR-006, monetization constraints
  - Task: Finalize launch monetization pack definitions (SKU, value, limits, pricing display requirements).
  - Output files: `context/rules/monetization_rules.md`, `context/dynamic/decisions_log.md`
  - Done when: pack matrix is documented and policy-compliant on iOS/Android.

- [x] **P0 | T-003 | owner: coordinator**
  - Requirement links: project KPI governance
  - Task: Finalize go/no-go KPI thresholds for beta and initial release.
  - Output files: `context/static/project_overview.md`, `docs/requirements-v2.md`, `context/dynamic/decisions_log.md`
  - Done when: KPI targets are numeric, time-bounded, and approved.

### Phase 2: Spec Synchronization (Spec-first enforcement)
- [x] **P0 | T-004 | owner: spec_agent**
  - Requirement links: FR-001 to FR-008
  - Task: Synchronize updates between `docs/` and `context/` after T-001 to T-003 closure.
  - Output files: affected `docs/*`, affected `context/*`
  - Done when: no unresolved contradiction remains between docs and context.

### Phase 3: Contract and Design Finalization
- [x] **P1 | T-005 | owner: backend_agent**
  - Requirement links: FR-001, FR-002, FR-004, FR-005, FR-006, FR-EC-001..004
  - Task: Expand API contract to endpoint-level schema, auth, idempotency, and error codes.
  - Output files: `context/rules/contracts/api_contracts.md`, `context/rules/data_contracts.md`
  - Done when: every endpoint has request/response/error schema and edge-case mapping.

- [x] **P1 | T-006 | owner: ai_pipeline_agent**
  - Requirement links: FR-001, FR-002, FR-003
  - Task: Finalize deterministic progression flow (phase params, seed policy, NSFW gate, delete timing).
  - Output files: `context/rules/ai_generation_pipeline.md`, `context/rules/image_progression_rules.md`
  - Done when: run-to-run deterministic expectations are testable and auditable.

- [x] **P1 | T-007 | owner: flutter_agent**
  - Requirement links: FR-002, FR-003, FR-004, FR-005, FR-008
  - Task: Define UI state transitions and irreversible-action confirmations.
  - Output files: `context/rules/ui_behavior.md`
  - Done when: lock states, confirmations, and prohibited UX patterns are explicitly covered.

- [x] **P1 | T-008 | owner: monetization_agent**
  - Requirement links: FR-006, platform policy rules
  - Task: Formalize ad reward and purchase compliance checks.
  - Output files: `context/rules/operations/release_checklist.md`, `context/rules/monetization_rules.md`
  - Done when: anti-replay, transparency, and payment-route checks are release-gated.

### Phase 4: QA and Release Readiness
- [x] **P1 | T-009 | owner: qa_agent**
  - Requirement links: FR-001 to FR-008, FR-EC-001..004, non-functional requirements
  - Task: Build requirement-to-test matrix and evidence template.
  - Output files: `context/rules/operations/test_strategy.md`
  - Done when: each FR/EC has test IDs and pass criteria with measurable evidence.

- [x] **P1 | T-010 | owner: coordinator**
  - Requirement links: release governance
  - Task: Verify all phase outputs and authorize implementation start.
  - Output files: `context/dynamic/current_sprint.md`, `context/dynamic/changelog.md`
  - Done when: all P0 tasks closed and all P1 tasks accepted.
