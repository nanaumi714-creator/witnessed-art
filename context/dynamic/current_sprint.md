# Current Sprint

## Sprint Goal
Establish a deterministic, spec-first execution sequence that resolves all current blockers (safety policy, monetization scope, KPI target) before implementation.

## In-scope Items
1. Close all high/medium-risk open questions that can affect safety, policy compliance, or release decisions.
2. Convert resolved decisions into versioned updates across `docs/` and `context/`.
3. Define API, worker, UI, monetization, and QA tasks with owners, requirement IDs, and acceptance criteria.
4. Produce a release-readiness checklist aligned with store-policy constraints.

## Out-of-scope Items
- Production code changes.
- Infrastructure scaling or cost tuning beyond documented policy constraints.
- New feature proposals outside existing FR-001 to FR-008 scope.

## Ordered Delivery Sequence
1. **Safety/Policy Decisions First**
   - Resolve NSFW threshold policy, paid pack details, and go/no-go KPI thresholds.
2. **Spec Synchronization**
   - Update `docs/requirements-v2.md` and corresponding `context/rules/*` files to keep spec-first consistency.
3. **Contract Finalization**
   - Expand API and data contracts to endpoint/schema/error-level detail and map edge cases.
4. **Implementation Planning by Layer**
   - Backend/API -> Generation Worker -> Flutter UI -> Monetization integration.
5. **Validation Planning**
   - Lock QA matrix for FR and edge cases, plus non-functional measurements.
6. **Release Gating**
   - Run policy/compliance checklist and capture evidence requirements.
