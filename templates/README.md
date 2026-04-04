# Dev Container Templates

Standardized `.devcontainer/` configurations for different tech stacks. Copy these into your projects to get started quickly.

## 📋 What Are Dev Containers?

Dev containers allow you to develop inside a Docker container with all dependencies pre-installed. Benefits:

- ✅ **Isolation**: Each project has its own environment
- ✅ **Reproducibility**: Same setup on all machines
- ✅ **Minimal setup**: No need to install tools on host
- ✅ **Integrated dotfiles**: All your aliases and configs work
- ✅ **IDE support**: Works with VS Code, JetBrains, Neovim

## 🚀 Quick Start

### 1. Copy a Template

```bash
# For a Python project
cp -r templates/python your-project/.devcontainer

# For Node/TypeScript
cp -r templates/node your-project/.devcontainer

# For Infrastructure (Terraform/Ansible)
cp -r templates/terraform your-project/.devcontainer
```

### 2. Open in VS Code

```bash
cd your-project
devcontainer open .
```

VS Code will:
- Detect the `.devcontainer/` configuration
- Build the Docker image
- Start the container
- Mount your project
- Run post-create setup
- Connect you to the container

### 3. Start Coding

Inside the container, all tools and aliases are ready:

```bash
ls                    # Uses eza with icons
lg                    # Opens lazygit
k get pods           # kubectl shortcut
v main.py            # Opens nvim
```

## 📦 Available Templates

### Python 3.11 (`templates/python/`)

**For projects using**: FastAPI, LangChain, Qdrant, ML/AI, data science

**What's included**:
- Python 3.11 runtime
- Poetry (dependency management)
- pip, black, ruff, mypy
- Build tools (gcc, make, git)
- Auto port forwarding: 8000 (FastAPI default)

**Example projects**:
- `ai-infra-workflow/rag-system/`
- Any FastAPI or LangChain project

**Start a new Python project**:
```bash
mkdir my-python-project
cd my-python-project
cp -r ../dotfiles/templates/python .devcontainer
devcontainer open .
# Inside container:
poetry init
poetry add fastapi uvicorn
```

### Node.js 20 (`templates/node/`)

**For projects using**: TypeScript, Express, Next.js, MCP servers

**What's included**:
- Node.js 20 LTS (latest)
- TypeScript, ts-node
- ESLint, Prettier
- npm, pnpm (package managers)
- Auto port forwarding: 3000, 8000

**Example projects**:
- MCP servers (TypeScript)
- CLI tools
- Web applications

**Start a new Node project**:
```bash
mkdir my-node-project
cd my-node-project
cp -r ../dotfiles/templates/node .devcontainer
devcontainer open .
# Inside container:
npm init
npm install typescript ts-node --save-dev
npm install express
```

### Terraform & Ansible (`templates/terraform/`)

**For projects using**: Infrastructure-as-Code, Ansible playbooks, cloud automation

**What's included**:
- Terraform (latest)
- Ansible (latest)
- AWS CLI v2
- kubectl
- Helm
- jq (JSON processor)
- Python 3 with ansible/netaddr

**Example projects**:
- Homelab infrastructure automation
- Cloud infrastructure (AWS, Azure, GCP)
- On-prem Kubernetes clusters

**Start infrastructure work**:
```bash
mkdir my-infra-project
cd my-infra-project
cp -r ../dotfiles/templates/terraform .devcontainer
devcontainer open .
# Inside container:
terraform init
terraform plan
ansible-playbook playbooks/deploy.yml
```

## 🔧 Customization

### Change Python Version

Edit `.devcontainer/Dockerfile`:
```dockerfile
# Change FROM line
FROM python:3.12-slim  # or 3.10, 3.9, etc.
```

### Add More Python Packages

Edit `.devcontainer/Dockerfile`, in the pip install section:
```dockerfile
RUN pip install --upgrade \
    pip \
    poetry \
    requests \           # Add here
    pandas \             # Add here
    numpy                # Add here
```

Or add to `pyproject.toml` and Poetry will install in post-create:
```toml
[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.104"
uvicorn = "^0.24"
```

### Change Node Version

Edit `.devcontainer/Dockerfile`:
```dockerfile
FROM node:22-alpine  # or node:18, node:20, etc.
```

