---
id: artifact.test-report
version: 1.0
loop_stage: 03-testing
tier_cost: medium
---

<!-- TIER 1: CORE -->

Version: 1.0

Status: Draft

Artifact ID: TR

---

# 1. Purpose

The Test Report (TR) records the execution results of one or more approved Test Cases.

It provides objective evidence of software behavior during test execution.

The Test Report is an execution artifact.

It does not redefine test requirements or expected behavior.

Its purpose is to document what actually happened during execution.

The Test Report serves as one of the primary evidence sources for the Quality Evidence Package (QEP).

---

# 2. Ownership

| Stage | Owner |
|--------|-------|
| Produce | Tester Agent |
| Review | Reviewer Agent |
| Consume | Quality Evidence Package |

The Test Report is owned by the Tester Agent.

---

# 3. Lifecycle

```text
Draft

↓

Executing

↓

Completed

↓

Reviewed

↓

Archived
```

Each execution generates a new Test Report.

Previous execution reports are preserved.

---

# 4. Objectives

The Test Report records:

- Executed Test Cases
- Execution Results
- Test Evidence
- Defects Found
- Environment Information
- Execution Metrics

The Test Report answers one question:

> What happened when the software was tested?

---

# 5. Artifact Structure

```text
Test Report

├── Execution Summary

├── Test Environment

├── Executed Test Cases

├── Execution Results

├── Evidence

├── Defects

├── Metrics

├── Traceability

└── Version
```

---

# 6. Execution Summary

The summary contains:

- Report ID
- Execution Date
- Tester
- Environment
- Overall Result

Example

```yaml
execution:

  id:

  executedBy:

  executedAt:

  environment:

  result:
```

---

# 7. Test Environment

Document the execution environment.

Examples

- Development
- Integration
- UAT
- Staging
- Production Verification

Environment details may include:

- Application Version
- API Version
- Database Version
- Browser
- Operating System

Execution environments shall be reproducible.

---

# 8. Executed Test Cases

List all executed Test Cases.

Example

| Test Case | Result |
|-----------|--------|
| TC-001 | PASS |
| TC-002 | PASS |
| TC-003 | FAIL |

Each execution shall reference the approved Test Case version.

---

# 9. Execution Results

Each execution result shall include:

- Status
- Duration
- Timestamp
- Executor
- Comments

Allowed statuses:

- PASS
- FAIL
- BLOCKED
- SKIPPED

Execution results are immutable.

---

# 10. Evidence

Every execution shall produce objective evidence.

Examples include:

- Screenshots
- Logs
- API Responses
- Console Output
- Trace IDs
- Performance Results
- Security Reports

Evidence shall be stored and referenced.

The Test Report records evidence metadata rather than embedding large files.

---

# 11. Defects

All defects discovered during execution shall be documented.

Example

| Defect | Severity | Status |
|---------|----------|--------|
| BUG-001 | High | Open |
| BUG-002 | Medium | Fixed |

Each defect shall reference the corresponding Test Case.

---

# 12. Metrics

The report shall summarize execution metrics.

Examples

| Metric | Value |
|---------|------|
| Executed Tests | 150 |
| Passed | 147 |
| Failed | 3 |
| Pass Rate | 98% |
| Average Duration | 4.3 s |

Metrics shall be automatically generated whenever possible.

---

# 13. Traceability

Every Test Report shall reference:

```text
Requirement

↓

Product Specification

↓

Architecture Design

↓

Test Case

↓

Test Report
```

Execution evidence shall remain traceable.

---

# 14. Runtime Contract

```yaml
artifact:

  id: TR

  owner:

    Tester Agent

  consumes:

    - Approved Test Cases

    - Build Artifact

    - Deployment Environment

  produces:

    - Execution Evidence

    - Defect Records

    - Quality Evidence Package

  validates:

    - Test Execution

    - Result Consistency

    - Evidence Integrity
```

---

# 15. Quality Rules

Every Test Report shall be:

- Objective
- Repeatable
- Traceable
- Auditable
- Versioned
- Evidence-Based

Subjective conclusions are not permitted.

The report records observations, not opinions.

---

# 16. Definition of Done

A Test Report is complete when:

- Execution Summary is completed.
- Test Environment is documented.
- All executed Test Cases are recorded.
- Execution Results are complete.
- Evidence has been collected.
- Defects have been linked.
- Metrics have been generated.
- Traceability is complete.
- Reviewer validation has passed.

Only completed Test Reports may be included in a Quality Evidence Package.