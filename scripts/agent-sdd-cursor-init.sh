#!/usr/bin/env bash
#
# agent-sdd-cursor-init.sh — Wire Agent SDD into the Cursor IDE.
#
# Creates .cursor/rules/ with modular rules that reference agent-sdd/ agents,
# loop stages, schemas, and templates. Optionally integrates SPEC-KIT for
# artifact schema validation.
#
# Usage:
#   ./agent-sdd-cursor-init.sh                     # interactive
#   ./agent-sdd-cursor-init.sh --force            # non-interactive, overwrite
#   ./agent-sdd-cursor-init.sh --spec-kit         # also wire SPEC-KIT schema validation
#   ./agent-sdd-cursor-init.sh --workflows        # also copy workflow rules
#   ./agent-sdd-cursor-init.sh --dir agent-sdd    # override framework directory
#
set -euo pipefail

# ----------------------------------------------------------------------------
# Defaults & flag parsing
# ----------------------------------------------------------------------------
FRAMEWORK_DIR="agent-sdd"
FORCE=false
ADD_SPEC_KIT=false
ADD_WORKFLOWS=false

usage() {
    sed -n '3,16p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --force|-f)       FORCE=true; shift ;;
        --spec-kit)       ADD_SPEC_KIT=true; shift ;;
        --workflows)      ADD_WORKFLOWS=true; shift ;;
        --dir)             FRAMEWORK_DIR="$2"; shift 2 ;;
        --help|-h)        usage 0 ;;
        *)                 echo "[WARN] Unknown flag: $1"; shift ;;
    esac
done

# Cross-platform sed in-place
sedi() {
    if sed --version >/dev/null 2>&1; then
        sed -i "$@"
    else
        sed -i '' "$@"
    fi
}

prompt_yes_no() {
    local question="$1"
    if [ "$FORCE" = true ]; then
        echo "[AUTO] ${question} -> yes (--force)"
        return 0
    fi
    printf "%s (y/n) " "$question"
    local ans
    read -r ans || ans=""
    [[ "$ans" =~ ^[Yy]$ ]]
}

ok()    { printf "[OK]   %s\n" "$*"; }
warn()  { printf "[WARN] %s\n" "$*" >&2; }
err()   { printf "[ERROR] %s\n" "$*" >&2; }

# ----------------------------------------------------------------------------
# 1. Pre-flight checks
# ----------------------------------------------------------------------------
echo "==> Agent SDD — Cursor IDE Integration"
echo "    Framework: $FRAMEWORK_DIR/"

if [ ! -d "$FRAMEWORK_DIR" ]; then
    err "$FRAMEWORK_DIR/ not found. Run agent-sdd-init.sh first."
    exit 1
fi

REQUIRED_DIRS="agents loop schemas templates"
for d in $REQUIRED_DIRS; do
    if [ ! -d "$FRAMEWORK_DIR/$d" ]; then
        err "$FRAMEWORK_DIR/$d/ missing. Is $FRAMEWORK_DIR a valid Agent SDD root?"
        exit 1
    fi
done
ok "Framework verified."