### Add VS Code Extensions

Edit `.devcontainer/devcontainer.json`:
```json
"customizations": {
  "vscode": {
    "extensions": [
      "ms-python.python",
      "charliermarsh.ruff",      // Add your extensions
      "ms-vscode.makefile-tools" // here
    ]
  }
}
```

### Forward Additional Ports

Edit `.devcontainer/devcontainer.json`:
```json
"forwardPorts": [8000, 5432, 6379],
"portsAttributes": {
  "8000": { "label": "FastAPI" },
  "5432": { "label": "PostgreSQL" },
  "6379": { "label": "Redis" }
}
```

### Add Environment Variables

Edit `.devcontainer/devcontainer.json`:
```json
"containerEnv": {
  "LOG_LEVEL": "DEBUG",
  "API_KEY": "dev-key-here",
  "DATABASE_URL": "postgresql://user:pass@db:5432/mydb"
}
```

## 🔑 Key Files

Each template contains 3 files:

### `devcontainer.json`
- Main configuration file (JSON format)
- Defines image, ports, environment variables
- Specifies post-create commands
- VS Code extension list
- Required by dev container tools

### `Dockerfile`
- Builds the custom Docker image
- Installs tools and dependencies
- Multi-stage for efficiency
- Based on official language images

### `postCreateCommand.sh`
- Runs once after container starts
- Clones your dotfiles repo
- Installs project dependencies
- Verifies environment setup
- Sets up shell aliases

## 📝 Dotfiles Integration

Each template automatically:

1. **Clones your dotfiles** from `https://gitlab.com/jason/dotfiles.git`
2. **Applies configurations** using chezmoi
3. **Sources zshrc** for shell setup
4. **Activates aliases**: `lg`, `ls`, `k`, `v`, `gs`, `gp`, `gm`

Result: Your complete shell environment works inside the container!

### How It Works

Post-create script runs:
```bash
# 1. Clone dotfiles
git clone https://gitlab.com/jason/dotfiles ~/.dotfiles

# 2. Apply with chezmoi
chezmoi init --apply ~/.dotfiles

# 3. Source shell config
source ~/.zshrc

# 4. Now aliases work!
lg              # lazygit opens ✓
ls              # shows eza output ✓
k pods          # kubectl shortcut ✓
```

## 🛠️ Troubleshooting

### Issue: Container won't build

**Check Docker is running**:
```bash
docker ps
```

**Try building manually**:
```bash
cd your-project/.devcontainer
docker build -f Dockerfile -t debug-build .
```

### Issue: Aliases don't work

**Verify dotfiles cloned**:
```bash
ls -la ~/.dotfiles
cat ~/.zshrc | grep "alias lg"
```

**Source zshrc manually**:
```bash
source ~/.zshrc
alias lg  # Should show the alias definition
```

### Issue: Port forwarding doesn't work

**Check VS Code ports tab**:
- Click "Ports" tab in VS Code
- Verify port is listed and forwarded

**Manually test port**:
```bash
# Inside container
python -m http.server 8000

# From host terminal
curl http://localhost:8000
```

### Issue: Out of disk space

**Clean up Docker**:
```bash
docker system prune -a --volumes
```

### Issue: Permission denied on mounted files

**Fix in Dockerfile**:
```dockerfile
RUN chown -R $(id -u):$(id -g) /workspace
```

## 📚 Learn More

- **Dev Containers Spec**: https://containers.dev/
- **Official Templates**: https://github.com/devcontainers/templates
- **VS Code Remote Dev**: https://code.visualstudio.com/docs/remote/remote-overview
- **Docker Best Practices**: https://docs.docker.com/develop/dev-best-practices/

## 🎯 Next Steps

1. **Copy a template** to your project
2. **Customize** `devcontainer.json` if needed
3. **Test locally** with `devcontainer open .`
4. **Commit** `.devcontainer/` to your repo
5. **Share** with team members

Now everyone can develop in the exact same environment! 🎉

## ❓ Questions?

See the specific template directory:
- `python/` - Python-specific setup
- `node/` - Node.js-specific setup
- `terraform/` - Infrastructure tools setup

Or check `DEVCONTAINERS_GUIDE.md` for detailed information.
