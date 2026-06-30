---
id: artifact.api
version: 1.0
loop_stage: 02-development
tier_cost: medium
---

<!-- TIER 1: CORE -->
# CORE

**Purpose**: Define the contract between software components — what a service exposes, not how it's implemented.

**Consumes**: `artifacts/architecture-design.md` (AD)

**Produces**: API Contract (endpoint definitions, Request, Response, Error Codes)

**Stage Transition Gate**: Architecture Review (validates API completeness, contract freeze)

**Handoff**: API approved → consumed by `agents/frontend.md` and `agents/backend.md`

**Related**: `schemas/api.schema.yaml` | `agents/architecture.md`

