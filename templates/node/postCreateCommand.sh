#!/bin/sh
# Post-create script for Node.js dev container

set -e

echo "📦 Setting up Node.js development environment..."

# 1. Clone dotfiles if not present
DOTFILES_REPO="https://gitlab.com/jason/dotfiles.git"
DOTFILES_HOME="${HOME}/.dotfiles"

if [ ! -d "$DOTFILES_HOME" ]; then
    echo "📥 Cloning dotfiles..."
    git clone --depth 1 "$DOTFILES_REPO" "$DOTFILES_HOME"
    cd "$DOTFILES_HOME"
    
    if command -v chezmoi &>/dev/null; then
        echo "🔧 Applying dotfiles..."
        chezmoi init --apply . 2>/dev/null || true
    fi
else
    echo "✅ Dotfiles already present"
fi

# 2. Install project dependencies
if [ -f /workspace/package.json ]; then
    echo "📦 Installing dependencies..."
    cd /workspace
    npm install || yarn install 2>/dev/null || pnpm install 2>/dev/null || true
fi

# 3. Install TypeScript definitions if needed
if [ -f /workspace/tsconfig.json ]; then
    echo "📝 Setting up TypeScript..."
    cd /workspace
    npm install --save-dev typescript @types/node 2>/dev/null || true
fi

echo ""
echo "✅ Node.js environment ready!"
echo ""
echo "📊 Environment details:"
node --version
npm --version
echo ""
echo "🚀 Ready to start coding!"
