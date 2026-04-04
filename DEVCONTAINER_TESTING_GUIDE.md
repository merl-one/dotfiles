# Phase 6: Dev Container Testing & Validation Guide

## Overview

This guide provides step-by-step instructions for testing dev container configurations created in Phases 1-5. Testing validates that:
- Dockerfiles build successfully
- Post-create scripts execute without errors
- Dotfiles integration works (chezmoi applies configurations)
- Aliases are available inside containers
- Project dependencies install correctly
- Port forwarding works as expected

## Prerequisites

- **Docker Desktop**: Running and connected
- **VS Code**: Installed with "Dev Containers" extension
- **Git**: Available in local system
- **Projects**: RAG system and infrastructure containers already set up

## Quick Reference: Dev Containers Lifecycle

```
1. devcontainer.json loads (defines image, ports, environment)
2. Image builds from Dockerfile (if not cached)
3. Container starts
4. initializeCommand runs (on host, not in container)
5. onCreateCommand runs (in container, as root)
6. updateContentCommand runs (in container, optional)
7. postCreateCommand runs (in container, as root) ← DOTFILES INSTALLED HERE
8. postStartCommand runs (in container, when restarted)
9. postAttachCommand runs (in container, when VS Code connects)
```

## Testing Procedure

### Test 1: RAG System Container

#### Step 1: Verify Configuration Files

```bash
cd ~/Documents/GitLab/ai-infra-workflow/rag-system
ls -la .devcontainer/

# Expected output:
# drwxr-xr-x   devcontainer.json
# drwxr-xr-x   Dockerfile
# drwxr-xr-x   postCreateCommand.sh
# drwxr-xr-x   README.md
```

#### Step 2: Open in Dev Container (VS Code)

1. Open the RAG system folder in VS Code:
   ```bash
   code ~/Documents/GitLab/ai-infra-workflow/rag-system
   ```

2. Press `F1` (or `Ctrl+Shift+P`) and search: **"Dev Containers: Open Folder in Container"**

3. VS Code will:
   - Build the Docker image (first time takes ~5-10 minutes)
   - Start the container
   - Mount the workspace folder
   - Run the post-create script

#### Step 3: Verify Inside Container

