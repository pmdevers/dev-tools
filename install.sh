#!/usr/bin/env bash

set -euo pipefail

TOOLS_DIR="$HOME/.dev-tools"
REPO_URL="https://github.com/pmdevers/dev-tools"
SCRIPT="dev"

echo "📦 Installing shared dev tools..."

# Clone the tools repo
if [ ! -d "$TOOLS_DIR" ]; then
  echo "📥 Cloning dev-tools repo..."
  git clone "$REPO_URL" "$TOOLS_DIR"
else
  echo "🔄 Updating existing dev-tools repo..."
  git -C "$TOOLS_DIR" pull
fi

# Check for Devbox
if ! command -v devbox &> /dev/null; then
  echo "📦 Devbox not found. Installing..."
  curl -fsSL https://get.jetpack.io/devbox | bash
else
  echo "✅ Devbox is already installed."
fi

# Add dev-tools to Path
echo "🔧 Adding dev-tools to PATH..."
export PATH="$TOOLS_DIR:$PATH"

chmod 755 "$TOOLS_DIR/$SCRIPT"

echo "✅ dev-tools cli is installed."