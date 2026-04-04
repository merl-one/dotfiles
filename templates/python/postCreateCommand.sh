#!/bin/bash
# Post-create script for Python dev container
# Runs once after container is created

set -e  # Exit on error

echo "🐍 Setting up Python development environment..."

# 1. Clone dotfiles if not already present
DOTFILES_REPO="https://gitlab.com/jason/dotfiles.git"
DOTFILES_HOME="${HOME}/.dotfiles"

if [ ! -d "$DOTFILES_HOME" ]; then
    echo "📥 Cloning dotfiles..."
    git clone --depth 1 "$DOTFILES_REPO" "$DOTFILES_HOME"
    cd "$DOTFILES_HOME"
    
    # Apply dotfiles with chezmoi
    echo "🔧 Applying dotfiles with chezmoi..."
    if command -v chezmoi &>/dev/null; then
        chezmoi init --apply . || true
    else
        echo "⚠️ chezmoi not found, installing..."
        sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply "$DOTFILES_HOME"
    fi
else
    echo "✅ Dotfiles already present at $DOTFILES_HOME"
fi

# 2. Source shell configuration
if [ -f ~/.zshrc ]; then
    echo "📝 Sourcing zshrc..."
    source ~/.zshrc 2>/dev/null || true
fi

# 3. Install project dependencies if Poetry lock exists
if [ -f /workspace/pyproject.toml ]; then
    echo "📦 Installing Python dependencies with poetry..."
    cd /workspace
    poetry install --no-root || pip install -e . || true
fi

# 4. Verify environment
echo ""
echo "✅ Python development environment ready!"
echo ""
echo "📊 Environment details:"
python --version
pip --version
poetry --version 2>/dev/null || echo "Poetry: not in PATH"
echo ""
echo "🔧 Aliases available:"
echo "  lg     - lazygit"
echo "  ls/la  - eza with icons"
echo "  k      - kubectl"
echo "  v      - nvim"
echo "  gs/gp  - git shortcuts"
echo ""
echo "🚀 Ready to start coding!"
