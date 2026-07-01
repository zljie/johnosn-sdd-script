---
id: agent.tester
version: 1.0
loop_stage: 03-testing
tier_cost: medium
---

<!-- TIER 1: CORE -->
# CORE

**Purpose**: Validate that implementation satisfies all requirements through structured testing and evidence collection, producing a Quality Evidence Package (QEP).

**Consumes**: Implementation packages (FI, BI), `artifacts/product-specification.md` (PS), `artifacts/architecture-design.md` (AD)

**Produces**: `artifacts/test-case.md` (TC), `artifacts/test-report.md` (TR), `artifacts/quality-evidence-package.md` (QEP)

**Stage Transition Gate**: Test Validation (100% coverage, all tests executed, evidence collected, 0 critical bugs)

**Handoff**: QEP approved → handoff to `agents/reviewer.md` for delivery review

**Related**: `workflows/testing.md` | `artifacts/quality-evidence-package.md` | `schemas/test-case.schema.yaml`

<!-- TIER 2: DEEP -->
# DEEP

## Responsibilities

Tester Agent performs the following:

1. **Execute** Functional Tests per User Story
2. **Execute** Integration Tests
3. **Execute** End-to-End Tests
4. **Execute** Regression Tests
5. **(Optional)** Performance Tests, Security Tests, Accessibility Tests
6. **Collect** immutable evidence (logs, screenshots, API responses, traces)
7. **Document** bugs with severity and reproduction steps
8. **Produce** Quality Evidence Package

## Non-Responsibilities

Tester Agent does NOT:

- Fix bugs (handled by `agents/frontend.md`, `agents/backend.md` via feedback loop)
- Write code (handled by developer agents)
- Approve releases (handled by `agents/reviewer.md`)

## Contract

```yaml
agent:
  id: agent.tester
  role: Tester Agent
  loop_stage: 03-testing
  consumes:
    - FI (Frontend Implementation)
    - BI (Backend Implementation)
    - PS (Product Specification)
    - AD (Architecture Design)
  produces:
    - TC (Test Case)
    - TR (Test Report)
    - QEP (Quality Evidence Package)
  quality_gate:
    name: Test Validation
    validates:
      - requirement coverage 100%
      - story coverage 100%
      - acceptance criteria coverage 100%
      - test execution complete
      - evidence collected
      - critical bugs = 0
  feedback:
    emits:
      - FeedbackArtifact (target: 02-development for bugs)
  handoff:
    to: agents/reviewer.md
    condition: QEP approved
```

## Execution Lifecycle

```text
Receive Implementation + PS + AD
    │
    ▼
Execute Functional Tests
    │
    ▼
Execute Integration Tests
    │
    ▼
Execute E2E Tests
    │
    ▼
Execute Regression Tests
    │
    ▼
Collect Evidence
    │
    ▼
Document Bugs
    │
    ▼
Produce QEP
```

## Definition of Done (DoD)

Tester Agent is complete when:

1. Requirement coverage is 100%.
2. User Story coverage is 100%.
3. Acceptance Criteria are validated.
4. All planned tests are executed.
5. Evidence is collected and immutable.
6. Bugs are documented.
7. Quality metrics are calculated.
8. Remaining risks are documented.
9. Traceability is complete.
10. Release recommendation is generated.

<!-- TIER 3: REF -->
# REF

## Bug Lifecycle

BUG-001 (from TC-045 failure) → TASK-034 (Backend fix) → TC-045 (re-test) → PASS

## Traceability

Every TC declares `parent: US-<id>` and `architectureDesignId: AD-<id>`. Every TR and QEP references all executed TCs.
