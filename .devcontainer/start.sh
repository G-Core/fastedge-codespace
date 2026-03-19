#!/bin/bash
# Interactive template selector for FastEdge Apps

# Install cached FastEdge VSIX extension (code CLI is only available on attach, not during prebuild)
FASTEDGE_VSIX_PATH=$(ls /usr/local/share/fastedge-extension/fastedge-linux-x64-*.vsix 2>/dev/null | head -1)
if [ -n "$FASTEDGE_VSIX_PATH" ] && [ ! -f "$HOME/.fastedge-extension-installed" ]; then
    echo "📦 Installing FastEdge VSCode extension from VSIX..."
    if code --install-extension "$FASTEDGE_VSIX_PATH" --force; then
        echo "✅ FastEdge extension installed"
        touch "$HOME/.fastedge-extension-installed"
    else
        echo "⚠️  FastEdge extension install failed (will retry on next attach)"
    fi
fi

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
echo "Validating your environment..."

SECRET_SET=false

# Check if GCORE_API_TOKEN is set
if [ -z "$GCORE_API_TOKEN" ]; then
    echo "⚠️  GCORE_API_TOKEN not found. Setting up secret..."
    echo ""

    # Trigger the VS Code command
    echo "fastedge.setup-codespace-secret" > .vscode/.fastedge-run-command

    # Wait for the secret to be created (poll for up to 2 minutes)
    echo "Waiting for secret configuration to complete..."
    TIMEOUT=120
    ELAPSED=0
    SECRET_SET=false

    while [ $ELAPSED -lt $TIMEOUT ]; do
        # Check if secret exists using gh CLI
        if gh secret list --app codespaces --user --json name 2>/dev/null | grep -q "GCORE_API_TOKEN"; then
            SECRET_SET=true
            break
        fi
        sleep 2
        ELAPSED=$((ELAPSED + 2))
        echo -n "."
    done

    echo ""

    if [ "$SECRET_SET" = true ]; then
        echo "✅ Secret configured successfully!"
        echo ""
        echo "⚠️  Note: You'll need to REBUILD the codespace for the secret to be available."
        echo "    The secret is now saved but not yet loaded into this environment."
        echo ""
    else
        echo "⏱️  Secret setup is taking longer than expected or was cancelled."
        echo ""
        echo "You can set it up later by:"
        echo "1. Running: Command Palette > FastEdge (Setup Codespace Secret)"
        echo "2. Or manually via GitHub repository Settings > Secrets > Codespaces"
        echo ""
    fi
fi

# Initialize MCP Server only if GCORE_API_TOKEN is set
if [ -n "$GCORE_API_TOKEN" ]; then
    # Ensure Docker daemon is ready for MCP server
    echo ""
    echo "🔧 Initializing FastEdge MCP Server..."
    # Wait for Docker daemon to be ready (the MCP server uses Docker)
    until docker info >/dev/null 2>&1; do
        echo "Waiting for Docker daemon to be ready..."
        sleep 1
    done
    echo "✅ Docker daemon ready"
    echo ""

    # Trigger VS Code to reload the window to ensure MCP servers restart
    # This ensures that if Copilot Chat was already open, it reconnects to MCP servers
    echo "🔄 Reloading VS Code window to initialize MCP servers..."
    # echo "workbench.action.reloadWindow" > .vscode/.fastedge-run-command
    sleep 2
else
    echo ""
    if [ "$SECRET_SET" = true ]; then
        echo "ℹ️  MCP server will be available after you rebuild the codespace"
        echo "   (The secret is saved but not yet loaded into this session)"
    else
        echo "⚠️  Skipping MCP server initialization (GCORE_API_TOKEN not configured)"
    fi
    echo ""
fi


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



