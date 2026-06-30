---
id: workflow.release
version: 1.0
loop_stage: 04-release
tier_cost: high
---

<!-- TIER 1: CORE -->
# CORE

**Purpose**: Define the Release Flow — the process of governing final delivery, assembling a Software Delivery Package, and authorizing production release.

**Owner**: `agents/reviewer.md`

**Consumes**: `artifacts/quality-evidence-package.md` (QEP), all prior artifacts

**Produces**: `artifacts/delivery-review-report.md` (DRR), `artifacts/software-delivery-package.md` (SDP)

**Quality Gates**:
1. Delivery Review (completeness, traceability, quality gates, release recommendation)
2. Release Approval (HITL)

**Handoff**: SDP approved → loop iteration complete; customer feedback may restart loop at `01-requirement`

**Related**: `loop/04-release.md` | `agents/reviewer.md` | `artifacts/software-delivery-package.md`

<!-- TIER 2: DEEP -->
# DEEP

## Stages

### Stage 1: Release Preparation

**Objective**: Assemble Release Candidate.

**Input**: Delivery Package (Source Code, Build Artifact, Release Note, Test Report, Delivery Review Report).

**Output**: Release Candidate (RC).

### Stage 2: Release Validation

**Objective**: Validate release readiness.

**Output**: Release Validation Report (Build, Package, Dependency, Version, Configuration).

### Stage 3: Release Approval (HITL)

**Objective**: Human approval to release.

**Approvers**: Product Owner, Engineering Manager, Release Manager.

**Output**: Approved / Rejected / Postponed.

### Stage 4: Release Execution

**Objective**: Deploy to production.

**Output**: Release Result (Package, Deploy, Database Migration, Smoke Test, Health Check).

### Stage 5: Release Verification

**Objective**: Verify production health.

**Output**: Release Verification Report (API, UI, Database, MQ, Cache, Monitoring).

### Stage 6: Release Closure

**Objective**: Close release and archive.

**Output**: Release Package (Release Note, Deployment Record, Audit Log, Lessons Learned).

## Artifact Flow

```
Delivery Review Report
    │
    ▼
Release Candidate
    │
    ▼
Validation Report
    │
    ▼
Release Result
    │
    ▼
Verification Report
    │
    ▼
Release Package (SDP)
```

## Quality Gates

| Gate | Must Pass |
|------|-----------|
| Delivery Review | ✅ |
| Test Report | ✅ |
| Critical Bug | 0 |
| Build Success | ✅ |
| Security Review | ✅ |
| Approval | ✅ |
| Smoke Test | ✅ |

## Rollback Strategy

Every release must include a rollback plan:
- Trigger conditions
- Recovery steps
- Previous version
- Data recovery considerations
- Validation steps

## Definition of Done (DoD)

Release Flow is complete when:

1. Release Candidate prepared.
2. Pre-release validation passed.
3. All approvals (HITL) obtained.
4. Release execution successful.
5. Smoke Test and Health Check passed.
6. Release verification complete.
7. Rollback Plan archived.
8. Release Package generated.
9. Version enters operational state.

<!-- TIER 3: REF -->
# REF

## Release Timeline

```
Code Freeze
    │
    ▼
Release Candidate
    │
    ▼
Validation
    │
    ▼
Approval
    │
    ▼
Production Release
    │
    ▼
Verification
    │
    ▼
Release Closed
```

## Runtime Contract

```yaml
workflow:
  id: ReleaseFlow
  consumes:
    - Delivery Review Report
    - Release Candidate
  produces:
    - Software Delivery Package
  quality_gate:
    - Approval Passed
    - Smoke Test Passed
    - Health Check Passed
  next:
    - Production
```
