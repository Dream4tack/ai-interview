#!/bin/bash

# 项目审查顾问 - 卸载脚本
# 从用户的全局 Claude Code 命令目录中移除审查命令

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  项目审查顾问 - 卸载工具${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Claude Code 用户命令目录
CLAUDE_USER_DIR="$HOME/.claude/commands"
TARGET_DIR="$CLAUDE_USER_DIR/review"

# 检查是否已安装
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}未检测到已安装的审查命令${NC}"
    echo "目录不存在: $TARGET_DIR"
    exit 0
fi

# 显示将要删除的命令
echo -e "${YELLOW}将要删除的审查命令：${NC}"
echo ""
find "$TARGET_DIR" -name "*.md" -type f | while read file; do
    filename=$(basename "$file")
    cmdname="${filename%.md}"
    echo -e "  ${RED}✗${NC} /review:$cmdname"
done
echo ""

# 询问用户确认
read -p "确定要卸载这些命令吗？(y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}卸载已取消${NC}"
    exit 0
fi

# 备份后删除
BACKUP_DIR="$CLAUDE_USER_DIR/review.backup.$(date +%Y%m%d_%H%M%S)"
echo -e "${BLUE}备份命令到: $BACKUP_DIR${NC}"
mv "$TARGET_DIR" "$BACKUP_DIR"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  卸载完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "审查命令已从全局目录中移除"
echo -e "备份位于: ${BLUE}$BACKUP_DIR${NC}"
echo ""
echo -e "${YELLOW}如果需要恢复，可以运行：${NC}"
echo "  mv $BACKUP_DIR $TARGET_DIR"
echo ""
