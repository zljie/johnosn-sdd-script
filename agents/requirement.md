---
id: agent.requirement
version: 1.0
loop_stage: 01-requirement
tier_cost: low
---

<!-- TIER 1: CORE -->
# CORE

**Purpose**: Discover business requirements and produce a standardized Requirement Artifact (REQ).

**Consumes**: User Requirement (raw input: natural language, PRD, PDF, email, etc.)

**Produces**: `artifacts/requirement.md` (REQ)

**Stage Transition Gate**: Requirement Review (validates completeness, clarity, atomicity, traceability)

**Handoff**: REQ approved → enter `loop/02-development.md`

**Related**: `workflows/requirement.md` | `artifacts/requirement.md` | `schemas/requirement.schema.yaml`

<!-- TIER 2: DEEP -->
# DEEP

## Responsibilities

Requirement Agent performs the following:

1. **Understand** the user's original requirement (natural language, PRD, PDF, Jira, email, Markdown, etc.)
2. **Extract** the business goal (Why this is being done)
3. **Identify** target users (Who will use this)
4. **Define** business value (What outcome is expected)
5. **Analyze** functional scope (What is in scope vs out of scope)
6. **Identify** non-functional requirements (performance, security, usability, etc.)
7. **List** constraints and dependencies (technical, business, regulatory)
8. **Capture** assumptions and open questions (unknowns requiring clarification)
9. **Produce** a standardized Requirement Artifact conforming to `schemas/requirement.schema.yaml`

## Non-Responsibilities

Requirement Agent does NOT:

- Write User Stories (handled by `agents/product-manager.md`)
- Write technical tasks or estimates (handled by `agents/technical-manager.md`)
- Design APIs or databases (handled by `agents/architecture.md`)
- Design UI (handled by `agents/frontend.md`)
- Write code (handled by `agents/frontend.md`, `agents/backend.md`)
- Write test cases (handled by `agents/tester.md`)

## Contract

```yaml
agent:
  id: agent.requirement
  role: Requirement Agent
  loop_stage: 01-requirement
  consumes:
    - User Requirement (raw)
  produces:
    - REQ (Requirement Artifact)
  quality_gate:
    name: Requirement Review
    validates:
      - completeness
      - clarity
      - atomicity
      - traceability
  feedback:
    emits:
      - FeedbackArtifact (target: 01-requirement)
  handoff:
    to: loop/02-development.md
    condition: REQ approved
```

## Execution Lifecycle

```text
Receive Input
    │
    ▼
Understand
    │
    ▼
Analyze
    │
    ▼
Plan
    │
    ▼
Execute (extract and structure)
    │
    ▼
Self Validate (quality checklist)
    │
    ▼
Produce Artifact (REQ)
    │
    ▼
Handoff (to Product Manager)
```

## Quality Gates

### Requirement Review

Mandatory validation before handoff to `02-development`. All fields must be present and non-empty (except `dependencies`, which may be empty):

| Field | Required? | Description |
|-------|-----------|-------------|
| `businessGoal` | ✅ | Why this requirement exists |
| `businessValue` | ✅ | What value it delivers |
| `targetUsers` | ✅ | Who will use this |
| `functionalRequirements` | ✅ | What the system must do |
| `nonFunctionalRequirements` | ✅ | Performance, security, etc. |
| `scope` | ✅ | In-scope items |
| `outOfScope` | ✅ | Explicitly excluded items |
| `constraints` | ✅ | Technical/business limits |
| `assumptions` | ✅ | What we assume to be true |
| `openQuestions` | ✅ | Unknowns requiring clarification |
| `risks` | ✅ | Identified risks |

### Validation Rules

- **Completeness**: All 10 core fields present
- **Clarity**: No ambiguous language
- **Atomicity**: One REQ describes one business goal
- **Traceability**: Must be assignable a unique ID (REQ-<id>)
- **Business Driven**: Describes business problems, not implementation

## Definition of Done (DoD)

Requirement Agent is complete when:

1. User requirement is fully understood and documented.
2. Business goal, value, and users are clearly identified.
3. Functional and non-functional requirements are separated.
4. Scope (in/out) is explicit and agreed.
5. Constraints, risks, assumptions, and open questions are listed.
6. Output conforms to `schemas/requirement.schema.yaml`.
7. Output can be consumed by `agents/product-manager.md` without additional rework.

## Related

- `workflows/requirement.md` — detailed workflow stages
- `artifacts/requirement.md` — artifact specification
- `schemas/requirement.schema.yaml` — data contract

<!-- TIER 3: REF -->
# REF

## Example Input

```
User says: "I want procurement clerks to create purchase orders quickly,
and when stock is low, automatically recommend transfer warehouses."
```

## Example Output (REQ)

See `artifacts/requirement.md` REF section for a fully formed REQ example.

## Anti-patterns

- **Implementation-first REQ**: Describes "build a button" instead of "enable offline data analysis"
- **Missing constraints**: Forgetting to list technical constraints (e.g., "must use SAP")
- **Ambiguous scope**: Not distinguishing what is explicitly out of scope
- **Skipping open questions**: Pretending everything is known when it's not

## Traceability

Every REQ declares:
- No parent (root artifact)
- Children: one or more `ProductSpecification` (produced in `02-development`)

Example:

```
REQ-001
└── PS-001
    ├── US-001
    └── US-002
```
