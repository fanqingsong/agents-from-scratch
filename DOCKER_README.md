# Agents From Scratch - Docker 部署指南

本项目已完全 Docker 化，提供一键运行脚本，支持在 Linux、macOS 和 Windows 环境下运行。

## 🚀 快速开始

### 1. 环境准备

确保您的系统已安装：
- Docker Desktop (推荐最新版本)
- Docker Compose (通常随 Docker Desktop 一起安装)

### 2. 配置环境变量

```bash
# 复制环境变量模板
cp env.example .env

# 编辑 .env 文件，填入您的 API 密钥
nano .env  # 或使用您喜欢的编辑器
```

**必需的环境变量：**
```bash
LANGSMITH_API_KEY=your_langsmith_api_key_here
OPENAI_API_KEY=your_openai_api_key_here
```

**可选的环境变量：**
```bash
LANGSMITH_TRACING=true
LANGSMITH_PROJECT=interrupt-workshop
GOOGLE_APPLICATION_CREDENTIALS=/app/data/google_credentials.json
```

### 3. 一键运行

#### Linux/macOS:
```bash
# 启动所有服务
./run.sh start

# 查看帮助
./run.sh help
```

#### Windows:
```cmd
# 启动所有服务
run.bat start

# 查看帮助
run.bat help
```

## 📋 可用命令

| 命令 | 描述 | 示例 |
|------|------|------|
| `start` | 启动所有服务 | `./run.sh start` |
| `stop` | 停止所有服务 | `./run.sh stop` |
| `restart` | 重启所有服务 | `./run.sh restart` |
| `build` | 重新构建镜像 | `./run.sh build` |
| `logs` | 查看服务日志 | `./run.sh logs` |
| `shell` | 进入容器 shell | `./run.sh shell` |
| `test` | 运行测试 | `./run.sh test` |
| `studio` | 启动 LangGraph Studio | `./run.sh studio` |
| `clean` | 清理容器和镜像 | `./run.sh clean` |
| `help` | 显示帮助信息 | `./run.sh help` |

## 🌐 服务访问

启动服务后，您可以通过以下地址访问：

- **Jupyter Notebook**: http://localhost:8888
- **LangGraph Studio**: http://localhost:8000 (需要运行 `./run.sh studio`)

## 📁 项目结构

```
agents-from-scratch/
├── docker-compose.yml          # Docker Compose 主配置
├── docker-compose.test.yml     # 测试专用配置
├── Dockerfile                  # Docker 镜像构建文件
├── .dockerignore              # Docker 构建忽略文件
├── jupyter_config.py          # Jupyter 配置文件
├── env.example                 # 环境变量模板
├── run.sh                     # Linux/macOS 运行脚本
├── run.bat                    # Windows 运行脚本
├── src/                       # 源代码
├── notebooks/                 # Jupyter 笔记本
├── tests/                     # 测试文件
├── data/                      # 数据目录 (Docker 卷)
└── logs/                      # 日志目录 (Docker 卷)
```

## 🔧 高级配置

### 自定义端口

编辑 `docker-compose.yml` 文件中的端口映射：

```yaml
ports:
  - "8888:8888"  # Jupyter Notebook
  - "8000:8000"  # LangGraph Studio
```

### 启用 LangGraph Studio

```bash
# 启动 LangGraph Studio
./run.sh studio

# 或者使用 Docker Compose 直接启动
docker compose --profile studio up -d langgraph-studio
```

### 运行测试

```bash
# 运行所有测试
./run.sh test

# 或者使用测试专用配置
docker compose -f docker-compose.test.yml up --build
```

### 开发模式

开发模式下，源代码会实时同步到容器中：

```bash
# 启动开发环境
./run.sh start

# 在另一个终端中进入容器进行开发
./run.sh shell
```

## 🐛 故障排除

### 常见问题

1. **端口被占用**
   ```bash
   # 检查端口占用
   lsof -i :8888
   
   # 修改 docker-compose.yml 中的端口映射
   ```

2. **权限问题**
   ```bash
   # 确保脚本有执行权限
   chmod +x run.sh
   ```

3. **环境变量未设置**
   ```bash
   # 检查 .env 文件是否存在且配置正确
   cat .env
   ```

4. **Docker 镜像构建失败**
   ```bash
   # 清理并重新构建
   ./run.sh clean
   ./run.sh build
   ```

### 查看日志

```bash
# 查看所有服务日志
./run.sh logs

# 查看特定服务日志
docker compose logs email-assistant
docker compose logs langgraph-studio
```

### 进入容器调试

```bash
# 进入主容器
./run.sh shell

# 在容器内运行命令
docker compose exec email-assistant uv run python --version
```

## 🔄 更新和维护

### 更新依赖

```bash
# 重新构建镜像
./run.sh build
```

### 清理资源

```bash
# 清理容器、镜像和卷
./run.sh clean
```

### 备份数据

```bash
# 备份数据目录
tar -czf backup-$(date +%Y%m%d).tar.gz data/ logs/
```

## 📚 相关文档

- [LangGraph 官方文档](https://langchain-ai.github.io/langgraph/)
- [Docker Compose 文档](https://docs.docker.com/compose/)
- [Jupyter Notebook 文档](https://jupyter-notebook.readthedocs.io/)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个 Docker 化方案！

## 📄 许可证

本项目遵循原项目的许可证。



