#!/usr/bin/env python3
"""
Azure OpenAI 配置测试脚本
用于验证 Azure OpenAI 配置是否正确
"""

import os
from dotenv import load_dotenv
from langchain.chat_models import init_chat_model

def test_azure_openai_config():
    """测试 Azure OpenAI 配置"""
    
    # 加载环境变量
    load_dotenv()
    
    # 检查环境变量
    required_vars = [
        'AZURE_OPENAI_API_KEY',
        'AZURE_OPENAI_ENDPOINT', 
        'AZURE_OPENAI_API_VERSION',
        'AZURE_OPENAI_DEPLOYMENT_NAME'
    ]
    
    print("🔍 检查环境变量...")
    missing_vars = []
    for var in required_vars:
        value = os.getenv(var)
        if not value or value.startswith('your_'):
            missing_vars.append(var)
            print(f"❌ {var}: 未设置或使用默认值")
        else:
            # 隐藏 API Key 的大部分内容
            if 'API_KEY' in var:
                masked_value = value[:8] + '...' + value[-4:] if len(value) > 12 else '***'
                print(f"✅ {var}: {masked_value}")
            else:
                print(f"✅ {var}: {value}")
    
    if missing_vars:
        print(f"\n⚠️  请先配置以下环境变量: {', '.join(missing_vars)}")
        print("📝 编辑 .env 文件，填入您的 Azure OpenAI 信息")
        return False
    
    # 测试 Azure OpenAI 连接
    print("\n🚀 测试 Azure OpenAI 连接...")
    try:
        llm = init_chat_model("azure_openai:gpt-4", temperature=0)
        response = llm.invoke("Hello! This is a test message. Please respond with 'Azure OpenAI is working!'")
        print(f"✅ Azure OpenAI 连接成功!")
        print(f"📝 响应: {response.content}")
        return True
    except Exception as e:
        print(f"❌ Azure OpenAI 连接失败: {str(e)}")
        print("\n🔧 故障排除建议:")
        print("1. 检查 API Key 是否正确")
        print("2. 检查 Endpoint URL 格式是否正确")
        print("3. 检查 Deployment Name 是否存在")
        print("4. 检查网络连接")
        print("5. 检查 Azure OpenAI 资源配额")
        return False

if __name__ == "__main__":
    print("🧪 Azure OpenAI 配置测试")
    print("=" * 50)
    
    success = test_azure_openai_config()
    
    print("\n" + "=" * 50)
    if success:
        print("🎉 配置测试通过！Azure OpenAI 已准备就绪")
    else:
        print("❌ 配置测试失败，请检查上述错误信息")
