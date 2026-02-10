# Monetization Skill

## Purpose
Implement monetization features that respect the core experience and platform compliance.

## When to use this skill
- Working on ad rewards and ticket issuance
- Working on paid save slots, skins, or resolution upgrades
- Preparing purchase behavior for release validation

## Inputs (which context files to read)
- `context/rules/monetization_rules.md`
- `context/rules/functional_requirements.md`
- `context/rules/security_constraints.md`
- `context/rules/operations/release_checklist.md`

## Execution rules
1. Keep monetization additive, never replacing core progression semantics.
2. Enforce max ticket and slot boundaries.
3. Ensure store-policy compliant payment flows.
4. Keep pricing and value clearly represented in product-facing docs.
5. Update `context/dynamic/changelog.md` after approved changes.

## Things NOT to do
- Do not block basic daily progression behind payment.
- Do not add deceptive ad placement.
- Do not mix unsupported payment methods in mobile builds.
- Do not change economics without explicit product approval.
