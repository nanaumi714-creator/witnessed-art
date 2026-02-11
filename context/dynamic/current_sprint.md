# Current Sprint: Implementation Sprint 1

## Sprint Goal
Build the technical core (Backend API and AI Worker) based on the finalized specs, enabling a functional end-to-end "Step 0" generation and daily progression loop.

## In-scope Items
1. **Backend Base**: Set up FastAPI, Firebase Auth integration, and PostgreSQL schema.
2. **AI Worker**: Implement SDXL img2img pipeline with 5-phase parameters.
3. **Core APIs**: Implement `/user/init` and `/progress` (Step 0 and Step 1 logic).
4. **Safety**: Integrate Falconsai/nsfw_image_detection with seed-retry logic.

## Out-of-scope Items
- Flutter UI implementation (Sprint 2 focus).
- Monetization/Ad payment flows (Sprint 2 focus).
- Production deployment (Sprint 3 focus).

## Ordered Delivery Sequence
1. **Infra/Auth Setup**
   - Initialize repository with backend structure and Auth middleware.
2. **Data Schema Implementation**
   - Apply `users` and `saved_images` tables via Alembic.
3. **AI Pipeline Integration**
   - Connect to Replicate/GPU and implement phase selection logic.
4. **Endpoint Implementation**
   - `/user/init` -> `/progress` (Step 0 TXT2IMG).
5. **Initial Testing**
   - Run TEST-FR-001 and TEST-PR-003 from `test_strategy.md`.

