# johnosn-sdd-script

> johnosn 的 Spec-Driven Development (SDD) 规范库

## 包含内容

### 1. Constitution (核心规范)

`.specify/memory/constitution.md` - 核心宪章，包含两大纪律：

**纪律一：高效率运维准则**
| 原则 | 说明 |
|------|------|
| **Result-Oriented** | 结果导向，获得关键信息立即汇报 |
| **No Busy-Wait** | 禁止无效轮询，15秒无进展请求人工介入 |
| **Read Before Act** | 调研先行，禁止盲目操作 |
| **Token Saving** | 上下文精简，超20行日志需筛选 |
| **Skip COT** | 标准运维跳过复杂思维链 |

**纪律二：Harness 复用规范**
| 原则 | 说明 |
|------|------|
| **Search for Similar** | 编码前必须搜索相似实现并引用 |
| **Reuse First** | 已有组件优先复用，不得重复造轮子 |
| **Copy & Adapt** | 新建文件必须复制最相似文件后修改 |

### 2. 文档模板

| 文件 | 用途 |
|------|------|
| `plan.md` | 敏捷迭代面板模板 |
| `templates/SPEC.md.tmpl` | 系统技术文档模板 |

### 3. Cursor Agent Rules

`.cursor/rules/harness-reuse.mdc` - Cursor Agent 规则文件，确保 Agent 在每次响应时遵守 Harness 复用原则。与 `/speckit.plan` 和 `/speckit.implement` 阶段无缝集成。

### 4. 初始化脚本

`scripts/bootstrap.sh` - 一键初始化规范

## 快速开始

### 在新项目中引入规范

```bash
# 克隆仓库
git clone https://github.com/zljie/johnosn-sdd-script.git /tmp/sdd-standards

# 复制规范文件（包含 Cursor 规则）
cp -r /tmp/sdd-standards/.specify .
cp -r /tmp/sdd-standards/.cursor .
cp /tmp/sdd-standards/plan.md .
cp /tmp/sdd-standards/templates/SPEC.md.tmpl SPEC.md
```

或使用 bootstrap 脚本：

```bash
curl -sL https://raw.githubusercontent.com/zljie/johnosn-sdd-script/main/scripts/bootstrap.sh | bash
```

## 与 Spec Kit 集成

与 [github/spec-kit](https://github.com/github/spec-kit) 无缝集成：

```bash
# 安装 Specify CLI (需要 uv)
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# 初始化项目
specify init . --integration cursor-agent

# 使用规范命令
/speckit.constitution  # 项目原则
/speckit.specify      # 定义需求
/speckit.plan         # 技术方案
/speckit.tasks        # 拆分任务
/speckit.implement    # 执行实现
```

## 规范版本

- **Version**: 1.0
- **Created**: 2026-05-18
- **Author**: johnosn

## License

MIT
