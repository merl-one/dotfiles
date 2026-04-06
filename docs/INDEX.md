# 📚 Dotfiles Documentation

This directory contains all documentation for the dotfiles repository. 

## 📖 Main Guides

- **[BEGINNER_WORKFLOW.md](./BEGINNER_WORKFLOW.md)** - Getting started with chezmoi and setting up your environment
- **[DEVPOD_SETUP.md](./DEVPOD_SETUP.md)** - Setting up SSH, Git authentication, and dev containers with DevPod
- **[QUICK_REFERENCE.md](./QUICK_REFERENCE.md)** - Quick reference for common commands and aliases
- **[GUIDES.md](./GUIDES.md)** - Comprehensive usage guide and configuration details

## 🏗️ Architecture & Implementation

- **[../templates/DEVCONTAINERS_GUIDE.md](../templates/DEVCONTAINERS_GUIDE.md)** - Dev container setup and configuration
- **[../templates/README.md](../templates/README.md)** - Dev container templates overview

## 📝 Archive

Archived project completion notes and session summaries are stored in [./ARCHIVE/](./ARCHIVE/).

These documents track the development phases and should be referenced for context on past decisions.

## 🚀 Quick Start

1. **Install chezmoi**:
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)"
   ```

2. **Apply dotfiles**:
   ```bash
   chezmoi init --apply https://github.com/merl-one/dotfiles.git
   ```

3. **Post-install**:
   ```bash
   # Install zinit plugins
   zsh -i -c "zinit update --all"
   
   # Install tmux plugins
   tmux new -d && tmux run-shell ~/.tmux/plugins/tpm/scripts/install_plugins.sh
   
   # Install LazyVim plugins
   nvim --headless "+Lazy! sync" +qa
   ```

4. **Start using**:
   ```bash
   lg              # lazygit
   v               # nvim
   k               # kubectl
   gs/gp/gm        # git shortcuts
   ```

## 📂 Directory Structure

```
dotfiles/
├── README.md                      # Main readme
├── docs/
│   ├── INDEX.md                   # This file
│   ├── BEGINNER_WORKFLOW.md       # Getting started
│   ├── DEVPOD_SETUP.md            # DevPod/SSH setup
│   ├── GUIDES.md                  # Comprehensive guides
│   ├── QUICK_REFERENCE.md         # Command reference
│   └── ARCHIVE/                   # Project completion notes
├── dot_config/                    # Configuration files (chezmoi-managed)
│   ├── opencode/                  # OpenCode agent configuration
│   ├── nvim/                      # Neovim + LazyVim
│   ├── lazygit/                   # Lazygit theme & keybinds
│   ├── starship.toml              # Starship prompt
│   └── k9s/                       # K9s dashboard
├── executable_dot_gitconfig       # Git configuration (chezmoi-managed)
├── executable_dot_tmux.conf       # Tmux configuration (chezmoi-managed)
├── executable_dot_zshrc           # Zsh configuration (chezmoi-managed)
├── templates/                     # Dev container templates
│   ├── python/                    # Python 3.11 template
│   ├── node/                      # Node.js 20 template
│   └── terraform/                 # Terraform/Ansible template
└── scripts/
    └── devcontainer-init.sh       # Bootstrap script for new projects
```

## ✨ What's Included

- **zsh** with completion plugins (zinit, autosuggestions, syntax highlighting)
- **tmux** with Gruvbox Dark theme and standard keybinds
- **Neovim** with LazyVim framework and LSPs
- **Starship** prompt with git and Kubernetes context
- **Lazygit** with Catppuccin theme
- **Dev containers** for Python, Node.js, and Terraform
- **SSH setup** for GitHub and self-hosted GitLab
- **CLI tools**: k9s, kubectl, talosctl, flux

## ⚙️ Configuration

All dotfiles are managed by [chezmoi](https://www.chezmoi.io/). Files prefixed with `dot_` are automatically placed in your home directory (e.g., `dot_zshrc` → `~/.zshrc`).

### Customization

To customize your environment:

1. Apply the dotfiles
2. Edit files directly in `~/.config/`, `~/.zshrc`, etc.
3. Changes persist automatically (no need to re-apply chezmoi)

To update dotfiles across machines:
- Make changes locally
- Commit them to git
- Run `chezmoi update` on other machines

## 🔒 Security

- SSH keys are managed separately in `~/.ssh/` (not tracked in git)
- Environment variables are stored in local `.env` files (excluded by .gitignore)
- Git uses SSH authentication (no password storage)

## 📚 Additional Resources

- [Chezmoi Documentation](https://www.chezmoi.io/)
- [LazyVim Documentation](https://www.lazyvim.org/)
- [DevPod Documentation](https://devpod.sh/)
