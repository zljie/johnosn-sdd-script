# Agent SDD Command Protocol

> **Version**: 1.0.0
> **Type**: Command Protocol
> **Scope**: Human-Agent interaction interface for Agent SDD Framework

---

## Overview

This protocol defines the standard commands for interacting with the Agent SDD framework. Commands provide a structured interface for starting, advancing, and governing the Software Delivery Loop.

## Command Syntax

All SDD commands use the `/sdd` prefix followed by the command name:

```
/sdd <command> [options]
```

---

## Command Reference

### `/sdd start`

**Purpose**: Initialize or resume a Software Delivery Loop.

**Syntax**:
```
/sdd start [--loop-id <id>] [--stage <stage>]
```

**Behavior**:
1. If no `runtime-state.json` exists, create a new loop (`LOOP-001`)
2. If `runtime-state.json` exists and status is not `completed`, resume from current state
3. If `runtime-state.json` exists and status is `completed`, prompt for new loop
4. Set `current.loop_stage` to `01-requirement` (default) or specified stage
5. Update `meta.created_at` and `meta.started_by`
6. Load the corresponding loop stage definition file

**Quality Gate**:
- None (start command initializes the loop)

**Example**:
```
/sdd start
/sdd start --stage 02-development
/sdd start --loop-id LOOP-002
```

---

### `/sdd next`

**Purpose**: Advance to the next stage after validating the current stage's quality gate.

**Syntax**:
```
/sdd next [--force]
```

**Behavior**:
1. Read `runtime-state.json` to identify current stage
2. Load the current stage's quality gate definition
3. Validate:
   - Required artifacts exist and are in correct status
   - Traceability links are complete
   - Artifact schemas are satisfied
4. If validation PASSES:
   - Mark current artifact as `Approved` if not already
   - Update `gates.last_gate_result` to `PASS`
   - Advance `current.loop_stage` to next stage
   - Update `artifacts.approved` list
   - Add audit log entry
5. If validation FAILS:
   - Update `gates.last_gate_result` to `FAIL`
   - Stop execution
   - Report missing artifacts / invalid state
   - Suggest corrective actions
6. If `--force` is used, skip quality gate validation (requires human override confirmation)

**Quality Gate**:
- Current stage's gate must PASS (unless `--force`)

**Example**:
```
/sdd next
/sdd next --force  # Skip quality gate (requires HITL approval)
```

---

### `/sdd approve`

**Purpose**: Mark the current artifact as human-approved and create an audit record.

**Syntax**:
```
/sdd approve [--artifact <id>] [--comment <text>]
```

**Behavior**:
1. If `--artifact` is specified, approve that artifact
2. Otherwise, approve the `current.artifact_id`
3. Validate the artifact exists and is in `Ready` status
4. Update artifact frontmatter:
   - Set `status` to `Approved`
   - Add `approved_at` timestamp
   - Add `approved_by` (human approver identity)
5. Add artifact to `artifacts.approved` list in `runtime-state.json`
6. Move from `approvals.pending` to `approvals.completed`
7. Create audit log entry with:
   - `action: APPROVED`
   - `artifact_id`
   - `approver`
   - `timestamp`
   - `comment` (if provided)

**Quality Gate**:
- Artifact must exist and be in `Ready` status

**Example**:
```
/sdd approve
/sdd approve --artifact REQ-001
/sdd approve --artifact PS-001 --comment "Product spec looks good"
```

---

### `/sdd validate`

**Purpose**: Validate current artifacts against their JSON schemas.

**Syntax**:
```
/sdd validate [--artifact <id>] [--all]
```

**Behavior**:
1. If `--artifact` is specified, validate that artifact only
2. If `--all` is specified, validate all artifacts in the current loop
3. Otherwise, validate the current artifact only
4. For each artifact:
   - Read the artifact file
   - Extract frontmatter
   - Load corresponding schema from `schemas/`
   - Validate against schema
   - Report validation errors (if any)
5. Report overall validation status

**Quality Gate**:
- None (validate is read-only)

**Example**:
```
/sdd validate
/sdd validate --artifact REQ-001
/sdd validate --all
```

---

### `/sdd feedback`

**Purpose**: Create structured feedback that triggers a new engineering cycle.

**Syntax**:
```
/sdd feedback --category <category> --severity <severity> --description <text> [--target <stage>]
```

