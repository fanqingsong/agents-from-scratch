# 故障排除指南

## LangGraph Studio 无法连接的问题

如果遇到 "TypeError: Failed to fetch" 错误，这通常是由于跨域访问限制导致的。

### 问题原因

LangGraph Studio 托管在 `https://smith.langchain.com`，它尝试访问本地的 `http://127.0.0.1:8000`。浏览器会阻止这种 HTTPS 到 HTTP 的跨域请求，导致连接失败。

### 解决方案

#### 方案 1: 直接访问 API（推荐）

直接访问 LangGraph Dev Server 的 API 文档：

**http://localhost:8000/docs**

这将打开 LangGraph 的交互式 API 文档，您可以直接测试所有的 agent。

#### 方案 2: 使用 localhost 而非 127.0.0.1

在浏览器中访问：

**https://smith.langchain.com/studio/?baseUrl=http://localhost:8000**

#### 方案 3: 使用 Jupyter Notebook

Jupyter Notebook 提供完整的开发环境，无需额外的可视化工具：

**http://localhost:8888**

#### 方案 4: 检查防火墙和网络

确保：
1. Docker 容器正在运行：`docker compose ps`
2. 端口 8000 未被占用：`lsof -i :8000` 或 `netstat -an | grep 8000`
3. 防火墙允许本地访问

### 验证服务是否正常运行

```bash
# 检查服务状态
./run.sh logs

# 测试 API 连接
curl http://localhost:8000/docs

# 查看所有可用的 agent
curl http://localhost:8000/graphs
```

### 常见错误

#### 1. "Failed to fetch"

**原因**: 跨域访问限制  
**解决**: 使用 http://localhost:8000/docs 代替

#### 2. "Server not accessible from browser"

**原因**: 容器未启动或端口未映射  
**解决**: 运行 `./run.sh logs` 检查状态

#### 3. Agent 加载失败

**原因**: Azure OpenAI 配置不正确  
**解决**: 检查 `.env` 文件中的配置

### 推荐工作流程

1. **开发阶段**: 使用 Jupyter Notebook (http://localhost:8888)
2. **调试 API**: 使用 API 文档 (http://localhost:8000/docs)
3. **生产部署**: 使用 LangGraph Platform

### 有用的命令

```bash
# 查看服务状态
docker compose ps

# 查看日志
./run.sh logs

# 重启服务
./run.sh restart

# 进入容器调试
./run.sh shell

# 停止所有服务
./run.sh stop
```

### 联系方式

如果问题持续存在，请：
1. 查看日志: `./run.sh logs`
2. 检查配置: `cat .env`
3. 提交 issue 到项目仓库
