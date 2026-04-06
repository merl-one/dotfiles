# Dotfiles

Managed by [chezmoi](https://www.chezmoi.io). Bootstraps a complete Linux CLI development environment on WSL2 or bare Linux.

## Quick Bootstrap

```bash
# 1. Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# 2. Init and apply from this repo
chezmoi init --apply https://github.com/merl-one/dotfiles.git
```

## What's Included

- **zsh** + standard completion (autosuggestions, syntax highlighting)
- **tmux** + minimal TPM with Gruvbox Dark theme and `Ctrl+b` prefix (default)
- **Neovim** + LazyVim with gruvbox.nvim theme and LSPs for Python, TypeScript, Terraform, YAML
- **Starship** prompt with git and Kubernetes context
- **Alacritty** terminal config (Windows-side, targets WSL2)
- **git** config with delta diff pager and lazygit
- **Homelab CLI** tools: k9s, kubectl aliases, talosctl, flux
- **Fabric** AI integration with `??` shortcut

## Manual Bootstrap Steps

For a new machine, after `chezmoi init --apply`:

```bash
# Install zinit plugins
zsh -i -c "zinit update --all"

# Install tmux plugins
tmux new -d && tmux run-shell ~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Install LazyVim plugins (headless)
nvim --headless "+Lazy! sync" +qa
```

## Alacritty Configuration (Windows)

Alacritty config is located at: `C:\Users\%USERNAME%\AppData\Roaming\alacritty\alacritty.toml`

The current configuration uses:
- **Font**: JetBrains Mono Nerd Font (provides Nerd Font icons for `ls` output)
- **WSL2**: Targets `Ubuntu-24.04` distribution
- **Theme**: Gruvbox Dark (matches tmux, vim, and starship)
- **Startup**: zsh automatically launches and starts in home directory (`~`)

**Font Installation**: JetBrains Mono Nerd Font files must be installed to `C:\Windows\Fonts\` before Alacritty will render correctly. The font registers as `"JetBrains Mono"` in the system font registry.

## Dev Containers (Project-Specific Environments)

This repo includes **Dev Container templates** for isolated, reproducible project development environments. Each template includes:
- Pre-configured Dockerfile with language-specific tools
- Automatic dotfiles sourcing (aliases, vim config, tmux setup)
- Port forwarding configuration
- Health checks and lifecycle hooks
- VS Code integration (optional, language extensions, debugging, testing)

### Quick Start: Using DevPod (Recommended)

[DevPod](https://devpod.sh/) is the simplest way to spin up dev containers. It works with Docker, Podman, SSH, VMs, and more.

```bash
# 1. Install DevPod (one-time)
# macOS/Linux:
curl -sSL https://devpod.sh/install.sh | sh

# Windows (PowerShell):
iwr https://devpod.sh/install.ps1 | iex

# 2. Navigate to your project
cd ~/my-project

# 3. Start the container
devpod up .
# DevPod auto-detects .devcontainer/devcontainer.json and starts the environment

# 4. Inside the container, verify everything works
python --version       # Python 3.11 (or Node 20 for Node template)
ls                      # Should show icons (eza with Nerd Font)
lg                      # lazygit alias works
v                       # Opens nvim with your config
k                       # kubectl alias works
gs/gp/gm                # git shortcuts work
```

### Alternative: VS Code Dev Containers Extension

If you prefer the VS Code GUI:

```bash
# 1. Install VS Code Dev Containers extension
# From VS Code: F1 → "Extensions: Install Extensions" → search "Dev Containers" → install Microsoft's extension

# 2. Initialize dev container from template (one-time per project)
bash ~/dotfiles/scripts/devcontainer-init.sh . python
# Available templates: python, node, terraform

# 3. Open in VS Code
code .

# 4. Press F1 → "Dev Containers: Reopen in Container"
# VS Code will build the image and start the container

# 5. Inside container, verify everything works (same as DevPod approach)
```

### Quick Start: New Project with Dev Container

```bash
# 1. Clone or create your project
mkdir ~/my-project && cd ~/my-project

# 2. Option A: Copy template manually (for VS Code workflow)
cp -r ~/dotfiles/templates/python .devcontainer
# Available templates: python, node, terraform

# 2. Option B: Use bootstrap script (for VS Code workflow)
bash ~/dotfiles/scripts/devcontainer-init.sh . python

# 3. Then use either DevPod or VS Code extension (see above)
devpod up .
# or
code . && F1 → "Dev Containers: Reopen in Container"
```

### Available Templates

| Template | Use Case | Includes |
|----------|----------|----------|
| **python** | Python projects, FastAPI, ML | Python 3.11, Poetry, black, ruff, pytest |
| **node** | TypeScript, Node.js, MCP servers | Node 20, npm, pnpm, TypeScript, ESLint |
| **terraform** | Infrastructure-as-code, Ansible | Terraform, Ansible, kubectl, Helm, cloud CLIs |

### Existing Project Containers

- **RAG System**: `ai-infra-workflow/rag-system/.devcontainer/` (Python + ML)
- **Infrastructure**: `homelab-iac/.devcontainer/` (Terraform + Ansible)

### Documentation

- **Setup & Configuration**: See `templates/DEVCONTAINERS_GUIDE.md` (400+ lines, comprehensive)
- **Testing Instructions**: See `DEVCONTAINER_TESTING_GUIDE.md` (step-by-step validation)
- **Project-Specific**: Each `.devcontainer/README.md` has project-specific workflows

## Structure

```
dotfiles/
├── dot_zshrc                    # zsh config (chezmoi managed)
├── dot_tmux.conf                # tmux config
├── .chezmoitemplates/           # chezmoi templates
├── dot_config/
│   ├── starship.toml            # Starship prompt
│   ├── nvim/                    # LazyVim config
│   ├── lazygit/                 # lazygit config
│   └── k9s/                     # k9s config
├── templates/                   # Dev container templates
│   ├── python/                  # Python 3.11 template
│   ├── node/                    # Node.js 20 template
│   ├── terraform/               # Terraform/Ansible template
│   ├── DEVCONTAINERS_GUIDE.md   # Comprehensive reference
│   └── README.md                # Quick start
├── scripts/
│   └── devcontainer-init.sh     # Bootstrap script for new projects
├── plans/active/
│   └── dev-containers-setup.md  # Implementation plan
├── DEVCONTAINER_TESTING_GUIDE.md # Testing & validation guide
└── README.md                    # This file
```
