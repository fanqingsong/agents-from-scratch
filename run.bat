@echo off
REM Agents From Scratch - Docker 一键运行脚本 (Windows)
REM 作者: AI Assistant
REM 版本: 1.0

setlocal enabledelayedexpansion

REM 检查参数
if "%1"=="" set "1=start"

REM 检查 Docker 是否安装
docker --version >nul 2>&1
if errorlevel 1 (
    echo 错误: Docker 未安装。请先安装 Docker Desktop。
    pause
    exit /b 1
)

docker compose version >nul 2>&1
if errorlevel 1 (
    echo 错误: Docker Compose 未安装。请先安装 Docker Compose。
    pause
    exit /b 1
)

REM 检查环境变量文件
if not exist ".env" (
    echo 警告: .env 文件不存在，正在创建...
    if exist "env.example" (
        copy env.example .env
        echo 已从 env.example 创建 .env 文件
        echo 请编辑 .env 文件，填入您的 API 密钥！
        pause
    ) else (
        echo 错误: env.example 文件不存在
        pause
        exit /b 1
    )
)

REM 创建必要的目录
if not exist "data" mkdir data
if not exist "logs" mkdir logs

REM 根据参数执行相应操作
if "%1"=="start" goto start_services
if "%1"=="stop" goto stop_services
if "%1"=="restart" goto restart_services
if "%1"=="build" goto build_image
if "%1"=="logs" goto show_logs
if "%1"=="shell" goto enter_shell
if "%1"=="test" goto run_tests
if "%1"=="studio" goto start_studio
if "%1"=="clean" goto clean_up
if "%1"=="help" goto show_help
goto unknown_option

:start_services
echo 启动 Agents From Scratch 服务...
docker compose up -d
echo 服务已启动！
echo Jupyter Notebook: http://localhost:8888
echo LangGraph Studio: http://localhost:8000 (如果启用)
goto end

:stop_services
echo 停止服务...
docker compose down
echo 服务已停止
goto end

:restart_services
echo 重启服务...
docker compose restart
echo 服务已重启
goto end

:build_image
echo 构建 Docker 镜像...
docker compose build --no-cache
echo 镜像构建完成
goto end

:show_logs
echo 显示服务日志...
docker compose logs -f
goto end

:enter_shell
echo 进入容器 shell...
docker compose exec email-assistant /bin/bash
goto end

:run_tests
echo 运行测试...
docker compose exec email-assistant uv run python tests/run_all_tests.py
goto end

:start_studio
echo 启动 LangGraph Studio...
docker compose --profile studio up -d langgraph-studio
echo LangGraph Studio 已启动: http://localhost:8000
goto end

:clean_up
echo 清理容器和镜像...
docker compose down -v
docker system prune -f
echo 清理完成
goto end

:show_help
echo Agents From Scratch - Docker 运行脚本
echo.
echo 用法: %0 [选项]
echo.
echo 选项:
echo   start        启动所有服务
echo   stop         停止所有服务
echo   restart      重启所有服务
echo   build        重新构建镜像
echo   logs         查看日志
echo   shell        进入容器 shell
echo   test         运行测试
echo   studio       启动 LangGraph Studio
echo   clean        清理容器和镜像
echo   help         显示此帮助信息
echo.
echo 示例:
echo   %0 start     # 启动服务
echo   %0 logs      # 查看日志
echo   %0 test      # 运行测试
goto end

:unknown_option
echo 未知选项: %1
goto show_help

:end
pause



