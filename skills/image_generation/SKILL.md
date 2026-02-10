---
name: image_generation
description: Deterministic SDXL progression execution skill
version: 1.1.0
owners:
  - ai_pipeline_agent
inputs:
  - context/rules/ai_generation_pipeline.md
  - context/rules/image_progression_rules.md
  - context/rules/cost_budget.md
  - context/rules/security_constraints.md
outputs:
  - worker implementation plan
  - safety and reproducibility report
safety_constraints:
  - no_auto_progression
  - mandatory_nsfw_filter
  - preserve_product_philosophy
---

# Image Generation Skill

## Purpose
Provide a deterministic execution method for image progression using SDXL img2img while preserving product philosophy.

## When to use this skill
- Implementing or modifying image generation worker logic
- Tuning progression phases, denoise settings, or safety checks
- Investigating generation reproducibility or GPU cost spikes

## Inputs (which context files to read)
- `context/rules/ai_generation_pipeline.md`
- `context/rules/image_progression_rules.md`
- `context/rules/cost_budget.md`
- `context/rules/security_constraints.md`

## Execution rules
1. Keep seed deterministic per run unless reset is explicitly requested.
2. Enforce user-trigger-only progression.
3. Run NSFW checks before persisting outputs.
4. Delete transitional old image immediately after visual transition flow is complete.
5. Record operational changes in `context/dynamic/changelog.md`.

## Things NOT to do
- Do not introduce auto-progression.
- Do not store historical image timelines.
- Do not bypass safety checks for debugging.
- Do not optimize cost by reducing core experience quality.
