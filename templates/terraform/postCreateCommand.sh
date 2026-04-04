#!/bin/bash
# Post-create script for Terraform/Ansible dev container

set -e

echo "🏗️ Setting up Infrastructure development environment..."

# 1. Clone dotfiles
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

# 2. Initialize Terraform if needed
if [ -f /workspace/main.tf ]; then
    echo "🔧 Initializing Terraform..."
    cd /workspace
    terraform init -upgrade 2>/dev/null || echo "⚠️ terraform init requires backend configuration"
fi

# 3. Validate Terraform
if [ -f /workspace/main.tf ]; then
    echo "✓ Validating Terraform configuration..."
    cd /workspace
    terraform validate 2>/dev/null || echo "ℹ️ Terraform validation skipped"
fi

# 4. Check Ansible
if [ -f /workspace/ansible.cfg ] || [ -f /workspace/playbook.yml ]; then
    echo "🔍 Checking Ansible setup..."
    ansible-inventory --list 2>/dev/null || echo "ℹ️ Ansible inventory not configured"
fi

echo ""
echo "✅ Infrastructure environment ready!"
echo ""
echo "📊 Environment details:"
terraform --version | head -n1
ansible --version | head -n1
kubectl version --client 2>/dev/null | head -n1
helm version 2>/dev/null | head -n1
aws --version
echo ""
echo "🚀 Ready for infrastructure work!"
