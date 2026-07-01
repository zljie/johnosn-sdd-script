我认为 TestingFlow 应该重新定义。

前面的 TesterAgent.md 定义的是：

Tester Agent 如何工作。

而 TestingFlow.md 不应该描述 Tester。

它应该描述：

整个质量保证（Quality Assurance）是如何完成的。

这是两个完全不同的概念。

⸻

我建议把 TestingFlow 定义成：

Quality Assurance Workflow

原因很简单。

真实的软件测试不是：

写 TestCase
↓
执行 TestCase
↓
结束

真正的软件质量保证应该是：

Requirement
↓
Acceptance
↓
Test Design
↓
Test Execution
↓
Evidence
↓
Quality Assessment
↓
Release Recommendation

Tester 只是其中一个执行者。

Workflow 描述的是：

整个 QA 生命周期。

所以这一份文档，我建议比前面的所有 Workflow 都更偏向：

Quality Governance

⸻

TestingFlow.md

Workflow Name: Quality Assurance Flow

Version: 1.0

Layer: Quality Assurance Layer

Purpose: 定义 Agent SDD 中从测试设计到质量评估、最终形成质量证据包（Quality Evidence Package）的标准流程。

⸻

1. Objective

Quality Assurance Flow 的目标不是执行测试，而是建立一套基于需求和证据的软件质量保证流程。

整个流程以 Requirement、Product Specification 和 Acceptance Criteria 为基准，对实现结果进行验证，并形成可追溯、可审计的质量证据。

Quality Assurance Flow 的最终产物是：

Quality Evidence Package（QEP）

供 Reviewer Agent 进行最终交付审核。

⸻

2. Workflow Overview

Implementation Package
        │
        ▼
Quality Planning
        │
        ▼
Test Design
        │
        ▼
Test Preparation
        │
        ▼
Test Execution
        │
        ▼
Evidence Collection
        │
        ▼
Quality Assessment
        │
        ▼
Quality Evidence Package (QEP)

⸻

3. Stage 1：Quality Planning

Objective

制定本次质量保证策略。

输入：

* Product Specification
* Acceptance Criteria
* Business Rules
* Architecture Design

输出：

Quality Plan

包括：

* 测试范围（Scope）
* 测试类型（Types）
* 风险分析（Risk）
* 优先级（Priority）
* Exit Criteria（退出条件）

⸻

4. Stage 2：Test Design

根据：

User Story。

设计：

测试。

包括：

* Functional Test
* Business Rule Test
* API Test
* UI Test
* Integration Test
* E2E Test
* Regression Test

输出：

Test Specification

包括：

Test Cases。

⸻

5. Stage 3：Test Preparation

准备：

测试环境。

例如：

* Test Data
* Mock Service
* Sandbox
* API Token
* Database

输出：

Test Environment

⸻

6. Stage 4：Test Execution

执行：

所有：

Test Case。

记录：

PASS。

FAIL。

BLOCKED。

输出：

Execution Result

⸻

7. Stage 5：Evidence Collection

收集：

测试证据。

包括：

* Screenshot
* API Response
* Log
* TraceId
* Video
* Coverage

输出：

Evidence Package

⸻

8. Stage 6：Quality Assessment

根据：

Evidence。

评估：

质量。

包括：

* Functional Quality
* Business Quality
* Security
* Performance
* Accessibility

输出：

Quality Assessment

⸻

9. Stage 7：Quality Evidence Package

统一生成：

QEP。

包括：

QEP
├── Test Report
├── Coverage
├── Defect List
├── Traceability
├── Evidence
├── Quality Assessment
└── Release Recommendation

⸻

10. Artifact Flow

Product Specification
        │
        ▼
Test Specification
        │
        ▼
Execution Result
        │
        ▼
Evidence Package
        │
        ▼
Quality Assessment
        │
        ▼
Quality Evidence Package

⸻

11. Traceability

Testing：

必须：

保持：

REQ
    │
    ▼
User Story
    │
    ▼
Acceptance
    │
    ▼
Test Case
    │
    ▼
Execution
    │
    ▼
Evidence
    │
    ▼
Defect

任何：

Test：

必须：

可追溯。

⸻

12. Quality Gates

