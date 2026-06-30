---
id: agent-sdd.index
version: 1.0
---

# Agent Software Delivery Driven (Agent SDD) — Index

This is the runtime entry point for the Agent SDD Framework. It lists all specifications, schemas, and templates with their 3-tier disclosure cost.

## Quick Start

1. Read `AGENTS.MD` for the canonical definition.
2. Start at `loop/01-requirement.md` for loop-driven execution.
3. Use the table below to locate specific specs.

## 3-Tier Disclosure

Every spec file contains three sections marked by HTML comments:

- `<!-- TIER 1: CORE -->` — always loaded (~30 lines). Minimal, machine-parseable summary.
- `<!-- TIER 2: DEEP -->` — loaded when the loop stage runs. Full responsibilities, contract, lifecycle.
- `<!-- TIER 3: REF -->` — loaded only on explicit lookup. Examples, anti-patterns, related specs.

The `tier_cost` field in each file's frontmatter indicates context budget: `low`, `medium`, or `high`. The runtime uses this to budget loading.

## Loop Stages

| File | Purpose | Tier Cost | Entry Point |
|------|---------|-----------|-------------|
| `loop/00-loop.md` | Loop definition, feedback mechanism | low | Start here for loop model |
| `loop/01-requirement.md` | Stage 1: discover requirements | low | Entry for requirement discovery |
| `loop/02-development.md` | Stage 2: product, technical, architecture, implementation | medium | Entry for development |
| `loop/03-testing.md` | Stage 3: quality assurance, evidence collection | medium | Entry for testing |
| `loop/04-release.md` | Stage 4: governance, delivery package, release | high | Entry for release |

## Agents

| File | Role | Loop Stage | Tier Cost |
|------|------|------------|-----------|
| `agents/requirement.md` | Requirement discovery | 01 | low |
| `agents/product-manager.md` | Product specification | 02 | medium |
| `agents/technical-manager.md` | Technical planning | 02 | medium |
| `agents/architecture.md` | Architecture design | 02 | high |
| `agents/frontend.md` | Frontend implementation | 02 | medium |
| `agents/backend.md` | Backend implementation | 02 | medium |
| `agents/tester.md` | Quality assurance | 03 | medium |
| `agents/reviewer.md` | Delivery governance | 04 | high |

## Workflows

| File | Stage | Tier Cost | Corresponding Loop |
|------|-------|-----------|-------------------|
| `workflows/requirement.md` | Requirement Flow | low | `loop/01-requirement.md` |
| `workflows/development.md` | Development Flow | medium | `loop/02-development.md` |
| `workflows/testing.md` | Testing Flow | medium | `loop/03-testing.md` |
| `workflows/release.md` | Release Flow | high | `loop/04-release.md` |

## Artifacts

| File | Artifact ID | Loop Stage | Tier Cost | Schema |
|------|-------------|------------|-----------|--------|
| `artifacts/requirement.md` | REQ | 01 | low | `schemas/requirement.schema.yaml` |
| `artifacts/product-specification.md` | PS | 02 | medium | `schemas/product-specification.schema.yaml` |
| `artifacts/technical-specification.md` | TS | 02 | medium | `schemas/technical-specification.schema.yaml` |
| `artifacts/architecture-design.md` | AD | 02 | high | `schemas/architecture-design.schema.yaml` |
| `artifacts/api.md` | API | 02 | medium | `schemas/api.schema.yaml` |
| `artifacts/data-model.md` | MODEL | 02 | medium | `schemas/data-model.schema.yaml` |
| `artifacts/test-case.md` | TC | 03 | medium | `schemas/test-case.schema.yaml` |
| `artifacts/test-report.md` | TR | 03 | medium | `schemas/test-report.schema.yaml` |
| `artifacts/quality-evidence-package.md` | QEP | 03 | high | `schemas/quality-evidence-package.schema.yaml` |
| `artifacts/delivery-review-report.md` | DRR | 04 | high | `schemas/delivery-review-report.schema.yaml` |
| `artifacts/software-delivery-package.md` | SDP | 04 | high | `schemas/software-delivery-package.schema.yaml` |

## Schemas

All schemas are JSON Schema 2020-12 compliant and machine-consumable. Each corresponds 1:1 with an artifact.

| File | Covers | Status |
|------|--------|--------|
| `schemas/requirement.schema.yaml` | REQ | ✅ |
| `schemas/product-specification.schema.yaml` | PS | ✅ |
| `schemas/technical-specification.schema.yaml` | TS | ✅ |
| `schemas/architecture-design.schema.yaml` | AD | ✅ |
| `schemas/api.schema.yaml` | API | ✅ (already aligned) |
| `schemas/data-model.schema.yaml` | MODEL | ✅ |
| `schemas/test-case.schema.yaml` | TC | ✅ (already aligned) |
| `schemas/test-report.schema.yaml` | TR | ✅ |
| `schemas/quality-evidence-package.schema.yaml` | QEP | ✅ |
| `schemas/delivery-review-report.schema.yaml` | DRR | ✅ |
| `schemas/software-delivery-package.schema.yaml` | SDP | ✅ |

## Templates

Minimal skeleton files for each artifact. Runtime agents use these as starting templates.

| File | Artifact |
|------|----------|
| `templates/requirement.md` | REQ |
| `templates/product-specification.md` | PS |
| `templates/technical-specification.md` | TS |
| `templates/architecture-design.md` | AD |
| `templates/api.md` | API |
| `templates/data-model.md` | MODEL |
| `templates/test-case.md` | TC |
| `templates/test-report.md` | TR |
| `templates/quality-evidence-package.md` | QEP |
| `templates/delivery-review-report.md` | DRR |
| `templates/software-delivery-package.md` | SDP |

## Traceability Graph

Every artifact links to its parent and children. The full traceability chain:

```text
REQ
└─ PS
   └─ TS
      └─ AD
         ├─ API
         └─ MODEL
            └─ TC
               └─ TR
                  └─ QEP
                     └─ DRR
                        └─ SDP
```

## Runtime Notes

- **Minimum startup load**: `loop/00-loop.md`, `INDEX.md` (this file).
- **Per-stage load**: Only loop stage file + agents active in that stage.
- **Artifact load**: Only artifacts required for current stage (lazy load).
- **Schema load**: Only schemas needed for validation (on-demand).

## Canonical Source

`AGENTS.MD` is the source of truth. This index is a navigation helper.