Once inside the container (you'll see `><` in the terminal), run:

```bash
# Check Python installation
python --version  # Should show Python 3.11.x

# Check Poetry
poetry --version  # Should show Poetry 1.x.x

# Check ml dependencies
python -c "import torch; print(f'PyTorch: {torch.__version__}')"
python -c "import sentence_transformers; print('Sentence Transformers: OK')"

# Check git
git --version

# Check zsh is available
which zsh

# Check chezmoi installed
which chezmoi
```

#### Step 4: Test Dotfiles Integration

```bash
# Verify dotfiles were cloned
ls -la ~/.dotfiles

# Verify chezmoi applied configurations
ls -la ~/.config/nvim          # Neovim config
ls -la ~/.config/starship.toml # Starship prompt
cat ~/.tmux.conf | grep "status-position"  # Should show "top"

# Test aliases (CRITICAL - shows dotfiles worked)
lg      # Should show lazygit menu
ls      # Should show files with icons (eza)
la      # Should show hidden files with icons
v       # Should open nvim
k       # Should show kubectl help
gs      # Should show git status
gp      # Should show git pull (or error if no remote)
gm      # Should show git commit help (or error if wrong args)
```

#### Step 5: Test Ports

In the container, start a test server:

```bash
# Start a simple Python HTTP server on port 8000
python -m http.server 8000
```

In VS Code output, you should see a notification: **"Port 8000 is available"** with an option to "Open in Browser".

Click it to verify port forwarding works.

#### Step 6: Test Dependencies

```bash
# Verify project dependencies would install
cd /workspace
poetry install --with dev --dry-run  # Dry run - don't actually install

# Or if pyproject.toml exists:
poetry install --with dev  # Actually install
```

### Test 2: Python Template Container

Use the bootstrap script to quickly test:

```bash
# From dotfiles repo root:
cd ~/Documents/GitLab/dotfiles

# Initialize a test project with Python template
bash scripts/devcontainer-init.sh ~/tmp/test-python-project python

# Then test it:
cd ~/tmp/test-python-project
code .
# Press F1 → "Dev Containers: Open Folder in Container"
```

Inside container, verify:

```bash
python --version        # Python 3.11
poetry --version        # Poetry installed
ls                       # Icons showing (eza + nerd font)
lg                       # lazygit alias works
v                        # nvim alias works
```

### Test 3: Node Template Container

```bash
# Initialize test project
bash scripts/devcontainer-init.sh ~/tmp/test-node-project node

# Test it
cd ~/tmp/test-node-project && code .
# Press F1 → "Dev Containers: Open Folder in Container"
```

Inside container:

```bash
node --version          # Node 20+
npm --version           # NPM installed
ls                       # Icons (eza)
v                        # Neovim works
gs                       # Git shortcuts work
```

### Test 4: Terraform Template Container

```bash
# Initialize test project
bash scripts/devcontainer-init.sh ~/tmp/test-infra-project terraform

# Test it
cd ~/tmp/test-infra-project && code .
# Press F1 → "Dev Containers: Open Folder in Container"
```

Inside container:

```bash
terraform version       # Terraform installed
ansible --version       # Ansible installed
kubectl version         # kubectl installed
helm version            # helm installed
aws --version           # AWS CLI installed
azure --version         # Azure CLI installed

# Test aliases
k                        # kubectl works
v                        # neovim works
gs                       # git status works
```

## Validation Checklist

For each container tested, mark these boxes:

### RAG System Container
- [ ] devcontainer.json loads without errors
- [ ] Dockerfile builds successfully
- [ ] Python 3.11 installed
- [ ] Poetry installed and functional
- [ ] ML dependencies available (torch, sentence-transformers)
- [ ] Dotfiles cloned to ~/.dotfiles
- [ ] Aliases work (lg, ls, v, k, gs, gp, gm)
- [ ] Port 8000 forwards correctly
- [ ] Port 6333 forwards correctly
- [ ] Post-create script completes without errors

### Python Template Container
- [ ] Dockerfile builds from template
- [ ] Python 3.11 present
- [ ] Poetry installed
- [ ] Dotfiles integrated
- [ ] Aliases available
- [ ] Bootstrap script works

### Node Template Container
- [ ] Dockerfile builds from template
- [ ] Node 20 installed
- [ ] npm/pnpm installed
- [ ] TypeScript available
- [ ] Dotfiles integrated
- [ ] Aliases available

### Terraform Template Container
- [ ] Dockerfile builds from template
- [ ] Terraform installed
- [ ] Ansible installed
- [ ] kubectl installed
- [ ] Cloud CLIs (aws, azure, gcloud) installed
- [ ] Dotfiles integrated
- [ ] Aliases available

## Troubleshooting

### Issue: Docker daemon not running

**Solution**: Start Docker Desktop
```bash
# On Windows, look for Docker Desktop application
# On macOS: open -a Docker
# On Linux: sudo systemctl start docker
```

### Issue: "Dev Containers" extension not installed

**Solution**: Install via VS Code
```bash
code --install-extension ms-vscode-remote.remote-containers
```

### Issue: Aliases not working inside container

**Common cause**: Chezmoi didn't apply successfully

**Debug**:
```bash
# Inside container
ls -la ~/.dotfiles
cat ~/.dotfiles/executable_dot_zshrc | head -20

# Manually re-apply if needed
chezmoi init --apply ~/.dotfiles --force
source ~/.zshrc
lg  # Test alias again
```

### Issue: Port forwarding not working

**Debug**:
```bash
# Inside container, check port is listening
netstat -tuln | grep 8000
# or: lsof -i :8000
```

**In VS Code**: Check "Ports" tab in bottom panel

### Issue: Build fails with "chezmoi" not found

**Cause**: Chezmoi installation failed

**Fix**: The chezmoi script uses curl, verify:
```bash
# In container
curl --version
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin init only
which chezmoi
```

### Issue: Poetry install fails in post-create

**Debug**:
```bash
# Inside container
cd /workspace
poetry --version
poetry install -vv  # Verbose output to see what fails
```

## Performance Notes

### First Build
- Python image: ~2 min (slim base, minimal deps)
- Node image: ~1 min (alpine base)
- Terraform image: ~3 min (many tools to download)
- RAG image: ~5-10 min (ML libraries are large)

### Subsequent Builds
- Docker cache reuses layers, usually <30 seconds
- If dependencies change, only changed layer rebuilds

### Container Startup
- Usually 1-3 seconds after image is ready
- Post-create script takes 1-2 minutes on first run

## Success Criteria

✅ **Phase 6 Complete When**:
1. All 5 container configurations (RAG + 3 templates + infrastructure) can be opened in VS Code
2. At least one full test passes (RAG system recommended as primary test)
3. Aliases work inside containers (lg, ls, v, k, gs, gp, gm all functional)
4. Port forwarding works as expected
5. Post-create script completes without errors

✅ **Ready for Production When**:
1. All 4 validation checklists marked complete
2. No manual intervention needed to get aliases working
3. Bootstrap script successfully initializes new projects
4. Documentation has been updated with dev container section

## Testing Procedure (Alternative): DevPod CLI

**DevPod is the simpler, recommended approach.** Use this instead of the VS Code GUI for faster setup.

### Prerequisites for DevPod Testing

- **DevPod**: Installed (https://devpod.sh/)
- **Docker or Podman**: Running and available
- **Projects**: Same as VS Code testing above

### Installation

```bash
# macOS/Linux
curl -sSL https://devpod.sh/install.sh | sh

# Windows (PowerShell)
iwr https://devpod.sh/install.ps1 | iex
```

### Test 1: RAG System with DevPod

```bash
# Navigate to project
cd ~/Documents/GitLab/ai-infra-workflow/rag-system

# Start container with DevPod
devpod up .

# DevPod will:
# 1. Auto-detect .devcontainer/devcontainer.json
# 2. Build image if not cached
# 3. Start container
# 4. Mount project directory
# 5. Run postCreateCommand
# 6. Drop into container shell
```

#### Verify Inside Container

```bash
# Same validations as VS Code approach:
python --version
poetry --version
python -c "import torch; print(torch.__version__)"

# Check dotfiles applied
ls -la ~/.dotfiles
which lg  # Should find lazygit alias

# Test aliases
lg        # Opens lazygit
ls        # Shows eza with icons
v         # Opens nvim
```

### Test 2: Infrastructure Container with DevPod

```bash
cd ~/homelab-iac
devpod up .

# Inside container:
terraform --version
ansible --version
kubectl version
which k   # kubectl alias
```

### Test 3: Python Template with DevPod

```bash
# Create test project
mkdir /tmp/test-python && cd /tmp/test-python
git init

# Copy template
mkdir -p .devcontainer
cp ~/dotfiles/templates/python/* .devcontainer/

# Start with DevPod
devpod up .

# Verify
python --version
poetry --version
ls   # aliases work
```

### Common DevPod Troubleshooting

**"devpod: command not found"**
- Ensure it's installed and in PATH
- Try full path: `~/.local/bin/devpod` (Linux) or check Program Files (Windows)

**"Container exits immediately"**
```bash
# Check logs
devpod logs .
devpod logs . --follow  # Real-time logs
```

**"Dotfiles not applied"**
```bash
# Inside container, verify chezmoi ran:
cat ~/.zshrc | grep -c "alias lg"  # Should show non-zero
which chezmoi
chezmoi status
```

**"Ports not forwarding"**
```bash
# Verify port config in devcontainer.json:
cat .devcontainer/devcontainer.json | grep -A5 "forwardPorts"

# Inside container, check if service listening:
lsof -i :8000
```

### DevPod vs VS Code Comparison

| Task | DevPod | VS Code |
|------|--------|---------|
| **Startup** | `devpod up .` | F1 → search → click → wait |
| **Speed** | Faster (direct CLI) | Slower (GUI overhead) |
| **Headless Support** | ✅ Yes (CI/CD) | ❌ No (GUI only) |
| **Learning** | Minimal | Moderate (menus) |
| **Flexibility** | Multiple backends | Docker/Podman only |

**Recommendation**: Use DevPod for new development and testing. Use VS Code extension as backup if GUI preferred.

## Next Steps

After completing Phase 6-7 testing:

1. **Phase 8a**: Validate DevPod works with all 5 containers
2. **Phase 8b**: Document DevPod as primary workflow
3. **Phase 8c**: Create DEVPOD_WORKFLOW.md guide (DONE)
4. **Phase 8d**: Update main README with DevPod quickstart (DONE)
5. **Phase 8e**: Commit final changes
6. **Phase 8f**: (Optional) Implement advanced features:
   - Multi-container setup with docker-compose
   - GPU support (if applicable)
   - Custom volume mounts
   - Additional service containers (Qdrant, PostgreSQL, etc.)

## References

- [Dev Containers Spec](https://containers.dev/)
- [VS Code Remote Containers](https://code.visualstudio.com/docs/remote/remote-overview)
- [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Chezmoi Documentation](https://www.chezmoi.io/)

---

**Last Updated**: 2026-04-05  
**Author**: Development Coordinator  
**Status**: In Progress - Phase 6 Testing
