# AGENTS.md

> **Agent Software Delivery Driven (Agent SDD)**
>
> **Version:** 1.0  
> **Status:** Draft  
> **Language:** English

---

# Vision

Agent SDD is an AI-native Software Delivery Framework.

Instead of treating Artificial Intelligence as a code generation tool, Agent SDD treats AI as a collaborative software engineering organization composed of specialized agents.

Each agent owns a well-defined responsibility.

Each workflow represents a software engineering lifecycle.

Each artifact becomes a contract between agents.

Each decision is traceable.

Each delivery is governed.

The objective of Agent SDD is **not to generate code**.

The objective of Agent SDD is **to standardize and automate the complete software delivery lifecycle**.

---

# Mission

Enable AI Agents to collaborate as a real software engineering organization.

Transform software development from isolated prompt-based coding into a structured, traceable, governable, and continuously improving delivery system.

---

# Design Philosophy

Agent SDD is built upon one simple philosophy:

> **Software is delivered by collaboration, not by code generation.**

Modern software projects involve many disciplines:

- Business Analysis
- Product Management
- Technical Planning
- Architecture
- Frontend Engineering
- Backend Engineering
- Quality Assurance
- Delivery Governance

Traditional AI coding tools typically compress all of these responsibilities into a single model.

Agent SDD intentionally separates responsibilities into specialized agents, allowing each agent to focus on one domain while collaborating through standardized artifacts.

---

# Software Delivery Loop

Software development is not a linear pipeline.

It is a continuous feedback loop.

Every production release generates feedback.

Every feedback may generate new requirements.

Every new requirement starts another development cycle.

Therefore, Agent SDD models software engineering as a continuous Software Delivery Loop.

```text
                         Agent Software Delivery Loop

                 ┌────────────────────────────┐
                 │     Requirement Flow       │
                 │        Discovery           │
                 └─────────────┬──────────────┘
                               │
                               ▼
                 ┌────────────────────────────┐
                 │     Development Flow       │
                 │ Planning & Implementation  │
                 └─────────────┬──────────────┘
                               │
                               ▼
                 ┌────────────────────────────┐
                 │      Testing Flow          │
                 │    Quality Assurance       │
                 └─────────────┬──────────────┘
                               │
                               ▼
                 ┌────────────────────────────┐
                 │      Release Flow          │
                 │   Delivery Governance      │
                 └─────────────┬──────────────┘
                               │
                               ▼
                    Customer Feedback / Incident
                               │
                               ▼
                     Requirement Discovery
```

Software Delivery never ends.

The completion of one release becomes the starting point of the next development cycle.

---

# Four Core Workflows

Agent SDD organizes software delivery into four independent but connected workflows.

| Workflow | Lifecycle | Primary Output |
|----------|-----------|----------------|
| Requirement Flow | Discovery | Requirement Artifact (REQ) |
| Development Flow | Planning & Implementation | Product Specification (PS), Technical Specification (TS), Architecture Design (AD), Implementation |
| Testing Flow | Quality Assurance | Quality Evidence Package (QEP) |
| Release Flow | Delivery Governance | Software Delivery Package (SDP) |

Each workflow owns one lifecycle.

Each lifecycle produces standardized artifacts.

Each artifact becomes the input of the next workflow.

---

# Framework Architecture

The framework consists of five dimensions.

```text
Agent SDD

├── Agents
├── Workflows
├── Artifacts
├── Runtime
└── Governance
```

Every feature inside Agent SDD belongs to exactly one of these five dimensions.

---

# Core Principles

## 1. Single Responsibility

Each Agent owns exactly one responsibility.

Examples:

- Requirement Agent
- Product Manager Agent
- Technical Manager Agent
- Architecture Agent
- Frontend Agent
- Backend Agent
- Tester Agent
- Reviewer Agent

No Agent should perform responsibilities owned by another Agent.

---

## 2. Artifact First

Agents never communicate through free-form conversations.

Agents communicate only through standardized artifacts.

```text
User Requirement
        │
        ▼
Requirement Artifact
        │
        ▼
Product Specification
        │
        ▼
Technical Specification
        │
        ▼
Architecture Design
        │
        ▼
Implementation
        │
        ▼
Quality Evidence
        │
        ▼
Software Delivery Package
```

Artifacts are the engineering contracts between agents.

---

## 3. Traceability First