**Behavior**:
1. Create a `FeedbackArtifact` with:
   - Unique ID (FB-###)
   - `source_stage`: current stage
   - `target_stage`: specified stage (default: `01-requirement`)
   - `category`: Requirement | Product | Technical | Architecture | Quality | Implementation
   - `severity`: Critical | High | Medium | Low
   - `description`: structured description of the issue
   - `created_at`: timestamp
2. Save feedback artifact to `artifacts/feedback/FB-###.md`
3. Update `runtime-state.json`:
   - If target is `01-requirement`, increment `meta.loop_count`
   - Add feedback to traceability chain
4. Create audit log entry

**Quality Gate**:
- None (feedback can be created at any time)

**Example**:
```
/sdd feedback --category Technical --severity High --description "API endpoint naming is inconsistent"
/sdd feedback --category Requirement --severity Critical --target 01-requirement --description "Missing payment validation requirements"
```

---

### `/sdd status`

**Purpose**: Display the current state of the Software Delivery Loop.

**Syntax**:
```
/sdd status [--json]
```

**Behavior**:
1. Read `runtime-state.json`
2. Display:
   - Current loop and stage
   - Current agent role
   - Artifact status
   - Required vs produced artifacts
   - Last gate result
   - Pending approvals
3. If `--json` is specified, output raw JSON

**Quality Gate**:
- None (status is read-only)

**Example**:
```
/sdd status
/sdd status --json
```

---

### `/sdd audit`

**Purpose**: Display the audit log for the current loop.

**Syntax**:
```
/sdd audit [--limit <n>] [--action <type>]
```

**Behavior**:
1. Read `audit_log` from `runtime-state.json`
2. Display entries in reverse chronological order
3. Filter by action type if specified
4. Limit output if `--limit` is specified

**Quality Gate**:
- None (audit is read-only)

**Example**:
```
/sdd audit
/sdd audit --limit 10
/sdd audit --action APPROVED
```

---

## Command Flow Diagram

```
User Command
     │
     ▼
┌─────────────────────────┐
│ Parse /sdd <command>    │
└────────────┬────────────┘
             │
     ┌───────┴────────┐
     │                 │
     ▼                 ▼
┌─────────┐      ┌──────────┐
│ Read    │      │ Validate │
│ State   │      │ Command  │
└────┬────┘      └────┬─────┘
     │                 │
     └───────┬─────────┘
             │
             ▼
┌─────────────────────────┐
│ Execute Command Logic   │
│ - Update State          │
│ - Validate Gate         │
│ - Create Artifacts      │
│ - Record Audit          │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Write runtime-state.json│
└────────────┬────────────┘
             │
             ▼
       Command Result
```

---

## State Transitions

| Current Stage | Next Stage | Gate Required |
|--------------|------------|---------------|
| `01-requirement` | `02-development` | Requirement Review (HITL) |
| `02-development` | `03-testing` | Development Gate |
| `03-testing` | `04-release` | Testing Gate |
| `04-release` | `completed` | Release Gate (HITL) |

---

## Error Handling

| Error | Response |
|-------|----------|
| Missing `runtime-state.json` | Create new state with `/sdd start` |
| Missing required artifact | Stop and report: "Cannot proceed. Missing: <list>" |
| Artifact not approved | Stop and report: "Artifact <id> must be Approved before proceeding" |
| Quality gate failed | Stop and report: "Gate failed. Correct issues and retry `/sdd next`" |
| Invalid command | Report usage and available commands |
| Invalid stage | Report valid stages and current stage |

---

## Audit Log Entry Schema

Each audit log entry contains:

```yaml
{
  "id": "AUDIT-###",
  "timestamp": "ISO-8601",
  "action": "STARTED | ADVANCED | APPROVED | VALIDATED | FEEDBACK_CREATED | STATE_UPDATED",
  "actor": "human | <agent-role>",
  "artifact_id": "<id or null>",
  "stage": "<current-stage>",
  "details": {
    "previous_state": "<if applicable>",
    "new_state": "<if applicable>",
    "comment": "<if applicable>"
  }
}
```

---

## Related Files

- `runtime-state.json` — Current runtime state
- `loop/*.md` — Stage definitions with quality gates
- `schemas/*.schema.yaml` — Artifact validation schemas
- `scripts/agent-sdd-validate.sh` — CLI validation tool
