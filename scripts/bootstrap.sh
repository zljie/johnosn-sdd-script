#!/bin/bash
#
# johnosn SDD 规范快速初始化脚本
# 用法:
#   bash <(curl -sL RAW_URL/bootstrap.sh)
#   curl -sL RAW_URL/bootstrap.sh | bash
#

set -e

STANDARDS_RAW_URL="${STANDARDS_URL:-https://raw.githubusercontent.com/zljie/johnosn-sdd-script/main}"

echo "=========================================="
echo " johnosn SDD 规范快速初始化"
echo "=========================================="
echo ""

PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"

# 1. 检测并初始化 Spec Kit
echo "[1/3] 检查 Spec Kit..."
if command -v uvx &> /dev/null; then
    SPECIFY_VERSION=$(uvx --from git+https://github.com/github/spec-kit.git specify --version 2>/dev/null || echo "not installed")
    echo "  Specify CLI: $SPECIFY_VERSION"
elif command -v specify &> /dev/null; then
    echo "  Specify CLI: $(specify --version)"
else
    echo "  [SKIP] Spec Kit 未安装 (可选)"
fi

# 2. 创建目录结构
echo "[2/3] 创建规范目录..."
mkdir -p .specify/memory

# 3. 下载规范文件
echo "[3/3] 下载规范文件..."

# 下载 Constitution
if curl -sf "${STANDARDS_RAW_URL}/.specify/memory/constitution.md" -o .specify/memory/constitution.md 2>/dev/null; then
    echo "  [OK] constitution.md"
else
    echo "  [FAIL] constitution.md 下载失败"
fi

# 创建 plan.md (如果不存在)
if [ ! -f "plan.md" ]; then
    if curl -sf "${STANDARDS_RAW_URL}/plan.md" -o plan.md 2>/dev/null; then
        echo "  [OK] plan.md"
    fi
fi

# 创建 SPEC.md (如果不存在)
if [ ! -f "SPEC.md" ]; then
    if curl -sf "${STANDARDS_RAW_URL}/templates/SPEC.md.tmpl" -o SPEC.md 2>/dev/null; then
        echo "  [OK] SPEC.md"
    fi
fi

echo ""
echo "=========================================="
echo " 初始化完成!"
echo "=========================================="
echo ""
echo "项目: $PROJECT_NAME"
echo "目录: $PROJECT_DIR"
echo ""
echo "已安装文件:"
[ -f ".specify/memory/constitution.md" ] && echo "  - .specify/memory/constitution.md"
[ -f "plan.md" ] && echo "  - plan.md"
[ -f "SPEC.md" ] && echo "  - SPEC.md"
echo ""
echo "下一步:"
echo "  1. 编辑 SPEC.md 完善技术文档"
echo "  2. 使用 /speckit.constitution 自定义规范"
echo "  3. 开始开发!"
echo ""
