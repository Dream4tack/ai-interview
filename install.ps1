# 项目审查顾问 - 安装/更新脚本 (Windows PowerShell)
# 将审查命令安装到用户的全局 Claude Code 命令目录

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Blue
Write-Host "  项目审查顾问 - 安装/更新工具" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# 获取脚本所在目录（项目根目录）
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir = Join-Path $ScriptDir ".claude\commands\review"

# Claude Code 用户命令目录
$ClaudeUserDir = Join-Path $env:USERPROFILE ".claude\commands"
$TargetDir = Join-Path $ClaudeUserDir "review"

# 检查源目录是否存在
if (-Not (Test-Path $SourceDir)) {
    Write-Host "错误：源目录不存在: $SourceDir" -ForegroundColor Red
    exit 1
}

# 统计命令文件数量
$CmdFiles = Get-ChildItem -Path $SourceDir -Filter "*.md" -File
$CmdCount = $CmdFiles.Count

Write-Host "检测到的审查命令：" -ForegroundColor Yellow
Write-Host ""

foreach ($file in $CmdFiles) {
    $cmdname = $file.BaseName
    Write-Host "  ✓ /review:$cmdname" -ForegroundColor Green
}

Write-Host ""
Write-Host "共 $CmdCount 个命令" -ForegroundColor Green
Write-Host ""

# 询问用户确认
$confirmation = Read-Host "是否要安装/更新这些命令到全局目录？(y/n)"
if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
    Write-Host "安装已取消" -ForegroundColor Yellow
    exit 0
}

# 创建目标目录
Write-Host "创建目标目录..." -ForegroundColor Blue
if (-Not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

# 备份现有命令（如果存在）
if (Test-Path $TargetDir) {
    $existingFiles = Get-ChildItem -Path $TargetDir -File
    if ($existingFiles.Count -gt 0) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $BackupDir = Join-Path $ClaudeUserDir "review.backup.$timestamp"
        Write-Host "备份现有命令到: $BackupDir" -ForegroundColor Yellow
        Copy-Item -Path $TargetDir -Destination $BackupDir -Recurse -Force
    }
}

# 复制命令文件
Write-Host "复制命令文件..." -ForegroundColor Blue
Copy-Item -Path "$SourceDir\*.md" -Destination $TargetDir -Force -Verbose

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  安装完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "审查命令已安装到: " -NoNewline
Write-Host $TargetDir -ForegroundColor Blue
Write-Host ""
Write-Host "可用命令：" -ForegroundColor Yellow
Write-Host ""
Write-Host "  /review:start        - 完整项目审查（Spec-Based Deep Interview）"
Write-Host "  /review:quick        - 快速审查（10-15分钟）"
Write-Host "  /review:report       - 生成审查报告"
Write-Host "  /review:architecture - 架构深度审查"
Write-Host "  /review:security     - 安全专项审查"
Write-Host "  /review:performance  - 性能专项审查"
Write-Host ""
Write-Host "现在您可以在任何项目中使用这些命令了！" -ForegroundColor Green
Write-Host ""
Write-Host "提示：" -ForegroundColor Yellow
Write-Host "  - 在任何项目中输入 /review:start 开始审查"
Write-Host "  - 审查文件会生成在当前项目目录下"
Write-Host "  - 运行此脚本可更新到最新版本"
Write-Host ""
