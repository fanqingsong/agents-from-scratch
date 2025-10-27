# 服务架构说明

## 📋 服务概述

本项目提供两个独立的 Docker 服务：

### 1. Jupyter Notebook 服务
- **容器名称**: `agents-jupyter`
- **端口**: 8888
- **用途**: 开发和探索 agent 代码
- **默认启动**: ✅

### 2. LangGraph Dev Server
- **容器名称**: `agents-langgraph-dev`
- **端口**: 8000
- **用途**: 调试和可视化 agent
- **需要单独启动**: 🔧

## 🚀 使用方式

### 基本命令

```bash
# 启动 Jupyter Notebook (默认)
./run.sh start
# 或
./run.sh jupyter

# 启动 LangGraph Dev Server (调试模式)
./run.sh dev

# 停止所有服务
./run.sh stop

# 查看日志
./run.sh logs

# 进入容器
./run.sh shell
```

### 访问地址

| 服务 | 地址 | 说明 |
|------|------|------|
| Jupyter Notebook | http://localhost:8888 | 开发环境 |
| LangGraph Studio | http://localhost:8000 | 调试和可视化 |

## 🔧 详细说明

### Jupyter Notebook 服务

这是主要的开发和探索环境，提供：

- ✅ 运行和测试所有的 Agent 实现
- ✅ 查看和修改代码
- ✅ 运行测试
- ✅ 开发新功能
- ✅ 直接交互式开发

**启动方式**:
```bash
./run.sh jupyter
```

### LangGraph Dev Server

提供图形化调试界面，可以：

- 🔍 可视化 agent 的执行流程
- 📊 查看 agent 的状态和中间结果
- 🛠️ 调试 agent 的行为
- 📈 查看运行统计和性能指标

**可用的 Agent**:
- `langgraph101` - LangGraph 基础示例
- `email_assistant` - 基础邮件助手
- `email_assistant_hitl` - 带人工审核的邮件助手
- `email_assistant_hitl_memory` - 带记忆和反馈学习的邮件助手
- `email_assistant_hitl_memory_gmail` - Gmail 集成版本
- `cron` - 定时任务 agent

**启动方式**:
```bash
./run.sh dev
```

## 📝 配置文件

### langgraph.json

定义了所有可用的 agent 和它们的入口点：

```json
{
    "graphs": {
        "langgraph101": "./src/email_assistant/langgraph_101.py:app",
        "email_assistant": "./src/email_assistant/email_assistant.py:email_assistant",
        ...
    }
}
```

### .env

包含所有必要的环境变量：

- `AZURE_OPENAI_*` - Azure OpenAI 配置
- `LANGSMITH_*` - LangSmith 追踪配置
- `GOOGLE_APPLICATION_CREDENTIALS` - Gmail 集成（可选）

## 🛠️ 故障排除

### 问题 1: LangGraph Dev Server 无法启动

**解决方案**:
1. 检查日志: `./run.sh logs`
2. 确保 `.env` 文件已正确配置
3. 尝试重新构建镜像: `./run.sh build`

### 问题 2: Agent 找不到

**解决方案**:
1. 检查 `langgraph.json` 配置
2. 确保入口点 `app` 或 `email_assistant` 在对应的 Python 文件中定义
3. 查看容器日志: `docker compose logs langgraph-dev`

### 问题 3: Azure OpenAI 连接失败

**解决方案**:
1. 运行测试脚本: `python test_azure_openai.py`
2. 检查 `.env` 文件中的 Azure OpenAI 配置
3. 参考 `AZURE_SETUP.md` 文档

## 💡 最佳实践

1. **开发阶段**: 使用 Jupyter Notebook 进行快速迭代
2. **调试阶段**: 使用 LangGraph Dev Server 可视化执行流程
3. **生产阶段**: 使用 Jupyter Notebook 运行测试和验证

## 📚 相关文档

- [Azure OpenAI 配置指南](AZURE_SETUP.md)
- [LangGraph Studio 替代方案](LANGGRAPH_STUDIO.md)
- [主 README](README.md)
