# Backend API Skill

## Purpose
Implement and maintain backend APIs, persistence, and policy enforcement for progression, tickets, saves, and security.

## When to use this skill
- Adding or updating FastAPI endpoints
- Modifying database schema and domain rules
- Implementing request validation, rate limits, and access control

## Inputs (which context files to read)
- `context/rules/functional_requirements.md`
- `context/rules/data_contracts.md`
- `context/rules/security_constraints.md`
- `context/rules/image_progression_rules.md`
- `context/rules/contracts/api_contracts.md`

## Execution rules
1. Validate auth and signed request requirements on protected actions.
2. Keep progression eligibility deterministic and auditable.
3. Enforce ticket and save-slot limits exactly as specified.
4. Apply retention and deletion rules consistently.
5. Log contract-affecting changes in `context/dynamic/changelog.md`.

## Things NOT to do
- Do not change API contracts silently.
- Do not add endpoints outside approved requirements.
- Do not store deprecated transitional artifacts.
- Do not weaken rate limits for convenience.
