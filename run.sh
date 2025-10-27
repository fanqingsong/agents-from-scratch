#!/bin/bash

# Agents From Scratch - Docker 一键运行脚本
# 作者: AI Assistant
# 版本: 1.0

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# 检查 Docker 是否安装
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_message $RED "错误: Docker 未安装。请先安装 Docker。"
        exit 1
    fi
    
    if ! command -v docker compose &> /dev/null; then
        print_message $RED "错误: Docker Compose 未安装。请先安装 Docker Compose。"
        exit 1
    fi
}

# 检查环境变量文件
check_env() {
    if [ ! -f ".env" ]; then
        print_message $YELLOW "警告: .env 文件不存在，正在创建..."
        if [ -f "env.example" ]; then
            cp env.example .env
            print_message $YELLOW "已从 env.example 创建 .env 文件"
            print_message $RED "请编辑 .env 文件，填入您的 API 密钥！"
            read -p "按 Enter 键继续，或 Ctrl+C 退出编辑 .env 文件..."
        else
            print_message $RED "错误: env.example 文件不存在"
            exit 1
        fi
    fi
}

# 创建必要的目录
create_directories() {
    print_message $BLUE "创建必要的目录..."
    mkdir -p data logs
}

# 显示帮助信息
show_help() {
    echo "Agents From Scratch - Docker 运行脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  start        启动所有服务 (Jupyter + LangGraph Dev)"
    echo "  stop         停止所有服务"
    echo "  restart      重启所有服务"
    echo "  build        重新构建镜像"
    echo "  logs         查看日志"
    echo "  shell        进入容器 shell"
    echo "  test         运行测试"
    echo "  jupyter      仅启动 Jupyter Notebook"
    echo "  dev          仅启动 LangGraph Dev Server"
    echo "  clean        清理容器和镜像"
    echo "  help         显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 start     # 启动服务"
    echo "  $0 logs      # 查看日志"
    echo "  $0 test      # 运行测试"
}

# 启动服务
start_services() {
    print_message $GREEN "启动 Agents From Scratch 服务..."
    print_message $BLUE "启动 Jupyter Notebook..."
    docker compose up -d jupyter
    print_message $GREEN "✅ Jupyter Notebook 已启动: http://localhost:8888"
    
    print_message $BLUE "启动 LangGraph Dev Server..."
    docker compose --profile dev up -d langgraph-dev
    print_message $GREEN "✅ LangGraph Dev Server 已启动: http://localhost:8123"
    print_message $BLUE "📊 LangGraph Studio: https://smith.langchain.com/studio/?baseUrl=http://127.0.0.1:8000"
    
    print_message $YELLOW "提示: 使用 './run.sh logs' 查看日志"
}

# 停止服务
stop_services() {
    print_message $YELLOW "停止服务..."
    docker compose down
    print_message $GREEN "服务已停止"
}

# 重启服务
restart_services() {
    print_message $YELLOW "重启服务..."
    docker compose restart
    print_message $GREEN "服务已重启"
}

# 构建镜像
build_image() {
    print_message $BLUE "构建 Docker 镜像..."
    docker compose build --no-cache
    print_message $GREEN "镜像构建完成"
}

# 查看日志
show_logs() {
    print_message $BLUE "显示服务日志..."
    docker compose logs -f
}

# 进入容器
enter_shell() {
    print_message $BLUE "进入容器 shell..."
    print_message $YELLOW "选择容器: jupyter (1) 或 langgraph-dev (2)"
    read -p "请输入选项 [1]/2: " choice
    case "${choice:-1}" in
        2)
            docker compose exec langgraph-dev /bin/bash
            ;;
        *)
            docker compose exec jupyter /bin/bash
            ;;
    esac
}

# 运行测试
run_tests() {
    print_message $BLUE "运行测试..."
    docker compose exec jupyter uv run python tests/run_all_tests.py
}

# 启动 Jupyter Notebook
start_jupyter() {
    print_message $BLUE "启动 Jupyter Notebook..."
    docker compose up -d jupyter
    print_message $GREEN "✅ Jupyter Notebook 已启动: http://localhost:8888"
}

# 启动 LangGraph Dev Server
start_dev() {
    print_message $BLUE "启动 LangGraph Dev Server..."
    docker compose --profile dev up -d langgraph-dev
    print_message $GREEN "✅ LangGraph Dev Server 已启动: http://localhost:8123"
    print_message $YELLOW "可用以下 agent:"
    print_message $YELLOW "  - langgraph101"
    print_message $YELLOW "  - email_assistant"
    print_message $YELLOW "  - email_assistant_hitl"
    print_message $YELLOW "  - email_assistant_hitl_memory"
    print_message $YELLOW "  - email_assistant_hitl_memory_gmail"
    print_message $YELLOW "  - cron"
}

# 启动 LangGraph Studio
start_studio() {
    print_message $YELLOW "注意: LangGraph Studio 镜像拉取可能失败（网络问题）"
    print_message $BLUE "建议: 使用 Jupyter Notebook (http://localhost:8888) 替代"
    print_message $BLUE "详情请查看 LANGGRAPH_STUDIO.md"
    echo ""
    print_message $YELLOW "正在尝试启动 LangGraph Studio..."
    if docker compose --profile studio up -d langgraph-studio; then
        print_message $GREEN "LangGraph Studio 已启动: http://localhost:8123"
    else
        print_message $RED "启动失败。请参考 LANGGRAPH_STUDIO.md 中的替代方案"
        print_message $YELLOW "或者直接使用 Jupyter Notebook: http://localhost:8888"
    fi
}

# 清理
clean_up() {
    print_message $YELLOW "清理容器和镜像..."
    docker compose down -v
    docker system prune -f
    print_message $GREEN "清理完成"
}

# 主函数
main() {
    case "${1:-start}" in
        start)
            check_docker
            check_env
            create_directories
            start_services
            ;;
        stop)
            stop_services
            ;;
        restart)
            restart_services
            ;;
        build)
            check_docker
            build_image
            ;;
        logs)
            show_logs
            ;;
        shell)
            enter_shell
            ;;
        test)
            run_tests
            ;;
        jupyter)
            check_docker
            check_env
            create_directories
            start_jupyter
            ;;
        dev)
            check_docker
            check_env
            create_directories
            start_dev
            ;;
        studio)
            start_studio
            ;;
        clean)
            clean_up
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_message $RED "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
}

# 运行主函数
main "$@"



