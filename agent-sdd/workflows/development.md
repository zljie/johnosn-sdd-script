---
id: workflow.development
version: 1.0
loop_stage: 02-development
tier_cost: medium
---

<!-- TIER 1: CORE -->
# CORE

**Purpose**: Define the Development Flow — the process of translating requirements into shippable software through product, technical, and architectural design, then implementation.

**Owners**:
- `agents/product-manager.md` (Product)
- `agents/technical-manager.md` (Technical)
- `agents/architecture.md` (Architecture)
- `agents/frontend.md` (Frontend)
- `agents/backend.md` (Backend)

**Consumes**: `artifacts/requirement.md` (REQ)

**Produces**: `artifacts/product-specification.md` (PS), `artifacts/technical-specification.md` (TS), `artifacts/architecture-design.md` (AD), Implementation Packages (FI, BI)

**Quality Gates**:
1. Product Review
2. Technical Review
3. Architecture Review
4. Build & Unit Test

**Handoff**: All gates PASS and implementation complete → enter `loop/03-testing.md`

**Related**: `loop/02-development.md` | all agents in stage 02

<!-- TIER 2: DEEP -->
# DEEP

## Stages

### Stage 1: Product Specification

**Owner**: `agents/product-manager.md`

**Input**: REQ

**Output**: PS (User Stories, Acceptance Criteria, Business Rules, Test Scenarios, Product Scope)

### Stage 2: Technical Planning

**Owner**: `agents/technical-manager.md`

**Input**: PS

**Output**: TS (Architecture Overview, Technical Solution, Impact Analysis, Task Breakdown, Dependency Graph, Risk Analysis, Estimate)

### Stage 3: Architecture Design

**Owner**: `agents/architecture.md`

**Input**: TS

**Output**: AD (System Context, Component Diagram, Domain Model, Data Model, API Contract, Sequence Diagram, Deployment View, Security Design, Exception Strategy, Logging Strategy, ADRs)

### Stage 4: Implementation

**Owners**: `agents/frontend.md`, `agents/backend.md` (parallel after AD frozen)

**Input**: AD, assigned Tasks

**Output**: Frontend Implementation (FI), Backend Implementation (BI)

## Artifact Flow

```
REQ
    │
    ▼
PS
    │
    ▼
TS
    │
    ▼
AD
    │
    ├─▶ FI
    └─▶ BI
```

## Quality Gates

| Gate | Validates | HITL? |
|------|-----------|-------|
| Product Review | PS completeness, story INVEST compliance | ✅ |
| Technical Review | TS feasibility, task breakdown | ✅ |
| Architecture Review | AD coverage, API contracts frozen | ✅ |
| Build & Unit Test | Code compiles, unit tests pass | ❌ (CI) |

## Parallel Execution

Once AD is frozen, Frontend and Backend execute concurrently:
- API Contract frozen
- Domain Model confirmed

## Definition of Done (DoD)

Development Flow is complete when:

1. All stages executed.
2. All Artifacts generated and conform to schemas.
3. All Quality Gates passed.
4. All feedback closed or explicitly accepted.
5. Traceability chain complete.
6. Delivery Package formed, ready for Release Flow.

<!-- TIER 3: REF -->
# REF

## Runtime Contract

```yaml
workflow:
  id: DevelopmentFlow
  stages:
    - Product Specification
    - Technical Planning
    - Architecture Design
    - Implementation
  produces:
    - Implementation Package
  next:
    - TestingFlow
  quality_gate:
    - Build Passed
    - Unit Test Passed
```
