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
# The menu needs a terminal; without one, read would hit EOF and pick the default
if [ ! -t 0 ]; then
    echo "Run 'bash .devcontainer/start.sh' in a terminal to create your FastEdge application."
    exit 0
fi

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
echo "When your AI agent needs your account it will ask you to open a new terminal"
echo "and run: fastedge-login"
echo ""
echo "It shows a portal link: open it, approve, then"
echo "paste the connect code at the prompt."
echo ""
echo "Never paste the connect code into the chat - it is your access token."
echo "Each time the MCP server restarts you will need to approve again."
echo ""

echo "🎉 Your FastEdge codespace is ready."
echo ""

# Prompt user for setup method
echo "How would you like to create your FastEdge application?"
echo ""
echo "1) Claude Code (Recommended) - needs a Claude account"
echo "2) Codex CLI - needs a ChatGPT account or OpenAI API key"
echo "3) GitHub Copilot Chat - included with your GitHub account"
echo "4) Setup Manually - Interactive CLI wizard"
echo ""
read -p "Enter your choice (1-4) [default: 1]: " setup_choice
setup_choice=${setup_choice:-1}

# Open the CODESPACE_README
code CODESPACE_README.md

# Open the README
code README.md

# Mark as initialized only once the chosen path succeeds, so a failed or
# interrupted setup shows this menu again on the next attach
case "$setup_choice" in
    1)
        echo ""
        echo "Starting Claude Code with the FastEdge scaffold skill..."
        echo "(Sign in with your Claude account when asked. Run 'claude' any time to return.)"
        echo ""
        claude "/gcore-fastedge:scaffold" && touch .devcontainer/.codespace-initialized
        ;;
    2)
        echo ""
        echo "Starting Codex with the FastEdge scaffold skill..."
        echo "(Sign in with your ChatGPT account when asked. Run 'codex' any time to return.)"
        echo ""
        codex '$gcore-fastedge:scaffold' && touch .devcontainer/.codespace-initialized
        ;;
    3)
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🤖 GitHub Copilot Setup"
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
        touch .devcontainer/.codespace-initialized
        ;;
    4)
        echo ""
        echo "Starting manual setup wizard..."
        echo ""
        npx create-fastedge-app . --codespaces && touch .devcontainer/.codespace-initialized
        ;;
    *)
        echo ""
        echo "Invalid choice. Please restart the codespace and try again."
        exit 1
        ;;
esac
