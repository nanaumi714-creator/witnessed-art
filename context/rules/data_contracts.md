# Data Contracts

- **User State**: Includes `seed` (int64), `step` (int), `current_image_path` (string), `last_progressed_at` (timestamp, UTC), `tickets` (int), `max_save_slots` (int).
- **Seed Generation**: 
  - Generated at run start. 
  - Type: signed 64-bit integer (PostgreSQL `BIGINT`). 
  - Range: `0` to `2^63 - 1` (to avoid sign issues).
  - Strategy: CSPRNG `uint64` masked to 63-bit.
- **Saved Image Records**: Includes immutable copy of image path and run metadata (seed, final_step) at time of save.
- **Deletion Behavior**: 
  - Periodic cleanup not needed for "Current" state.
  - Intermediate generations in a multi-step run MUST be deleted immediately upon success of the next step to minimize S3 costs.