Every engineering activity must be traceable.

Every artifact shall contain:

- Identifier
- Parent
- Children
- Owner
- Version
- Status

Example:

```text
REQ-001
   │
   ▼
PS-001
   │
   ▼
US-003
   │
   ▼
TASK-021
   │
   ▼
BE-004
   │
   ▼
TC-010
   │
   ▼
BUG-003
   │
   ▼
Release v1.2
```

No engineering activity should exist without traceability.

---

## 4. Quality by Design

Quality is built into every engineering stage.

Every workflow includes:

- Validation
- Quality Gates
- Review
- Feedback

Quality is not the responsibility of a single agent.

Quality is a responsibility shared by every stage.

---

## 5. Human-in-the-Loop (HITL)

Artificial Intelligence accelerates engineering.

Humans make final decisions.

Mandatory approval points include:

- Requirement Approval
- Product Approval
- Architecture Approval
- Release Approval
- Production Rollback

All human decisions must be recorded and auditable.

---

## 6. Feedback Driven

Software continuously evolves.

Feedback may originate from:

- Testing
- Production
- Customers
- Security Reviews
- Architecture Reviews
- Performance Monitoring

Feedback creates a new engineering cycle.

Feedback never modifies an existing artifact directly.

---

# Engineering Layers

```text
Discovery Layer

↓

Planning Layer

↓

Architecture Layer

↓

Implementation Layer

↓

Quality Assurance Layer

↓

Delivery Layer

↓

Feedback Layer
```

Each layer owns different responsibilities.

No layer may bypass another layer.

---

# Agent Collaboration Model

```text
User
    │
    ▼
Requirement Agent
    │
    ▼
Product Manager Agent
    │
    ▼
Technical Manager Agent
    │
    ▼
Architecture Agent
    │
    ▼
Frontend Agent
        │
Backend Agent
        │
        ▼
Tester Agent
        │
        ▼
Reviewer Agent
        │
        ▼
Release Flow
```

Each agent consumes approved artifacts.

Each agent produces standardized artifacts.

No agent modifies another agent's output directly.

---

# Lifecycle Model

Every Agent follows the same execution lifecycle.

```text
Receive
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
Execute
    │
    ▼
Validate
    │
    ▼
Produce Artifact
    │
    ▼
Handoff
```

Only responsibilities differ.

The execution model remains identical.

---

# Engineering Contracts

Every interaction inside Agent SDD is contract-driven.

Each contract defines:

- Inputs
- Outputs
- Constraints
- Quality Gates
- Ownership

This enables different AI runtimes to execute the same engineering workflow consistently.

---

# Artifact Lifecycle

Every artifact progresses through a standardized lifecycle.

```text
Draft
    │
    ▼
Ready
    │
    ▼
Approved
    │
    ▼
Implemented
    │
    ▼
Verified
    │
    ▼
Released
    │
    ▼
Archived
```

Artifacts may never skip lifecycle states.

Every transition must be validated.

---

# Quality Gates

Every workflow contains mandatory Quality Gates.

If a Quality Gate fails:

- Stop the workflow.
- Generate feedback.
- Return the artifact to the responsible agent.
- Repeat validation.

No workflow may bypass Quality Gates.

---

# Governance Model

Governance consists of:

- Traceability
- Auditability
- Review
- Approval
- Compliance
- Version Management

Governance applies to every artifact and every workflow.

---

# Runtime Independence

Agent SDD is runtime agnostic.

Compatible runtimes include:

- AgentScope
- OpenAI Agents SDK
- LangGraph
- Temporal
- Custom Runtime

Any implementation that follows the Agent SDD contracts is considered compliant.

---

# Repository Philosophy

This repository defines engineering standards.

It is **not** an implementation repository.

It specifies:

- How software is delivered.
- How agents collaborate.
- How workflows execute.
- How artifacts evolve.
- How quality is governed.

Implementation technologies may change.

Engineering principles remain stable.

---

# Next Sections

The remaining sections of this specification define:

- Agent Specifications
- Workflow Specifications
- Artifact Specifications
- Runtime Specifications
- Governance Specifications

Together they form the complete **Agent Software Delivery Driven Framework**.

---

# 6. Agent Architecture

## 6.1 Design Principles

Agent SDD models a software engineering organization instead of a single intelligent assistant.

Every agent represents a professional engineering role with clearly defined responsibilities.