# ----------------------------------------------------------------------------
# 2. Detect which rules already exist and prompt to overwrite
# ----------------------------------------------------------------------------
RULES_DIR=".cursor/rules"
if [ -d "$RULES_DIR" ]; then
    EXISTING=$(find "$RULES_DIR" -name "*.mdc" -o -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$EXISTING" -gt 0 ] && [ "$FORCE" = false ]; then
        warn "$RULES_DIR/ already has $EXISTING rule file(s)."
        prompt_yes_no "Backup and overwrite?" || { echo "Aborted."; exit 0; }
        BACKUP="${RULES_DIR}.backup.$(date +%s)"
        mv "$RULES_DIR" "$BACKUP"
        ok "Backed up to $BACKUP"
    elif [ "$FORCE" = true ]; then
        BACKUP="${RULES_DIR}.backup.$(date +%s)"
        mv "$RULES_DIR" "$BACKUP" 2>/dev/null || true
    fi
fi

mkdir -p "$RULES_DIR"

# ----------------------------------------------------------------------------
# 3. Prompt for optional integrations
# ----------------------------------------------------------------------------
if [ "$ADD_SPEC_KIT" = false ] && prompt_yes_no "Also wire SPEC-KIT for schema validation?"; then
    ADD_SPEC_KIT=true
fi

if [ "$ADD_WORKFLOWS" = false ] && prompt_yes_no "Also copy workflow rules?"; then
    ADD_WORKFLOWS=true
fi

# ----------------------------------------------------------------------------
# 4. Generate rules
# ----------------------------------------------------------------------------

# -- 4a. Main entry rule: AGENTS.mdc ----------------------------------------
echo "==> Generating Cursor rules..."

cat > "$RULES_DIR/AGENTS.mdc" <<'RULES'
---
description: Agent SDD — Software Delivery Framework
version: 1.0
---

@ agent-sdd-overview.mdc
@ agent-sdd-artifacts.mdc
@ agent-sdd-lifecycle.mdc
@ agent-sdd-agents.mdc
@ agent-sdd-loop-stages.mdc
RULES
ok "AGENTS.mdc (entry point)"

# -- 4b. Framework overview rule --------------------------------------------
cat > "$RULES_DIR/agent-sdd-overview.mdc" <<RULES
---
description: Agent SDD Framework Overview — what the framework is and how it works
version: 1.0
---

# Agent SDD Framework Overview

## What Is Agent SDD?

Agent SDD (Agent Software Delivery Driven) is an AI-native software delivery framework that treats AI as a collaborative engineering organization composed of specialized agents.

Instead of compressing all engineering responsibilities into a single model, Agent SDD separates them into well-defined agents that collaborate through standardized **artifacts**.

## Core Principles

1. **Single Responsibility** — Each agent owns exactly one engineering domain.
2. **Artifact First** — Agents never communicate through free-form conversations. Artifacts are the engineering contract.
3. **Traceability First** — Every artifact contains id, parent, children, owner, version, and status.
4. **Quality by Design** — Quality is built into every stage, not inspected at the end.
5. **Human-in-the-Loop (HITL)** — AI accelerates; humans make final approval decisions.
6. **Feedback Driven** — Production feedback creates a new engineering cycle.

## Agent Types

| Agent | Domain | Produces |
|-------|--------|----------|
| Requirement Agent | Business requirements | REQ |
| Product Manager Agent | Product specification | PS |
| Technical Manager Agent | Technical planning | TS |
| Architecture Agent | Architecture design | AD |
| Frontend Agent | Frontend implementation | FI |
| Backend Agent | Backend implementation | BI |
| Tester Agent | Quality assurance | QEP |
| Reviewer Agent | Delivery governance | DRR |

## Artifact Lifecycle

```
Draft → Ready → Approved → In Progress → Completed → Verified → Released → Archived
```

## Framework Root

The framework lives in \`$FRAMEWORK_DIR/\` (default: \`agent-sdd/\`).

- \`AGENTS.MD\` — Full framework specification
- \`INDEX.md\` — Framework index
- \`loop/\` — Software Delivery Loop stage definitions
- \`agents/\` — Agent role definitions
- \`workflows/\` — Workflow specifications
- \`artifacts/\` — Artifact instances
- \`schemas/\` — JSON Schema contracts for all artifact types
- \`templates/\` — Markdown templates for every artifact type

## Working with Agent SDD

1. Always reference the framework root when creating or validating artifacts.
2. Every artifact must have a unique ID, owner, version, and status.
3. Never modify another agent's artifacts directly — use feedback instead.
4. Before writing any code, ensure the relevant artifact is in **Approved** status.
5. Use templates from \`$FRAMEWORK_DIR/templates/\` when creating new artifacts.
6. Validate artifacts against schemas in \`$FRAMEWORK_DIR/schemas/\`.
RULES
ok "agent-sdd-overview.mdc"

# -- 4c. Artifacts rule -------------------------------------------------------
cat > "$RULES_DIR/agent-sdd-artifacts.mdc" <<RULES
---
description: Agent SDD Artifact system — types, schemas, and templates
version: 1.0
---

# Agent SDD Artifact System

## Artifact Types

Every artifact in the Agent SDD framework follows a standardized format with YAML frontmatter.

| Artifact | ID Pattern | Schema |
|----------|-----------|--------|
| Requirement | REQ-### | requirement.schema.yaml |
| Product Specification | PS-### | product-specification.schema.yaml |
| Technical Specification | TS-### | technical-specification.schema.yaml |
| Architecture Design | AD-### | architecture-design.schema.yaml |
| User Story | US-### | user-story.schema.yaml |
| Task | TASK-### | task.schema.yaml |
| Backend Implementation | BI-### | (informal) |
| Frontend Implementation | FI-### | (informal) |
| Test Case | TC-### | test-case.schema.yaml |
| Test Report | TR-### | test-report.schema.yaml |
| Bug Report | BUG-### | (informal) |
| Data Model | MODEL-### | data-model.schema.yaml |
| API | API-### | api.schema.yaml |
| Quality Evidence Package | QEP-### | quality-evidence-package.schema.yaml |
| Delivery Review Report | DRR-### | delivery-review-report.schema.yaml |
| Software Delivery Package | SDP-### | software-delivery-package.schema.yaml |

## Artifact Frontmatter

Every artifact file must start with YAML frontmatter:

\`\`\`yaml
---
id: REQ-001
title: User Authentication
owner: requirement-agent
version: 1.0.0
status: Approved
traceability:
  parent: null
  children:
    - PS-001
    - US-001
metadata:
  createdAt: 2024-01-01
  updatedAt: 2024-01-15
  loopStage: 01-requirement
---
\`\`\`

## Templates

Use the matching template from \`$FRAMEWORK_DIR/templates/\` when creating new artifacts:

\`\`\`
$FRAMEWORK_DIR/templates/
├── requirement.md
├── product-specification.md
├── technical-specification.md
├── architecture-design.md
├── user-story.md
├── task.md
├── test-case.md
├── test-report.md
├── quality-evidence-package.md
├── delivery-review-report.md
├── software-delivery-package.md
└── ...
\`\`\`

## Schemas

Validate artifacts against the JSON Schema in \`$FRAMEWORK_DIR/schemas/\`:

\`\`\`
$FRAMEWORK_DIR/schemas/
├── requirement.schema.yaml
├── product-specification.schema.yaml
├── technical-specification.schema.yaml
├── architecture-design.schema.yaml
├── user-story.schema.yaml
├── task.schema.yaml
├── test-case.schema.yaml
├── test-report.schema.yaml
├── quality-evidence-package.schema.yaml
├── delivery-review-report.schema.yaml
├── software-delivery-package.schema.yaml
├── data-model.schema.yaml
├── api.schema.yaml
└── ...
\`\`\`

## Artifact File Naming

Save artifacts as: \`{artifact-id}-{slug}.md\`

Examples:
- \`REQ-001-user-authentication.md\`
- \`PS-001-ecommerce-product.md\`
- \`TS-003-payment-service.md\`
RULES
ok "agent-sdd-artifacts.mdc"

# -- 4d. Lifecycle rule -------------------------------------------------------
cat > "$RULES_DIR/agent-sdd-lifecycle.mdc" <<RULES
---
description: Agent SDD Lifecycle — loop stages, state machines, and quality gates
version: 1.0
---

# Agent SDD Lifecycle

## Software Delivery Loop

The framework operates as a continuous loop of five stages:

\`\`\`
┌─────────────────────┐
│ 01. Requirement      │
│ (Discovery)         │
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│ 02. Development      │
│ (Planning & Build)  │
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│ 03. Testing          │
│ (Quality Assurance) │
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│ 04. Release          │
│ (Delivery Governance)│
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│ 05. Feedback        │
│ (Customer / Incident│
└──────────┬──────────┘
           ▼
    Requirement ← NEW CYCLE
\`\`\`

## Loop Stage Definitions

Each stage is defined in \`$FRAMEWORK_DIR/loop/\`:

- \`01-requirement.md\` — Requirement discovery and capture
- \`02-development.md\` — Planning, architecture, and implementation
- \`03-testing.md\` — Quality assurance and test execution
- \`04-release.md\` — Delivery governance and release management
- \`05-feedback.md\` — Customer feedback and incident handling

## Artifact Lifecycle States

Artifacts progress through a fixed lifecycle and **never skip states**:

\`\`\`
Draft → Ready → Approved → In Progress → Completed → Verified → Released → Archived
\`\`\`

| State | Meaning |
|-------|---------|
| Draft | Being authored, not yet ready for review |
| Ready | Author believes it is complete; awaiting review |
| Approved | Reviewed and accepted; ready for downstream use |
| In Progress | Work is actively being done |
| Completed | Work is done; awaiting verification |
| Verified | Quality verified; ready for release |
| Released | Delivered to production or customer |
| Archived | Superseded or no longer active |

## Workflow State Machine

Each workflow follows:

\`\`\`
Draft → Ready → Running → Waiting Review → Approved → Completed → Archived
\`\`\`

## Quality Gates

Every stage has mandatory quality gates. If a gate fails:
1. Stop the workflow.
2. Generate structured feedback.
3. Return the artifact to the responsible agent.
4. Repeat validation.

No workflow may bypass quality gates.

## Human Approval Points

The following decisions require explicit human approval:
- Requirement Approval
- Product Approval
- Architecture Approval
- Production Release
- Emergency Rollback

## Feedback Lifecycle

Feedback is a first-class artifact. It follows:

\`\`\`
Created → Assigned → Accepted → Resolved → Verified → Closed
\`\`\`

Feedback never modifies an existing artifact directly — it creates new work.
RULES
ok "agent-sdd-lifecycle.mdc"

# -- 4e. Agents rule ---------------------------------------------------------
# Build the agents section dynamically from $FRAMEWORK_DIR/agents/*.md
AGENTS_LIST=$(find "$FRAMEWORK_DIR/agents" -name "*.md" -type f 2>/dev/null | sort)

# Extract name + description from each agent file
build_agent_entry() {
    local file="$1"
    local name
    name=$(basename "$file" .md | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1))tolower(substr($i,2)); print}')
    local desc=""
    if grep -A2 "^## CORE" "$file" >/dev/null 2>&1; then
        desc=$(sed -n '/^## CORE/,/^##/p' "$file" | grep -i "description" | head -1 | sed 's/^[ ]*//' | cut -d: -f2- | xargs)
    fi
    echo "**$name**"
    if [ -n "$desc" ]; then echo "  $desc"; fi
    echo ""
}

AGENTS_CONTENT=""
for agent_file in $AGENTS_LIST; do
    AGENTS_CONTENT="${AGENTS_CONTENT}$(build_agent_entry "$agent_file")"
done

cat > "$RULES_DIR/agent-sdd-agents.mdc" <<RULES
---
description: Agent SDD Agents — roles, responsibilities, and interaction patterns
version: 1.0
---

# Agent SDD Agents

Each agent represents a professional engineering role with clearly defined responsibilities. Agents collaborate through standardized artifacts — there is no hidden memory shared between agents.

## Agent Roster

${AGENTS_CONTENT:-*(no agent definitions found in $FRAMEWORK_DIR/agents/)*}

## Agent Communication Model

\`\`\`
User
  │
  ▼
Requirement Agent
  │
  ▼ (produces REQ)
Product Manager Agent
  │
  ▼ (produces PS)
Technical Manager Agent
  │
  ▼ (produces TS)
Architecture Agent
  │
  ▼ (produces AD)
  ├──────────┐
  ▼         ▼
Frontend  Backend
Agent      Agent
  │         │
  └────┬────┘
       ▼
  Tester Agent
       │
       ▼
  Reviewer Agent
       │
       ▼
   Release Flow
\`\`\`

## Agent Execution Lifecycle

Every agent follows the same execution lifecycle:

\`\`\`
Receive Input → Understand → Analyze → Plan → Execute → Self-Validate → Produce Artifact → Handoff
\`\`\`

## Agent Contract

Every agent exposes a standard contract:

\`\`\`yaml
agent:
  id:           # Unique identifier
  role:         # Agent role name
  description:  # One-line description
  consumes:     # Artifact types this agent reads
  produces:     # Artifact types this agent writes
  qualityGate:  # Validation this agent performs before producing
  feedback:     # Feedback types this agent can create
  owner:        # Human or system owner
\`\`\`

## Artifact Flow

When working as or with an Agent SDD agent:

1. **Read** the relevant artifact from \`$FRAMEWORK_DIR/artifacts/\`
2. **Validate** it is in the correct lifecycle state
3. **Produce** the next artifact in the chain
4. **Write** the artifact to \`$FRAMEWORK_DIR/artifacts/\`
5. **Do not** modify another agent's output directly

## Agent Detail Files

Each agent's full definition lives in \`$FRAMEWORK_DIR/agents/\`:

$(for f in $AGENTS_LIST; do echo "- \`$(basename $f)\`"; done 2>/dev/null || echo "  *(not found)*")
RULES
ok "agent-sdd-agents.mdc"

# -- 4f. Loop stages rule ----------------------------------------------------
STAGES_LIST=$(find "$FRAMEWORK_DIR/loop" -name "*.md" -type f 2>/dev/null | sort)

STAGES_CONTENT=""
for stage_file in $STAGES_LIST; do
    stage_name=$(basename "$stage_file" .md)
    stage_title=$(sed -n "s/^# \+//p" "$stage_file" | head -1 || echo "$stage_name")
    STAGES_CONTENT="${STAGES_CONTENT}- **${stage_name}** — ${stage_title}\n"
done

cat > "$RULES_DIR/agent-sdd-loop-stages.mdc" <<RULES
---
description: Agent SDD Loop Stages — the five stages of the Software Delivery Loop
version: 1.0
---

# Agent SDD Loop Stages

The Software Delivery Loop consists of five stages. Each stage is defined in \`$FRAMEWORK_DIR/loop/\`.

## Stage Overview

${STAGES_CONTENT:-*(no loop stages found in $FRAMEWORK_DIR/loop/)*}

## Stage Details

$(for f in $STAGES_LIST; do
    stage_name=$(basename "$f" .md)
    echo "### $stage_name"
    echo ""
    echo '```'引用自: `'"$f"'`'
    echo '> *(内容摘要 — 完整定义见框架文件)*'
    echo '```'
    echo ""
done 2>/dev/null || echo "*(no stage files found)*")

