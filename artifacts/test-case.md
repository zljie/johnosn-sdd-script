---
id: artifact.test-case
version: 1.0
loop_stage: 03-testing
tier_cost: medium
---

<!-- TIER 1: CORE -->

Version: 1.0

Status: Draft

Artifact ID: TC

---

# 1. Purpose

The Test Case (TC) Artifact defines a verifiable engineering contract used to validate software behavior.

Each Test Case proves that one or more engineering contracts have been satisfied.

Examples include:

- Business Requirements
- User Stories
- Acceptance Criteria
- Business Rules
- API Contracts
- Data Contracts
- Architecture Constraints

The Test Case does not describe implementation.

It describes expected system behavior.

---

# 2. Ownership

| Stage | Owner |
|--------|-------|
| Produce | Tester Agent |
| Review | Product Manager Agent |
| Consume | Testing Flow |
| Govern | Reviewer Agent |

The Test Case Artifact is owned by the Tester Agent.

---

# 3. Lifecycle

```text
Draft

↓

Review

↓

Approved

↓

Executed

↓

Verified

↓

Archived
```

Test Cases become immutable after approval.

Behavior changes require a new version.

---

# 4. Objectives

The Test Case verifies:

- Business Requirements
- User Stories
- Acceptance Criteria
- Business Rules
- API Contracts
- Data Contracts
- Architecture Constraints

A Test Case verifies behavior rather than implementation.

---

# 5. Artifact Structure

```text
Test Case

├── Metadata

├── Objective

├── Preconditions

├── Test Data

├── Test Steps

├── Expected Results

├── Verification Rules

├── Traceability

├── Automation

└── Version
```

---

# 6. Metadata

Each Test Case shall contain:

```yaml
testCase:

  id:

  title:

  owner:

  priority:

  type:

  status:

  version:
```

---

# 7. Objective

Describe what engineering contract is being verified.

Example

```text
Verify that a Purchase Request can be submitted successfully after mandatory fields have been completed.
```

The objective should reference business intent.

---

# 8. Preconditions

Document required conditions.

Examples

- User is authenticated.
- Inventory exists.
- Supplier is active.
- Purchase amount is within approval threshold.

Preconditions shall be explicit.

---

# 9. Test Data

The Test Case defines required business data.

Example

```yaml
testData:

  requester:

  warehouse:

  supplier:

  amount:
```

Test data shall be deterministic.

---

# 10. Test Steps

Describe the business actions.

Example

```text
1. Create Purchase Request.
2. Enter mandatory fields.
3. Submit the request.
```

Steps should describe user behavior.

Not UI implementation.

---

# 11. Expected Results

Expected Results define observable outcomes.

Example

```text
Purchase Request is created.

Status becomes Submitted.

Confirmation notification is generated.
```

Expected Results must be measurable.

---

# 12. Verification Rules

Each Test Case shall explicitly define what is being verified.

Examples

- Business Rule
- API Response
- State Transition
- Event Generation
- Authorization
- Data Integrity

Verification Rules separate validation from execution.

---

# 13. Traceability

Every Test Case shall reference:

```text
Requirement

↓

Product Specification

↓

User Story

↓

Acceptance Criteria

↓

Architecture Design

↓

API Contract

↓

Data Model

↓

Test Case
```

Traceability is mandatory.

---

# 14. Automation

Every Test Case should define its execution strategy.

Examples

- Manual
- Automated
- API Test
- UI Test
- Integration Test
- End-to-End Test
- Performance Test
- Security Test

Automation is metadata.

Not implementation.

---

# 15. Runtime Contract

```yaml
artifact:

  id: TC

  owner:

    Tester Agent

  consumes:

    - Product Specification

    - Architecture Design

    - API Contract

    - Data Model

  produces:

    - Test Execution Result

    - Quality Evidence

  validates:

    - Acceptance Criteria

    - Business Rules

    - Architecture Constraints
```

---

# 16. Quality Rules

Every Test Case shall be:

- Deterministic
- Repeatable
- Traceable
- Independent
- Observable
- Reviewable
- Versioned

Expected Results shall be objective.

---

# 17. Definition of Done

A Test Case is complete when:

- Objective is defined.
- Preconditions are documented.
- Test Data is prepared.
- Test Steps are complete.
- Expected Results are measurable.
- Verification Rules are defined.
- Traceability is complete.
- Execution strategy is identified.
- Product Review has been completed.

Only approved Test Cases may be executed.