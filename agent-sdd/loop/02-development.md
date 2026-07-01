---
id: loop.stage.02-development
version: 1.0
loop_stage: 02-development
tier_cost: medium
---

<!-- TIER 1: CORE -->
# CORE

## Purpose

Translate requirements into shippable software through product, technical, and architectural design, then implementation.

## Owners

| Role | Agent |
|------|-------|
| Product | `agents/product-manager.md` |
| Technical Planning | `agents/technical-manager.md` |
| Architecture | `agents/architecture.md` |
| Frontend | `agents/frontend.md` |
| Backend | `agents/backend.md` |

## Workflow

`workflows/development.md`

## Artifacts

- **Consumes**: `artifacts/requirement.md` (REQ)
- **Produces**: `artifacts/product-specification.md` (PS), `artifacts/technical-specification.md` (TS), `artifacts/architecture-design.md` (AD), implementation packages

## Quality Gates

1. **Product Review** — PS completeness, story INVEST compliance
2. **Technical Review** — TS feasibility, task breakdown completeness
3. **Architecture Review** — AD coverage, API contracts frozen
4. **Build & Unit Test** — implementation builds and passes unit tests

- Any **FAIL** → emit `FeedbackArtifact` (target: respective stage), loop restart

## Handoff

All gates PASS and implementation complete → enter `loop/03-testing.md`

## Related

- `agents/product-manager.md`, `agents/technical-manager.md`, `agents/architecture.md`, `agents/frontend.md`, `agents/backend.md`
- `workflows/development.md`
- `artifacts/product-specification.md`, `artifacts/technical-specification.md`, `artifacts/architecture-design.md`

<!-- TIER 2: DEEP -->
# DEEP

## Stage Definition

Stage 02 is a composite stage that runs multiple agents in sequence and parallel:

```text
REQ (from 01)
  │
  ▼
Product Manager → PS
  │
  ▼
Technical Manager → TS
  │
  ▼
Architecture → AD
  │
  ├─▶ Frontend ───┐
  │               │
  └─▶ Backend ────┴──▶ Implementation
```

## Quality Gates in Sequence

| Gate | Validates | Owner |
|------|-----------|-------|
| Product Review | PS stories, acceptance criteria, business rules | HITL (Product Owner) |
| Technical Review | TS tasks, dependencies, estimates, risks | HITL (Engineering Manager) |
| Architecture Review | AD components, API contracts, data models, ADRs | HITL (Architecture Review Board) |
| Build & Unit Test | Code compiles, unit tests pass | CI |

## Parallel Execution

Once AD is frozen, Frontend and Backend agents execute in parallel (as declared in their contracts).

## Feedback Cases

Feedback from any substage may target:
- `01-requirement` (requirement clarification)
- `02-development` (rework within stage)

## HITL

Three mandatory approval points:
1. Product Review
2. Technical Review
3. Architecture Review

## Related

- `loop/01-requirement.md` — previous stage
- `loop/03-testing.md` — next stage

<!-- TIER 3: REF -->
# REF

## Example Artifact Flow

REQ-001
  │
  ▼
PS-001 (US-001, US-002)
  │
  ▼
TS-001 (TASK-001..TASK-008)
  │
  ▼
AD-001 (API-001, MODEL-001)
  │
  ▼
Implementation (FI-001, BI-001)

## Traceability

Every artifact produced in this stage declares:
- `parent: REQ-<id>` (for PS)
- `parent: PS-<id>` (for TS)
- `parent: TS-<id>` (for AD)
- `parent: AD-<id>` (for implementation packages)
