# CLI Linux Workflow Guide

Complete bootstrap and usage guide for WSL2 Linux development environment managed by chezmoi.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Architecture Overview](#architecture-overview)
3. [Tool Reference](#tool-reference)
4. [Daily Workflows](#daily-workflows)
5. [Configuration](#configuration)
6. [Troubleshooting](#troubleshooting)
7. [Full Bootstrap from Scratch](#full-bootstrap-from-scratch)

---

## Quick Start

### First Time Using This Setup

1. **Open Alacritty** (Windows)
   - You'll automatically land in WSL2 Ubuntu-24.04
   - Should see the Starship prompt (warm colors on dark background with Gruvbox Dark theme)

2. **Verify everything works**
   ```bash
   zsh --version          # Should show 5.x
   nvim --version         # Should show v0.12+
   kubectl get nodes      # Should show 4 cluster nodes
   ?? what is kubectl     # Should return AI explanation via Fabric
   ```

3. **Update plugins & packages (optional, runs daily)**
   ```bash
   # In zsh, press Ctrl+Space then p (tmux shortcut to list plugins)
   # Or run manually:
   chezmoi update         # Sync latest dotfiles changes
   nvim "+Lazy update"    # Update Neovim plugins
   tmux list-plugins      # View installed tmux plugins
   ```

### Keyboard Shortcuts Quick Reference

| Action | Keys |
|--------|------|
| **Tmux prefix** | `Ctrl+b` (standard tmux default) |
| **Vim escape** | `ESC` (standard vim) |
| **LazyVim leader** | `Space` |
| **Fzf find files** | `Ctrl+P` (in zsh) |
| **Fzf find history** | `Ctrl+R` (in zsh) |
| **AI explain command** | `?? your question` |
| **Tmux new pane** | `Ctrl+b` then `%` (vertical) or `"` (horizontal) |
| **Navigate tmux panes** | `Ctrl+b` then arrow keys |

---

## Architecture Overview

### Directory Structure

```
~/ (home directory)
├── .config/
│   ├── nvim/                    # Neovim + LazyVim config
│   │   ├── init.lua             # Entry point
│   │   ├── lua/config/          # Core settings
│   │   │   ├── keymaps.lua      # Key bindings
│   │   │   ├── options.lua      # Vim options
│   │   │   └── lazy.lua         # Plugin manager setup
│   │   ├── lua/plugins/         # Custom plugin configs
│   │   │   ├── obsidian.lua     # Notes editing
│   │   │   └── tmux.lua         # Pane navigation
│   │   └── lazy-lock.json       # Plugin versions (auto-updated)
│   ├── starship.toml            # Prompt config (Gruvbox Dark theme)
│   ├── lazygit/config.yml       # Git TUI config
│   ├── k9s/config.yaml          # Kubernetes TUI config
│   └── .ssh/                    # SSH keys (persistent)
├── .local/
│   ├── bin/                     # Custom binaries
│   │   ├── nvim → nvim-linux-x86_64/bin/nvim
│   │   ├── kubectl
│   │   ├── k9s
│   │   ├── flux
│   │   ├── helm
│   │   └── fabric
│   └── share/nvim/
│       ├── lazy/                # LazyVim plugins (38 total)
│       └── mason/packages/      # Language servers
├── .tmux/
│   └── plugins/tpm/             # Tmux Plugin Manager
├── .local/share/zinit/          # Zsh plugin manager
├── notes/                       # Zettelkasten vault (separate git repo)
│   ├── 00-inbox/                # Daily capture
│   ├── 10-zettelkasten/         # Permanent notes
│   ├── 20-projects/             # Project notes
│   ├── 30-areas/                # Ongoing areas
│   ├── 40-resources/            # Reference material
│   ├── 50-archive/              # Completed/old notes
│   └── templates/               # Note templates
├── .secrets/                    # (700 perms) API keys, credentials
│   └── (not in dotfiles!)
├── .zshrc                       # Zsh config
├── .tmux.conf                   # Tmux config
└── .gitconfig                   # Git config with delta pager
```

### Dotfiles Repository

```
C:\Users\jason\Documents\GitLab\dotfiles/  (Windows path)
= /mnt/c/Users/jason/Documents/GitLab/dotfiles (WSL path)

chezmoi source directory
├── README.md                    # This repo's docs
├── .chezmoiignore              # Files to skip (README.md, .sisyphus/)
├── .gitignore                  # Git ignore
├── executable_dot_zshrc        # Zsh config
├── executable_dot_tmux.conf    # Tmux config
├── executable_dot_gitconfig    # Git config
├── dot_config/
│   ├── executable_starship.toml
│   ├── k9s/config.yaml
│   ├── lazygit/config.yml
│   └── nvim/                   # Full LazyVim starter (with git removed)
└── .sisyphus/
    ├── plans/                  # Implementation plans (READ ONLY)
    └── evidence/               # QA evidence files
```

### Tool Stack

| Tool | Purpose | Version |
|------|---------|---------|
| **zsh** | Shell | 5.x |
| **zinit** | Zsh plugin manager | latest |
| **Starship** | Prompt (Gruvbox Dark) | latest |
| **tmux** | Terminal multiplexer (Ctrl+b default prefix) | 3.x |
| **Neovim** | Editor | 0.12.0 |
| **LazyVim** | Neovim config framework | v12.x |
| **kubectl** | Kubernetes CLI | 1.35.3 |
| **k9s** | Kubernetes TUI | 0.50.18 |
| **flux** | GitOps CLI | 2.8.3 |
| **helm** | Package manager | 3.20.1 |
| **fabric** | AI CLI framework | 1.4.442 |
| **lazygit** | Git TUI | latest |
| **delta** | Git diff pager | latest |
| **eza** | Modern ls | latest |
| **bat** | Modern cat | latest |
| **fd** | Modern find | latest |
| **rg** | Ripgrep (fast grep) | latest |
| **fzf** | Fuzzy finder | latest |
| **zoxide** | Smart cd | latest |

---

## Tool Reference

### Terminal & Shell

#### **Zsh** — Interactive shell
```bash
# Plugins active (via zinit):
zsh-users/zsh-autosuggestions    # Gray suggestions as you type
zsh-users/zsh-syntax-highlighting # Real-time syntax highlighting
Aloxaf/fzf-tab                   # Fuzzy autocomplete for Tab
zsh-users/zsh-completions       # Additional completions

# Useful keybindings:
jk                   # Escape from insert mode (vim keybinding)
Ctrl+R               # Fuzzy search history
Ctrl+P               # Fuzzy find files (fzf)
Tab                  # Smart autocomplete (fzf-tab)
```

#### **Starship** — Prompt (Gruvbox Dark theme)
Shows:
- Current directory (truncated)
- Git branch & status (dirty indicator)
- Kubernetes context & namespace
- Command execution time (if > 2s)
- Exit code (red X if failed)

Styled in neon pink/blue/cyan with Nerd Font icons.

#### **Zoxide** — Smart directory navigation
```bash
z kubernetes         # Jump to ~/something/kubernetes
z -                  # Go to previous directory
zi                   # Interactive fuzzy select from history
```

#### **Fzf** — Fuzzy finder
```bash
# Already integrated with zsh via keybindings
Ctrl+R               # Fuzzy search command history
Ctrl+P               # Fuzzy find files in current dir
<command> | fzf      # Pipe output to fzf for selection
```

---

### Terminal Multiplexer

#### **Tmux** — Session management
```bash
# Start/attach
tmux                 # Create new unnamed session
tmux new -s work     # Create session named "work"
tmux attach -t work  # Attach to "work" session
tmux list-sessions   # List all sessions

# Inside tmux (Ctrl+Space is prefix):
Ctrl+Space then ?    # Show all keybindings
Ctrl+Space then c    # Create new window
Ctrl+Space then |    # Split pane vertically
Ctrl+Space then -    # Split pane horizontally
Ctrl+Space then h/j/k/l  # Navigate panes (vim keys)
Ctrl+Space then H/J/K/L  # Resize panes
Ctrl+Space then r    # Reload config
Ctrl+Space then s    # Show sessions & windows

# Saved sessions (auto-restore on tmux start):
tmux kill-session -t work  # Kill session

# Ctrl+hjkl navigates seamlessly between:
# - Tmux panes (vim-tmux-navigator)
# - Neovim splits
# - Completely transparent navigation!
```

**Plugins active:**
- `tmux-sensible` — Sensible defaults
- Manual Gruvbox Dark theme (no theme plugin)

---

### Text Editor

#### **Neovim + LazyVim** — Modern editor with 38 plugins
```bash
nvim                 # Open nvim
nvim file.py         # Open specific file
nvim .               # Open file browser (Neo-tree)

# LazyVim keybindings (Space is leader):
Space ff             # Find files (Telescope)
Space fg             # Grep across files
Space e              # Toggle file explorer
Space gg             # Open lazygit (git TUI)
Space bd             # Delete buffer (close file)
Space sr             # Search & replace (grug-far)
Space ca             # Code actions (LSP)

# Normal mode:
K                    # Hover documentation (LSP)
gd                   # Go to definition
gr                   # Go to references
]d                   # Next diagnostic
[d                   # Previous diagnostic

# Insert mode:
jk                   # Escape to normal mode
Ctrl+N/P             # Next/previous autocomplete
Ctrl+Y               # Accept autocomplete

# Splits & navigation:
Ctrl+h/j/k/l         # Navigate splits (works with tmux panes too!)
:vsplit              # Vertical split
:split               # Horizontal split
Ctrl+w w             # Cycle between splits
```

**Language support** (LSPs auto-installed on first use):
- **Python** — pyright LSP, black/isort formatting, ruff linting
- **TypeScript** — typescript-language-server, eslint
- **Terraform** — terraform-ls
- **YAML/JSON** — yaml-language-server, SchemaStore.nvim
- **Markdown** — marksman, render-markdown.nvim (renders in editor!)

**Extra plugins:**
- `obsidian.nvim` — Edit Zettelkasten notes with wiki links
- `vim-tmux-navigator` — Seamless Ctrl+hjkl navigation
- `render-markdown.nvim` — Rendered markdown display (headers bold/larger, bullets formatted)
- `blink.cmp` — Smart autocomplete with AI context
- `trouble.nvim` — Diagnostic panel
- `grug-far.nvim` — Find & replace
- `flash.nvim` — Smart f/F motion
- `which-key.nvim` — Show available keybindings on Space/Ctrl

**Mason (Language Server Manager)**
```bash
# Inside nvim:
:Mason               # Open Mason UI
:MasonInstall pyright                         # Install Python LSP
:MasonInstall typescript-language-server     # Install TS LSP
:MasonUpdate         # Update all installed packages
```

---

### Git & Version Control

#### **Git with Delta & GCM**
```bash
git config --global user.name    # Show your name
git config --global core.pager   # Shows delta

# Delta is configured as pager for:
git diff             # Show diffs with syntax highlighting
git log              # Show logs with colored output
```

**Credential storage:**
- Uses Git Credential Manager (GCM)
- Supports GitHub & GitLab with OAuth
- Stores tokens securely in Windows Credential Manager
- No plaintext credentials!

#### **Lazygit** — Git TUI
```bash
lazygit              # Open lazygit
# or inside nvim:
Space gg             # Open lazygit from LazyVim

# Main views:
1                    # Status view
2                    # Files view
3                    # Branches view
4                    # Log view
5                    # Stash view

# Navigation:
hjkl                 # Move up/down/left/right
Enter                # Select/confirm
d                    # Delete (file, branch, etc)
c                    # Commit
p                    # Push
P                    # Pull
```

---

### Kubernetes & Homelab

#### **kubectl** — Kubernetes CLI
```bash
# Aliases in .zshrc:
k                    # kubectl
kns <namespace>      # Switch namespace
kctx <context>       # Switch context
kgp                  # Get pods
kgn                  # Get nodes

# Common commands:
kubectl get nodes                    # List cluster nodes
kubectl get pods -A                  # All pods all namespaces
kubectl logs <pod> -n <ns>          # View pod logs
kubectl exec -it <pod> -- bash      # Shell into pod
kubectl apply -f manifest.yaml       # Apply Kubernetes manifest
kubectl describe node k8s-cp-1       # Node details

# Completion:
kubectl completion zsh               # Generate completion script
# (Already in .zshrc)
```

#### **k9s** — Kubernetes TUI
```bash
k9s                  # Launch k9s
# (Can take 5-10 seconds to start first time)

# In k9s:
:pods                # Go to pods view
:nodes               # Go to nodes view
:ns                  # Change namespace
d                    # Delete resource
l                    # Show logs
e                    # Edit resource (opens in $EDITOR)
s                    # Shell into pod
<n>                  # Next resource
<p>                  # Previous resource
?                    # Help

# Status line shows:
CPU/Memory used by cluster
Nodes ready/total
API server status
```

#### **Flux** — GitOps
```bash
flux version         # Show client & server versions
flux get helmreleases -A    # List all Helm releases
flux get kustomizations -A  # List all kustomizations
flux logs -f         # Follow flux logs
```

#### **Helm** — Package manager
```bash
helm list            # List installed charts
helm search repo prometheus  # Search chart repos
helm install my-release prometheus-community/prometheus  # Install
helm upgrade my-release <chart>                          # Upgrade
helm uninstall my-release                                # Uninstall
```

---

### AI & Automation

#### **Fabric** — AI CLI framework
```bash
# Setup (one-time):
fabric --setup
# Enter your OpenAI or Anthropic API key

# Use via ?? function:
?? what does kubectl get pods do
?? explain this python error
?? how do i use jq

# Or pipe to fabric:
cat file.md | ai                    # Summarize via Fabric
echo "code snippet" | fabric --pattern explain_code

# Available patterns (search in ~/.config/fabric/patterns/):
fabric --pattern summarize <input
fabric --pattern explain_code <input
fabric --pattern improve_writing <input
fabric --list-patterns              # Show all available
```

**Error handling:**
```bash
?? something
# If returns: "fabric not configured — run: fabric --setup"
# Then you haven't run fabric --setup yet OR API key is missing
```

---

### Notes & Knowledge Management

#### **Obsidian** (on Windows) + **Notes vault** (on WSL2)

**Open vault:**
1. Open Obsidian (Windows desktop app)
2. "Open folder as vault"
3. Navigate to: `\\wsl$\Ubuntu-24.04\home\jason\notes`
4. Obsidian will index all notes

**Structure (PARA method):**
```
00-inbox/          Quickly capture everything here (process daily)
10-zettelkasten/   Atomic, linked permanent notes (~100 chars, 1 idea per note)
20-projects/       Temporary project-specific notes
30-areas/          Ongoing responsibilities (homelab, dev, learning)
40-resources/      Reference material you don't own
50-archive/        Completed projects, old notes
```

**Editing in Neovim:**
```bash
nvim ~/notes/10-zettelkasten/my-note.md

# In Neovim (obsidian.nvim plugin active):
:ObsidianNew test-note                    # Create new note
:ObsidianFollowLink                       # Follow [[link]] under cursor
:ObsidianBacklinks                        # Show backlinks
:ObsidianToday                            # Go to today's daily note
:ObsidianDailies                          # Open daily notes picker
```

**Templates:**
```markdown
# ~/notes/templates/daily-note.md
# {{date:YYYY-MM-DD}}

## Today's Focus
- [ ]

## Notes / Learnings

## Links to permanent notes
```

```markdown
# ~/notes/templates/zettel.md
# {{title}}

## Idea

## Context / Why it matters

## Links
- [[related-note]]

## Sources
```

**Obsidian recommended plugins (Settings → Community Plugins):**
- **Templater** — Use templates with date/title variables
- **Calendar** — Daily notes sidebar calendar
- **Dataview** — Query notes like a database (advanced)

**Git workflow:**
```bash
cd ~/notes
git add .
git commit -m "feat(notes): add kubernetes networking note"
git push              # Push to remote (your notes repo)
```

---

## Daily Workflows

### Typical Development Session

```bash
# 1. Open Alacritty → lands in zsh in WSL2

# 2. Start tmux with your workspace
tmux new -s dev

# 3. Split panes in tmux
Ctrl+Space |         # Vertical split for editor vs shell

# 4. Open nvim in left pane
nvim my-project/

# 5. Run commands in right pane
pytest tests/
docker-compose up

# 6. Navigate between panes/nvim splits seamlessly
Ctrl+h/j/k/l         # Works in BOTH tmux and nvim!

# 7. Git workflow in nvim
Space gg             # Open lazygit
# Stage, commit, push from TUI

# 8. Check Kubernetes (mid-session)
k9s                  # Open k9s TUI in new pane (Ctrl+Space c)
# Check pods, check logs, etc

# 9. Quick note during work
Ctrl+Space 2         # New window in tmux
nvim ~/notes/00-inbox/quick-thought.md
# Write note, save, return to dev pane

# 10. Exit session (autosaved)
Ctrl+Space d         # Detach from tmux
# Next time: tmux attach -t dev
```

### Python Development

```bash
# 1. Open project in nvim
nvim my-project/src/main.py

# 2. LSP attaches automatically (pyright)
# - Hover over function with K → docs appear
# - Type hints show inline
# - Errors underlined in red

# 3. Format on save
# black & isort run automatically when you save

# 4. Run tests
# In right tmux pane:
pytest -v

# 5. Check types
mypy src/

# 6. Lint
ruff check src/

# All errors appear in Space d (trouble.nvim) in editor
```

### TypeScript Development

```bash
nvim my-project/src/index.ts

# - typescript-language-server attaches
# - Type errors appear as you type
# - Go to definition: gd
# - Find all references: gr
# - Rename: Space cr (via coc or lsp)

# Run build/dev server in right tmux pane
npm run dev
```

### Terraform/Infrastructure

```bash
nvim homelab-iac/infrastructure/main.tf

# - terraform-ls provides:
#   - Resource docs on hover (K)
#   - Validation as you type
#   - Formatting on save (terraform fmt)

# Right pane:
terraform plan
terraform apply
```

### YAML/Kubernetes

```bash
nvim k8s-manifest.yaml

# - yaml-language-server checks schema
# - SchemaStore.nvim knows Kubernetes schemas
# - Autocomplete knows all Kubernetes fields
# - Format on save

# Quickly validate:
kubectl apply -f k8s-manifest.yaml --dry-run=client
```

### Markdown/Documentation

```bash
nvim docs/architecture.md

# - render-markdown.nvim renders in editor!
# - Headers appear bold/larger
# - Links highlighted
# - Code blocks syntax-colored
# - Tables formatted

# In Obsidian (open same file from Windows):
# Vault shows as `docs/` folder
# Can edit from Obsidian UI while nvim has it open
```

### Kubernetes Troubleshooting

```bash
# 1. Check cluster health quickly
k get nodes          # Alias: kgn

# 2. TUI exploration
k9s

# Navigate to problematic namespace/pod
:ns myapp
l                    # Show logs
e                    # Edit pod spec
s                    # Shell into pod

# 3. From shell in tmux pane
kubectl logs <pod> -n myapp -f --tail=100

# 4. Quick debugging
kubectl exec -it <pod> -n myapp -- bash
# Now inside pod:
curl localhost:8000/health
env | grep DEBUG
```

### Git Workflow

```bash
# 1. Check status from nvim
Space gg             # Opens lazygit

# 2. Stage files
j/k to navigate
Space to stage

# 3. Commit
c (commit)

# 4. Push
P (capital P)

# 5. View history
l (view log)

# Or use cli:
git status
git diff             # Uses delta (colored output)
git log --oneline    # Uses delta (colored output)
git add .
git commit -m "feat(api): add user authentication"
git push
```

### AI-Assisted Coding

```bash
# 1. Explain an error you see
?? AttributeError: 'NoneType' object has no attribute 'read'

# 2. Get explanation of command/tool
?? how does kubectl port-forward work

# 3. Summarize a file/docs
cat CONTRIBUTING.md | ai

# 4. Context-aware help
?? show me how to use pytest fixtures

# All goes through Fabric → your LLM (OpenAI/Anthropic)
# Responses appear in terminal (no browser needed!)
```

---

## Configuration

### Customize Your Environment

#### Zsh — Add aliases
```bash
# Edit ~/.zshrc (chezmoi-managed):
vim ~/.zshrc

# Add your aliases at the end:
alias kc="kubectl"
alias kgpa="kubectl get pods -A"
alias dc="docker-compose"

# Save and reload:
source ~/.zshrc
```

#### Tmux — Change prefix or colors
```bash
# Edit ~/.tmux.conf (chezmoi-managed):
vim ~/.tmux.conf

# Change prefix if you want (currently Ctrl+Space):
unbind C-Space
set -g prefix C-a
bind C-a send-prefix

# Save and reload:
Ctrl+Space r
```

#### Neovim — Add custom keybindings
```bash
vim ~/.config/nvim/lua/config/keymaps.lua

# Add at end of keymaps table:
map("n", "<leader>tt", ":terminal<cr>", { desc = "Terminal" })

# Or create custom plugin at ~/.config/nvim/lua/plugins/custom.lua:
return {
  {
    "your-plugin/name",
    config = function()
      -- your config
    end,
  },
}

# Reload nvim (or :Lazy update)
```

#### Starship — Customize prompt
```bash
vim ~/.config/starship.toml

# Add/modify modules:
[kubernetes]
disabled = false
symbol = "☸ "

# More at: https://starship.rs/config/
```

#### Git — Add global config
```bash
git config --global user.email "your@email.com"
git config --global user.name "Your Name"
git config --global core.editor "nvim"
git config --global init.defaultBranch "main"

# View all config:
git config --global --list
```

### Update Dotfiles from Repo

If you make changes to dotfiles locally and want to sync to repo:

```bash
# 1. Make changes (e.g., edit .zshrc)
vim ~/.zshrc

# 2. Add to chezmoi
chezmoi add ~/.zshrc

# 3. Check what changed
chezmoi diff

# 4. Commit to dotfiles repo
cd /mnt/c/Users/jason/Documents/GitLab/dotfiles
git add .
git commit -m "feat(shell): add custom aliases"
git push
```

To apply changes from repo to system:

```bash
chezmoi update          # Apply all dotfiles changes
chezmoi apply           # Same as update
chezmoi status          # Show what would change
```

---

## Troubleshooting

### "Command not found" errors

**Problem:** Tool not found even though installed
```bash
?? kubectl
# zsh: command not found: ??
```

**Solution:**
```bash
# Reload shell
exec zsh

# Or source zshrc
source ~/.zshrc

# Verify PATH includes ~/.local/bin
echo $PATH | grep -c ".local/bin"
# Should output 1 (meaning it's there)

# List what's actually in ~/.local/bin
ls -la ~/.local/bin/
# Should see: kubectl, k9s, flux, helm, fabric, etc
```

### Nvim LSP not attaching

**Problem:** Hover (K) doesn't show docs, no autocomplete
```bash
:LspInfo
# Returns: "No servers attached"
```

**Solution:**
```bash
# Check if Mason packages need install
:Mason

# Install missing LSP for your language:
# Python → pyright
# TypeScript → typescript-language-server
# Terraform → terraform-ls
# Etc

# If still not working:
:LspRestart

# If problem persists:
:LspLog          # Show LSP error log
# Read errors, may need to install language runtime
```

### Tmux panes not navigating with Ctrl+hjkl

**Problem:** Ctrl+h doesn't work between tmux panes and nvim
```bash
# Ctrl+h not working
```

**Solution:**
```bash
# Check vim-tmux-navigator is installed in nvim
:Lazy              # Search for "vim-tmux-navigator"
# Should see it listed

# In tmux, check config was loaded
tmux show -g | grep -i vim
# Should show vim-tmux-navigator bindings

# Reload tmux config
Ctrl+Space r

# Test: open nvim split, open tmux pane in different window
# Use Ctrl+h/j/k/l to move between both
```

### Fabric not working ("command not found" or "not configured")

**Problem:**
```bash
?? hello
# fabric: not found
# OR
# fabric not configured — run: fabric --setup
```

**Solution:**
```bash
# 1. Check binary exists
which fabric
ls -la ~/.local/bin/fabric

# 2. If not found, reinstall
curl -sL "https://github.com/danielmiessler/fabric/releases/download/v1.4.442/fabric_Linux_x86_64.tar.gz" | tar -xz -O > ~/.local/bin/fabric
chmod +x ~/.local/bin/fabric

# 3. If found, configure API key
fabric --setup
# Follow prompts, enter your OpenAI or Anthropic key

# 4. Test
?? test question
# Should return AI response

# 5. If still failing, check env var is set
echo $OPENAI_API_KEY
# Should print your key (or source ~/.secrets/env if using that)
```

### Kubernetes connection failing

**Problem:**
```bash
kubectl get nodes
# Unable to connect to server: dial tcp: lookup on no such host
```

**Solution:**
```bash
# 1. Check kubeconfig exists and readable
ls -la ~/.kube/config
file ~/.kube/config       # Should say "ASCII text"

# 2. Check cluster is accessible from Windows
# In Windows PowerShell:
ping homelab-server       # Verify network connectivity

# 3. Verify kubeconfig points to right cluster
cat ~/.kube/config | grep "server:"
# Should show your homelab cluster address

# 4. Test with k9s (more verbose errors)
k9s
# Error messages will show what's wrong

# 5. If behind firewall/VPN
# Ensure you're on same network as homelab cluster
# Or ensure VPN is connected
```

### Notes vault not accessible from Obsidian

**Problem:**
```
Obsidian: "Cannot find folder: \\wsl$\Ubuntu-24.04\home\jason\notes"
```

**Solution:**
```bash
# 1. Check WSL2 distro is running
# Windows PowerShell:
wsl -l -v
# Should show Ubuntu-24.04 as RUNNING

# 2. Check path is correct
wsl -d Ubuntu-24.04 -- ls -la ~/notes
# Should list directory contents

# 3. If WSL2 not running, start it
wsl -d Ubuntu-24.04 -- echo "hello"
# This starts the distro

# 4. In Obsidian, try again with correct UNC path
# MacOS/Linux users: /mnt/wsl/Ubuntu-24.04/home/jason/notes
# Windows users: \\wsl$\Ubuntu-24.04\home\jason\notes

# 5. If Explorer can't see \\wsl$, enable WSL integration
# Windows → Settings → Developers → WSL Integration
# Ensure it's enabled
```

### Lazy plugins not installing

**Problem:**
```bash
nvim +Lazy
# Shows "Failed to clone" or "Timeout"
```

**Solution:**
```bash
# 1. Check network connectivity
ping github.com
# Should get replies

# 2. Clear LazyVim cache and retry
rm -rf ~/.local/share/nvim/lazy
nvim "+Lazy! sync" +qa
# This re-clones all plugins

# 3. If network is slow, increase timeout
# In ~/.config/nvim/lua/config/lazy.lua:
# Add under lazy.setup():
performance = {
  rtp = {
    disabled_plugins = { ... },
  },
},
git = {
  timeout = 120,  -- 120 seconds instead of default
},

# 4. Restart nvim and try sync again
```

### SSH/Git authentication failing

**Problem:**
```bash
git push
# Permission denied (publickey)
```

**Solution:**
```bash
# 1. Check SSH key is loaded
ssh-add -l
# Should show your key

# 2. If no keys, load from ~/.ssh
ssh-add ~/.ssh/id_ed25519
# Enter passphrase if prompted

# 3. Verify GitHub/GitLab knows about key
# Add public key to your account:
cat ~/.ssh/id_ed25519.pub | clip  # Copy to clipboard
# GitHub → Settings → SSH and GPG keys → New SSH key
# GitLab → Settings → SSH Keys

# 4. Test connection
ssh -T git@github.com
# Should return greeting

# 5. Use Git Credential Manager (already configured)
# Next git push, it will prompt for OAuth
# Select "GitHub (Oauth)" or "GitLab"
# Browser will open, you authorize, done
```

---

## Full Bootstrap from Scratch

### If you need to set up on a new machine

#### Step 1: Install prerequisites (Windows side)

```powershell
# Winget (already installed on Win11)
# Install essential tools:
winget install Git.Git
winget install 9P9TQF7MRM4R  # Alacritty
winget install OpenJS.NodeJS
winget install Hashicorp.Terraform
```

#### Step 2: Enable WSL2 and install Ubuntu

```powershell
# Enable WSL2
wsl --install

# Restart computer, then:
wsl --install Ubuntu-24.04

# Set up Ubuntu:
# - Create username: jason
# - Create password (will use for sudo)
```

#### Step 3: Install from dotfiles repo (in WSL2)

```bash
# In WSL2 (Ubuntu terminal or Alacritty):
curl -fsSLO https://get.chezmoi.io/chezmoi-linux-x86_64
sudo chmod +x chezmoi-linux-x86_64
sudo mv chezmoi-linux-x86_64 /usr/local/bin/chezmoi

# Clone and apply dotfiles:
chezmoi init --apply https://gitlab.com/jason/dotfiles

# Done! Everything installed and configured
# Source .zshrc:
exec zsh
```

#### Step 4: Manual post-setup

```bash
# 1. Set default shell to zsh
chsh -s /usr/bin/zsh

# 2. Set up fabric (optional but useful)
fabric --setup
# Enter your OpenAI/Anthropic API key

# 3. Configure git
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# 4. Test everything
zsh --version
nvim --version
kubectl get nodes
k9s
?? test

# 5. Set up kubeconfig if needed
# Copy from homelab server:
scp user@homelab:/etc/kubeconfig ~/.kube/config
chmod 600 ~/.kube/config
```

#### Step 5: Customize

```bash
# Add your aliases to .zshrc
chezmoi edit ~/.zshrc
# Add your lines, save

# Update dotfiles repo if you made changes
chezmoi add ~/.zshrc
cd /mnt/c/Users/jason/Documents/GitLab/dotfiles
git add .
git commit -m "chore: customize aliases"
git push
```

---

## Quick Reference Card

### Terminal Shortcuts
| Action | Keys |
|--------|------|
| Search command history | Ctrl+R |
| Fuzzy find files | Ctrl+P |
| Complete with fzf | Tab |
| Undo last command | Ctrl+Z then `fg` |
| Clear screen | Ctrl+L |
| Go to start of line | Home or Ctrl+A |
| Go to end of line | End or Ctrl+E |

### Tmux Shortcuts
| Action | Keys |
|--------|------|
| Prefix | Ctrl+Space |
| New pane (vertical) | Prefix then `\|` |
| New pane (horizontal) | Prefix then `-` |
| Navigate panes | Ctrl+h/j/k/l |
| Resize panes | Prefix then Shift+hjkl |
| New window | Prefix then `c` |
| Kill pane | Prefix then `x` |
| Zoom pane | Prefix then `z` |
| Detach | Prefix then `d` |

### Nvim Shortcuts
| Action | Keys |
|--------|------|
| Save | `:w` |
| Quit | `:q` |
| Save & quit | `:wq` |
| Find files | `Space ff` |
| Grep | `Space fg` |
| File browser | `Space e` |
| Git UI | `Space gg` |
| Hover docs | `K` |
| Go to def | `gd` |
| Go to refs | `gr` |
| Next error | `]d` |

### Kubernetes Shortcuts
| Tool | Command | Purpose |
|------|---------|---------|
| kubectl | `kgn` | Get nodes |
| kubectl | `kgp` | Get pods |
| kubectl | `kctx` | Switch context |
| kubectl | `kns` | Switch namespace |
| k9s | `k9s` | Launch TUI |
| lazygit | `lazygit` | Git TUI |
| flux | `flux version` | Check flux |

---

## Additional Resources

- **Chezmoi docs**: https://www.chezmoi.io
- **LazyVim docs**: https://lazyvim.org
- **Tmux docs**: https://github.com/tmux/tmux
- **Neovim docs**: `:help` in nvim
- **Kubernetes docs**: https://kubernetes.io/docs
- **Fabric patterns**: ~/.config/fabric/patterns/
- **Zettelkasten method**: https://zettelkasten.de/introduction/

---

## Support

If something breaks:

1. **Check logs**: `chezmoi status`, `:LspLog`, `kubectl logs`, `k9s`
2. **Rebuild plugins**: `nvim "+Lazy! sync" +qa`, `tmux run-shell ~/.tmux/plugins/tpm/scripts/install_plugins.sh`
3. **Reload config**: `source ~/.zshrc`, `Ctrl+Space r` (tmux), `:Lazy update` (nvim)
4. **Last resort**: Reinstall from dotfiles repo: `chezmoi apply --force`

Happy coding! 🚀
