# DevPod Workflow Guide

**DevPod is the recommended way to use dev containers.** It's simpler, more flexible, and works with multiple backend environments (Docker, Podman, SSH, VMs, Kubernetes).

## Why DevPod?

| Aspect | DevPod | VS Code Extension |
|--------|--------|-------------------|
| **Setup** | `devpod up .` (one command) | Bootstrap script + F1 menu (multi-step) |
| **Backends** | Docker, Podman, SSH, VMs, K8s | Docker/Podman only |
| **Headless Support** | ✅ Yes (CI/CD, remote SSH) | ❌ No (GUI only) |
| **Port Forwarding** | Built-in, automatic | ✅ Yes |
| **Dotfiles Integration** | ✅ Works automatically | ✅ Yes |
| **Learning Curve** | Minimal | Moderate (F1 menu navigation) |

## Installation

### macOS / Linux
```bash
curl -sSL https://devpod.sh/install.sh | sh
```

### Windows (PowerShell)
```powershell
iwr https://devpod.sh/install.ps1 | iex
```

### Or install via package manager
```bash
# Homebrew (macOS/Linux)
brew install devpod

# Scoop (Windows)
scoop install devpod

# Chocolatey (Windows)
choco install devpod
```

## Quick Start

### 1. Start a Dev Container

Navigate to any project with a `.devcontainer/devcontainer.json`:

```bash
cd ~/my-project
devpod up .
```

DevPod will:
1. Auto-detect the `.devcontainer/devcontainer.json` config
2. Build the Docker image (if needed)
3. Start the container
4. Mount your project directory
5. Drop you into a shell inside the container

### 2. Verify Environment

Inside the container:
```bash
# Check Python/Node/tools
python --version          # 3.11+
node --version            # 20+
terraform --version       # Latest

# Check aliases (all should work)
ls                         # eza with icons
lg                         # lazygit
v                          # nvim with your config
k                          # kubectl
gs                         # git status
gp                         # git push
gm                         # git checkout main
```

### 3. Exit Container

```bash
exit
# or Ctrl+D
```

## Common Commands

```bash
# Start a dev container
devpod up .

# Start and attach with bash instead of default shell
devpod up . --cmd bash

# Stop container (preserve state for next `up`)
devpod stop .

# Remove container entirely
devpod delete .

# SSH into running container (without using devpod)
devpod ssh . -- zsh

# Execute command in running container without attaching
devpod exec . -- python --version

# Rebuild image (useful after changing Dockerfile)
devpod up . --rebuild

# Use a different backend (e.g., Podman instead of Docker)
devpod use podman

# List all running DevPod environments
devpod list

# Show detailed info about a container
devpod info .
```

## Backends

DevPod supports multiple backends. Switch with:

```bash
# List available backends
devpod list-backends

# Set default backend
devpod use docker      # Default
devpod use podman      # Alternative to Docker
devpod use ssh         # Remote SSH machine
devpod use kubernetes  # Kubernetes cluster
```

### SSH Backend Example
```bash
# Configure SSH backend
devpod use ssh
devpod ssh-config add myserver user@server.com

# Then start container on remote machine
devpod up .
```

## For Existing Projects

### RAG System
```bash
cd ~/ai-infra-workflow/rag-system
devpod up .

# Inside container:
# API runs on http://localhost:8000
# Qdrant runs on http://localhost:6333
```

### Infrastructure (Terraform/Ansible)
```bash
cd ~/homelab-iac
devpod up .

# Inside container:
terraform plan
ansible-playbook playbooks/deploy.yml
```

## Creating New Projects with Dev Containers

### Option 1: Manual Setup (Recommended)
```bash
# 1. Create project
mkdir ~/my-python-project && cd ~/my-python-project
git init

# 2. Copy template
mkdir -p .devcontainer
cp ~/dotfiles/templates/python/Dockerfile .devcontainer/
cp ~/dotfiles/templates/python/devcontainer.json .devcontainer/
cp ~/dotfiles/templates/python/postCreateCommand.sh .devcontainer/

# 3. Start container
devpod up .

# Inside container, your dotfiles automatically apply:
ls       # aliases work
lg       # lazygit
v        # nvim with gruvbox theme
```

### Option 2: Bootstrap Script
```bash
# One-time setup
bash ~/dotfiles/scripts/devcontainer-init.sh ~/my-project python

# Then use DevPod
cd ~/my-project
devpod up .
```

