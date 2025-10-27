# LangGraph Studio 启动指南

## 问题说明

由于网络原因，Docker 无法直接拉取 LangGraph Studio 官方镜像。以下是几种替代方案：

## 方案 1：使用 Jupyter Notebook（推荐）

本项目的主要功能是 Jupyter Notebook，它已经成功启动并可以正常使用。

**访问地址：** http://127.0.0.1:8888

在 Jupyter Notebook 中，您可以：
- 运行和测试所有的 Agent 实现
- 查看和修改代码
- 运行测试
- 开发新功能

## 方案 2：配置 Docker 镜像加速

如果需要使用 LangGraph Studio，您需要配置 Docker 镜像加速：

### 步骤 1：配置 Docker 镜像加速器

创建或编辑 `/etc/docker/daemon.json` 文件（需要 sudo 权限）：

```bash
sudo nano /etc/docker/daemon.json
```

添加以下内容：

```json
{
  "registry-mirrors": [
    "https://dockerproxy.com",
    "https://docker.m.daocloud.io",
    "https://docker.mirrors.sjtug.sjtu.edu.cn",
    "https://docker.nju.edu.cn"
  ]
}
```

### 步骤 2：重启 Docker 服务

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 步骤 3：尝试拉取镜像

```bash
docker pull langchain/langgraph-studio:latest
```

### 步骤 4：启动 LangGraph Studio

```bash
./run.sh studio
```

## 方案 3：在容器内安装并运行（临时方案）

如果上述方案都不可用，您可以在容器内安装 LangGraph Studio：

### 进入容器

```bash
docker exec -it agents-from-scratch bash
```

### 在容器内安装

```bash
pip install langgraph-studio
```

### 启动 LangGraph Studio

```bash
langgraph-studio --port 8000 --host 0.0.0.0
```

然后访问：http://127.0.0.1:8000

## 方案 4：仅使用 Jupyter Notebook

**建议：** 对于本项目的所有功能，使用 Jupyter Notebook 已经足够。LangGraph Studio 主要用于可视化开发，但不影响代码的运行和测试。

## 测试建议

在 Jupyter Notebook 中测试 Azure OpenAI 配置：

```python
from langchain.chat_models import init_chat_model
from dotenv import load_dotenv
import os

load_dotenv()

# 测试 Azure OpenAI
llm = init_chat_model("azure_openai:gpt-4", temperature=0)
response = llm.invoke("Hello, this is a test message.")
print(response.content)
```

## 总结

- **主要功能：** 使用 Jupyter Notebook (http://127.0.0.1:8888)
- **LangGraph Studio：** 可选，主要用于可视化开发
- **建议：** 先配置 Docker 镜像加速，如果无法配置，直接使用 Jupyter Notebook 即可
