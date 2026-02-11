# Monetization Rules

- Paid value includes save slot expansion and optional cosmetics.
- Ads can issue progress tickets.
- Resolution upgrades are optional paid features.
- Monetization must not break the core slow experience.

## Pack Definitions (Launch Scope)

| Item Name | Price | Type | Content |
|---|---|---|---|
| **Patron Pack** | $2.99 | One-time | Save slots +2 (total 3), No Ads, 5 seed presets |
| **Creator Pack** | $9.99 | One-time | Save slots +4 (total 5), 3 UI skins, Timelapse export |
| **High-Res Export** | $1.99 | consumable | 1024x1024 output for current image |
| **Print Data Conversion** | $4.99 | consumable | 300dpi CMYK conversion service |


## Billing and Entitlement Edge Cases

| Case ID | Trigger | Precondition | Expected Response | Retry Policy | Audit Requirement | Acceptance Test ID |
|---|---|---|---|---|---|---|
| MON-EC-001 | purchase verification timeout | store purchase succeeds but backend timeout | keep entitlement pending, do not grant twice | background verify retry for 24h | log transaction id and pending state | E2E-MON-EC-001 |
| MON-EC-002 | purchase verification failed | invalid signature or receipt mismatch | reject entitlement and show recoverable message | allow manual restore action | log failure reason code | E2E-MON-EC-002 |
| MON-EC-003 | refund notification | previously granted entitlement exists | revoke corresponding paid capability deterministically | no retry needed, one-way update | log revocation timestamp | E2E-MON-EC-003 |
| MON-EC-004 | ad reward duplicate callback | same ad id already processed | keep ticket count unchanged | no retry, mark duplicate | log anti-fraud decision | E2E-MON-EC-004 |

## Execution Note
Operational HOW details are maintained in `skills/monetization/SKILL.md`.
