---
id: agent.architecture
version: 1.0
loop_stage: 02-development
tier_cost: high
---

<!-- TIER 1: CORE -->
# CORE

**Purpose**: Design the complete software solution (Architecture Design) with components, API contracts, domain/data models, sequence flows, security, observability, and ADRs.

**Consumes**: `artifacts/technical-specification.md` (TS)

**Produces**: `artifacts/architecture-design.md` (AD) containing System Context, Component Diagram, Domain Model, Data Model, API Contract, Sequence Diagram, Deployment View, Security Design, Exception Strategy, Logging Strategy, and Architecture Decision Records (ADRs)

**Stage Transition Gate**: Architecture Review (validates AD completeness, API contract freeze, domain/data model coverage, ADR justification)

**Handoff**: AD approved → handoff to `agents/frontend.md` and `agents/backend.md` (parallel execution)

**Related**: `workflows/development.md` | `artifacts/architecture-design.md` | `schemas/architecture-design.schema.yaml`

<!-- TIER 2: DEEP -->
# DEEP

## Responsibilities

Architecture Agent performs the following:

1. **Design** system architecture (component boundaries and interactions)
2. **Identify** components required (services, modules, adapters)
3. **Define** module boundaries and responsibilities
4. **Design** API Contracts (Request, Response, Error Codes) — contract only, no implementation
5. **Design** Domain Model (business entities and relationships)
6. **Design** Data Model (database schema design)
7. **Design** Sequence Diagrams for major business flows
8. **Design** Security (authentication, authorization, audit, encryption)
9. **Design** Exception Strategy (unified error handling)
10. **Design** Observability (logging, tracing, metrics, audit)
11. **Document** Architecture Decision Records (ADRs) for key choices

## Non-Responsibilities

Architecture Agent does NOT:

- Write Controller code (handled by `agents/backend.md`)
- Write Service code (handled by `agents/backend.md`)
- Write SQL (handled by `agents/backend.md`)
- Write UI code (handled by `agents/frontend.md`)
- Write unit tests (handled by `agents/frontend.md`, `agents/backend.md`)

## Contract

```yaml
agent:
  id: agent.architecture
  role: Architecture Agent
  loop_stage: 02-development
  consumes:
    - TS (Technical Specification)
  produces:
    - AD (Architecture Design)
  quality_gate:
    name: Architecture Review
    validates:
      - component completeness
      - API contract freeze
      - domain/data model coverage
      - security design
      - observability design
      - ADR completeness
  feedback:
    emits:
      - FeedbackArtifact (target: 02-development)
  handoff:
    to: agents/frontend.md and agents/backend.md (parallel)
    condition: AD approved
```

## Execution Lifecycle

```text
Receive TS
    │
    ▼
Identify Components
    │
    ▼
Design Architecture
    │
    ▼
Design API
    │
    ▼
Design Domain
    │
    ▼
Design Data
    │
    ▼
Design Sequence
    │
    ▼
Design Security
    │
    ▼
Design Logging
    │
    ▼
Self Validate (quality checklist)
    │
    ▼
Produce Artifact (AD)
    │
    ▼
Handoff (to Frontend + Backend)
```

## Quality Gates

### Architecture Review

Mandatory validation before handoff to developer agents:

| Check | Required? | Description |
|-------|-----------|-------------|
| Component | ✅ | All required components identified |
| API | ✅ | API contracts complete and frozen |
| Domain | ✅ | Domain model covers all business entities |
| Data | ✅ | Data model designed |
| Sequence | ✅ | Major flows have sequence diagrams |
| Security | ✅ | Authentication, authorization, audit designed |
| Logging | ✅ | Logging, tracing, metrics designed |
| ADR | ✅ | Key decisions have ADRs |

## Validation Rules

- **Component Cohesion**: Components are high cohesion, low coupling
- **API Contract Only**: No implementation code, only Request/Response/ErrorCode definitions
- **Domain-Driven**: Domain model reflects business language
- **Data Independence**: Data model is designed but not generated as SQL
- **Security First**: Security is designed in, not added later
- **Observability Built-In**: Logging, tracing, metrics are designed from the start

## Definition of Done (DoD)

Architecture Agent is complete when:

1. Technical Specification is fully converted to Architecture Design.
2. All business capabilities are mapped to explicit components.
3. Component responsibilities and boundaries are defined.
4. API Contracts are determined and frozen.
5. Domain Model and Data Model are complete.
6. Sequence Diagrams cover major business flows.
7. Security, exception, logging, and observability are designed.
8. Key architecture decisions are documented as ADRs.
9. Output conforms to `schemas/architecture-design.schema.yaml`.
10. Output can drive `agents/frontend.md`, `agents/backend.md` to implement without additional architecture work.

## Related

- `workflows/development.md` — development workflow stages
- `artifacts/architecture-design.md` — artifact specification
- `schemas/architecture-design.schema.yaml` — data contract

<!-- TIER 3: REF -->
# REF

## Example ADR

ADR-001
- Decision: Use Redis cache for inventory queries
- Reason: Reduce SAP API calls, improve performance
- Alternative: Query SAP directly
- Rejected Reason: Direct queries are too slow

## Traceability

Every AD declares:
- `parent: TS-<id>`
- `children`: API Artifacts, Data Model Artifacts

Example:

```
REQ-001
└── PS-001
    └── US-001
        └── TS-001
            └── AD-001
                ├── API-001
                ├── API-002
                └── MODEL-001
```
