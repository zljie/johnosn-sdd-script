---
id: template.api
version: 1.0
loop_stage: 02-development
---

<!-- API ARTIFACT TEMPLATE -->

```yaml
id: API-001
name:
method: POST
path: /purchase-request
version: v1
description:
owner: Purchase Service

authorization:
  required: true
  schemes:
    - JWT
  scopes:
    - purchase:create
  roles:
    - ProcurementClerk

request:
  contentType: application/json
  headers:
    - name: Authorization
      required: true
  body:
    $ref: '#/definitions/PurchaseRequest'

response:
  success:
    status: 201
    body:
      $ref: '#/definitions/PurchaseRequestResponse'

errorCodes:
  - code: VALIDATION_ERROR
    status: 400
    message: Invalid request payload
    category: Validation
  - code: UNAUTHORIZED
    status: 401
    message: Authentication required
    category: Security

idempotent: false
rateLimit:
  enabled: true
  requestsPerMinute: 100

observability:
  traceEnabled: true
  metricsEnabled: true
  auditLog: false

status: Draft
traceability:
  architectureDesignId: AD-001
  storyIds:
    - US-001
  dataModelRefs:
    - MODEL-001
metadata:
  createdAt:
  updatedAt:
  version:

definitions:
  PurchaseRequest:
    type: object
    required: [itemId, quantity]
    properties:
      itemId:
        type: string
      quantity:
        type: integer
```
