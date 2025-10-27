#!/usr/bin/env python3
"""
测试LangGraph 101的简单脚本
需要设置Azure OpenAI环境变量
"""

import os
from dotenv import load_dotenv
from src.email_assistant.langgraph_101 import app
from langchain_core.messages import HumanMessage

# 加载.env文件中的环境变量
load_dotenv()

def test_langgraph():
    """测试LangGraph工作流"""
    
    # 检查环境变量
    required_vars = [
        "AZURE_OPENAI_API_KEY",
        "AZURE_OPENAI_ENDPOINT", 
        "AZURE_OPENAI_API_VERSION",
        "AZURE_OPENAI_DEPLOYMENT_NAME"
    ]
    
    missing_vars = [var for var in required_vars if not os.getenv(var)]
    if missing_vars:
        print("❌ 缺少以下环境变量:")
        for var in missing_vars:
            print(f"   - {var}")
        print("\n请设置这些环境变量后再运行测试")
        return
    
    print("✅ 环境变量检查通过")
    
    # 测试消息
    test_message = HumanMessage(content="请帮我给张三发送一封邮件，主题是'会议安排'，内容是'明天下午2点开会'")
    
    print(f"📝 测试消息: {test_message.content}")
    print("🚀 开始运行LangGraph工作流...")
    
    try:
        # 运行工作流
        result = app.invoke({"messages": [test_message]})
        
        print("\n📋 工作流执行结果:")
        for i, message in enumerate(result["messages"]):
            print(f"\n消息 {i+1}:")
            print(f"  类型: {message.__class__.__name__}")
            print(f"  内容: {message.content}")
            if hasattr(message, 'tool_calls') and message.tool_calls:
                print(f"  工具调用: {message.tool_calls}")
                
    except Exception as e:
        print(f"❌ 运行出错: {e}")
        print("请检查Azure OpenAI配置是否正确")

if __name__ == "__main__":
    test_langgraph()
