# Dev Container Templates Guide

This directory contains reusable Dev Container templates for different tech stacks. Each template provides a standardized `.devcontainer/` configuration that you can copy into your project.

## Quick Start

1. Choose a template matching your project (python, node, terraform, etc.)
2. Copy the template directory to your project:
   ```bash
   cp -r templates/python .devcontainer
   ```
3. Customize `devcontainer.json` if needed
4. Open in VS Code: `devcontainer open .`

## Available Templates

### Python (3.11)
**Use for**: FastAPI, LangChain, Qdrant, ML projects
- **Base image**: `python:3.11-slim`
- **Tools**: Poetry, pip, git, curl, build-essential
- **Dotfiles integration**: Yes (clones and sources zshrc)

**What's included**:
- Python 3.11 runtime
- Poetry for dependency management
- Common build tools (gcc, make, git)
- Post-create hook for dotfiles
- 8000 port forwarding (FastAPI default)

**Example projects**:
- RAG system (ai-infra-workflow/rag-system)

### Node/TypeScript (LTS)
**Use for**: MCP servers, Express, Next.js projects
- **Base image**: `node:20-alpine`
- **Tools**: npm, yarn, TypeScript, eslint, prettier
- **Dotfiles integration**: Yes

**What's included**:
- Node.js 20 LTS
- npm package manager
- TypeScript compiler
- ESLint and Prettier for code quality
- Post-create hook for dotfiles

**Example projects**:
- MCP servers
- CLI tools

### Terraform/Ansible
**Use for**: Infrastructure-as-code projects
- **Base image**: `ubuntu:24.04`
- **Tools**: Terraform, Ansible, AWS CLI, kubectl
- **Dotfiles integration**: Yes

**What's included**:
- Terraform (latest)
- Ansible
- AWS CLI v2
- kubectl
- Git for version control

**Example projects**:
- Homelab infrastructure automation
- Cloud infrastructure

## Template Structure

Each template directory contains:

```
template-name/
├── devcontainer.json      # Dev container configuration
├── Dockerfile             # Custom image definition
└── postCreateCommand.sh   # Setup script (runs once)
```

### devcontainer.json

Key properties:
- **name**: Display name for the container
- **image** or **build**: Docker image or Dockerfile to use
- **forwardPorts**: Ports to expose (e.g., [8000, 3000])
- **containerEnv**: Environment variables
- **remoteUser**: User to run commands as (default: root)
- **postCreateCommand**: Runs after container creation
- **workspaceFolder**: Where your code lives in container

### Dockerfile

Multi-stage build approach:
1. **Base stage**: Official language image
2. **Build tools stage**: Common utilities, git, curl
3. **Runtime stage**: Final image with everything needed
4. **User setup**: Create non-root user if needed

### postCreateCommand.sh

Runs once after container is created:
1. Clones dotfiles if not present
2. Sources zshrc for shell configuration
3. Installs language-specific tools
4. Verifies environment readiness

## Customization

### Changing the Python Version

In `python/devcontainer.json`:
```json
"build": {
  "context": ".",
  "dockerfile": "Dockerfile",
  "args": {
    "PYTHON_VERSION": "3.12"
  }
}
```

In `python/Dockerfile`:
```dockerfile
ARG PYTHON_VERSION=3.11
FROM python:${PYTHON_VERSION}-slim
```

### Adding More Ports

In `devcontainer.json`:
```json
"forwardPorts": [8000, 5432, 6379],
"portsAttributes": {
  "8000": { "label": "FastAPI", "onAutoForward": "notify" },
  "5432": { "label": "PostgreSQL" },
  "6379": { "label": "Redis" }
}
```

### Custom Environment Variables

In `devcontainer.json`:
```json
"containerEnv": {
  "LOG_LEVEL": "DEBUG",
  "PYTHONUNBUFFERED": "1"
}
```

### VS Code Extensions

In `devcontainer.json`:
```json
"customizations": {
  "vscode": {
    "extensions": [
      "ms-python.python",
      "ms-python.vscode-pylance",
      "charliermarsh.ruff",
      "ms-vscode.makefile-tools"
    ]
  }
}
```

## Dotfiles Integration

Each template includes a post-create hook that:

