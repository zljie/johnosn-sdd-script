---
id: template.software-delivery-package
version: 1.0
loop_stage: 04-release
---

<!-- SOFTWARE DELIVERY PACKAGE ARTIFACT TEMPLATE -->

```yaml
id: SDP-001
release:
  version: 1.2.0
  releaseDate: 
  releaseType: Minor
  environment: production
  owner: 

requirementArtifact: REQ-001
productSpecification: PS-001
technicalSpecification: TS-001
architectureDesign: AD-001

apiContracts:
  - API-001
  - API-002

dataModels:
  - MODEL-001

implementation:
  frontend:
    - FI-001
  backend:
    - BI-001
  buildArtifacts:
    - 

qualityEvidencePackage: QEP-001
deliveryReviewReport: DRR-001

releaseNotes: |
  ## Delivered Capabilities
  - Create purchase requests
  - Recommend transfer warehouses

  ## Fixed Defects
  - BUG-001

  ## Known Limitations
  - 

deploymentManifest:
  - 

rollbackPlan:
  triggerConditions:
    - 
  recoverySteps:
    - 
  previousVersion: 1.1.9
  dataRecovery:
    - 
  validationSteps:
    - 

auditRecords:
  - 

versionMetadata:
  product: 1.2.0
  build: 12345
  api: v1
  dataModel: v1
  compatibility: Backward Compatible

status: Released
traceability:
  allArtifacts:
    - REQ-001
    - PS-001
    - TS-001
    - AD-001
    - API-001
    - MODEL-001
    - FI-001
    - BI-001
    - TC-001..TC-120
    - TR-001
    - QEP-001
    - DRR-001

metadata:
  createdAt:
  updatedAt:
  version:
```
