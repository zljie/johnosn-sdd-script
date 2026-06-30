---
id: artifact.data-model
version: 1.0
loop_stage: 02-development
tier_cost: medium
---

<!-- TIER 1: CORE -->

Version: 1.0

Status: Draft

Artifact ID: DM

---

# 1. Purpose

The Data Model Artifact defines the business data contracts used throughout the software system.

It describes **business entities**, their relationships, lifecycle, ownership, validation rules, and business semantics.

The Data Model is independent of any persistence technology.

It does not describe database implementation.

Instead, it defines the canonical business representation of information shared across the system.

---

# 2. Ownership

| Stage | Owner |
|--------|-------|
| Produce | Architecture Agent |
| Review | Technical Manager |
| Consume | Backend Agent |
| Consume | Frontend Agent |
| Consume | Tester Agent |
| Govern | Reviewer Agent |

The Data Model belongs to the Architecture layer.

Implementation agents shall not modify business data contracts.

---

# 3. Lifecycle

```text
Draft

↓

Review

↓

Approved

↓

Implemented

↓

Verified

↓

Released

↓

Archived
```

Approved Data Models become immutable.

Changes require versioning.

---

# 4. Objectives

The Data Model defines:

- Business Entities
- Attributes
- Relationships
- Ownership
- Validation Rules
- Lifecycle
- Events
- Business Constraints

The Data Model intentionally excludes:

- SQL
- Tables
- Indexes
- Storage Engines
- ORM Mappings

These belong to implementation.

---

# 5. Data Model Structure

```text
Data Model

├── Entity Definitions

├── Attributes

├── Relationships

├── Ownership

├── Business Rules

├── Validation Rules

├── Lifecycle

├── Events

├── Policies

└── Version
```

---

# 6. Entity Definition

Every entity represents a business concept.

Example

```text
Purchase Request

Purchase Order

Supplier

Warehouse

Inventory

Customer
```

Entities are technology independent.

---

# 7. Attributes

Each entity defines its business attributes.

Example

```yaml
entity:

  PurchaseRequest

attributes:

  id

  requester

  warehouse

  status

  totalAmount

  createdAt
```

Attributes describe business meaning.

Not database columns.

---

# 8. Relationships

Entities shall define relationships.

Example

```text
Purchase Request

──────────────► Supplier

Purchase Request

──────────────► Warehouse

Purchase Request

──────────────► Purchase Order
```

Relationships are directional and explicit.

---

# 9. Ownership

Each entity has one owner.

Example

| Entity | Owner |
|----------|--------|
| Purchase Request | Procurement Service |
| Supplier | Supplier Service |
| Inventory | Inventory Service |

Ownership guarantees consistency.

---

# 10. Business Rules

Business rules define semantic constraints.

Example

- Purchase Amount > 0
- Warehouse must exist
- Supplier must be active
- Status must follow lifecycle

Business rules are implementation independent.

---

# 11. Validation Rules

Validation belongs to the data contract.

Example

```yaml
validation:

  required:

    - requester

    - warehouse

  maximum:

    totalAmount: 1000000
```

Validation rules are reusable.

---

# 12. Lifecycle

Entities define lifecycle states.

Example

```text
Draft

↓

Submitted

↓

Approved

↓

Ordered

↓

Completed

↓

Archived
```

Lifecycle belongs to business semantics.

---

# 13. Events

Entities define business events.

Example

```text
PurchaseRequestCreated

PurchaseRequestApproved

PurchaseOrderCreated

InventoryReserved
```

Events describe business changes.

---

# 14. Policies

Policies define governance.

Examples

- Retention Policy
- Access Policy
- Approval Policy
- Security Policy

Policies are independent from implementation.

---

# 15. Runtime Contract

```yaml
artifact:

  id: DM

  owner:

    Architecture Agent

  consumes:

    - Architecture Design

  produces:

    - Backend Implementation

    - Frontend Models

    - Test Scenarios

  validates:

    - Business Consistency

    - Entity Ownership

    - Relationship Integrity
```

---

# 16. Traceability

Every entity shall reference:

```text
Requirement

↓

Product Specification

↓

Architecture Design

↓

Data Model

↓

Implementation

↓

Testing

↓

Release
```

Business traceability is mandatory.

---

# 17. Quality Rules

Every Data Model must satisfy:

- Complete
- Consistent
- Technology Independent
- Traceable
- Reviewable
- Versioned
- Governed

---

# 18. Definition of Done

The Data Model Artifact is complete when:

- Business entities are identified.
- Attributes are defined.
- Relationships are complete.
- Ownership is assigned.
- Validation rules are documented.
- Lifecycle is defined.
- Events are identified.
- Policies are documented.
- Runtime contract is validated.
- Traceability is complete.
- Technical review has passed.