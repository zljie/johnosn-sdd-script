# johnosn-sdd-script

> johnosn 的 Spec-Driven Development (SDD) 规范库

## 包含内容

### 1. Constitution (核心规范)

`.specify/memory/constitution.md` - 五条核心原则：

| 原则 | 说明 |
|------|------|
| **Result-Oriented** | 结果导向，获得关键信息立即汇报 |
| **No Busy-Wait** | 禁止无效轮询，15秒无进展请求人工介入 |
| **Read Before Act** | 调研先行，禁止盲目操作 |
| **Token Saving** | 上下文精简，超20行日志需筛选 |
| **Skip COT** | 标准运维跳过复杂思维链 |

### 2. 文档模板

| 文件 | 用途 |
|------|------|
| `plan.md` | 敏捷迭代面板模板 |
| `templates/SPEC.md.tmpl` | 系统技术文档模板 |

### 3. 初始化脚本

`scripts/bootstrap.sh` - 一键初始化规范

## 快速开始

### 在新项目中引入规范

```bash
# 克隆仓库
git clone https://github.com/zljie/johnosn-sdd-script.git /tmp/sdd-standards

# 复制规范文件
cp -r /tmp/sdd-standards/.specify .
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