## Dotfiles Integration (Automatic)

Every container automatically:
1. Clones `https://gitlab.com/jason/dotfiles.git`
2. Applies dotfiles with chezmoi
3. Sources zshrc to make all aliases available

**No additional steps needed!** Just run `devpod up .` and aliases work.

## Troubleshooting

### "devpod: command not found"
**Solution**: Ensure DevPod is in your PATH. Reinstall:
```bash
# macOS/Linux
curl -sSL https://devpod.sh/install.sh | sh

# Windows PowerShell
iwr https://devpod.sh/install.ps1 | iex
```

### "Container exits immediately after startup"
**Cause**: Likely a postCreateCommand error. Check logs:
```bash
devpod logs .
# or detailed logs
devpod logs . --follow
```

### "Aliases don't work inside container"
**Cause**: zshrc not sourced. Verify chezmoi ran:
```bash
# Inside container:
which chezmoi           # Should show path
chezmoi status          # Check what's managed
cat ~/.zshrc | grep lg  # Verify alias exists
source ~/.zshrc         # Re-source manually if needed
```

### "Port forwarding not working"
**Solution**: Verify port in devcontainer.json:
```bash
# Inside container:
lsof -i :8000           # Check if service is listening
netstat -tuln           # List all listening ports

# Outside container:
devpod info .           # Shows port mappings
```

### "Need different shell (bash instead of zsh)"
```bash
# Force bash
devpod up . --cmd bash

# Or change in devcontainer.json's postStartCommand
```

## Best Practices

1. **Keep .devcontainer checked into git**
   ```bash
   git add .devcontainer/
   git commit -m "feat: add dev container configuration"
   ```

2. **Use devpod up . before coding**
   ```bash
   # Start of workday
   devpod up .
   # Guarantees reproducible environment
   ```

3. **Stop containers when done**
   ```bash
   devpod stop .
   # Preserves container state for faster next startup
   ```

4. **Rebuild after Dockerfile changes**
   ```bash
   # If you modified Dockerfile:
   devpod up . --rebuild
   ```

5. **Test on CI/CD with DevPod**
    ```bash
    # Your CI/CD can also use DevPod for reproducible testing
    # Install DevPod in CI image, then use same devpod up . command
    ```

## SSH & Git Authentication (Windows + WSL)

If you're using **Windows + WSL with lazygit**, you may need to set up SSH key access:

### One-time Setup (WSL)

1. **Create SSH symlink** (links WSL to Windows SSH keys):
   ```bash
   # In WSL terminal
   rm -rf ~/.ssh
   ln -s /mnt/c/Users/username/.ssh ~/.ssh
   ```

2. **Verify SSH access**:
   ```bash
   ssh -T git@gitlab.com      # For GitLab
   # or
   ssh -T git@github.com      # For GitHub
   ```

3. **Inside containers**: SSH keys are automatically available because:
   - Containers mount your `~/.ssh` directory (via devcontainer.json)
   - Your projects are git cloned, so lazygit can use SSH
   - The dotfiles (`lg` alias) pulls from git via SSH

### How It Works

```
Windows SSH Keys (~/.ssh/id_ed25519)
    ↓
WSL symlink (~/.ssh → /mnt/c/Users/username/.ssh)
    ↓
Container mount (volume: ~/.ssh)
    ↓
lazygit inside container (uses SSH automatically)
```

### Troubleshooting

- **"Permission denied (publickey)" in lazygit**: Verify SSH works in WSL first (`ssh -T git@gitlab.com`)
- **SSH key not found**: Check the symlink: `ls -l ~/.ssh/id_ed25519`
- **Too open permissions error**: SSH permissions are strict on Windows files; use `ssh-add` to cache the key

## Advanced: Custom DevPod Workspace

DevPod can manage multiple workspaces. See: https://devpod.sh/docs

```bash
# Named workspace
devpod up github.com/user/repo

# Auto-clones repo and starts container
```

## References

- **DevPod Docs**: https://devpod.sh/docs
- **Dev Containers Spec**: https://containers.dev/
- **GitHub DevPod**: https://github.com/loft-sh/devpod

## Next Steps

1. Install DevPod: `curl -sSL https://devpod.sh/install.sh | sh`
2. Try with existing project: `cd ~/ai-infra-workflow/rag-system && devpod up .`
3. Verify aliases work inside container
4. Use for all future dev work!
