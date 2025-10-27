# 使用 Python 3.11 官方镜像（优先使用华为云镜像加速）
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/python:3.11-slim

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# 更换为国内 APT 源以加速安装
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 配置 pip 使用国内镜像源
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip config set global.trusted-host pypi.tuna.tsinghua.edu.cn

# 安装 uv 包管理器
RUN pip install uv

# 复制项目文件
COPY pyproject.toml uv.lock ./
COPY src/ ./src/

# 配置 uv 使用国内镜像源并安装项目依赖
RUN uv sync --extra dev --index-url https://pypi.tuna.tsinghua.edu.cn/simple --no-dev

# 安装开发依赖
RUN uv sync --extra dev --index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 安装 LangGraph CLI (如果还没有安装)
RUN uv pip install langgraph-cli -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制其他必要文件
COPY notebooks/ ./notebooks/
COPY tests/ ./tests/
COPY langgraph.json ./
COPY jupyter_config.py ./

# 创建 Jupyter 配置目录
RUN mkdir -p /root/.jupyter

# 复制 Jupyter 配置
COPY jupyter_config.py /root/.jupyter/jupyter_notebook_config.py

# 暴露端口
EXPOSE 8888 8000

# 设置默认命令
CMD ["uv", "run", "jupyter", "notebook", "--config=/root/.jupyter/jupyter_notebook_config.py"]
