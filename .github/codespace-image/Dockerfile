# Debian-based devcontainer with WASI SDK, Rust, Node.js and the FastEdge tooling
# Published as ghcr.io/<owner>/fastedge-codespace (see .github/workflows/codespace-image.yml)

FROM mcr.microsoft.com/devcontainers/base:debian

ARG DEBIAN_FRONTEND=noninteractive
ARG wasm32_wasi_version=1.86.0

ENV RUSTUP_HOME=/usr/local/rustup \
  CARGO_HOME=/usr/local/cargo \
  PATH=/usr/local/cargo/bin:$PATH

# Host toolchain for Rust build scripts and native npm modules
# Note: git, curl, wget, ca-certificates, gnupg already in base image
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential pkg-config libssl-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Install WASI SDK for WebAssembly compilation
RUN mkdir -p /opt/wasi-sdk \
  && curl -fsSL https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-20/wasi-sdk-20.0-linux.tar.gz \
  | tar -xz -C /opt/wasi-sdk --strip-components=1

# Install Rust with WASM target
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
  | sh -s -- -y --default-toolchain ${wasm32_wasi_version} --profile minimal \
  && rustup target add wasm32-wasip1 \
  && rustup --version && cargo --version && rustc --version

# Set environment variables for WASI SDK
ENV WASI_SYSROOT=/opt/wasi-sdk/share/wasi-sysroot \
  PATH="/opt/wasi-sdk/bin:$PATH" \
  CC=/opt/wasi-sdk/bin/clang \
  CXX=/opt/wasi-sdk/bin/clang++

# Install Node.js v24.12.0 (exact version) using NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
  && apt-get install -y --no-install-recommends nodejs=24.12.0-1nodesource1 \
  && apt-mark hold nodejs \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && npm install -g pnpm@10.26.2 \
  && node --version && npm --version && pnpm --version

# Configure npm to use user-writable directory for global packages
# This allows vscode user (and Codespace users) to run npm i -g without sudo
RUN mkdir -p /home/vscode/.npm-global \
  && chown -R vscode:vscode /home/vscode/.npm-global

ENV NPM_CONFIG_PREFIX=/home/vscode/.npm-global \
  PATH="/home/vscode/.local/bin:/home/vscode/.npm-global/bin:$PATH"

# Debian's /etc/profile resets PATH in login shells; restore the toolchain paths
RUN echo 'export PATH="/home/vscode/.local/bin:/home/vscode/.npm-global/bin:/opt/wasi-sdk/bin:/usr/local/cargo/bin:$PATH"' \
  > /etc/profile.d/fastedge-path.sh

# Short sign-in command for the manual connect code (see the script)
COPY fastedge-login /usr/local/bin/fastedge-login

# FastEdge CLIs and AI agents, installed as the codespace user so they can self-update.
# Users sign in to Claude Code / Codex with their own accounts on first run.
USER vscode
RUN npm install -g create-fastedge-app @gcoredev/fastedge-test @openai/codex \
  && curl -fsSL https://claude.ai/install.sh | bash \
  && claude plugin marketplace add G-Core/gcore-marketplace \
  && claude plugin install gcore-fastedge@gcore-marketplace \
  && codex plugin marketplace add G-Core/gcore-marketplace \
  && codex plugin add gcore-fastedge@gcore-marketplace \
  && claude --version && codex --version
USER root
