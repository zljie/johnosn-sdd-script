---
id: workflow.testing
version: 1.0
loop_stage: 03-testing
tier_cost: medium
---

<!-- TIER 1: CORE -->
# CORE

**Purpose**: Define the Testing Flow — the process of validating that implementation satisfies all requirements through structured testing and evidence collection.

**Owner**: `agents/tester.md`

**Consumes**: Implementation packages (FI, BI), `artifacts/product-specification.md` (PS), `artifacts/architecture-design.md` (AD)

**Produces**: `artifacts/test-case.md` (TC), `artifacts/test-report.md` (TR), `artifacts/quality-evidence-package.md` (QEP)

**Quality Gate**: Test Validation (100% coverage, all tests executed, evidence collected, 0 critical bugs)

**Handoff**: QEP approved → enter `loop/04-release.md`

**Related**: `loop/03-testing.md` | `agents/tester.md` | `artifacts/quality-evidence-package.md`

<!-- TIER 2: DEEP -->
# DEEP

## Stages

### Stage 1: Test Planning

**Objective**: Define test scope and strategy.

**Output**: Test Plan (coverage targets, test levels).

### Stage 2: Test Design

**Objective**: Create test cases.

**Output**: Test Cases (TC) covering:
- Positive scenarios
- Negative scenarios
- Boundary scenarios
- Exception scenarios

### Stage 3: Test Execution

**Objective**: Execute all planned tests.

**Output**: Test Results (PASS/FAIL per TC), evidence (logs, screenshots, traces).

### Stage 4: Evidence Collection

**Objective**: Gather immutable evidence.

**Output**: Evidence Artifacts (logs, screenshots, API responses, traces, reports).

### Stage 5: Quality Assessment

**Objective**: Evaluate overall quality.

**Output**: Quality Metrics (coverage, pass rate, defect density).

### Stage 6: Quality Evidence Package

**Objective**: Assemble complete quality record.

**Output**: QEP (executive summary, coverage matrices, test execution summary, defect summary, evidence, metrics, risks, release recommendation).

## Artifact Flow

```
Implementation + PS + AD
    │
    ▼
TC (Test Cases)
    │
    ▼
Test Execution
    │
    ▼
Evidence
    │
    ▼
TR (Test Report)
    │
    ▼
QEP (Quality Evidence Package)
```

## Quality Gates

| Gate | Result |
|------|--------|
| Requirement Coverage | 100% |
| Story Coverage | 100% |
| Acceptance Criteria Coverage | 100% |
| Test Execution | All planned tests executed |
| Evidence Collected | Every test has evidence |
| Critical Bugs | 0 |

## Definition of Done (DoD)

Testing Flow is complete when:

1. Requirement coverage complete.
2. Story coverage complete.
3. Acceptance Criteria validated.
4. Business Rules verified.
5. Test execution complete.
6. Evidence collected.
7. Defect summary complete.
8. Quality metrics calculated.
9. Remaining risks documented.
10. Traceability complete.
11. Release recommendation generated.

<!-- TIER 3: REF -->
# REF

## Runtime Contract

```yaml
workflow:
  id: TestingFlow
  stages:
    - Test Planning
    - Test Design
    - Test Execution
    - Evidence Collection
    - Quality Assessment
  produces:
    - Quality Evidence Package
  next:
    - ReleaseFlow
  quality_gate:
    - Test Validation Passed
```
