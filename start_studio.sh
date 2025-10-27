#!/bin/bash
# LangGraph Studio 手动启动脚本
# 如果 Docker 镜像拉取失败，可以使用这个脚本在容器内手动启动 LangGraph Studio

echo "🔧 在 email-assistant 容器内启动 LangGraph Studio..."
echo "📝 注意：这需要在容器内安装 LangGraph Studio"

# 进入容器
docker exec -it agents-from-scratch sh -c "
    # 安装 LangGraph Studio（如果需要）
    if ! command -v langgraph-studio &> /dev/null; then
        echo '安装 LangGraph Studio...'
        pip install langgraph-studio
    fi
    
    # 启动 LangGraph Studio
    echo '🚀 启动 LangGraph Studio on http://0.0.0.0:8000...'
    langgraph-studio --port 8000 --host 0.0.0.0
"

echo "✅ LangGraph Studio 已在 http://localhost:8000 启动"
