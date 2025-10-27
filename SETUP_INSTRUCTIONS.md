# 项目设置说明

## 1. 环境变量配置

### 复制环境变量模板
```bash
cp .env.example .env
```

### 编辑 .env 文件
使用你喜欢的编辑器编辑 `.env` 文件，填入你的Azure OpenAI配置：

```bash
nano .env
# 或者
vim .env
# 或者
code .env
```

### 必需的配置项
- `AZURE_OPENAI_API_KEY`: 你的Azure OpenAI API密钥
- `AZURE_OPENAI_ENDPOINT`: 你的Azure OpenAI端点URL
- `AZURE_OPENAI_API_VERSION`: API版本（建议使用最新稳定版）
- `AZURE_OPENAI_DEPLOYMENT_NAME`: 你的模型部署名称

## 2. 运行测试

### 激活虚拟环境
```bash
source .venv/bin/activate
```

### 运行LangGraph 101测试
```bash
python test_langgraph.py
```

## 3. 预期输出

如果配置正确，你应该看到类似以下的输出：
```
✅ 环境变量检查通过
📝 测试消息: 请帮我给张三发送一封邮件，主题是'会议安排'，内容是'明天下午2点开会'
🚀 开始运行LangGraph工作流...

📋 工作流执行结果:

消息 1:
  类型: AIMessage
  内容: 我来帮你发送邮件...

消息 2:
  类型: ToolMessage
  内容: Email sent to 张三 with subject '会议安排' and content: 明天下午2点开会

消息 3:
  类型: AIMessage
  内容: 邮件已成功发送给张三...
```

## 4. 故障排除

如果遇到问题，请检查：
1. Azure OpenAI服务是否正常运行
2. API密钥是否正确
3. 部署名称是否匹配
4. 网络连接是否正常
