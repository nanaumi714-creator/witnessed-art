# Context Changelog

## 2026-02-10
- Added baseline context files for AI-driven multi-agent development.
- Added contracts, decisions, and operations folders.

## 2026-02-10 (structure update)
- Reason: Separate HOW (`skills/`) from WHAT (`context/`) and split context into static/rules/dynamic for long-lived agent operation.
- Impact: Added skill playbooks, added lightweight `.agent` role cards, and moved context files to scoped folders without rewriting core content.
- Related PR/Commit: docs: reorganize AI operation structure (current branch commit history).

## 2026-02-10 (operational hardening)
- Reason: Address review feedback for stronger deterministic AI operations during implementation phase.
- Impact: Added SKILL metadata contract, validation scripts, structured open-question lifecycle, and edge-case decision rules.
- Related PR/Commit: docs: harden skills metadata and dynamic decision workflow.
