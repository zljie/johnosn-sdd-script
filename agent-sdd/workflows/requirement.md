---
id: workflow.requirement
version: 1.0
loop_stage: 01-requirement
tier_cost: low
---

<!-- TIER 1: CORE -->
# CORE

**Purpose**: Define the Requirement Discovery Flow — the process of transforming raw user input into a standardized Requirement Artifact (REQ).

**Owner**: `agents/requirement.md`

**Consumes**: User Requirement (raw)

**Produces**: `artifacts/requirement.md` (REQ)

**Quality Gates**: Requirement Review (completeness, clarity, atomicity, traceability)

**Handoff**: REQ approved → enter `loop/02-development.md`

**Related**: `loop/01-requirement.md` | `agents/requirement.md` | `artifacts/requirement.md`

<!-- TIER 2: DEEP -->
# DEEP

## Stages

### Stage 1: Requirement Intake

**Objective**: Receive user input in any format.

**Input**: User Natural Language, PRD, PDF, Jira, Email, Markdown, etc.

**Output**: Problem Statement.

### Stage 2: Requirement Analysis

**Objective**: Understand the user's true requirement, not just what they said.

**Output**: Business Analysis (Business Goal, Business Value, Stakeholder).

### Stage 3: Business Context Discovery

**Objective**: Identify business context.

**Output**: Actors, Business Process, Business Object, Business Rule, Constraints, External Systems.

### Stage 4: Requirement Structuring

**Objective**: Produce structured Requirement Artifact.

**Output**: Structured Requirement with:
- `id`, `title`, `summary`
- `businessGoal`, `businessValue`, `targetUsers`
- `scope`, `outOfScope`
- `functionalRequirements`, `nonFunctionalRequirements`
- `constraints`, `dependencies`, `assumptions`, `openQuestions`, `risks`
- `priority`, `acceptanceSummary`

### Stage 5: Gap & Risk Analysis

**Objective**: Identify unknowns.

**Output**: Requirement Gaps and Requirement Risks.

### Stage 6: Requirement Validation

**Objective**: Self-validate before review.

**Output**: Validation Checklist (all 10 fields complete).

### Stage 7: Requirement Review (HITL)

**Objective**: Human approval.

**Input**: Requirement Artifact.

**Output**: Approved / Need Revision / Rejected.

## Artifact Flow

```
Raw Input
    │
    ▼
Problem Statement
    │
    ▼
Business Analysis
    │
    ▼
Structured Requirement
    │
    ▼
Requirement Review
    │
    ▼
REQ (Requirement Artifact)
```

## Decision Rules

- If Business Goal unclear → continue questioning
- If Scope unclear → generate Clarification Questions
- If Constraints unknown → mark as Open Question
- If Requirement complete → generate REQ

## Quality Rules

Every REQ must be:
- Complete
- Governable
- Auditable
- Traceable
- Versioned

## Definition of Done (DoD)

Requirement Flow is complete when:

1. User's problem is understood and formed as Problem Statement.
2. Business Analysis and Business Context Discovery are complete.
3. Structured Requirement Artifact (REQ) is generated.
4. All Assumptions, Constraints, Risks, and Open Questions are identified.
5. Requirement Review (HITL) is completed and approved.
6. REQ meets Quality Gates and can enter Product Flow.

<!-- TIER 3: REF -->
# REF

## Clarification Questions

Examples:
- Who is this for?
- One user or multiple roles?
- What is the success standard?
- Do we have an existing ERP?
- What should we not do in this scope?

## Runtime Contract

```yaml
workflow:
  id: RequirementFlow
  stages:
    - Intake
    - Analysis
    - Discovery
    - Structuring
    - Validation
    - Review
  produces:
    - Requirement Artifact
  next:
    - ProductFlow
  quality_gate:
    - Requirement Review Passed
```
