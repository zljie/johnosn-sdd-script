---
id: loop.software-delivery-loop
version: 1.0
type: loop
tier_cost: low
---

<!-- TIER 1: CORE -->
# CORE

The **Agent Software Delivery Loop** is the canonical execution model.

## Stages

```text
01-requirement
    │
    ▼
02-development
    │
    ▼
03-testing
    │
    ▼
04-release
```

## Feedback

Any stage may emit `FeedbackArtifact` with `target_stage: 01-requirement`, restarting the loop.

## Entry

`loop/01-requirement.md`

<!-- TIER 2: DEEP -->
# DEEP

## Purpose

Model software delivery as a continuous loop where each release generates customer feedback, which may trigger new requirements, restarting the cycle.

## Stage Transitions

Each stage has:
- **Consumes**: required artifacts entering the stage
- **Produces**: artifacts exiting the stage
- **Quality Gate**: validation checkpoint (PASS → proceed; FAIL → generate feedback, loop restart)
- **Handoff**: pointer to next stage

No stage may bypass its quality gate.

## Feedback Mechanism

Feedback is a first-class artifact:

```yaml
feedback_artifact:
  id: FB-001
  source_stage: 03-testing
  target_stage: 01-requirement
  category: Requirement|Product|Technical|Architecture|Quality
  severity: Critical|High|Medium|Low
  description: structured engineering work
  traceability: ...
```

Feedback never modifies existing artifacts directly — it creates new engineering cycles.

## Runtime Contract

The loop runtime:
1. Evaluates the current stage's quality gate.
2. On PASS, schedules the next stage.
3. On FAIL, emits a `FeedbackArtifact` pointing to `01-requirement`, then terminates current loop execution.
4. On HITL gate, pauses and waits for human approval (recorded as audit event).

## Loop Completion

A loop iteration is complete when `04-release` produces a `SoftwareDeliveryPackage`.

Completion does not imply termination — customer feedback may restart the loop at any time.

## Related

- `AGENTS.MD` — canonical source of truth
- `loop/01-requirement.md` — stage 1
- `loop/02-development.md` — stage 2
- `loop/03-testing.md` — stage 3
- `loop/04-release.md` — stage 4

<!-- TIER 3: REF -->
# REF

## Examples

See each stage file for concrete artifact flows.

## Anti-patterns

- **Skipping quality gates**: invalid — loops enforce gates.
- **Direct artifact modification**: invalid — use feedback artifacts.
- **Ignoring feedback**: invalid — feedback loops are mandatory.
