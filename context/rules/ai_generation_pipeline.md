# AI Generation Pipeline

## Generation Logic
- **Step 0**: Uses `txt2img` to create the initial noise-base (thin gradient).
- **Steps 1+**: Uses `img2img` to advance the image.
- **Denoising Strategy**: Decreases as steps increase to stabilize the image.

## Phase Parameters (SDXL)

| Phase | Steps | Denoise | CFG | Status |
|---|---|---|---|---|
| 0 (Step 1-2) | 12 | 0.95 | 4.5 | Noise / Presence |
| 1 (Step 3-5) | 18 | 0.80 | 5.0 | Shape Emergence |
| 2 (Step 6-9) | 24 | 0.60 | 5.5 | Artistic Formation |
| 3 (Step 10-14)| 32 | 0.40 | 6.0 | Stability / Maturation |
| 4+ (Step 15+) | 36 | 0.30 | 6.0 | Maintenance / Refinement |

## Prompts

### Positive Prompt
```text
abstract watercolor painting, serene landscape, gentle colors,
artistic, dreamy atmosphere, soft lighting, peaceful,
professional digital art, high quality, safe for work
```

### Negative Prompt
```text
nude, nsfw, explicit, sexual content, violence, gore, blood,
disturbing, horror, scary, inappropriate, realistic photo,
text, watermark, signature, low quality, blurry
```

## Deterministic Flow & Safety
- **Seed Policy**: Seed is generated at run start and remains fixed. For NSFW retries, temporary offset `seed + 1` is used up to 3 times.
- **Safety Gate**: Falconsai/nsfw_image_detection (Threshold > 0.7).
- **Cleanup Policy**: 
  - To minimize storage costs, the "Before" image MUST be deleted from S3 immediately upon the backend successfully persisting the "After" image to S3 and updating the database.
  - The client is responsible for local caching of the "Before" image to ensure smooth crossfade animations.


## Execution Note
Operational HOW details are maintained in `skills/image_generation/SKILL.md`.

