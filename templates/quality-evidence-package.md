---
id: template.quality-evidence-package
version: 1.0
loop_stage: 03-testing
---

<!-- QUALITY EVIDENCE PACKAGE ARTIFACT TEMPLATE -->

```yaml
id: QEP-001
version: 1.0.0
owner: Tester Agent
scope:
testPeriod:
  start: 
  end: 

requirementCoverage:
  - requirementId: REQ-001
    status: PASS
  - requirementId: REQ-002
    status: PASS

storyCoverage:
  - storyId: US-001
    result: PASS
  - storyId: US-002
    result: PASS

acceptanceCoverage:
  - acceptanceCriteriaId: AC-001
    testCaseId: TC-001
    status: PASS

executionSummary:
  total: 150
  passed: 147
  failed: 3
  blocked: 0

defectSummary:
  critical: 0
  high: 1
  medium: 3
  low: 8

qualityMetrics:
  requirementCoverage: 100%
  storyCoverage: 100%
  acceptanceCoverage: 100%
  testPassRate: 98.0%

qualityRisks:
  - risk: Performance under load
    severity: Low
    decision: Accepted

releaseRecommendation: Ready for Review

status: Approved
traceability:
  testReportIds:
    - TR-001

metadata:
  createdAt:
  updatedAt:
```
