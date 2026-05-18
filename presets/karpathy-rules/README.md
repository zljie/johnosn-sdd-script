# Karpathy Rules Preset

> 自动注入 Andrej Karpathy 的 LLM 编码准则到项目中

## 包含内容

此 preset 会自动将以下规则添加到项目中：

### Cursor Rules
- `.cursor/rules/karpathy-guidelines.mdc` - Karpathy 编码准则

### 内容来源

基于 [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)

## 规则说明

### Think Before Coding
- 不确定时主动提问
- 多个解释存在时，呈现选择而非沉默选择
- 有更简单方案时说出来

### Simplicity First
- 只写解决问题所需的代码
- 不做 speculative 抽象
- 200行能写完就不要写400行

### Surgical Changes
- 只改需要改的地方
- 不"改进"邻近代码
- 每个改动行都要能追溯到用户需求

### Goal-Driven Execution
- 定义可验证的成功标准
- 多步骤任务列出计划
- 用检查点验证每步

## 使用方式

```bash
# 在项目中安装 preset
mkdir -p .specify/presets
cp -r presets/karpathy-rules .specify/presets/
```

## License

MIT (来源仓库许可证)
