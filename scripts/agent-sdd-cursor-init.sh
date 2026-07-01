#!/usr/bin/env bash
#
# agent-sdd-cursor-init.sh — Wire Agent SDD into the Cursor IDE.
#
# Creates .cursor/rules/ with modular rules that reference agent-sdd/ agents,
# loop stages, schemas, and templates. Optionally integrates SPEC-KIT for
# artifact schema validation.
#
# Idempotent: safe to re-run; use --force to overwrite existing rules.
#
# Usage:
#   ./agent-sdd-cursor-init.sh                          # interactive
#   ./agent-sdd-cursor-init.sh --force                 # non-interactive, overwrite
#   ./agent-sdd-cursor-init.sh --spec-kit              # also wire SPEC-KIT
#   ./agent-sdd-cursor-init.sh --workflows             # also copy workflow rules
#   ./agent-sdd-cursor-init.sh --dir agent-sdd         # override framework directory
#
# Pipe usage (e.g. from curl):
#   curl -sSL .../agent-sdd-cursor-init.sh | bash -s -- --dir agent-sdd --spec-kit
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
    sed -n '4,18p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --force|-f)       FORCE=true; shift ;;
        --spec-kit)       ADD_SPEC_KIT=true; shift ;;
        --workflows)      ADD_WORKFLOWS=true; shift ;;
        --dir)             FRAMEWORK_DIR="$2"; shift 2 ;;
        --help|-h)        usage 0 ;;
        *)                 printf "[WARN] Unknown flag: %s\n" "$1"; shift ;;
    esac
done

# ----------------------------------------------------------------------------
# Helpers (defined first so they're available in all code paths)
# ----------------------------------------------------------------------------
sedi() {
    # Cross-platform: GNU sed uses -i directly; BSD/macOS needs -i ''
    if sed --version >/dev/null 2>&1; then
        sed -i "$@"
    else
        # BSD sed: first non-option arg is the script, remaining args are files
        # Use -e to pass the expression separately so we can append -i ''
        local _arg
        _arg="$1"; shift
        sed -i '' "$_arg" "$@"
    fi
}

ok()    { printf "[OK]   %s\n" "$*"; }
warn()  { printf "[WARN] %s\n" "$*" >&2; }
err()   { printf "[ERROR] %s\n" "$*" >&2; }

# ----------------------------------------------------------------------------
# ALL generation functions — must be defined BEFORE the idempotency check
# because the early-exit path calls them.
# ----------------------------------------------------------------------------

# Wire a new rule into AGENTS.mdc if not already present.
wire_into_agents_mdc() {
    local rule="$1"
    if grep -qF "@ $rule" "$RULES_DIR/AGENTS.mdc" 2>/dev/null; then
        return
    fi
    # awk is more portable than BSD sed's 'a' command
    awk -v _rule="@ $rule" '
        /^@ agent-sdd-loop-stages.mdc$/ { print; print _rule; next }
        { print }
    ' "$RULES_DIR/AGENTS.mdc" > "$RULES_DIR/AGENTS.mdc.tmp" \
    && mv "$RULES_DIR/AGENTS.mdc.tmp" "$RULES_DIR/AGENTS.mdc"
}

# -- Generate AGENTS.mdc (entry point) ----------------------------------------
generate_agents_mdc() {
    cat > "$RULES_DIR/AGENTS.mdc" <<'AGENTS_MDC'
---
description: Agent SDD — Software Delivery Framework
version: 1.0
---

@ agent-sdd-overview.mdc
@ agent-sdd-artifacts.mdc
@ agent-sdd-lifecycle.mdc
@ agent-sdd-agents.mdc
@ agent-sdd-loop-stages.mdc
@ agent-sdd-execution.mdc
AGENTS_MDC
}