Agents collaborate through standardized engineering artifacts rather than direct conversations.

Each agent:

- Owns one responsibility.
- Consumes standardized artifacts.
- Produces standardized artifacts.
- Never modifies another agent's artifacts directly.
- Participates in the Software Delivery Loop.

This architecture enables AI systems to scale similarly to real engineering organizations.

---

## 6.2 Agent Layers

Agent SDD organizes agents into multiple engineering layers.

```text
Business Layer

    Requirement Agent

            │

            ▼

Product Layer

    Product Manager Agent

            │

            ▼

Planning Layer

    Technical Manager Agent

            │

            ▼

Architecture Layer

    Architecture Agent

            │

            ▼

Implementation Layer

    Frontend Agent
    Backend Agent

            │

            ▼

Quality Layer

    Tester Agent

            │

            ▼

Governance Layer

    Reviewer Agent
```

Every layer has a unique responsibility.

Layers never overlap.

---

## 6.3 Agent Communication Model

Agents communicate only through engineering artifacts.

```text
Requirement Agent

        │

        ▼

Requirement Artifact

        │

        ▼

Product Manager Agent

        │

        ▼

Product Specification

        │

        ▼

Technical Manager Agent
```

There is no hidden memory shared between agents.

Artifacts become the only engineering contract.

---

## 6.4 Agent Responsibilities

| Agent | Responsibility | Primary Output |
|---------|----------------|----------------|
| Requirement Agent | Discover business requirements | REQ |
| Product Manager Agent | Product specification | PS |
| Technical Manager Agent | Technical planning | TS |
| Architecture Agent | Architecture design | AD |
| Frontend Agent | Frontend implementation | FI |
| Backend Agent | Backend implementation | BI |
| Tester Agent | Quality assurance | QEP |
| Reviewer Agent | Delivery governance | DRR |

---

## 6.5 Agent Execution Lifecycle

Every agent executes the same lifecycle.

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

Execute

        │

        ▼

Self Validation

        │

        ▼

Produce Artifact

        │

        ▼

Handoff
```

Execution logic remains identical.

Only engineering responsibilities differ.

---

## 6.6 Agent Contract

Every Agent must expose a standard contract.

```yaml
agent:

  id:

  role:

  description:

  consumes:

  produces:

  qualityGate:

  feedback:

  owner:
```

This allows every agent to become interchangeable.

Different AI models may implement the same agent contract.

---

# 7. Workflow Architecture

## 7.1 Overview

Agent SDD defines workflows instead of prompts.

A workflow represents an engineering lifecycle.

Each workflow:

- owns one lifecycle,
- contains multiple stages,
- produces standardized artifacts,
- defines quality gates,
- supports feedback loops.

---

## 7.2 Workflow Hierarchy

```text
Software Delivery Loop

        │

        ├── Requirement Flow

        ├── Development Flow

        ├── Testing Flow

        └── Release Flow
```

Each workflow is independent.

Together they form one Software Delivery Loop.

---

## 7.3 Workflow Execution Model

```text
Workflow

      │

      ▼

Stage

      │

      ▼

Task

      │

      ▼

Artifact

      │

      ▼

Quality Gate

      │

      ▼

Next Stage
```

---

## 7.4 Workflow Components

Every workflow consists of five components.

| Component | Description |
|------------|-------------|
| Stage | Engineering phase |
| Agent | Responsible executor |
| Artifact | Engineering output |
| Quality Gate | Validation checkpoint |
| Feedback | Engineering correction |

---

## 7.5 Workflow State Machine

Every workflow follows the same lifecycle.

```text
Draft

↓

Ready

↓

Running

↓

Review

↓

Completed

↓

Archived
```

---

# 8. Artifact Architecture

## 8.1 Philosophy

Artifacts are the core of Agent SDD.

Agents are temporary.

Artifacts are permanent.

Engineering knowledge must always be stored inside artifacts instead of conversations.

---

## 8.2 Artifact Hierarchy

```text
Requirement

        │

        ▼

Product Specification

        │

        ▼

Technical Specification

        │

        ▼

Architecture Design

        │

        ▼

Implementation

        │

        ▼

Quality Evidence Package

        │

        ▼

Delivery Review Report

        │

        ▼

