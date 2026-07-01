# Agent SDD — Agent Software Delivery Driven Framework

> **Version:** 1.0  
> **Status:** Draft  
> **Language:** English

---

# Agent SDD — Agent Software Delivery Driven Framework

> **Version:** 1.0
> **Status:** Draft
> **Language:** English

---

## Quick Start

### For Cursor IDE Users

Start using Agent SDD in Cursor with just a few commands:

```bash
# 1. Initialize Cursor IDE integration
./scripts/agent-sdd-cursor-init.sh --force

# 2. Restart Cursor or reload rules to activate
#    Agent will now automatically load Agent SDD rules

# 3. Start a new delivery loop
/sdd start

# 4. Advance through stages
/sdd next

# 5. Approve artifacts when ready
/sdd approve --artifact REQ-001
```

**Available SDD Commands:**

| Command | Description |
|---------|-------------|
| `/sdd start` | Initialize loop from 01-requirement |
| `/sdd next` | Validate current stage, advance if gate passes |
| `/sdd approve` | Mark artifact as Approved |
| `/sdd validate` | Validate artifacts against schemas |
| `/sdd feedback` | Create structured feedback |
| `/sdd status` | Display current runtime state |
| `/sdd audit` | Display audit log |

**Validate Artifacts:**

```bash
# Validate runtime state
./scripts/agent-sdd-validate.sh --state

# Validate all artifacts
./scripts/agent-sdd-validate.sh

# Validate specific artifact
./scripts/agent-sdd-validate.sh --artifact REQ-001

# CI mode (exit codes only)
./scripts/agent-sdd-validate.sh --ci
```

---

### For Repository Navigation

1. Read `AGENTS.MD` for the canonical framework definition.
2. See `INDEX.md` for the complete 3-tier manifest of all specs, schemas, and templates.
3. Start at `loop/01-requirement.md` to understand the 4-stage Software Delivery Loop.

---

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
├── agent-sdd.yaml         # Framework configuration
├── runtime-state.json     # Runtime state (memory)
├── commands/              # SDD command protocols
│   └── sdd-command-protocol.md
├── loop/                  # 4-stage loop as first-class artifacts
│   ├── 00-loop.md
│   ├── 01-requirement.md
│   ├── 02-development.md
│   ├── 03-testing.md
│   └── 04-release.md
├── agents/                 # 8 agent specifications (3-tier)
├── workflows/              # 4 workflow specifications (3-tier)
├── artifacts/              # 11 artifact specifications (3-tier)
├── schemas/                # 15 JSON Schemas (machine-consumable)
│   ├── runtime-state.schema.json
│   └── feedback.schema.yaml
└── templates/              # 11 template skeletons (for runtime agents)

.cursor/rules/              # Cursor IDE integration
├── AGENTS.mdc              # Entry point
├── agent-sdd-overview.mdc
├── agent-sdd-artifacts.mdc
├── agent-sdd-lifecycle.mdc
├── agent-sdd-agents.mdc
├── agent-sdd-loop-stages.mdc
└── agent-sdd-execution.mdc  # MANDATORY: State checking & guards

scripts/
├── agent-sdd-cursor-init.sh    # Initialize Cursor integration
├── agent-sdd-validate.sh       # Artifact validator (CI/CD ready)
└── agent-sdd-init.sh           # Bootstrap framework
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

---

# Getting Started (spec-kit Style)

## New Project: Bootstrap Agent SDD

### Step 1: Clone or Copy Framework

```bash
# Clone this repository
git clone https://github.com/zljie/johnosn-sdd-script.git /tmp/agent-sdd

# Or copy framework into your project
cp -r /tmp/agent-sdd/AGENTS.MD .
cp -r /tmp/agent-sdd/agents .
cp -r /tmp/agent-sdd/workflows .
cp -r /tmp/agent-sdd/artifacts .
cp -r /tmp/agent-sdd/schemas .
cp -r /tmp/agent-sdd/templates .
cp -r /tmp/agent-sdd/loop .
cp /tmp/agent-sdd/INDEX.md .
```

### Step 2: Initialize Runtime Directory

