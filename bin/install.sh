#!/bin/bash
# chezmoi-install.sh - Wrapper script to show progress during dotfiles installation

set -e

REPO_URL="https://github.com/merl-one/dotfiles.git"
REPO_NAME="merl-one/dotfiles"

echo "🚀 Installing dotfiles from $REPO_NAME..."
echo ""

# Check if chezmoi is installed
if ! command -v chezmoi &> /dev/null; then
    echo "📥 Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)"
    echo "✅ Chezmoi installed"
    echo ""
fi

echo "📚 Applying dotfiles configuration..."
echo "   Repository: $REPO_URL"
echo ""

# Run chezmoi init --apply
if chezmoi init --apply "$REPO_URL"; then
    echo ""
    echo "✅ Dotfiles applied successfully!"
    echo ""
    echo "📋 Next steps:"
    echo ""
    echo "   1. Install shell plugins:"
    echo "      zsh -i -c 'zinit update --all'"
    echo ""
    echo "   2. Install tmux plugins:"
    echo "      tmux new -d && tmux run-shell ~/.tmux/plugins/tpm/scripts/install_plugins.sh"
    echo ""
    echo "   3. Install Neovim plugins:"
    echo "      nvim --headless '+Lazy! sync' +qa"
    echo ""
    echo "   4. Start using:"
    echo "      lg              # lazygit"
    echo "      v               # nvim"
    echo "      k               # kubectl"
    echo "      gs/gp/gm        # git shortcuts"
    echo ""
    echo "📖 For more info, see:"
    echo "   https://github.com/merl-one/dotfiles/blob/main/docs/INDEX.md"
    echo ""
else
    echo "❌ Installation failed"
    exit 1
fi
