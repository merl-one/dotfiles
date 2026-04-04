# Dotfiles

Managed by [chezmoi](https://www.chezmoi.io). Bootstraps a complete Linux CLI development environment on WSL2 or bare Linux.

## Quick Bootstrap

```bash
# 1. Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# 2. Init and apply from this repo
chezmoi init --apply https://gitlab.com/jason/dotfiles
```

## What's Included

- **zsh** + zinit plugin manager (autosuggestions, syntax highlighting, fzf-tab)
- **tmux** + TPM with Catppuccin Mocha theme and `Ctrl+Space` prefix
- **Neovim** + LazyVim with LSPs for Python, TypeScript, Terraform, YAML
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
└── README.md
```
