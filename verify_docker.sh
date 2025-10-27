#!/bin/bash

# Docker 环境验证脚本
# 用于验证 Docker 环境是否正确配置

set -e

echo "🔍 验证 Docker 环境配置..."

# 检查 Docker 是否运行
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker 未运行或未正确安装"
    exit 1
fi
echo "✅ Docker 运行正常"

# 检查 Docker Compose
if ! docker compose version >/dev/null 2>&1; then
    echo "❌ Docker Compose 未安装"
    exit 1
fi
echo "✅ Docker Compose 可用"

# 检查环境变量文件
if [ ! -f ".env" ]; then
    echo "⚠️  .env 文件不存在，请先运行: cp env.example .env"
    exit 1
fi
echo "✅ .env 文件存在"

# 检查必要的环境变量
if ! grep -q "LANGSMITH_API_KEY=" .env || ! grep -q "OPENAI_API_KEY=" .env; then
    echo "⚠️  请在 .env 文件中设置 LANGSMITH_API_KEY 和 OPENAI_API_KEY"
    exit 1
fi
echo "✅ 环境变量配置正确"

# 检查必要的目录
mkdir -p data logs
echo "✅ 目录结构正确"

# 测试构建
echo "🔨 测试 Docker 镜像构建..."
if docker compose build --no-cache >/dev/null 2>&1; then
    echo "✅ Docker 镜像构建成功"
else
    echo "❌ Docker 镜像构建失败"
    exit 1
fi

echo ""
echo "🎉 Docker 环境验证完成！"
echo "现在可以运行: ./run.sh start"