## Stage Relationships

\`\`\`
01-requirement
  consumes: User Requirement
  produces: REQ, PS
  ↓
02-development
  consumes: REQ, PS
  produces: TS, AD, US, TASK, FI, BI
  ↓
03-testing
  consumes: FI, BI, TC
  produces: TR, QEP
  ↓
04-release
  consumes: QEP, DRR
  produces: SDP
  ↓
05-feedback
  consumes: SDP, Production Incidents
  produces: New REQ
  ↓
  (back to 01-requirement)
\`\`\`
RULES
ok "agent-sdd-loop-stages.mdc"

# -- 4g. SPEC-KIT schema validation rule (optional) -------------------------
if [ "$ADD_SPEC_KIT" = true ]; then
    cat > "$RULES_DIR/agent-sdd-spec-kit.mdc" <<RULES
---
description: Agent SDD SPEC-KIT integration — schema validation for all artifact types
version: 1.0
---

# Agent SDD SPEC-KIT Integration

SPEC-KIT validates Agent SDD artifacts against their JSON Schema contracts. This rule wires SPEC-KIT into the Cursor IDE.

## SPEC-KIT Setup

SPEC-KIT was initialized with the \`agent-sdd\` integration. Schema files are located at:

\`\`\`
$FRAMEWORK_DIR/schemas/
\`\`\`

## Schema Coverage

| Schema | Validates |
|--------|-----------|
| \`requirement.schema.yaml\` | REQ artifacts |
| \`product-specification.schema.yaml\` | PS artifacts |
| \`technical-specification.schema.yaml\` | TS artifacts |
| \`architecture-design.schema.yaml\` | AD artifacts |
| \`user-story.schema.yaml\` | US artifacts |
| \`task.schema.yaml\` | TASK artifacts |
| \`test-case.schema.yaml\` | TC artifacts |
| \`test-report.schema.yaml\` | TR artifacts |
| \`quality-evidence-package.schema.yaml\` | QEP artifacts |
| \`delivery-review-report.schema.yaml\` | DRR artifacts |
| \`software-delivery-package.schema.yaml\` | SDP artifacts |
| \`data-model.schema.yaml\` | MODEL artifacts |
| \`api.schema.yaml\` | API artifacts |

## Validation Workflow

1. Write or edit an artifact in \`$FRAMEWORK_DIR/artifacts/\`
2. Run \`specify validate\` to check against the matching schema
3. Fix any validation errors before committing
4. The CI workflow (\`.github/workflows/agent-sdd-validate.yml\`) runs validation on push

## Manual Validation

\`\`\`bash
# Validate a specific artifact
specify validate artifacts/REQ-001-user-auth.md

# Validate all artifacts
specify validate artifacts/

# Check SPEC-KIT status
specify status
\`\`\`

## Schema Versioning

Each schema follows semantic versioning. When updating a schema:
1. Increment the minor version if backward-compatible
2. Increment the major version if breaking
3. Update all affected artifacts to the new schema version
RULES
    ok "agent-sdd-spec-kit.mdc (SPEC-KIT integration)"

    # Wire SPEC-KIT into the main AGENTS.mdc
    if grep -q "@ agent-sdd-spec-kit.mdc" "$RULES_DIR/AGENTS.mdc" 2>/dev/null; then
        : # already included
    else
        sedi '/^@ agent-sdd-loop-stages.mdc$/a @ agent-sdd-spec-kit.mdc' "$RULES_DIR/AGENTS.mdc"
    fi
fi

# -- 4h. Workflow rules (optional) ------------------------------------------
if [ "$ADD_WORKFLOWS" = true ]; then
    WORKFLOWS_LIST=$(find "$FRAMEWORK_DIR/workflows" -name "*.md" -type f 2>/dev/null | sort)

    cat > "$RULES_DIR/agent-sdd-workflows.mdc" <<RULES
---
description: Agent SDD Workflows — requirement, development, testing, and release workflows
version: 1.0
---

# Agent SDD Workflows

Each workflow represents a complete engineering lifecycle. Workflows are defined in \`$FRAMEWORK_DIR/workflows/\`.

## Workflow Definitions

$(for f in $WORKFLOWS_LIST; do
    wf_name=$(basename "$f" .md)
    echo "- **${wf_name}.md**"
done 2>/dev/null || echo "*(no workflows found)*")

## Requirement Workflow

Produces: REQ (Requirement Artifact)

\`\`\`
User Requirement
  │
  ▼
Requirement Agent
  │
  ▼
Draft REQ → Ready → Approved
  │
  ▼
Product Manager Agent
  │
  ▼
Draft PS → Ready → Approved
\`\`\`

## Development Workflow

Produces: TS, AD, US, TASK, FI, BI

\`\`\`
PS Approved
  │
  ▼
Technical Manager Agent (TS)
Architecture Agent (AD)
  │
  ▼
Break down into User Stories (US) and Tasks
  │
  ▼
Frontend Agent + Backend Agent (parallel)
  │
  ▼
Implementation completed
\`\`\`

## Testing Workflow

Produces: TC, TR, QEP

\`\`\`
Implementation completed
  │
  ▼
Tester Agent
  │
  ▼
Test Cases (TC) → Test Execution → Test Report (TR)
  │
  ▼
Quality Evidence Package (QEP)
\`\`\`

## Release Workflow

Produces: DRR, SDP

\`\`\`
QEP verified
  │
  ▼
Reviewer Agent
  │
  ▼
Delivery Review Report (DRR)
  │
  ▼
Human Approval
  │
  ▼
Software Delivery Package (SDP)
  │
  ▼
Production Release
\`\`\`

## Workflow State Machine

\`\`\`
Draft → Ready → Running → Waiting Review → Approved → Completed → Archived
\`\`\`
RULES
    ok "agent-sdd-workflows.mdc (workflow rules)"

    # Wire workflows into the main AGENTS.mdc
    if grep -q "@ agent-sdd-workflows.mdc" "$RULES_DIR/AGENTS.mdc" 2>/dev/null; then
        :
    else
        sedi '/^@ agent-sdd-loop-stages.mdc$/a @ agent-sdd-workflows.mdc' "$RULES_DIR/AGENTS.mdc"
    fi
fi

# ----------------------------------------------------------------------------
# 5. Create / update CURSOR.md at project root
# ----------------------------------------------------------------------------
echo "==> Writing CURSOR.md ..."

# Detect if SPEC-KIT is installed
SPEC_KIT_LINE=""
if [ "$ADD_SPEC_KIT" = true ]; then
    SPEC_KIT_LINE="- **SPEC-KIT**: Configured for schema validation (run \`specify init . --integration agent-sdd\` to re-initialize)"
else
    SPEC_KIT_LINE="- **SPEC-KIT**: Not configured. Run \`./scripts/agent-sdd-cursor-init.sh --spec-kit\` to enable."
fi

if [ -f CURSOR.md ] && [ "$FORCE" = false ]; then
    warn "CURSOR.md already exists. Skipping (use --force to overwrite)."
else
    cat > CURSOR.md <<MD
# Agent SDD — Cursor IDE Integration

This project uses the [Agent SDD Framework]($FRAMEWORK_DIR/AGENTS.MD) for AI-driven software delivery.

## Cursor Rules

Rules are located in [\`.cursor/rules/\`](.cursor/rules/) and loaded automatically by Cursor:

- **[AGENTS.mdc](.cursor/rules/AGENTS.mdc)** — Entry point; \`@\`\-includes all sub-rules
- [agent-sdd-overview.mdc](.cursor/rules/agent-sdd-overview.mdc) — Framework overview
- [agent-sdd-artifacts.mdc](.cursor/rules/agent-sdd-artifacts.mdc) — Artifact types, schemas, templates
- [agent-sdd-lifecycle.mdc](.cursor/rules/agent-sdd-lifecycle.mdc) — Loop stages and state machines
- [agent-sdd-agents.mdc](.cursor/rules/agent-sdd-agents.mdc) — Agent roles and responsibilities
- [agent-sdd-loop-stages.mdc](.cursor/rules/agent-sdd-loop-stages.mdc) — Five loop stage definitions
$(if [ "$ADD_WORKFLOWS" = true ]; then echo "- [agent-sdd-workflows.mdc](.cursor/rules/agent-sdd-workflows.mdc) — Workflow definitions"; fi)
$(if [ "$ADD_SPEC_KIT" = true ]; then echo "- [agent-sdd-spec-kit.mdc](.cursor/rules/agent-sdd-spec-kit.mdc) — SPEC-KIT schema validation"; fi)

## Framework Structure

\`\`\`
$FRAMEWORK_DIR/
├── AGENTS.MD              # Full framework specification
├── INDEX.md               # Framework index
├── agent-sdd.yaml         # Project configuration
├── loop/                  # Loop stage definitions
│   ├── 01-requirement.md
│   ├── 02-development.md
│   ├── 03-testing.md
│   ├── 04-release.md
│   └── 05-feedback.md
├── agents/                # Agent role definitions
│   ├── requirement.md
│   ├── product-manager.md
│   ├── technical-manager.md
│   ├── architecture.md
│   ├── frontend.md
│   ├── backend.md
│   ├── tester.md
│   └── reviewer.md
├── workflows/             # Workflow specifications
├── artifacts/             # Artifact instances
├── schemas/               # JSON Schema contracts
└── templates/             # Markdown templates
\`\`\`

## Integrations

$SPEC_KIT_LINE

- **CI Validation**: See [\`.github/workflows/agent-sdd-validate.yml\`](.github/workflows/agent-sdd-validate.yml) for schema validation on push.

## Quick Start

1. **Start a loop**: Open \`$FRAMEWORK_DIR/loop/01-requirement.md\` and follow the requirement workflow.
2. **Create an artifact**: Use a template from \`$FRAMEWORK_DIR/templates/\`.
3. **Validate**: Run \`specify validate artifacts/REPO-<id>.md\` (if SPEC-KIT is enabled).
4. **Review**: Ensure the artifact is in **Approved** status before proceeding to implementation.
5. **Traceability**: Every artifact must declare its parent and children in the frontmatter.

## Commands

\`\`\`bash
# Re-initialize Cursor rules (after framework update)
./scripts/agent-sdd-cursor-init.sh --force

# Add SPEC-KIT integration
./scripts/agent-sdd-cursor-init.sh --spec-kit

# Show all available rules
ls -la .cursor/rules/
\`\`\`
MD
    ok "CURSOR.md written"
fi

# ----------------------------------------------------------------------------
# 6. Update agent-sdd.yaml
# ----------------------------------------------------------------------------
if [ -f "$FRAMEWORK_DIR/agent-sdd.yaml" ]; then
    if grep -q "cursor:" "$FRAMEWORK_DIR/agent-sdd.yaml" 2>/dev/null; then
        sedi "s/cursor: .*/cursor: true/" "$FRAMEWORK_DIR/agent-sdd.yaml"
    else
        sedi "/ci_validation:/a\  cursor: true" "$FRAMEWORK_DIR/agent-sdd.yaml"
    fi
    ok "Updated $FRAMEWORK_DIR/agent-sdd.yaml → cursor: true"
fi

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------
echo
echo "=============================================="
echo " ✅ Agent SDD Cursor IDE integration done!"
echo "=============================================="
echo
echo "Rules installed:"
find "$RULES_DIR" -name "*.mdc" -type f | while read -r f; do
    echo "  - $(basename "$f")"
done
echo
echo "Next steps:"
echo "  1. Restart Cursor (or reload rules) to activate"
echo "  2. Read CURSOR.md at the project root"
echo "  3. Explore $FRAMEWORK_DIR/ for framework details"
echo
if [ "$ADD_SPEC_KIT" = false ]; then
    echo "Optional:"
    echo "  • SPEC-KIT: ./scripts/agent-sdd-cursor-init.sh --spec-kit"
fi
echo
echo "Happy delivering!"
