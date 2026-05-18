# Preset Publishing Guide

## 创建新 Preset

1. 在 `presets/` 目录下创建 preset 文件夹
2. 包含必要文件：
   - `preset.yml` - preset 元数据
   - `README.md` - 说明文档
   - 模板文件（如规则文件）

## Preset 结构

```
presets/
└── my-preset/
    ├── preset.yml      # 必需：元数据
    ├── README.md       # 必需：说明
    └── templates/      # 可选：模板文件
        ├── template1.md
        └── template2.md
```

## preset.yml 格式

```yaml
name: my-preset
version: 1.0.0
description: My preset description
author: your-name
license: MIT

# 要安装的文件
files:
  - source: rules/my-rules.md
    target: .cursor/rules/my-rules.mdc
  - source: templates/custom-template.md
    target: .specify/templates/custom-template.md
```

## 发布 Preset

Preset 会被包含在仓库中，用户可以通过：

```bash
# 方式 1: 手动复制
cp -r presets/my-preset ~/.specify/presets/

# 方式 2: 链接到项目
ln -s /path/to/presets/my-preset .specify/presets/my-preset
```

## 已有 Presets

| Preset | 说明 |
|--------|------|
| `karpathy-rules` | 自动注入 Karpathy 编码准则 |
