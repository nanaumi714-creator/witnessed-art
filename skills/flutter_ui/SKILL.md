---
name: flutter_ui
description: Flutter UX implementation skill for slow progression experience
version: 1.1.0
owners:
  - flutter_agent
inputs:
  - context/rules/ui_behavior.md
  - context/rules/functional_requirements.md
  - context/rules/monetization_rules.md
  - context/static/product_philosophy.md
outputs:
  - ui implementation plan
  - state transition checklist
safety_constraints:
  - no_hidden_ad_patterns
  - no_completion_declaration
  - irreversible_flow_confirmation
---

# Flutter UI Skill

## Purpose
Implement and evolve Flutter UI behavior for progression experience, animation safety, and constrained storage UX.

## When to use this skill
- Building screens for progress, save, reset, settings, and notifications
- Updating interaction states around 24h lock and tickets
- Verifying animation lock and irreversible user actions

## Inputs (which context files to read)
- `context/rules/ui_behavior.md`
- `context/rules/functional_requirements.md`
- `context/rules/monetization_rules.md`
- `context/static/product_philosophy.md`

## Execution rules
1. Keep all progress actions explicit and user-initiated.
2. Disable interaction during Before/After animation.
3. Present irreversible actions with clear confirmation.
4. Keep wording and UX aligned with slow-experience philosophy.
5. Record completed work in `context/dynamic/changelog.md`.

## Things NOT to do
- Do not add completion declarations.
- Do not add history gallery UX by default.
- Do not introduce hidden ad interactions.
- Do not change purchase semantics without approved spec updates.