Software Delivery Package
```

Artifacts become engineering contracts.

---

## 8.3 Standard Artifact Types

| Artifact | Description |
|------------|-------------|
| REQ | Requirement Artifact |
| PS | Product Specification |
| TS | Technical Specification |
| AD | Architecture Design |
| FI | Frontend Implementation |
| BI | Backend Implementation |
| QEP | Quality Evidence Package |
| DRR | Delivery Review Report |
| SDP | Software Delivery Package |

---

## 8.4 Artifact Metadata

Every artifact contains common metadata.

```yaml
artifact:

  id:

  type:

  title:

  owner:

  version:

  status:

  parent:

  children:

  createdAt:

  updatedAt:
```

---

## 8.5 Artifact Lifecycle

```text
Draft

↓

Ready

↓

Approved

↓

In Progress

↓

Completed

↓

Verified

↓

Released

↓

Archived
```

Artifacts never bypass lifecycle states.

---

## 8.6 Traceability

Every artifact must be traceable.

Example

```text
REQ-001

↓

PS-001

↓

US-003

↓

TASK-021

↓

BE-004

↓

TC-010

↓

BUG-003

↓

Release-v1.2
```

Complete traceability is mandatory.

---

## 8.7 Artifact Ownership

Every artifact has exactly one owner.

Ownership may change only through workflow transitions.

Artifacts cannot have multiple owners simultaneously.

This guarantees engineering accountability.

---

# 9. Runtime Architecture

## 9.1 Overview

The Agent SDD Runtime is responsible for orchestrating the complete Software Delivery Loop.

Unlike traditional AI orchestration frameworks, the Agent SDD Runtime does not execute prompts.

Instead, it executes engineering workflows.

The runtime manages:

- Agent orchestration
- Workflow execution
- Artifact lifecycle
- State transitions
- Quality Gates
- Human approvals
- Feedback loops
- Traceability

The runtime is independent from any specific LLM provider.

---

## 9.2 Runtime Components

```text
                    Agent Runtime

        ┌──────────────────────────────────┐
        │ Workflow Engine                  │
        ├──────────────────────────────────┤
        │ Agent Scheduler                  │
        ├──────────────────────────────────┤
        │ Artifact Manager                 │
        ├──────────────────────────────────┤
        │ Quality Gate Engine              │
        ├──────────────────────────────────┤
        │ Traceability Engine              │
        ├──────────────────────────────────┤
        │ Feedback Engine                  │
        ├──────────────────────────────────┤
        │ HITL Engine                      │
        ├──────────────────────────────────┤
        │ Audit & Version Manager          │
        └──────────────────────────────────┘
```

---

## 9.3 Runtime Responsibilities

The runtime is responsible for:

- scheduling agents
- validating workflow transitions
- managing artifact versions
- enforcing quality gates
- coordinating human approvals
- tracking execution history
- recording audit logs
- triggering feedback loops

The runtime is **not responsible** for business logic.

Business logic belongs to the corresponding engineering agents.

---

# 10. Execution Graph

## 10.1 Overview

Every workflow is executed as a directed acyclic graph (DAG).

The runtime schedules nodes according to declared dependencies.

```text
Requirement

      │

      ▼

Product Specification

      │

      ▼

Technical Specification

      │

      ▼

Architecture Design

      │

      ├───────────────┐

      ▼               ▼

Frontend         Backend

      │               │

      └───────┬───────┘

              ▼

         Quality Assurance

              ▼

           Review

              ▼

          Release
```

The runtime automatically determines executable nodes.

---

## 10.2 Execution Node

Every execution node contains:

```yaml
node:

  id:

  stage:

  owner:

  consumes:

  produces:

  dependsOn:

  qualityGate:

  next:
```

---

## 10.3 Parallel Execution

Independent nodes may execute concurrently.

Example:

```text
Architecture Approved

        │

        ├─────────────┐

        ▼             ▼

Frontend        Backend

        │             │

        └──────┬──────┘

               ▼

         Integration Test
```

The runtime resolves execution order automatically.

---

# 11. Workflow State Machine

Every workflow follows the same state machine.

```text
Draft

↓

Ready

↓

Running

↓

Waiting Review

↓

Approved

↓

Completed

↓

