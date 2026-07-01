---
id: template.data-model
version: 1.0
loop_stage: 02-development
---

<!-- DATA MODEL ARTIFACT TEMPLATE -->

```yaml
id: MODEL-001
title: Purchase Request Data Model
architectureDesignId: AD-001

entities:
  - name: PurchaseRequest
    fields:
      - name: id
        type: string
        required: true
        unique: true
        index: true
      - name: itemId
        type: string
        required: true
      - name: quantity
        type: integer
        required: true
      - name: status
        type: string
        required: true
      - name: createdAt
        type: datetime
        required: true
    relationships:
      - to: PurchaseItem
        type: one-to-many
      - to: Inventory
        type: many-to-one

status: Draft
traceability:
  architectureDesignId: AD-001
  apiRefs:
    - API-001
    - API-002
metadata:
  owner: Architecture Agent
  createdAt:
  updatedAt:
  version:
```
