#!/bin/bash
set -e

# Marker file to prevent re-running setup
MARKER_FILE="$HOME/.fastedge-setup-complete"

if [ -f "$MARKER_FILE" ]; then
    echo "✅ FastEdge environment already set up (skipping)"
    exit 0
fi

echo "🚀 Setting up FastEdge development environment..."

## ADD ALL ONE TIME SETUP STEPS BELOW THIS LINE ##

# Pre-pull MCP server Docker image for caching in prebuild
echo "📦 Pulling FastEdge MCP server image..."
if docker pull ghcr.io/g-core/fastedge-mcp-server:latest; then
    echo "✅ MCP server image cached successfully"
else
    echo "⚠️  Failed to pull MCP server image (may succeed on container start)"
fi

## ADD ALL ONE TIME SETUP STEPS ABOVE THIS LINE ##

# Create marker file
touch "$MARKER_FILE"

## FINAL MESSAGES ##
echo ""
echo "✅ Setup complete!"