Archived
```

State transitions are controlled by the runtime.

Agents cannot change workflow states directly.

---

## 11.1 State Transition Rules

| Current | Next |
|----------|------|
| Draft | Ready |
| Ready | Running |
| Running | Waiting Review |
| Waiting Review | Approved |
| Approved | Completed |
| Completed | Archived |

Invalid transitions are rejected.

---

# 12. Artifact Runtime

## 12.1 Artifact Storage

Artifacts are immutable engineering records.

Every update creates a new version.

```text
REQ-001

├── v1

├── v2

└── v3
```

Previous versions are never overwritten.

---

## 12.2 Artifact Versioning

Version numbers follow semantic versioning.

Example:

```text
REQ-001

1.0.0

1.1.0

2.0.0
```

Major changes indicate engineering impact.

---

## 12.3 Artifact Locking

Approved artifacts become read-only.

If modifications are required:

- create a new version
- restart the affected workflow
- preserve previous history

---

# 13. Feedback Engine

## 13.1 Philosophy

Feedback is a first-class engineering artifact.

Feedback is never verbal.

Feedback always creates structured engineering work.

---

## 13.2 Feedback Categories

The runtime supports multiple feedback types.

| Type | Target |
|------|---------|
| Requirement Feedback | Requirement Agent |
| Product Feedback | Product Manager |
| Technical Feedback | Technical Manager |
| Architecture Feedback | Architecture Agent |
| Implementation Feedback | Frontend / Backend |
| Quality Feedback | Tester |
| Review Feedback | Reviewer |

---

## 13.3 Feedback Lifecycle

```text
Created

↓

Assigned

↓

Accepted

↓

Resolved

↓

Verified

↓

Closed
```

Every feedback item remains traceable.

---

# 14. Quality Gate Engine

## 14.1 Overview

Every workflow transition passes through a Quality Gate.

Quality Gates ensure engineering consistency.

A failed gate immediately stops workflow execution.

---

## 14.2 Standard Quality Gates

| Stage | Gate |
|--------|------|
| Requirement | Completeness |
| Product | Acceptance Review |
| Technical | Technical Review |
| Architecture | Architecture Review |
| Development | Build Validation |
| Testing | Test Validation |
| Release | Delivery Approval |

---

## 14.3 Gate Result

Each Quality Gate produces one result.

```text
PASS

FAIL

CONDITIONAL PASS
```

Conditional approval requires human confirmation.

---

# 15. Human-in-the-Loop Engine

## 15.1 Purpose

Critical engineering decisions require human approval.

The runtime pauses execution until approval is received.

---

## 15.2 Approval Points

Mandatory approval stages include:

- Requirement Approval
- Product Approval
- Architecture Approval
- Production Release
- Emergency Rollback

---

## 15.3 Approval Result

```text
Approved

Rejected

Needs Revision
```

Every approval generates an audit record.

---

# 16. Traceability Engine

## 16.1 Purpose

Every engineering artifact must remain connected.

The runtime continuously validates traceability.

---

## 16.2 Traceability Graph

```text
Requirement

↓

Product Specification

↓

User Story

↓

Task

↓

Architecture

↓

Implementation

↓

Test

↓

Bug

↓

Release
```

Broken links are reported automatically.

---

## 16.3 Traceability Rules

Every artifact shall declare:

- Parent
- Children
- Source
- Target

Traceability is mandatory.

---

# 17. Audit Engine

## 17.1 Audit Philosophy

Every engineering activity must be recorded.

Nothing happens without evidence.

---

## 17.2 Audit Events

The runtime records:

- Agent execution
- Artifact creation
- Artifact updates
- Reviews
- Approvals
- Feedback
- Workflow transitions
- Releases

---

## 17.3 Audit Record

```yaml
audit:

  id:

  timestamp:

  actor:

  action:

  artifact:

  version:

  result:
```

Audit history is immutable.

---

# 18. Runtime Independence

Agent SDD intentionally separates engineering logic from runtime implementation.

Any orchestration engine may execute Agent SDD.

Examples include:

- AgentScope
- LangGraph
- Temporal
- AWS Step Functions
- Azure Durable Functions
- Custom Workflow Engines

As long as runtime implementations follow the engineering contracts defined by Agent SDD, they remain fully compatible.

---

# 19. Runtime Principles

The runtime follows seven engineering principles.

1. Workflow First

2. Artifact First

3. Traceability First

4. Quality First

5. Human Governed

6. Feedback Driven

7. Runtime Independent

These principles guarantee that software delivery remains deterministic, auditable, and continuously improvable.