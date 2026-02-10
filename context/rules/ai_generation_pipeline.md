# AI Generation Pipeline

- Step 0 uses txt2img.
- Later steps use img2img with phase-based parameters.
- Seed remains fixed for a run unless reset.
- NSFW filtering is mandatory before persisting output.

## Execution Note
Operational HOW details are maintained in `skills/image_generation/SKILL.md`.
