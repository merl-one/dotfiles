#!/bin/bash
# Dev Container initialization and testing script
# Usage: ./scripts/devcontainer-init.sh [project-path] [template-name]
# Example: ./scripts/devcontainer-init.sh ~/projects/my-app python
# This script bootstraps a new project with dev container configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TEMPLATES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/templates"
PROJECT_PATH="${1:-.}"
TEMPLATE_NAME="${2:-python}"
DOTFILES_REPO="https://gitlab.com/jason/dotfiles.git"

# Validate inputs
if [ ! -d "$PROJECT_PATH" ]; then
    echo -e "${RED}❌ Project path does not exist: $PROJECT_PATH${NC}"
    exit 1
fi

TEMPLATE_PATH="$TEMPLATES_DIR/$TEMPLATE_NAME"
if [ ! -d "$TEMPLATE_PATH" ]; then
    echo -e "${RED}❌ Template not found: $TEMPLATE_NAME${NC}"
    echo -e "${YELLOW}Available templates:${NC}"
    ls -1 "$TEMPLATES_DIR" | grep -v "DEVCONTAINERS_GUIDE\|README"
    exit 1
fi

echo -e "${BLUE}🚀 Dev Container Bootstrap${NC}"
echo -e "${BLUE}========================${NC}"
echo ""
echo -e "Project: ${GREEN}$PROJECT_PATH${NC}"
echo -e "Template: ${GREEN}$TEMPLATE_NAME${NC}"
echo ""

# Create .devcontainer directory
DEVCONTAINER_DIR="$PROJECT_PATH/.devcontainer"
if [ -d "$DEVCONTAINER_DIR" ]; then
    echo -e "${YELLOW}⚠️  .devcontainer already exists${NC}"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Skipping...${NC}"
        exit 0
    fi
else
    mkdir -p "$DEVCONTAINER_DIR"
    echo -e "${GREEN}✅ Created $DEVCONTAINER_DIR${NC}"
fi

# Copy template files
echo -e "${BLUE}📋 Copying template files...${NC}"
cp "$TEMPLATE_PATH/devcontainer.json" "$DEVCONTAINER_DIR/"
cp "$TEMPLATE_PATH/Dockerfile" "$DEVCONTAINER_DIR/"
cp "$TEMPLATE_PATH/postCreateCommand.sh" "$DEVCONTAINER_DIR/"
chmod +x "$DEVCONTAINER_DIR/postCreateCommand.sh"
echo -e "${GREEN}✅ Copied template configuration${NC}"

# Copy README if it exists
if [ -f "$TEMPLATE_PATH/README.md" ]; then
    cp "$TEMPLATE_PATH/README.md" "$DEVCONTAINER_DIR/README.md"
    echo -e "${GREEN}✅ Copied template README${NC}"
fi

echo ""
echo -e "${GREEN}✅ Dev Container configuration complete!${NC}"
echo ""
echo -e "${BLUE}📝 Next steps:${NC}"
echo "1. Open the project in VS Code:"
echo -e "   ${YELLOW}code $PROJECT_PATH${NC}"
echo ""
echo "2. Install 'Dev Containers' extension if not already installed"
echo "   Run in VS Code: ${YELLOW}code --install-extension ms-vscode-remote.remote-containers${NC}"
echo ""
echo "3. Open the dev container:"
echo "   - Press ${YELLOW}Ctrl+Shift+P${NC} (or ${YELLOW}Cmd+Shift+P${NC} on macOS)"
echo "   - Search: ${YELLOW}Dev Containers: Reopen in Container${NC}"
echo "   - Or press: ${YELLOW}F1 > Dev Containers: Open Folder in Container${NC}"
echo ""
echo "4. Wait for container to build and initialize"
echo "   - Dockerfile will build the image"
echo "   - postCreateCommand.sh will:"
echo "     • Clone dotfiles repo"
echo "     • Apply chezmoi configurations"
echo "     • Install project dependencies"
echo ""
echo "5. Verify aliases work inside container:"
echo "   ${YELLOW}ls${NC}   # Should show icons with eza"
echo "   ${YELLOW}lg${NC}   # Should open lazygit"
echo "   ${YELLOW}v${NC}    # Should open neovim"
echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
echo "Read $TEMPLATES_DIR/DEVCONTAINERS_GUIDE.md for:"
echo "  • Port forwarding and networking"
echo "  • Volume mounts and workspace folders"
echo "  • Environment variables"
echo "  • Lifecycle hooks (initializeCommand, postCreateCommand, etc.)"
echo "  • VS Code extensions and settings"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"
