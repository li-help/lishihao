#!/bin/bash
# ============================================
# Git 完整流程脚本
# 步骤: init → ignore → first commit → dev branch → merge master → push
# ============================================

set -e

REMOTE_URL="${1:-}"  # 可选: 传入远程仓库URL

echo "========================================"
echo "  Git 完整流程脚本"
echo "========================================"

# ---- 1. 初始化仓库 ----
echo "[1/8] 初始化 Git 仓库..."
if [ -d ".git" ]; then
    echo "   .git 已存在，跳过 init"
else
    git init
    echo "   ✅ git init 完成"
fi

# ---- 2. 添加 .gitignore ----
echo "[2/8] 确认 .gitignore..."
if [ -f ".gitignore" ]; then
    echo "   ✅ .gitignore 已存在"
else
    echo "   ⚠️  .gitignore 不存在！"
    exit 1
fi

# ---- 3. 初次提交（SDD 文档套件） ----
echo "[3/8] 初次提交 SDD 文档..."
git add .gitignore
git add doc/
git add sdd/
git add sql/
git add deploy/
git commit -m "init: SDD文档套件 + SQL建表 + 部署脚本" || echo "   (无可提交变更或已提交)"

# ---- 4. 提交后端代码 ----
echo "[4/8] 提交后端代码..."
git add backend/
git commit -m "feat: Spring Boot后端 — 4个REST接口 + JPA实体" || echo "   (无可提交变更)"

# ---- 5. 提交前端代码 ----
echo "[5/8] 提交前端代码..."
git add frontend/
git commit -m "feat: Flutter前端 — 首页+个人中心 + Provider状态管理" || echo "   (无可提交变更)"

# ---- 6. 创建 dev 分支 ----
echo "[6/8] 创建 dev 分支..."
if git show-ref --verify --quiet refs/heads/dev; then
    echo "   dev 分支已存在，跳过"
    git checkout dev
else
    git checkout -b dev
    echo "   ✅ 已创建并切换到 dev 分支"
fi

# ---- 7. 合并到 master ----
echo "[7/8] 合并 dev → master..."
git checkout master 2>/dev/null || git checkout -b master
git merge dev --no-ff -m "merge: dev分支合并到master — v1.0发布"

# 打标签
git tag -a "v1.0" -m "v1.0 — 首页+个人中心 完整功能发布"

# ---- 8. 推送远程 ----
echo "[8/8] 推送到远程仓库..."
if [ -n "${REMOTE_URL}" ]; then
    git remote add origin "${REMOTE_URL}" 2>/dev/null || git remote set-url origin "${REMOTE_URL}"
    git push -u origin master --tags
    git push -u origin dev
    echo "   ✅ 已推送到 ${REMOTE_URL}"
else
    echo "   ℹ️  未提供远程仓库URL，跳过推送"
    echo "   用法: ./git-init.sh git@github.com:user/repo.git"
fi

# ---- 完成 ----
echo ""
echo "========================================"
echo "  ✅ Git 流程完成！"
echo "========================================"
echo ""
echo "  分支状态:"
git branch -v
echo ""
echo "  提交历史:"
git log --oneline --graph --all -10
echo ""
echo "  标签:"
git tag -l
echo ""
