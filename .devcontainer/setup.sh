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

# Install FastEdge VSCode extension from VSIX (newer than marketplace version)
FASTEDGE_VSIX_VERSION="0.1.26"
FASTEDGE_VSIX_NAME="fastedge-linux-x64-${FASTEDGE_VSIX_VERSION}.vsix"
FASTEDGE_VSIX_URL="https://github.com/godronus/FastEdge-vscode/releases/download/v${FASTEDGE_VSIX_VERSION}/${FASTEDGE_VSIX_NAME}"
FASTEDGE_VSIX_SHA256_URL="${FASTEDGE_VSIX_URL}.sha256"
FASTEDGE_VSIX_CACHE_DIR="$HOME/.fastedge-extension"
FASTEDGE_VSIX_PATH="${FASTEDGE_VSIX_CACHE_DIR}/${FASTEDGE_VSIX_NAME}"

echo "📦 Downloading FastEdge VSCode extension v${FASTEDGE_VSIX_VERSION} (cached for install on attach)..."
mkdir -p "$FASTEDGE_VSIX_CACHE_DIR"
curl -fsSL "$FASTEDGE_VSIX_URL" -o "$FASTEDGE_VSIX_PATH"
curl -fsSL "$FASTEDGE_VSIX_SHA256_URL" -o "${FASTEDGE_VSIX_PATH}.sha256"

echo "🔒 Verifying checksum..."
read -r EXPECTED _ < "${FASTEDGE_VSIX_PATH}.sha256"
ACTUAL=$(sha256sum "$FASTEDGE_VSIX_PATH"); ACTUAL=${ACTUAL%% *}
if [ "$EXPECTED" != "$ACTUAL" ]; then
    echo "❌ Checksum mismatch for FastEdge VSIX — removing cached file"
    rm -f "$FASTEDGE_VSIX_PATH" "${FASTEDGE_VSIX_PATH}.sha256"
else
    echo "✅ FastEdge VSIX cached at ${FASTEDGE_VSIX_PATH} (will install on first attach)"
fi


# Pre-pull MCP server Docker image for caching in prebuild
echo "📦 Pulling FastEdge MCP server image..."
if docker pull ghcr.io/g-core/fastedge-mcp-server:latest; then
    echo "✅ MCP server image cached successfully"
else
    echo "⚠️  Failed to pull MCP server image (may succeed on container start)"
fi

# install create-fastedge-app globally
echo "📦 Installing create-fastedge-app..."
npm install -g create-fastedge-app

## ADD ALL ONE TIME SETUP STEPS ABOVE THIS LINE ##

# Create marker file
touch "$MARKER_FILE"

## FINAL MESSAGES ##
echo ""
echo "✅ Setup complete!"
