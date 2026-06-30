---
id: loop.stage.04-release
version: 1.0
loop_stage: 04-release
tier_cost: high
---

<!-- TIER 1: CORE -->
# CORE

## Purpose

Govern the final delivery decision, assemble a complete Software Delivery Package, and authorize production release.

## Owner

`agents/reviewer.md`

## Workflow

`workflows/release.md`

## Artifacts

- **Consumes**: `artifacts/quality-evidence-package.md` (QEP), all prior artifacts
- **Produces**: `artifacts/delivery-review-report.md` (DRR), `artifacts/software-delivery-package.md` (SDP)

## Quality Gates

1. **Delivery Review** — DRR completeness, traceability, quality gates, release recommendation
2. **Release Approval (HITL)** — human authorizes production deployment

- Any **FAIL** → emit `FeedbackArtifact` (target: any earlier stage), loop restart

## Handoff

SDP approved → loop iteration complete; customer feedback may restart loop at `01-requirement`

## Related

- `agents/reviewer.md`
- `workflows/release.md`
- `artifacts/delivery-review-report.md`, `artifacts/software-delivery-package.md`

<!-- TIER 2: DEEP -->
# DEEP

## Stage Definition

Stage 04 runs the Release Flow defined in `workflows/release.md`:
- Release Preparation (assemble SDP candidates)
- Release Validation (build, package, dependency checks)
- Release Approval (HITL — Product Owner, Engineering Manager, Release Manager)
- Release Execution (deploy, smoke test, health check)
- Release Verification (post-deployment validation)
- Release Closure (audit, rollback plan archived)

## Quality Gate Details

### Delivery Review Gate

The `DeliveryReviewReport` must validate:

| Check | Required? |
|-------|-----------|
| Requirement completeness | ✅ |
| Product completeness | ✅ |
| Technical completeness | ✅ |
| Architecture conformance | ✅ |
| Implementation completeness | ✅ |
| Testing evidence | ✅ |
| Traceability chain (REQ→SDP) | ✅ |
| Risk assessment | ✅ |

### Release Approval Gate (HITL)

Mandatory human approval from:
- Product Owner
- Engineering Manager
- Release Manager

Approval is recorded as an immutable audit event.

## Software Delivery Package

The SDP is the authoritative delivery artifact. It contains:
- Release information
- All approved artifacts (REQ, PS, TS, AD, API, DataModel)
- Implementation packages (build artifacts)
- Quality Evidence Package (QEP)
- Delivery Review Report (DRR)
- Release notes
- Deployment manifest
- Rollback plan
- Audit records

## Feedback Cases

If release is rejected or fails verification:
1. Emit `FeedbackArtifact` targeting the responsible stage
2. Loop restarts at that stage
3. Current loop iteration is terminated

## Post-Release

Customer feedback, incidents, or production issues may trigger new `FeedbackArtifact`s pointing back to `01-requirement`, starting a new loop iteration.

## Related

- `loop/03-testing.md` — previous stage (source of QEP)
- `loop/01-requirement.md` — target for feedback restart

<!-- TIER 3: REF -->
# REF

## Example Artifact Flow

QEP-001
  │
  ▼
DRR-001 (Delivery Review Report)
  │
  ▼
SDP-001 (Software Delivery Package)
  │
  ▼
Production Release (v1.2.0)

## Traceability

The SDP forms the root of the traceability tree:

```
SDP-001
├── REQ-001
│   └── PS-001
│       └── TS-001
│           └── AD-001
│               ├── FI-001
│               └── BI-001
└── QEP-001
    └── TC-001..TC-120
```

## Rollback

Every SDP includes a rollback plan. If release verification fails:
1. Execute rollback
2. Generate incident report
3. Emit `FeedbackArtifact` targeting the responsible stage
