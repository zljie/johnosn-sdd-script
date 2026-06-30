---
id: template.test-report
version: 1.0
loop_stage: 03-testing
---

<!-- TEST REPORT ARTIFACT TEMPLATE -->

```yaml
id: TR-001
executionDate: 
executedBy: 
environment: Staging

testCases:
  - TC-001
  - TC-002
  - TC-003

results:
  - testCaseId: TC-001
    status: PASS
    duration: 4.2
    timestamp: 
    executor: 
    comments:
    evidenceRefs:
      - type: Log
        ref:
  - testCaseId: TC-002
    status: FAIL
    duration: 2.1
    timestamp: 
    executor: 
    comments: 
    evidenceRefs:
      - type: Screenshot
        ref:
    defectRefs:
      - BUG-001

defects:
  - id: BUG-001
    severity: High
    testCaseId: TC-002
    description: 
    status: Open

metrics:
  executed: 150
  passed: 147
  failed: 3
  passRate: 98.0
  averageDuration: 4.3

status: Completed
traceability:
  qualityEvidencePackageId: QEP-001

metadata:
  owner: Tester Agent
  createdAt:
  updatedAt:
  version:
```