```bash
# Create agent-sdd/ directory at project root
mkdir -p agent-sdd

# Copy framework
cp -r /tmp/agent-sdd/* agent-sdd/

# Your project now has:
# agent-sdd/AGENTS.MD
# agent-sdd/INDEX.md
# agent-sdd/agents/ (8 agents)
# agent-sdd/workflows/ (4 workflows)
# agent-sdd/artifacts/ (11 artifacts)
# agent-sdd/schemas/ (13 schemas)
# agent-sdd/templates/ (11 templates)
# agent-sdd/loop/ (4 loop stages)
```

### Step 3: Configure Runtime Entry Point

Update your project's README to point to Agent SDD:

```markdown
# My Project

## Software Delivery Framework

This project uses the [Agent SDD](agent-sdd/INDEX.md) framework for software delivery.

Start at `agent-sdd/loop/01-requirement.md` to begin the Software Delivery Loop.
```

### Step 4: Configure Spec Kit Integration (Optional)

If using [spec-kit](https://github.com/github/spec-kit), add Agent SDD aliases:

```bash
# Install Specify CLI
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# Initialize Agent SDD as the delivery framework
specify init . --integration agent-sdd

# Now you can use:
/speckit.requirement      # Alias for Requirement Flow
/speckit.development      # Alias for Development Flow
/speckit.testing          # Alias for Testing Flow
/speckit.release          # Alias for Release Flow
```

### Step 5: Start First Loop

The loop begins when a user provides a requirement, and proceeds through:

1. Requirement Agent produces **REQ**
2. Product Manager Agent produces **PS**
3. Technical Manager Agent produces **TS**
4. Architecture Agent produces **AD**
5. Frontend/Backend Agents implement
6. Tester Agent produces **QEP**
7. Reviewer Agent produces **DRR** and **SDP**
8. Release deployed
9. Customer feedback may restart the loop

---

## Existing Project: Retrofit Agent SDD

### Step 1: Assessment

Evaluate current project structure:

```bash
# 1. Check existing processes
ls -la .specify/ .cursor/ plan.md

# 2. Identify pain points
# - Requirements scattered?
# - No traceability?
# - Quality gates missing?
# - Handoffs unclear?

# 3. Decide adoption scope
# - Full adoption (all 4 stages)
# - Partial adoption (select stages)
# - Shadow mode (run in parallel with existing process)
```

### Step 2: Incremental Introduction

#### Option A: Stage-by-Stage Migration

```bash
# Phase 1: Adopt Requirement Flow (1-2 weeks)
cp agent-sdd/loop/01-requirement.md ./
cp agent-sdd/agents/requirement.md ./
cp agent-sdd/artifacts/requirement.md ./
cp agent-sdd/schemas/requirement.schema.yaml ./

# Phase 2: Adopt Development Flow (2-4 weeks)
cp agent-sdd/loop/02-development.md ./
cp agent-sdd/agents/{product-manager,technical-manager,architecture}.md ./
cp agent-sdd/workflows/development.md ./
cp agent-sdd/artifacts/{product-specification,technical-specification,architecture-design}.md ./
cp agent-sdd/schemas/*.yaml ./

# Phase 3: Adopt Testing Flow (1-2 weeks)
cp agent-sdd/loop/03-testing.md ./
cp agent-sdd/agents/tester.md ./
cp agent-sdd/workflows/testing.md ./
cp agent-sdd/artifacts/{test-case,test-report,quality-evidence-package}.md ./

# Phase 4: Adopt Release Flow (1-2 weeks)
cp agent-sdd/loop/04-release.md ./
cp agent-sdd/agents/reviewer.md ./
cp agent-sdd/workflows/release.md ./
cp agent-sdd/artifacts/{delivery-review-report,software-delivery-package}.md ./
```

#### Option B: Parallel Shadow Mode

```bash
# Run Agent SDD alongside existing process for 2-3 iterations
mkdir -p agent-sdd-shadow
cp -r agent-sdd/* agent-sdd-shadow/

# Compare outputs:
# - Existing process vs Agent SDD
# - Traceability quality
# - Artifact completeness

# After validation, decide to:
# 1. Replace entirely
# 2. Merge best practices
# 3. Keep hybrid approach
```

### Step 3: Adapt Existing Artifacts

Map existing documents to Agent SDD artifacts:

```text
Existing PRD        → REQ + PS
Existing tech design → TS + AD
Existing API docs   → API artifacts
Existing test plans → TC + QEP
Existing release notes → SDP
```

```bash
# Migration script example:
python scripts/migrate-to-agent-sdd.py \
  --prd docs/PRD-001.md \
  --output agent-sdd/artifacts/requirement.md
```

### Step 4: Team Training

- **Framework overview** (30 min): Read `AGENTS.MD` together, understand the 4-stage loop, explore `INDEX.md`.
- **Role-specific training** (1 hour per role): Requirements, Product, Technical, Architecture, Development, QA, Governance.
- **Workflow training** (1 hour): Walk through `loop/01-requirement.md` → `loop/04-release.md`, practice feedback loops.
- **Hands-on exercise** (2 hours): Run one complete loop with a sample requirement, produce artifacts end-to-end, practice the feedback flow.

### Step 5: Configure Integration

```bash
# Update CI/CD to validate artifacts against schemas
# Example: validate REQ against its schema
yamllint agent-sdd/schemas/requirement.schema.yaml agent-sdd/artifacts/requirement.md
```

```yaml
# .github/workflows/validate-artifacts.yml
name: Validate Artifacts
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: yamllint schemas/requirement.schema.yaml artifacts/requirement.md
```

---

## Integration Patterns

### Pattern 1: Agent SDD as Spec-Kit Extension

Agent SDD extends spec-kit's delivery phase. Integration points:

- `/speckit.specify` → Agent SDD Requirement Flow
- `/speckit.plan` → Agent SDD Development Flow (partially)
- `/speckit.tasks` → Agent SDD Technical Specification
- `/speckit.implement` → Agent SDD Implementation
- Agent SDD produces QEP, DRR, SDP → feeds back to spec-kit

### Pattern 2: Dual-Track Execution

Run Agent SDD in parallel with spec-kit for comparison:

1. spec-kit defines requirement
2. Agent SDD produces REQ
3. Both proceed through planning/implementation
4. Agent SDD provides QEP, DRR, SDP
5. Compare outputs, merge best practices

### Pattern 3: Agent SDD as Quality Overlay

Keep the existing spec-kit workflow; add Agent SDD as a quality/validation layer:

1. spec-kit runs normally
2. Agent SDD validates requirement completeness, traceability chain, quality gates, and governance
3. If Agent SDD validation fails, feedback returns to spec-kit

---

## Migration Checklist

### New Project

- [ ] Clone/copy Agent SDD framework
- [ ] Configure `INDEX.md` entry point in project README
- [ ] (Optional) Integrate with spec-kit
- [ ] Initialize first requirement
- [ ] Train team on 4-stage loop
- [ ] Configure CI/CD for artifact validation
- [ ] Run first complete loop end-to-end

### Existing Project

- [ ] Assess current state and pain points
- [ ] Choose adoption scope (full/partial/shadow)
- [ ] Copy Agent SDD framework
- [ ] Map existing artifacts to Agent SDD artifacts
- [ ] Train team on new workflow
- [ ] Migrate 1-2 pilot requirements through full loop
- [ ] Configure artifact validation
- [ ] Establish feedback loops
- [ ] Measure improvement (traceability, quality, delivery speed)
- [ ] Decide: continue hybrid or full migration

---

## FAQ

**Q: What if my existing process doesn't fit 4 stages?**
Agent SDD is modular — adopt all 4 stages for full benefit, or only specific stages (e.g., Requirement + Testing). Adapt workflows to your process while maintaining core principles.

**Q: How do I handle legacy requirements?**
Wrap them in REQ format with a `legacySource` field pointing to the original document (Jira ticket, Confluence page, etc.).

**Q: Can I customize agent behavior?**
Yes. Agent specs are contracts, not implementations. Customize prompts within CORE responsibilities, add project-specific validation rules, extend schemas, and customize workflow stages while keeping the loop structure intact.

**Q: How does this compare to existing SDD frameworks?**
Agent SDD is unique in: **3-tier progressive disclosure** (minimal context footprint), **4-stage loop spine** (explicit feedback loops), **artifact-first governance** (every decision traceable), **runtime agnostic** (any orchestration engine), and **spec-kit native** (designed to integrate seamlessly).

---

## License

MIT

---

**Note:** This repository defines engineering standards. It is **not** an implementation repository. Implementation technologies may change; engineering principles remain stable.
