---
id: loop.stage.01-requirement
version: 1.0
loop_stage: 01-requirement
tier_cost: low
---

<!-- TIER 1: CORE -->
# CORE

## Purpose

Discover business requirements and produce a standardized Requirement Artifact (REQ).

## Owner

`agents/requirement.md`

## Workflow

`workflows/requirement.md`

## Artifacts

- **Consumes**: User Requirement (raw input)
- **Produces**: `artifacts/requirement.md` (REQ)

## Quality Gate

**Requirement Review** — validates completeness, clarity, atomicity, traceability.

- **PASS** → handoff to `02-development`
- **FAIL** → emit `FeedbackArtifact` (target: `01-requirement`), loop restart

## Handoff

REQ approved → enter `loop/02-development.md`

## Related

- `agents/requirement.md`
- `workflows/requirement.md`
- `artifacts/requirement.md`
- `schemas/requirement.schema.yaml`

<!-- TIER 2: DEEP -->
# DEEP

## Stage Definition

Stage 01 transforms raw user input (natural language, PRD, PDF, email, etc.) into a structured `Requirement Artifact` that:
- Declares a business goal and value
- Identifies target users
- Separates functional vs non-functional requirements
- Explicitly states scope, constraints, assumptions, risks, and open questions

## Execution Model

The `workflows/requirement.md` specifies the exact stages within this loop stage:
- Requirement Intake
- Analysis
- Business Context Discovery
- Structuring
- Validation
- Review (HITL)

## Quality Gate Details

The Requirement Review gate validates:

| Check | Required? |
|-------|-----------|
| Business Goal | ✅ |
| Business Value | ✅ |
| Target Users | ✅ |
| Functional Requirements | ✅ |
| Non-functional Requirements | ✅ |
| Scope (In/Out) | ✅ |
| Constraints | ✅ |
| Risks | ✅ |
| Assumptions | ✅ |
| Open Questions | ✅ |

All 10 fields must be present and non-empty (except `dependencies`, which may be empty).

## Feedback Cases

If the gate fails, `FeedbackArtifact` includes:
- `source_stage: 01-requirement`
- `target_stage: 01-requirement` (restart)
- `category: Requirement`
- `severity: High` (gate failure is high by default)
- structured list of missing/invalid fields

## HITL

Requirement Review (HITL) is mandatory — a human must approve before the loop proceeds to `02-development`.

## Related

- `loop/00-loop.md` — loop definition
- `loop/02-development.md` — next stage

<!-- TIER 3: REF -->
# REF

## Example Input

```
User says: "I want procurement clerks to create purchase orders quickly,
and when stock is low, automatically recommend transfer warehouses."
```

## Example Output

See `artifacts/requirement.md` REF section for a fully formed REQ example.

## Traceability

Every REQ declares:
- No parent (root of the traceability tree)
- Children: one or more `ProductSpecification` (produced in stage 02)