1. Clones your dotfiles repo (via HTTPS)
2. Runs `chezmoi apply` to set up configs
3. Sources zshrc so aliases work

The hook looks for dotfiles at:
```
https://gitlab.com/jason/dotfiles
```

Inside container, files appear at:
```
~/.dotfiles/           # Cloned repo
~/.config/             # Symlinked by chezmoi
~/.zshrc               # Updated by chezmoi
```

### Result: Aliases Work Everywhere

Once the post-create hook runs:
```bash
# Inside container
lg              # Opens lazygit ✓
ls              # Uses eza with icons ✓
k               # kubectl shortcut ✓
v               # nvim shortcut ✓
gs, gp, gm      # git aliases ✓
```

## Usage Workflow

### Opening in VS Code (Recommended)

```bash
# 1. Clone your project
git clone <your-repo>
cd <your-project>

# 2. Open in VS Code with dev container
devcontainer open .

# 3. VS Code will:
# - Detect .devcontainer/ configuration
# - Build the Docker image
# - Start the container
# - Mount your project inside
# - Run postCreateCommand
# - Connect to the container
```

### Using CLI (Headless)

```bash
# Build the container
docker build -f .devcontainer/Dockerfile -t my-project:dev .

# Run in interactive shell
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  my-project:dev \
  /bin/zsh

# Now you have all tools and aliases ready
lg
ls
pytest
```

### Multiple Containers (Docker Compose)

For projects with services (PostgreSQL, Redis, etc.), use `docker-compose`:

```bash
# In .devcontainer/devcontainer.json:
"dockerComposeFile": "docker-compose.yml",
"service": "app",
"workspaceFolder": "/workspace"
```

Then `devcontainer open .` will start all services.

## Best Practices

### 1. Layer Caching

Dockerfile should be ordered from least-changed to most-changed:
```dockerfile
# Rarely changes
FROM ubuntu:24.04

# Changes occasionally
RUN apt-get update && apt-get install -y \
    git curl build-essential

# Changes frequently  
COPY postCreateCommand.sh /workspace/
RUN chmod +x /workspace/postCreateCommand.sh
```

### 2. Non-root User

Create a non-root user for security:
```dockerfile
RUN useradd -m -s /bin/bash devuser
USER devuser
```

### 3. Cache Package Manager Layers

For Python:
```dockerfile
RUN pip install --upgrade pip poetry
# This layer won't rebuild unless poetry changes
```

### 4. Keep Images Lean

Use `-slim` or `-alpine` base images:
```dockerfile
FROM python:3.11-slim    # ~150MB
# vs
FROM python:3.11         # ~900MB
```

### 5. Health Checks (Optional)

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import requests; requests.get('http://localhost:8000/health')"
```

## Troubleshooting

### Container won't build

**Check Dockerfile syntax**:
```bash
docker build -f .devcontainer/Dockerfile .
```

**Check base image availability**:
```bash
docker pull python:3.11-slim
```

### Aliases don't work

**Verify dotfiles cloned**:
```bash
ls -la ~/.dotfiles
cat ~/.zshrc | grep "alias lg"
```

**Source zshrc manually**:
```bash
source ~/.zshrc
lg  # Should work now
```

### Port forwarding not working

**Check VS Code Dev Container settings**:
- Look at "Ports" tab in VS Code
- Try `netstat -tlnp | grep 8000`

**Manually forward ports**:
```bash
docker run -p 8000:8000 ...
```

### Permissions issues

**Fix ownership**:
```bash
chown -R $(id -u):$(id -g) /workspace
```

**In Dockerfile**:
```dockerfile
RUN chown -R devuser:devuser /workspace
```

## Advanced: Multi-stage Builds

For complex projects with build steps:

```dockerfile
# Stage 1: Builder
FROM python:3.11 as builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
WORKDIR /workspace
CMD ["/bin/bash"]
```

This reduces final image size by excluding build tools.

## Resources

- **Dev Containers Spec**: https://containers.dev/
- **Official Templates**: https://github.com/devcontainers/templates
- **Docker Best Practices**: https://docs.docker.com/develop/dev-best-practices/
- **VS Code Remote Development**: https://code.visualstudio.com/docs/remote/remote-overview

## Questions?

Refer to the individual template directories for specific setup instructions.