# -- Generate agent-sdd-overview.mdc -----------------------------------------
# All dynamic values (FRAMEWORK_DIR) are pre-computed into local variables
# BEFORE the heredoc so that the quoted-delimiter heredoc stays safe when
# the script is run via:  curl ... | bash -s -- --dir agent-sdd
generate_overview_rule() {
    local _dir="$FRAMEWORK_DIR"
    cat > "$RULES_DIR/agent-sdd-overview.mdc" <<OVERVIEW_MDC
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

\`\`\`
Draft → Ready → Approved → In Progress → Completed → Verified → Released → Archived
\`\`\`

## Framework Root

The framework lives in \`$_dir/\` (default: \`agent-sdd/\`).

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
5. Use templates from \`$_dir/templates/\` when creating new artifacts.
6. Validate artifacts against schemas in \`$_dir/schemas/\`.
OVERVIEW_MDC
}

# -- Generate agent-sdd-artifacts.mdc -----------------------------------------
generate_artifacts_rule() {
    local _dir="$FRAMEWORK_DIR"
    cat > "$RULES_DIR/agent-sdd-artifacts.mdc" <<ARTIFACTS_MDC
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

Use the matching template from \`$_dir/templates/\` when creating new artifacts.

## Schemas

Validate artifacts against the JSON Schema in \`$_dir/schemas/\`.

## Artifact File Naming

Save artifacts as: \`{artifact-id}-{slug}.md\`

Examples:
- \`REQ-001-user-authentication.md\`
- \`PS-001-ecommerce-product.md\`
- \`TS-003-payment-service.md\`
ARTIFACTS_MDC
}

# -- Generate agent-sdd-lifecycle.mdc -----------------------------------------
generate_lifecycle_rule() {
    local _dir="$FRAMEWORK_DIR"
    cat > "$RULES_DIR/agent-sdd-lifecycle.mdc" <<LIFECYCLE_MDC
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

Each stage is defined in \`$_dir/loop/\`:

- \`01-requirement.md\` — Requirement discovery and capture
- \`02-development.md\` — Planning, architecture, and implementation
- \`03-testing.md\` — Quality assurance and test execution
- \`04-release.md\` — Delivery governance and release management

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
LIFECYCLE_MDC
}

# -- Generate agent-sdd-agents.mdc -------------------------------------------
# Dynamically builds the agent roster from $FRAMEWORK_DIR/agents/.
build_agents_section() {
    local _list
    _list=$(find "$FRAMEWORK_DIR/agents" -name "*.md" -type f 2>/dev/null | sort) || true
    [ -z "$_list" ] && echo "*(no agent definitions found)*" && return
    while IFS= read -r _f; do
        [ -z "$_f" ] && continue
        local _name _desc
        _name=$(basename "$_f" .md | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1))tolower(substr($i,2)); print}')
        _desc=""
        if grep -A2 "^## CORE" "$_f" >/dev/null 2>&1; then
            _desc=$(sed -n '/^## CORE/,/^##/p' "$_f" | grep -i "description" | head -1 | sed 's/^[ ]*//' | cut -d: -f2- | xargs)
        fi
        printf "%s\n" "**$_name**"
        [ -n "$_desc" ] && printf "%s\n" "  $_desc"
        printf "\n"
    done <<< "$_list"
}

build_agents_detail_list() {
    local _list
    _list=$(find "$FRAMEWORK_DIR/agents" -name "*.md" -type f 2>/dev/null | sort) || true
    [ -z "$_list" ] && echo "  *(not found)*" && return
    while IFS= read -r _f; do
        [ -z "$_f" ] && continue
        echo "- \`$(basename "$_f")\`"
    done <<< "$_list"
}

generate_agents_rule() {
    local _content _detail_list _dir
    _content=$(build_agents_section)
    _detail_list=$(build_agents_detail_list)
    _dir="$FRAMEWORK_DIR"
    cat > "$RULES_DIR/agent-sdd-agents.mdc" <<AGENTS_RULES
---
description: Agent SDD Agents — roles, responsibilities, and interaction patterns
version: 1.0
---

# Agent SDD Agents

Each agent represents a professional engineering role with clearly defined responsibilities. Agents collaborate through standardized artifacts — there is no hidden memory shared between agents.

## Agent Roster

${_content:-*(no agent definitions found)*}

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

1. **Read** the relevant artifact from \`$_dir/artifacts/\`
2. **Validate** it is in the correct lifecycle state
3. **Produce** the next artifact in the chain
4. **Write** the artifact to \`$_dir/artifacts/\`
5. **Do not** modify another agent's output directly

## Agent Detail Files

Each agent's full definition lives in \`$_dir/agents/\`:

$(printf "%s\n" "$_detail_list")
AGENTS_RULES
}

# -- Generate agent-sdd-loop-stages.mdc ---------------------------------------
build_stages_overview() {
    local _list
    _list=$(find "$FRAMEWORK_DIR/loop" -name "*.md" -type f 2>/dev/null | sort) || true
    [ -z "$_list" ] && echo "*(no loop stages found)*" && return
    while IFS= read -r _f; do
        [ -z "$_f" ] && continue
        local _name _title
        _name=$(basename "$_f" .md)
        _title=$(sed -n "s/^# \+//p" "$_f" | head -1 || echo "$_name")
        printf "%s\n" "- **${_name}** — ${_title}"
    done <<< "$_list"
}

build_stages_details() {
    local _list
    _list=$(find "$FRAMEWORK_DIR/loop" -name "*.md" -type f 2>/dev/null | sort) || true
    [ -z "$_list" ] && echo "*(no stage files found)*" && return
    while IFS= read -r _f; do
        [ -z "$_f" ] && continue
        local _name
        _name=$(basename "$_f" .md)
        printf "%s\n" "### $_name"
        printf "\n"
        printf "%s\n" "\`\`\`quote"
        printf "%s\n" "引用自: \`$_f\`"
        printf "%s\n" "> *(内容摘要 — 完整定义见框架文件)*"
        printf "%s\n" "\`\`\`"
        printf "\n"
    done <<< "$_list"
}

generate_loop_stages_rule() {
    local _overview _details _dir
    _overview=$(build_stages_overview)
    _details=$(build_stages_details)
    _dir="$FRAMEWORK_DIR"
    cat > "$RULES_DIR/agent-sdd-loop-stages.mdc" <<STAGES_RULES
---
description: Agent SDD Loop Stages — the five stages of the Software Delivery Loop
version: 1.0
---

# Agent SDD Loop Stages

The Software Delivery Loop consists of five stages. Each stage is defined in \`$_dir/loop/\`.

## Stage Overview

$(printf "%s\n" "$_overview")

## Stage Details

$(printf "%s\n" "$_details")

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
STAGES_RULES
}

# -- Generate agent-sdd-execution.mdc (MANDATORY) ----------------------------
# This is the core enforcement rule that ensures Agent SDD compliance.
generate_execution_rule() {
    local _dir="$FRAMEWORK_DIR"
    cat > "$RULES_DIR/agent-sdd-execution.mdc" <<EXECUTION_MDC
---
description: Agent SDD Execution Rule — Mandatory state checking before any implementation
version: 1.0
---

# Agent SDD Execution Rule

> **CRITICAL**: This rule is MANDATORY. Violations should be flagged immediately.
> The Agent SDD framework treats execution as a state machine. You MUST check state BEFORE acting.

## Pre-Implementation Checklist

Before ANY implementation task, you MUST execute the following steps:

### Step 1: Read Runtime State

Read \`$_dir/runtime-state.json\`

If the file does not exist, the loop has not been started. Ask the user to run \`/sdd start\`.

### Step 2: Identify Current Loop Stage

From \`runtime-state.json\`, extract:
- \`current.loop_stage\` — current stage (01-requirement, 02-development, 03-testing, 04-release)
- \`current.agent_role\` — current agent responsibility
- \`current.artifact_id\` — artifact being worked on

### Step 3: Load Stage Definition

Load the corresponding loop file based on current stage:

| Stage | File |
|-------|------|
| 01-requirement | \`$_dir/loop/01-requirement.md\` |
| 02-development | \`$_dir/loop/02-development.md\` |
| 03-testing | \`$_dir/loop/03-testing.md\` |
| 04-release | \`$_dir/loop/04-release.md\` |

### Step 4: Check Required Artifacts

From \`artifacts.required\` in \`runtime-state.json\`, verify each required artifact:

1. **Exists**: Check the artifact file exists in \`$_dir/artifacts/\`
2. **Status**: Verify status in frontmatter is \`Approved\`
3. **Traceability**: Verify parent/children links are complete

### Step 5: Gate Validation

If you are attempting to advance to the next stage:

1. Load the quality gate definition from the current stage file
2. Validate all gate criteria are met
3. If gate fails: STOP, report issues, do not proceed

## Implementation Guards

### NEVER Do These Things

1. **NEVER** write production code before REQ, PS, TS, and AD are Approved
2. **NEVER** skip a quality gate
3. **NEVER** modify another agent's artifact directly
4. **NEVER** create new artifacts without saving to \`$_dir/artifacts/\`
5. **NEVER** skip artifact frontmatter (id, status, owner, traceability)

### ALWAYS Do These Things

1. **ALWAYS** check \`runtime-state.json\` before answering
2. **ALWAYS** read the current loop stage definition
3. **ALWAYS** validate required artifacts are Approved before proceeding
4. **ALWAYS** save outputs as artifacts with complete frontmatter
5. **ALWAYS** update \`runtime-state.json\` after handoff
6. **ALWAYS** use templates from \`$_dir/templates/\`
7. **ALWAYS** validate artifacts against schemas from \`$_dir/schemas/\`

## Command Protocol Reference

When the user says \`/sdd <command>\`, execute the corresponding protocol:

| Command | Action |
|---------|--------|
| \`/sdd start\` | Initialize loop from 01-requirement |
| \`/sdd next\` | Validate current stage, advance if gate passes |
| \`/sdd approve\` | Mark artifact as Approved, record audit |
| \`/sdd validate\` | Validate artifacts against schemas |
| \`/sdd feedback\` | Create FeedbackArtifact |
| \`/sdd status\` | Display current runtime state |
| \`/sdd audit\` | Display audit log |

See \`$_dir/commands/sdd-command-protocol.md\` for full command specifications.

## Stage-Specific Constraints

### 01-requirement
- **Required Input**: User Requirement (raw)
- **Produced Artifact**: REQ
- **Guard**: REQ must be Approved before exiting this stage

### 02-development
- **Required Input**: REQ (Approved), PS (Approved)
- **Produced Artifacts**: TS, AD, US, TASK, FI, BI
- **Guard**: TS and AD must be Approved before code implementation

### 03-testing
- **Required Input**: FI, BI, TC
- **Produced Artifacts**: TR, QEP
- **Guard**: All test cases must pass before QEP

### 04-release
- **Required Input**: QEP, DRR
- **Produced Artifact**: SDP
- **Guard**: Human approval required for production release

## Violation Response

If you detect a violation of this execution rule:

\`\`\`
[EXECUTION BLOCKED]

Reason: <specific violation>
Current Stage: <stage>
Missing: <list of required items>
Required Action: <corrective action>

Do not proceed until the violation is resolved.
\`\`\`

---

**Remember**: Cursor Rules solve "knowing the rules". Runtime State solves "remembering the progress". Quality Gates solve "enforcing the constraints". Validator solves "preventing violations".
EXECUTION_MDC
}

# -- Generate SPEC-KIT rule (optional) ----------------------------------------
generate_spec_kit_rule() {
    local _dir="$FRAMEWORK_DIR"
    cat > "$RULES_DIR/agent-sdd-spec-kit.mdc" <<SPEC_KIT_MDC
---
description: Agent SDD SPEC-KIT integration — schema validation for all artifact types
version: 1.0
---

# Agent SDD SPEC-KIT Integration

SPEC-KIT validates Agent SDD artifacts against their JSON Schema contracts. This rule wires SPEC-KIT into the Cursor IDE.

## Schema Files

Schema files are located at:

\`\`\`
$_dir/schemas/
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

1. Write or edit an artifact in \`$_dir/artifacts/\`
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
SPEC_KIT_MDC
}

# -- Generate workflows rule (optional) ----------------------------------------
build_workflows_list() {
    local _list
    _list=$(find "$FRAMEWORK_DIR/workflows" -name "*.md" -type f 2>/dev/null | sort) || true
    [ -z "$_list" ] && echo "*(no workflows found)*" && return
    while IFS= read -r _f; do
        [ -z "$_f" ] && continue
        printf "%s\n" "- **$(basename "$_f")**"
    done <<< "$_list"
}

generate_workflows_rule() {
    local _wf_list _dir
    _wf_list=$(build_workflows_list)
    _dir="$FRAMEWORK_DIR"
    cat > "$RULES_DIR/agent-sdd-workflows.mdc" <<WORKFLOWS_MDC
---
description: Agent SDD Workflows — requirement, development, testing, and release workflows
version: 1.0
---

# Agent SDD Workflows

Each workflow represents a complete engineering lifecycle. Workflows are defined in \`$_dir/\`.

## Workflow Definitions

$(printf "%s\n" "$_wf_list")

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
WORKFLOWS_MDC
}

# -- Update CURSOR.md ---------------------------------------------------------
# Pre-computes all dynamic values BEFORE printf so quoted-heredoc is safe.
update_cursor_md() {
    local _spec_kit_rule _workflows_rule _dir
    _spec_kit_rule=""
    _workflows_rule=""
    [ "$ADD_SPEC_KIT"   = true ] && _spec_kit_rule="- [agent-sdd-spec-kit.mdc](.cursor/rules/agent-sdd-spec-kit.mdc) — SPEC-KIT schema validation"
    [ "$ADD_WORKFLOWS" = true ] && _workflows_rule="- [agent-sdd-workflows.mdc](.cursor/rules/agent-sdd-workflows.mdc) — Workflow definitions"
    _dir="$FRAMEWORK_DIR"

    local _marker="<!-- AGENT_SDD_MARKER -->"
    if [ -f CURSOR.md ] && grep -qF "$_marker" CURSOR.md 2>/dev/null; then
        ok "CURSOR.md already has Agent SDD section — skipped (idempotent)."
    else
        # Build the section with all variables already expanded
        {
            printf '%s\n' "# Agent SDD — Cursor IDE Integration"
            printf '\n%s\n\n' "$_marker"
            printf '%s\n' "This project uses the [Agent SDD Framework]($_dir/AGENTS.MD) for AI-driven software delivery."
            printf '\n%s\n' "## Cursor Rules"
            printf '\n%s\n' "Rules are located in [\`.cursor/rules/\`](.cursor/rules/) and loaded automatically by Cursor:"
            printf '%s\n' "- **[AGENTS.mdc](.cursor/rules/AGENTS.mdc)** — Entry point; \`@\`\\-includes all sub-rules"
            printf '%s\n' "- [agent-sdd-overview.mdc](.cursor/rules/agent-sdd-overview.mdc) — Framework overview"
            printf '%s\n' "- [agent-sdd-artifacts.mdc](.cursor/rules/agent-sdd-artifacts.mdc) — Artifact types, schemas, templates"
            printf '%s\n' "- [agent-sdd-lifecycle.mdc](.cursor/rules/agent-sdd-lifecycle.mdc) — Loop stages and state machines"
            printf '%s\n' "- [agent-sdd-agents.mdc](.cursor/rules/agent-sdd-agents.mdc) — Agent roles and responsibilities"
            printf '%s\n' "- [agent-sdd-loop-stages.mdc](.cursor/rules/agent-sdd-loop-stages.mdc) — Five loop stage definitions"
            printf '%s\n' "- [agent-sdd-execution.mdc](.cursor/rules/agent-sdd-execution.mdc) — **MANDATORY** Execution Rule (state checking, guards, commands)"
            [ -n "$_workflows_rule" ] && printf '%s\n' "$_workflows_rule"
            [ -n "$_spec_kit_rule"  ] && printf '%s\n' "$_spec_kit_rule"
            printf '\n%s\n' "## Framework Structure"
            printf '\n%s\n' "\`\`\`"
            printf '%s\n' "$_dir/"
            printf '%s\n' "├── AGENTS.MD              # Full framework specification"
            printf '%s\n' "├── INDEX.md               # Framework index"
            printf '%s\n' "├── agent-sdd.yaml         # Project configuration"
            printf '%s\n' "├── runtime-state.json     # Runtime state (memory)"
            printf '%s\n' "├── loop/                  # Loop stage definitions"
            printf '%s\n' "│   ├── 01-requirement.md"
            printf '%s\n' "│   ├── 02-development.md"
            printf '%s\n' "│   ├── 03-testing.md"
            printf printf '%s\n' "│   ├── 04-release.md"
            printf '%s\n' "├── agents/                # Agent role definitions"
            printf '%s\n' "├── workflows/             # Workflow specifications"
            printf '%s\n' "├── artifacts/             # Artifact instances"
            printf '%s\n' "├── schemas/               # JSON Schema contracts"
            printf '%s\n' "├── templates/             # Markdown templates"
            printf '%s\n' "└── commands/              # SDD command protocols"
            printf '%s\n' "    └── sdd-command-protocol.md"
            printf '%s\n' "\`\`\`"
            printf '\n%s\n' "## Quick Start"
            printf '\n%s\n' "1. **Start a loop**: Open \\\`$_dir/loop/01-requirement.md\\\` and follow the requirement workflow."
            printf '%s\n' "2. **Create an artifact**: Use a template from \\\`$_dir/templates/\\\`."
            printf '%s\n' "3. **Traceability**: Every artifact must declare its parent and children in the frontmatter."
            printf '\n%s\n' "## Commands"
            printf '\n%s\n' "\`\`\`bash"
            printf '%s\n' "# Re-initialize Cursor rules (after framework update)"
            printf '%s\n' "./scripts/agent-sdd-cursor-init.sh --force"
            printf '\n%s\n' "# Add SPEC-KIT integration"
            printf '%s\n' "./scripts/agent-sdd-cursor-init.sh --spec-kit"
            printf '\n%s\n' "# Show all available rules"
            printf '%s\n' "ls -la .cursor/rules/"
            printf '%s\n' "\`\`\`"
        } > CURSOR.md.tmp

        if [ -f CURSOR.md ]; then
            cat CURSOR.md >> CURSOR.md.tmp
        fi
        mv CURSOR.md.tmp CURSOR.md
        ok "CURSOR.md written."
    fi
}

# -- Update agent-sdd.yaml -----------------------------------------------------
update_agent_yaml() {
    local _yaml="$FRAMEWORK_DIR/agent-sdd.yaml"
    if [ -f "$_yaml" ]; then
        if grep -q "^[[:space:]]*cursor:" "$_yaml" 2>/dev/null; then
            sedi "s/^[[:space:]]*cursor:.*/cursor: true/" "$_yaml"
        else
            # awk is more portable than BSD sed 'a' command
            awk '
                /^[[:space:]]*ci_validation:/ { print; print "  cursor: true"; next }
                { print }
            ' "$_yaml" > "$_yaml.tmp" && mv "$_yaml.tmp" "$_yaml"
        fi
        ok "Updated $_yaml → cursor: true"
    fi
}

# ----------------------------------------------------------------------------
# Idempotency sentinel
#
# If .cursor/rules/.sdd-cursor-installed exists and --force is NOT set, we are
# already fully installed.  The script only adds newly requested features
# (--spec-kit, --workflows) without disturbing existing rules.
# With --force the sentinel is removed first for a full regeneration.
# ----------------------------------------------------------------------------
echo "==> Agent SDD — Cursor IDE Integration"
echo "    Framework: $FRAMEWORK_DIR/"
echo "    Mode:      $([ "$FORCE" = true ] && echo "force (overwrite)" || echo "incremental (skip existing)")"

RULES_DIR=".cursor/rules"
SENTINEL="$RULES_DIR/.sdd-cursor-installed"

if ! [ -d "$FRAMEWORK_DIR" ]; then
    err "$FRAMEWORK_DIR/ not found. Run agent-sdd-init.sh first."
    exit 1
fi

for _d in agents loop schemas templates; do
    if ! [ -d "$FRAMEWORK_DIR/$_d" ]; then
        err "$FRAMEWORK_DIR/$_d/ missing. Is $FRAMEWORK_DIR a valid Agent SDD root?"
        exit 1
    fi
done
ok "Framework verified."

if [ "$FORCE" = true ]; then
    if [ -f "$SENTINEL" ]; then
        ok "Removing idempotency sentinel (--force)."
        rm -f "$SENTINEL"
    fi
    if [ -d "$RULES_DIR" ]; then
        _backup="${RULES_DIR}.backup.$(date +%s)"
        mv "$RULES_DIR" "$_backup"
        ok "Existing rules backed up to $_backup"
    fi
fi

if [ -f "$SENTINEL" ] && [ "$FORCE" = false ]; then
    echo "==> Idempotent run: $SENTINEL found, skipping already-installed rules."
    echo "    (use --force to regenerate all rules)"
    echo

    if [ "$ADD_SPEC_KIT" = true ] && [ ! -f "$RULES_DIR/agent-sdd-spec-kit.mdc" ]; then
        echo "==> Adding SPEC-KIT integration (idempotent)..."
        mkdir -p "$RULES_DIR"
        generate_spec_kit_rule
        wire_into_agents_mdc "agent-sdd-spec-kit.mdc"
        ok "SPEC-KIT rule added."
    fi

    if [ "$ADD_WORKFLOWS" = true ] && [ ! -f "$RULES_DIR/agent-sdd-workflows.mdc" ]; then
        echo "==> Adding workflow rules (idempotent)..."
        mkdir -p "$RULES_DIR"
        generate_workflows_rule
        wire_into_agents_mdc "agent-sdd-workflows.mdc"
        ok "Workflow rules added."
    fi

    update_cursor_md
    update_agent_yaml
    echo
    echo "✅ Idempotent update complete — no changes needed."
    exit 0
fi

# ----------------------------------------------------------------------------
# Full installation path (sentinel not found, or --force)
# ----------------------------------------------------------------------------
mkdir -p "$RULES_DIR"

echo "==> Building Cursor rules from framework..."
echo "==> Generating Cursor rules..."

generate_agents_mdc
ok "AGENTS.mdc (entry point)"

generate_overview_rule
ok "agent-sdd-overview.mdc"

generate_artifacts_rule
ok "agent-sdd-artifacts.mdc"

generate_lifecycle_rule
ok "agent-sdd-lifecycle.mdc"

generate_agents_rule
ok "agent-sdd-agents.mdc"

generate_loop_stages_rule
ok "agent-sdd-loop-stages.mdc"

generate_execution_rule
ok "agent-sdd-execution.mdc (MANDATORY — state checking, guards, commands)"

if [ "$ADD_SPEC_KIT" = true ]; then
    generate_spec_kit_rule
    ok "agent-sdd-spec-kit.mdc (SPEC-KIT integration)"
fi

if [ "$ADD_WORKFLOWS" = true ]; then
    generate_workflows_rule
    ok "agent-sdd-workflows.mdc (workflow rules)"
fi

update_cursor_md
update_agent_yaml

touch "$SENTINEL"
ok "Idempotency sentinel written: $SENTINEL"

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------
echo
echo "=============================================="
echo " ✅ Agent SDD Cursor IDE integration done!"
echo "=============================================="
echo
echo "Rules installed:"
find "$RULES_DIR" -name "*.mdc" -type f | sort | while read -r _f; do
    echo "  - $(basename "$_f")"
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
echo "Re-running this script is safe (idempotent). Use --force to regenerate."
echo "Happy delivering!"
