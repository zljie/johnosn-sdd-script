---
id: artifact.requirement
version: 1.0
loop_stage: 01-requirement
tier_cost: low
---

<!-- TIER 1: CORE -->

Version: 1.0

Status: Draft

Artifact ID: REQ

---

# 1. Purpose

The Requirement Artifact (REQ) is the authoritative representation of a business need.

It captures the business intent behind a requested capability and defines the scope of the software delivery lifecycle.

The Requirement Artifact answers one fundamental question:

> **Why should this software exist?**

It intentionally avoids describing implementation details.

Instead, it establishes the business contract that guides all downstream engineering activities.

The Requirement Artifact is the first engineering artifact produced within the Software Delivery Loop.

---

# 2. Ownership

| Stage | Owner |
|--------|-------|
| Produce | Requirement Agent |
| Review | Business Stakeholder |
| Consume | Product Manager Agent |
| Govern | Reviewer Agent |

The Requirement Artifact is owned by the Requirement Agent.

Only approved versions may enter the Product Flow.

---

# 3. Lifecycle

```text
Draft

↓

Discovery

↓

Analysis

↓

Review

↓

Approved

↓

Consumed

↓

Archived
```

Once approved, the Requirement Artifact becomes immutable.

Business changes require a new version.

---

# 4. Objectives

The Requirement Artifact defines:

- Business Intent
- Business Goals
- Stakeholders
- Business Scope
- Constraints
- Assumptions
- Success Criteria

The Requirement Artifact intentionally excludes:

- User Stories
- UI Design
- APIs
- Database Design
- Architecture
- Implementation
- Test Cases

---

# 5. Artifact Structure

```text
Requirement

├── Overview

├── Business Problem

├── Business Goals

├── Stakeholders

├── Business Context

├── Scope

├── Constraints

├── Assumptions

├── Success Criteria

├── Risks

├── Open Questions

└── Version Information
```

---

# 6. Overview

Provide a concise description of the requested capability.

Example

```text
Enable employees to submit purchase requests online.
```

The overview should be understandable by both business and engineering stakeholders.

---

# 7. Business Problem

Describe the problem being solved.

Example

Current purchase requests are processed manually through email, resulting in long processing times and poor visibility.

The focus is the problem—not the solution.

---

# 8. Business Goals

Business goals define measurable outcomes.

Examples

- Reduce manual processing by 80%
- Reduce approval time from three days to four hours
- Improve request visibility

Goals should be measurable whenever possible.

---

# 9. Stakeholders

Identify everyone affected by the requirement.

Examples

- Requester
- Manager
- Procurement
- Finance
- System Administrator

Stakeholders provide business validation.

---

# 10. Business Context

Describe the surrounding business environment.

Include:

- Existing systems
- Business processes
- External dependencies
- Organizational constraints

Business context explains why the requirement exists.

---

# 11. Scope

Define what is included.

Example

Included

- Create Purchase Request
- Submit for Approval
- Track Request Status

Excluded

- Supplier Management
- Invoice Processing
- Mobile Application

Clear scope prevents misunderstanding.

---

# 12. Constraints

Identify business limitations.

Examples

- SAP ERP must remain the system of record.
- Existing approval hierarchy cannot change.
- Corporate security policies must be followed.

Constraints guide downstream decisions.

---

# 13. Assumptions

Record assumptions explicitly.

Examples

- Corporate authentication service already exists.
- Notification service is available.
- Existing ERP APIs are accessible.

Assumptions reduce ambiguity.

---

# 14. Success Criteria

Success Criteria define when the requirement is considered fulfilled.

Examples

- Purchase requests can be submitted online.
- Managers can approve requests.
- Status updates are visible.
- Average processing time is reduced by at least 50%.

Success Criteria should be measurable and verifiable.

---

# 15. Risks

Document known business risks.

Examples

- ERP integration delays
- Organizational resistance
- Regulatory changes

Risk awareness improves planning.

---

# 16. Open Questions

Document unresolved topics.

Examples

- Should emergency purchases bypass approval?
- Are external suppliers supported?
- What notification channels are required?

Open Questions are intentionally preserved until resolved.

---

# 17. Runtime Contract

```yaml
artifact:

  id: REQ

  owner:

    Requirement Agent

  consumes:

    - User Input

    - Business Documents

    - Meeting Notes

  produces:

    - Product Specification

  validates:

    - Business Goals

    - Scope

    - Constraints

    - Success Criteria
```

---

# 18. Traceability

Every Requirement Artifact shall trace to:

```text
Business Request

↓

Requirement

↓

Product Specification

↓

Technical Specification

↓

Architecture Design

↓

Implementation

↓

Testing

↓

Release
```

Traceability begins with the Requirement Artifact.

---

# 19. Quality Rules

Every Requirement Artifact shall be:

- Complete
- Unambiguous
- Business-oriented
- Traceable
- Reviewable
- Versioned
- Testable

Requirements should describe business intent rather than implementation.

---

# 20. Definition of Done

A Requirement Artifact is complete when:

- Business problem is clearly defined.
- Business goals are measurable.
- Stakeholders are identified.
- Business context is documented.
- Scope is explicitly defined.
- Constraints are documented.
- Assumptions are recorded.
- Success Criteria are measurable.
- Risks are identified.
- Open Questions are documented.
- Traceability metadata is complete.
- Business Review has been approved.

Only after completion may the Product Specification be created.