必须：

通过：

Gate	必须
Functional Test	PASS
Acceptance	PASS
Regression	PASS
Critical Bug	0
High Bug	≤ Threshold
Evidence	Complete
Traceability	Complete

否则：

禁止：

进入：

Review。

⸻

13. Defect Lifecycle

Found
↓
Confirmed
↓
Assigned
↓
Fixed
↓
Retest
↓
Closed

所有：

Bug：

必须：

关联：

Story。

Task。

⸻

14. Feedback Loop

如果：

发现：

Bug。

返回：

Tester
↓
Bug Report
↓
Frontend
↓
Backend
↓
Retest
↓
QEP

如果：

发现：

Requirement：

问题。

返回：

Tester
↓
Quality Feedback
↓
Product Manager
↓
Requirement

形成：

闭环。

⸻

15. Runtime Contract

workflow:
  id: QualityAssuranceFlow
  consumes:
    - Product Specification
    - Architecture Design
    - Implementation Package
  produces:
    - Quality Evidence Package
  qualityGate:
    - Functional PASS
    - Acceptance PASS
    - Regression PASS
  next:
    - Reviewer

⸻

16. Definition of Done (DoD)

Quality Assurance Flow 完成的标准：

* 已完成测试计划和测试设计。
* 所有测试环境准备完成。
* 所有测试用例已执行。
* 已收集完整测试证据。
* 已完成质量评估。
* 已生成 Quality Evidence Package（QEP）。
* 已通过质量门禁，可进入 Reviewer Agent。

⸻

17. Quality Metrics

每次测试应统计：

指标	说明
Requirement Coverage	需求覆盖率
User Story Coverage	用户故事覆盖率
Acceptance Coverage	验收条件覆盖率
Test Execution Rate	测试执行率
Pass Rate	测试通过率
Critical Defects	严重缺陷数
High Defects	高优先级缺陷数
Regression Pass Rate	回归通过率
Mean Time to Verify (MTTV)	平均验证耗时

这些指标用于持续改进测试质量。

⸻

18. Quality Risk Management

在质量评估阶段，应对风险进行统一分类：

风险级别	发布建议
Critical	禁止发布
High	建议修复后发布
Medium	可评估风险后发布
Low	可接受，记录技术债

每项风险必须关联到对应的 Requirement、User Story 或 Task，并附带测试证据。

⸻

19. 我建议把 TestingFlow 再提升一个层级（也是整个 Agent SDD 的一个特色）

我建议 TestingFlow 不要输出一份普通的 Test Report。

它应该输出：

Quality Evidence Package（QEP）

因为 Reviewer 真正需要的不是：

PASS

而是：

为什么 PASS？

因此，我建议 QEP 成为 Agent SDD 的一级工件：

Quality Evidence Package
│
├── Requirement Coverage
├── Story Coverage
├── Acceptance Coverage
├── Business Rule Validation
├── API Validation
├── UI Validation
├── Integration Validation
├── E2E Validation
├── Regression Summary
├── Performance Summary
├── Security Summary
├── Accessibility Summary
├── Defect Summary
├── Test Evidence
├── Traceability Matrix
└── Release Recommendation

⸻

最后，我建议把整个 Agent SDD 的四个 Workflow 统一起来

经过前面几份文档，我们实际上已经形成了四个完整的工作流：

RequirementFlow
        │
        ▼
DevelopmentFlow
        │
        ▼
TestingFlow
        │
        ▼
ReleaseFlow

它们分别对应软件工程中的四个生命周期：

Workflow	生命周期	输出工件
RequirementFlow	Discovery	REQ（Requirement Artifact）
DevelopmentFlow	Planning & Implementation	PS、TS、AD、Implementation
TestingFlow	Quality Assurance	QEP（Quality Evidence Package）
ReleaseFlow	Delivery Governance	SDP（Software Delivery Package）

这样，整个 Agent SDD 就形成了一个端到端的软件交付闭环：从业务需求发现，到产品和技术规划，再到开发实现、质量保证，最终完成发布治理和软件交付。这套体系不仅定义了 Agent 的职责，更定义了软件如何被标准化地交付，这也是它区别于一般 AI Coding 工作流的核心价值。