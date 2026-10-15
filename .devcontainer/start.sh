#!/bin/bash
# Interactive template selector for FastEdge Apps

# Check if already initialized
if [ -f ".devcontainer/.codespace-initialized" ]; then
    echo "╔════════════════════════════════════════════╗"
    echo "║   FastEdge Application Codespace Started   ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    echo "👋 Welcome back! Your FastEdge application codespace is up and running again."
    echo ""
    exit 0
fi

echo "╔════════════════════════════════════════════╗"
echo "║   FastEdge Application Codespace Created   ║"
echo "╚════════════════════════════════════════════╝"
echo ""
echo ""
# Ensure Docker daemon is ready (the MCP server runs in Docker)
echo "🔧 Waiting for Docker..."
until docker info >/dev/null 2>&1; do
    sleep 1
done
echo "✅ Docker daemon ready"
echo ""

# Sign-in uses an ephemeral session: no API key is stored in this codespace.
# The token lives only in the running MCP server's memory, so every MCP server
# start needs a fresh approval in the Gcore portal.
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 Signing in to Gcore"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "The FastEdge MCP server signs in through the Gcore portal - no API key needed."
echo "When Copilot needs your account it will give you a portal link and a"
echo "'login --code' command:"
echo ""
echo "1. Open the link in your browser, choose the manual option and approve."
echo "2. Run the command in this terminal and paste the connect code at its prompt."
echo ""
echo "Never paste the connect code into the chat - it is your access token."
echo "Each time the MCP server restarts you will need to approve again."
echo ""

echo "🎉 Your FastEdge codespace is ready."
echo ""

# Prompt user for setup method
echo "How would you like to create your FastEdge application?"
echo ""
echo "1) Use AI Agent (Recommended) - Let GitHub Copilot guide you"
echo "2) Setup Manually - Interactive CLI wizard"
echo ""
read -p "Enter your choice (1 or 2) [default: 1]: " setup_choice
setup_choice=${setup_choice:-1}

if [ "$setup_choice" = "1" ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🤖 AI Agent Setup"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "To create your FastEdge application with AI assistance:"
    echo ""
    echo "1. Open GitHub Copilot Chat (Ctrl+Alt+I or Cmd+Shift+I)"
    echo "2. Type: /createFastEdgeApp"
    echo "3. Follow the prompts to configure your application"
    echo ""
    echo "The AI will help you choose the right template and"
    echo "configure your application based on your needs."
    echo ""
    echo "If the command is not recognized, please start the MCP server (fastedge-assistant) first."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
elif [ "$setup_choice" = "2" ]; then
    echo ""
    echo "Starting manual setup wizard..."
    echo ""
    npx create-fastedge-app . --codespaces
else
    echo ""
    echo "Invalid choice. Please restart the codespace and try again."
    exit 1
fi

# Mark as initialized
touch .devcontainer/.codespace-initialized

# Open the CODESPACE_README
code CODESPACE_README.md

# Open the README
code README.md



