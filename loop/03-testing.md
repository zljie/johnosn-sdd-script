---
id: loop.stage.03-testing
version: 1.0
loop_stage: 03-testing
tier_cost: medium
---

<!-- TIER 1: CORE -->
# CORE

## Purpose

Validate that the delivered implementation satisfies all requirements through structured testing and evidence collection.

## Owner

`agents/tester.md`

## Workflow

`workflows/testing.md`

## Artifacts

- **Consumes**: implementation packages, `artifacts/product-specification.md` (PS), `artifacts/architecture-design.md` (AD)
- **Produces**: `artifacts/test-case.md` (TC), `artifacts/test-report.md` (TR), `artifacts/quality-evidence-package.md` (QEP)

## Quality Gate

**Test Validation** — all tests executed, evidence collected, coverage 100%

- **PASS** → handoff to `04-release`
- **FAIL** → emit `FeedbackArtifact` (target: `02-development` for bug fixes, or `01-requirement` for requirement issues), loop restart

## Handoff

QEP approved → enter `loop/04-release.md`

## Related

- `agents/tester.md`
- `workflows/testing.md`
- `artifacts/test-case.md`, `artifacts/test-report.md`, `artifacts/quality-evidence-package.md`
- `schemas/test-case.schema.yaml`

<!-- TIER 2: DEEP -->
# DEEP

## Stage Definition

Stage 03 executes all testing levels defined in `workflows/testing.md`:
- Functional Tests (per User Story)
- Integration Tests
- End-to-End Tests
- Regression Tests
- (Optional) Performance, Security, Accessibility tests

## Quality Gate Details

The Test Validation gate checks:

| Check | Required? |
|-------|-----------|
| Requirement Coverage | 100% (every REQ verified) |
| Story Coverage | 100% (every US validated) |
| Acceptance Criteria Coverage | 100% (every AC satisfied) |
| Test Execution | All planned tests executed |
| Evidence Collected | Every test has immutable evidence |
| Critical Bugs | 0 |

## Evidence

Every test execution produces evidence artifacts (logs, screenshots, API responses, traces). Evidence is immutable and referenced by the `QualityEvidencePackage`.

## Feedback Cases

If bugs are found:
1. Create `BugArtifact` (BUG-<id>)
2. Emit `FeedbackArtifact` pointing to `02-development`
3. Loop restarts at development stage; bugs become tasks in the next iteration

## HITL

Test Review (HITL) is recommended — a human confirms that the quality evidence is sufficient and no critical risks remain before proceeding to release.

## Related

- `loop/02-development.md` — previous stage (source of implementation)
- `loop/04-release.md` — next stage

<!-- TIER 3: REF -->
# REF

## Example Artifact Flow

Implementation (FI-001, BI-001)
  │
  ▼
TC-001..TC-120 (Test Cases)
  │
  ▼
TR-001 (Test Report)
  │
  ▼
QEP-001 (Quality Evidence Package)

## Traceability

Every `TestCase` declares:
- `parent: US-<id>`
- `architectureDesignId: AD-<id>`

Every `TestReport` and `QualityEvidencePackage` references all executed TCs.

## Bug Lifecycle

BUG-001 (from TC-045 failure)
  │
  ▼
TASK-034 (Backend fix)
  │
  ▼
TC-045 (re-test) → PASS
