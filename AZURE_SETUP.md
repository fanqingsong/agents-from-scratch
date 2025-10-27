# Azure OpenAI 配置指南

## 概述

本项目已从 OpenAI 配置迁移到 Azure OpenAI 配置。以下是配置步骤：

## 1. 获取 Azure OpenAI 资源信息

在 Azure 门户中创建或找到您的 Azure OpenAI 资源，获取以下信息：

- **API Key**: 在 Azure OpenAI 资源的"密钥和终结点"页面获取
- **Endpoint**: 格式为 `https://your-resource-name.openai.azure.com/`
- **Deployment Name**: 您创建的模型部署名称（如 `gpt-4`）
- **API Version**: 推荐使用 `2024-02-15-preview`

## 2. 配置环境变量

编辑 `.env` 文件，填入您的 Azure OpenAI 信息：

```bash
# Azure OpenAI 配置
AZURE_OPENAI_API_KEY=your_actual_api_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource-name.openai.azure.com/
AZURE_OPENAI_API_VERSION=2024-02-15-preview
AZURE_OPENAI_DEPLOYMENT_NAME=your_deployment_name
```

## 3. 示例配置

```bash
# 示例配置（请替换为您的实际值）
AZURE_OPENAI_API_KEY=abc123def456ghi789jkl012mno345pqr678stu901vwx234yz
AZURE_OPENAI_ENDPOINT=https://my-openai-resource.openai.azure.com/
AZURE_OPENAI_API_VERSION=2024-02-15-preview
AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4
```

## 4. 验证配置

启动服务后，您可以在 Jupyter Notebook 中测试配置：

```python
from langchain.chat_models import init_chat_model
from dotenv import load_dotenv
import os

load_dotenv()

# 测试 Azure OpenAI 连接
llm = init_chat_model("azure_openai:gpt-4", temperature=0)
response = llm.invoke("Hello, this is a test message.")
print(response.content)
```

## 5. 注意事项

- 确保您的 Azure OpenAI 资源有足够的配额
- 检查部署的模型是否支持您需要的功能
- API 版本 `2024-02-15-preview` 支持最新的功能，但您也可以使用稳定版本如 `2024-02-01`

## 6. 故障排除

如果遇到问题，请检查：

1. API Key 是否正确
2. Endpoint URL 格式是否正确
3. Deployment Name 是否存在
4. 网络连接是否正常
5. Azure OpenAI 资源是否有足够的配额

## 7. 支持的模型

项目已配置为使用 `gpt-4` 模型。如果您想使用其他模型，请修改代码中的模型名称：

```python
llm = init_chat_model("azure_openai:gpt-35-turbo", temperature=0.0)  # 使用 GPT-3.5
```