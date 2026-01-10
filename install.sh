#!/bin/bash

# 项目审查顾问 - 安装/更新脚本
# 将审查命令安装到用户的全局 Claude Code 命令目录

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  项目审查顾问 - 安装/更新工具${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 获取脚本所在目录（项目根目录）
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_DIR="$SCRIPT_DIR/.claude/commands/review"

# Claude Code 用户命令目录
CLAUDE_USER_DIR="$HOME/.claude/commands"
TARGET_DIR="$CLAUDE_USER_DIR/review"

# 检查源目录是否存在
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}错误：源目录不存在: $SOURCE_DIR${NC}"
    exit 1
fi

# 统计命令文件数量
CMD_COUNT=$(find "$SOURCE_DIR" -name "*.md" -type f | wc -l)

echo -e "${YELLOW}检测到的审查命令：${NC}"
echo ""
find "$SOURCE_DIR" -name "*.md" -type f | while read file; do
    filename=$(basename "$file")
    cmdname="${filename%.md}"
    echo -e "  ${GREEN}✓${NC} /review:$cmdname"
done
echo ""
echo -e "共 ${GREEN}$CMD_COUNT${NC} 个命令"
echo ""

# 询问用户确认
read -p "是否要安装/更新这些命令到全局目录？(y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}安装已取消${NC}"
    exit 0
fi

# 创建目标目录
echo -e "${BLUE}创建目标目录...${NC}"
mkdir -p "$TARGET_DIR"

# 备份现有命令（如果存在）
if [ -d "$TARGET_DIR" ] && [ "$(ls -A $TARGET_DIR)" ]; then
    BACKUP_DIR="$CLAUDE_USER_DIR/review.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}备份现有命令到: $BACKUP_DIR${NC}"
    cp -r "$TARGET_DIR" "$BACKUP_DIR"
fi

# 复制命令文件
echo -e "${BLUE}复制命令文件...${NC}"
cp -v "$SOURCE_DIR"/*.md "$TARGET_DIR/" 2>/dev/null || {
    echo -e "${YELLOW}注意：某些文件可能已存在，已跳过${NC}"
}

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  安装完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "审查命令已安装到: ${BLUE}$TARGET_DIR${NC}"
echo ""
echo -e "${YELLOW}可用命令：${NC}"
echo ""
echo "  /review:start        - 完整项目审查（Spec-Based Deep Interview）"
echo "  /review:quick        - 快速审查（10-15分钟）"
echo "  /review:report       - 生成审查报告"
echo "  /review:architecture - 架构深度审查"
echo "  /review:security     - 安全专项审查"
echo "  /review:performance  - 性能专项审查"
echo ""
echo -e "${GREEN}现在您可以在任何项目中使用这些命令了！${NC}"
echo ""
echo -e "${YELLOW}提示：${NC}"
echo "  - 在任何项目中输入 /review:start 开始审查"
echo "  - 审查文件会生成在当前项目目录下"
echo "  - 运行此脚本可更新到最新版本"
echo ""
