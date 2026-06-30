# Agent SDD — Agent Software Delivery Driven Framework

> **Version:** 1.0  
> **Status:** Draft  
> **Language:** English

---

## Quick Start

This is the **Agent Software Delivery Driven (Agent SDD)** framework specification repository.

To navigate the specs:

1. Read `AGENTS.MD` for the canonical framework definition.
2. See `INDEX.md` for the complete 3-tier manifest of all specs, schemas, and templates.
3. Start at `loop/01-requirement.md` to understand the 4-stage Software Delivery Loop.

## What is Agent SDD?

Agent SDD is an AI-native software delivery framework. Instead of treating AI as a code generation tool, Agent SDD treats AI as a collaborative software engineering organization composed of specialized agents.

### Core Principles

1. **Single Responsibility** — Each agent owns exactly one responsibility.
2. **Artifact First** — Agents communicate only through standardized artifacts.
3. **Traceability First** — Every engineering activity is traceable.
4. **Quality by Design** — Quality is built into every stage.
5. **Human-in-the-Loop (HITL)** — Humans make final decisions.
6. **Feedback Driven** — Feedback creates new engineering cycles.

## 4-Stage Software Delivery Loop

```text
01-requirement → 02-development → 03-testing → 04-release → (feedback) → 01-requirement
```

See `loop/00-loop.md` for the complete loop definition.

## Repository Structure

```text
agent-sdd/
├── AGENTS.MD              # Canonical framework definition (source of truth)
├── INDEX.md               # Runtime entry point with 3-tier manifest
├── loop/                  # 4-stage loop as first-class artifacts
│   ├── 00-loop.md
│   ├── 01-requirement.md
│   ├── 02-development.md
│   ├── 03-testing.md
│   └── 04-release.md
├── agents/                 # 8 agent specifications (3-tier)
├── workflows/              # 4 workflow specifications (3-tier)
├── artifacts/              # 11 artifact specifications (3-tier)
├── schemas/                # 13 JSON Schemas (machine-consumable)
└── templates/              # 11 template skeletons (for runtime agents)
```

See `INDEX.md` for the complete manifest.

## 3-Tier Progressive Disclosure

Every spec file contains three sections:

- `<!-- TIER 1: CORE -->` — Always loaded (~30 lines). Minimal, machine-parseable summary.
- `<!-- TIER 2: DEEP -->` — Loaded when the loop stage runs. Full responsibilities, contract, lifecycle.
- `<!-- TIER 3: REF -->` — Loaded only on explicit lookup. Examples, anti-patterns, related specs.

This design minimizes context footprint at runtime while preserving depth when needed.

## Artifact Chain

The complete traceability chain:

```text
REQ → PS → TS → AD → API/MODEL → TC → TR → QEP → DRR → SDP
```

See each artifact spec in `artifacts/` for details.

## Runtime Usage

A runtime implementing Agent SDD should:

1. Load `INDEX.md` to discover all specs.
2. For each loop stage, load only the stage's `loop/0N-*.md` entry file.
3. Lazy-load agents/workflows/artifacts as needed using their `loop_stage` frontmatter.
4. Use schemas to validate artifacts at runtime.
5. Use templates as starting skeletons for artifact generation.

## License

MIT

---

**Note:** This repository defines engineering standards. It is **not** an implementation repository. Implementation technologies may change; engineering principles remain stable.
