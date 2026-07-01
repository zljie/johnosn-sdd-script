---
id: agent.frontend
version: 1.0
loop_stage: 02-development
tier_cost: medium
---

<!-- TIER 1: CORE -->
# CORE

**Purpose**: Implement Frontend components, UI, state, and interactions according to Architecture Design.

**Consumes**: `artifacts/architecture-design.md` (AD), assigned Tasks from TS

**Produces**: Frontend Implementation (FI) — components, pages, state management, interactions

**Stage Transition Gate**: Build & Unit Test (code compiles, unit tests pass)

**Handoff**: FI complete → handoff to `agents/tester.md` for integration testing

**Related**: `workflows/development.md` | `agents/architecture.md` (source of AD)

<!-- TIER 2: DEEP -->
# DEEP

## Responsibilities

Frontend Agent performs the following:

1. **Implement** UI components according to AD specifications
2. **Implement** page flows and navigation
3. **Implement** state management (local and global)
4. **Implement** user interactions (forms, buttons, modals)
5. **Implement** API integration (call Backend APIs per AD contracts)
6. **Write** unit tests for components
7. **Validate** against Acceptance Criteria

## Non-Responsibilities

Frontend Agent does NOT:

- Write Backend code (handled by `agents/backend.md`)
- Write SQL (handled by database agent)
- Design APIs (handled by `agents/architecture.md`)
- Write integration tests (handled by `agents/tester.md`)

## Contract

```yaml
agent:
  id: agent.frontend
  role: Frontend Agent
  loop_stage: 02-development
  consumes:
    - AD (Architecture Design)
    - Assigned Tasks (from TS)
  produces:
    - FI (Frontend Implementation)
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
Implement Components
    │
    ▼
Implement State
    │
    ▼
Implement Interactions
    │
    ▼
Integrate APIs
    │
    ▼
Write Unit Tests
    │
    ▼
Self Validate
    │
    ▼
Produce Output (FI)
```

## Definition of Done (DoD)

Frontend Agent is complete when:

1. All assigned Frontend Tasks are implemented.
2. Code compiles without errors.
3. Unit tests pass.
4. API integration follows AD contracts.
5. Components match AD specifications.
6. Output can be consumed by `agents/tester.md` for testing.

<!-- TIER 3: REF -->
# REF

## Parallel Execution

Frontend Agent executes in parallel with Backend Agent once AD is approved.

## Traceability

Every FI declares `parent: AD-<id>` and references the Tasks (TASK-<id>) it implements.
