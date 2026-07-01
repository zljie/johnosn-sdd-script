---
id: agent.backend
version: 1.0
loop_stage: 02-development
tier_cost: medium
---

<!-- TIER 1: CORE -->
# CORE

**Purpose**: Implement Backend services, business logic, persistence, and API endpoints according to Architecture Design.

**Consumes**: `artifacts/architecture-design.md` (AD), assigned Tasks from TS

**Produces**: Backend Implementation (BI) — services, controllers, repositories, API endpoints

**Stage Transition Gate**: Build & Unit Test (code compiles, unit tests pass)

**Handoff**: BI complete → handoff to `agents/tester.md` for integration testing

**Related**: `workflows/development.md` | `agents/architecture.md` (source of AD)

<!-- TIER 2: DEEP -->
# DEEP

## Responsibilities

Backend Agent performs the following:

1. **Implement** business services
2. **Implement** API endpoints (controllers)
3. **Implement** data access (repositories)
4. **Implement** business logic
5. **Write** unit tests for services and controllers
6. **Validate** against Acceptance Criteria

## Non-Responsibilities

Backend Agent does NOT:

- Write Frontend code (handled by `agents/frontend.md`)
- Design UI (handled by `agents/frontend.md`)
- Design APIs (handled by `agents/architecture.md`)
- Write integration tests (handled by `agents/tester.md`)

## Contract

```yaml
agent:
  id: agent.backend
  role: Backend Agent
  loop_stage: 02-development
  consumes:
    - AD (Architecture Design)
    - Assigned Tasks (from TS)
  produces:
    - BI (Backend Implementation)
  quality_gate:
    name: Build & Unit Test
    validates:
      - code compiles
      - unit tests pass
  handoff:
    to: agents/tester.md
    condition: implementation complete and unit-tested
```

## Execution Lifecycle

```text
Receive Tasks + AD
    │
    ▼
Implement Services
    │
    ▼
Implement API Endpoints
    │
    ▼
Implement Data Access
    │
    ▼
Write Unit Tests
    │
    ▼
Self Validate
    │
    ▼
Produce Output (BI)
```

## Definition of Done (DoD)

Backend Agent is complete when:

1. All assigned Backend Tasks are implemented.
2. Code compiles without errors.
3. Unit tests pass.
4. API endpoints match AD contracts.
5. Business logic satisfies Acceptance Criteria.
6. Output can be consumed by `agents/tester.md` for testing.

<!-- TIER 3: REF -->
# REF

## Parallel Execution

Backend Agent executes in parallel with Frontend Agent once AD is approved.

## Traceability

Every BI declares `parent: AD-<id>` and references the Tasks (TASK-<id>) it implements.
