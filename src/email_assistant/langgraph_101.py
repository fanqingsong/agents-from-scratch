from typing import Literal
from langchain.chat_models import init_chat_model
from langchain.tools import tool
from langgraph.graph import MessagesState, StateGraph, END, START
from langchain_core.messages import SystemMessage
from dotenv import load_dotenv
load_dotenv(".env")

@tool
def write_email(to: str, subject: str, content: str) -> str:
    """Write and send an email."""
    # Placeholder response - in real app would send email
    return f"Email sent to {to} with subject '{subject}' and content: {content}"

# 使用Azure OpenAI - 从环境变量读取部署名称
import os
deployment_name = os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME", "gpt-4o-mini")
llm = init_chat_model(f"azure_openai:{deployment_name}", temperature=0)
model_with_tools = llm.bind_tools([write_email], tool_choice="auto")  # 改为 auto，让 LLM 自己决定

def call_llm(state: MessagesState) -> MessagesState:
    """Run LLM"""
    # 添加系统提示词（如果还没有）
    messages = list(state["messages"])
    
    # 只在第一条消息不是 SystemMessage 时才添加
    if not messages or not isinstance(messages[0], SystemMessage):
        system_prompt = SystemMessage(
            content="You are a helpful email assistant. "
            "You can help users write and send emails using the write_email tool. "
            "Be concise and professional in your responses. "
            "Only call the write_email tool when the user explicitly asks you to send an email."
        )
        messages = [system_prompt] + messages
    
    output = model_with_tools.invoke(messages)
    return {"messages": [output]}

def run_tool(state: MessagesState) -> MessagesState:
    """Performs the tool call"""

    result = []
    last_message = state["messages"][-1]
    # Check if tool_calls attribute exists
    if hasattr(last_message, 'tool_calls') and last_message.tool_calls:
        for tool_call in last_message.tool_calls:
            observation = write_email.invoke(tool_call["args"])
            result.append({"role": "tool", "content": observation, "tool_call_id": tool_call["id"]})
    return {"messages": result}

def should_continue(state: MessagesState) -> Literal["run_tool", "__end__"]:
    """Route to tool handler, or end if Done tool called"""
    
    # Get the last message
    messages = state["messages"]
    last_message = messages[-1]
    
    # If the last message is a tool call, check if it's a Done tool call
    # Check if tool_calls attribute exists and is not empty
    if hasattr(last_message, 'tool_calls') and last_message.tool_calls:
        return "run_tool"
    # Otherwise, we stop (reply to the user)
    return END

workflow = StateGraph(MessagesState)
workflow.add_node("call_llm", call_llm)
workflow.add_node("run_tool", run_tool)
workflow.add_edge(START, "call_llm")
workflow.add_conditional_edges("call_llm", should_continue, {"run_tool": "run_tool", END: END})
workflow.add_edge("run_tool", "call_llm")

app = workflow.compile()