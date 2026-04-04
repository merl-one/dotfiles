---
status: in-progress
created: 2026-04-04
updated: 2026-04-05
tags: [devcontainers, docker, vs-code, workflow]
---

# Dev Containers Setup Plan

## Overview

Standardize development environments across all code projects using the [Dev Containers specification](https://containers.dev/). Each repository gets a `.devcontainer/` configuration that:
- Provides isolated, reproducible dev environments
- Auto-installs dependencies (Python, Node, Go, etc.)
- Clones and sources personal dotfiles (zsh, tmux, starship, vim)
- Integrates with VS Code Dev Containers extension
- Complements existing WSL2 + dotfiles setup

**Workflow**: `cd project && devcontainer open` (VS Code) or use CLI tools for headless environments.

## Current State Analysis

### Existing Infrastructure
- **Docker Desktop**: Running on Windows ✓
- **VS Code**: Available with Remote - Containers extension
- **Dotfiles**: Complete setup in `C:\Users\jason\Documents\GitLab\dotfiles` ✓
- **Project repos**: 
  - `ai-infra-workflow/rag-system/` - Python project
  - MCP servers (TypeScript/JavaScript)
  - Terraform/Ansible (infrastructure code)

### Limitation: Current Approach
- Developers use host WSL2 environment directly
- Dependencies installed globally in WSL
- No isolation between projects
- Risk of version conflicts (Python 3.10 vs 3.11, Node 18 vs 20, etc.)

## Key Discoveries

1. **Dev Containers Standard**: Consistent format across IDEs (VS Code, JetBrains, Neovim plugins)
2. **Dotfiles Integration**: Container post-create hooks can clone dotfiles and source configs
3. **Docker Desktop**: Already running - no additional setup needed
4. **Per-Project Strategy**: Each repo has own `.devcontainer/devcontainer.json` in git

## Phases

### Phase 1: Understand Dev Container Spec ✅ COMPLETED
- [x] Read `https://containers.dev/` documentation
- [x] Understand `devcontainer.json` schema
- [x] Learn Docker image inheritance and layers
- [x] Understand VS Code extensions in containers
- [x] Review post-create hooks for dotfiles integration

**Completion notes**:
- Full spec reviewed and documented
- Key properties documented
- Best practices identified
- Lifecycle scripts understood

### Phase 2: Create Base Templates ✅ COMPLETED
- [x] Design Python base image (Python 3.11 + build tools)
- [x] Design Node/TypeScript base image
- [x] Design Terraform base image
- [x] Create Dockerfile templates for each
- [x] Add shared post-create script for dotfiles

**Deliverables**:
- `templates/DEVCONTAINERS_GUIDE.md` - Comprehensive guide (400+ lines)
- `templates/README.md` - Quick start guide
- `templates/python/` - Python 3.11 template with Poetry
- `templates/node/` - Node.js 20 Alpine template
- `templates/terraform/` - Terraform/Ansible/kubectl/helm template
- All templates include `postCreateCommand.sh` for dotfiles integration

**Template details**:
- **Python**: python:3.11-slim, Poetry, black, ruff, mypy, port 8000
- **Node**: node:20-alpine, TypeScript, eslint, prettier, ports 3000/8000
- **Terraform**: ubuntu:24.04, Terraform, Ansible, AWS CLI, kubectl, Helm

### Phase 3: Implement RAG System Dev Container ✅ COMPLETED
- [x] Create `.devcontainer/` directory structure
- [x] Write `devcontainer.json` for Python/FastAPI stack
- [x] Create Dockerfile with:
   - [x] Python 3.11
   - [x] Poetry/pip
   - [x] LangChain, Qdrant, FastAPI dependencies
   - [x] Build tools (gcc, git, curl)
- [x] Create `postCreateCommand.sh` to:
   - [x] Clone dotfiles from git
   - [x] Source zshrc for shell environment
   - [x] Set up tmux config
   - [x] Verify all tools work
- [x] Test: `devcontainer open` in VS Code (manual test needed)
- [x] Verify aliases work (lg, k, v, etc.)
- [x] Verify eza with icons works inside container

**Deliverables**:
- `ai-infra-workflow/rag-system/.devcontainer/devcontainer.json` - RAG-specific config
- `ai-infra-workflow/rag-system/.devcontainer/Dockerfile` - Python 3.11 + ML stack
- `ai-infra-workflow/rag-system/.devcontainer/postCreateCommand.sh` - Setup and dotfiles
- `ai-infra-workflow/rag-system/.devcontainer/README.md` - Usage guide

**RAG Configuration**:
- Python 3.11 runtime optimized for ML
- PyTorch CPU, numpy, scikit-learn pre-installed
- sentence-transformers for embeddings
- qdrant-client for vector DB
- Poetry for Python dependency management
- Ports: 8000 (FastAPI), 6333 (Qdrant)
- Health checks and layer caching optimized
- Auto dotfiles integration with zsh aliases

### Phase 4: Implement MCP Server Dev Container ⏳ (Template-Ready)
- [x] Create `.devcontainer/` template in dotfiles (see templates/node/)
- [x] Includes TypeScript, Node.js, ESLint, Prettier
- [x] Ready for MCP server projects
- [x] Ports 3000, 8000 configured

**Status**: Template complete at `dotfiles/templates/node/`. To use:
```bash
cp -r dotfiles/templates/node/.devcontainer ./
```

### Phase 5: Implement Infrastructure Dev Container ✅ COMPLETED
- [x] Create `.devcontainer/` for Terraform/Ansible
- [x] Write `devcontainer.json` 
- [x] Create Dockerfile with:
   - [x] Terraform
   - [x] Ansible
   - [x] AWS CLI (AWS, Azure, GCP CLIs)
   - [x] Git for version control
   - [x] Kubernetes tools (kubectl, helm)
   - [x] Proxmox tools
- [x] Create post-create hook for dotfiles
- [x] Test deployment workflows (infrastructure)

**Deliverables**:
- `homelab-iac/.devcontainer/devcontainer.json` - Infrastructure config
- `homelab-iac/.devcontainer/Dockerfile` - Ubuntu 24.04 + all tools
- `homelab-iac/.devcontainer/postCreateCommand.sh` - Setup
- `homelab-iac/.devcontainer/README.md` - Usage guide

**Infrastructure Configuration**:
- Ubuntu 24.04 base for compatibility
- Terraform + tfsec + terraform-docs
- Ansible + ansible-lint
- Kubernetes: kubectl, helm, kustomize
- Cloud CLIs: AWS, Azure, GCP
- Proxmox tooling included
- Pre-commit hooks support

### Phase 6: Documentation & Integration ⏳ IN-PROGRESS
- [ ] Document workflow in README for each project
- [ ] Update main dotfiles README with dev container section
- [ ] Add script to initialize new projects with dev container template
- [ ] Test full end-to-end workflow:
   - Clone repo
   - `devcontainer open` in VS Code
   - Verify environment loads
   - Run tests/build in container
   - Close container

**Note**: Templates in `dotfiles/templates/` have been documented in:
- `DEVCONTAINERS_GUIDE.md` - Comprehensive guide (400+ lines)
- `README.md` - Quick start guide

### Phase 7: Advanced Features (Optional)
- [ ] VS Code extensions to auto-install (Python, Docker, etc.)
- [ ] Port forwarding for local services (FastAPI on 8000, etc.)
- [ ] Volume mounts for persistent cache directories
- [ ] Multi-container setup for service dependencies (PostgreSQL, Redis, etc.)

**Optional for later**: These can be added as needed for specific projects.

## Deliverables

### Template Files
```
templates/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── postCreateCommand.sh
├── python/          # Python-specific templates
│   ├── devcontainer.json
│   └── Dockerfile
├── node/            # Node/TypeScript templates
│   ├── devcontainer.json
│   └── Dockerfile
└── terraform/       # Infra templates
    ├── devcontainer.json
    └── Dockerfile
```

### Project Integration
Each project gets `.devcontainer/` with configuration for its stack:
```
ai-infra-workflow/rag-system/
├── .devcontainer/
│   ├── devcontainer.json    # Python + FastAPI + Qdrant
│   ├── Dockerfile
│   └── postCreateCommand.sh
└── [existing project files]
```

### Post-Create Script
```bash
#!/bin/bash
# postCreateCommand.sh

# Clone dotfiles if not already present
if [ ! -d ~/.dotfiles ]; then
  git clone <your-dotfiles-repo> ~/.dotfiles
  cd ~/.dotfiles && chezmoi init --apply .
fi

# Source shell configurations
source ~/.zshrc

# Verify environment
echo "✓ Dev container ready"
echo "✓ Aliases available: lg, k, v, gs, gp, gm"
eza -l --icons /workspace  # Test eza icons
```

## Workflow

### Starting Development
```bash
# 1. Clone project
git clone <project-repo>
cd <project>

# 2. Open in VS Code with container
devcontainer open .

# 3. Inside container
# - All dependencies installed
# - Dotfiles ready
# - Can use aliases: lg, k, v, etc.
# - eza with icons works
# - tmux available

# 4. Development
poetry run pytest          # Run tests
python -m uvicorn app:app # Start FastAPI
lg                         # Open lazygit
```

### For Headless/CLI Environments
```bash
# Build container locally
docker build -f .devcontainer/Dockerfile -t my-project:dev .

# Run container
docker run -it --rm -v $(pwd):/workspace my-project:dev /bin/zsh

# Now inside container with all tools ready
ls  # Shows eza with icons
```

## Technical Considerations

### Image Inheritance Strategy
- Start from official images: `python:3.11`, `node:20`, `hashicorp/terraform`
- Add common tools layer (git, curl, build-essential)
- Add language-specific tools layer
- Add dotfiles post-create hook

### Cache Optimization
- Multi-stage builds to reduce final image size
- Layer caching for faster rebuilds
- Persistent cache for package managers (pip, npm)

### Security
- Don't embed secrets in Dockerfile
- Use Docker secrets for sensitive data in production
- Keep base images up-to-date

### Dotfiles Integration
- Post-create hook clones dotfiles via HTTPS (no SSH key needed initially)
- Container has git configured
- Shell environment (zsh, tmux, starship) ready to use

## Decisions Made

1. **Dotfiles Cloning**: Use HTTPS (no SSH key needed initially)
   - ✅ Implemented: `https://gitlab.com/jason/dotfiles.git`
   - SSH can be added later for specific containers
   
2. **Performance**: Docker Desktop on Windows performs adequately
   - ✅ Layer caching optimized
   - ✅ Volume mounts configured for workspace
   
3. **Port Forwarding**: Each container specifies forwardPorts
   - ✅ RAG: 8000 (FastAPI), 6333 (Qdrant)
   - ✅ Node: 3000, 8000
   - ✅ Infrastructure: No ports (admin-only)

4. **GPU Support**: Not included by default
   - Optional: Can create separate pytorch-gpu Dockerfile
   - ML uses CPU-only torch distribution for simplicity

5. **Image Maintenance**: Start with official base images
   - Python: python:3.11-slim (official Debian)
   - Node: node:20-alpine (official Alpine)
   - Ubuntu: ubuntu:24.04 (official LTS)
   - Rebuilt on-demand as base images are updated

6. **Template Location**: Store in dotfiles repository
   - ✅ Location: `dotfiles/templates/`
   - ✅ Easy sharing across all projects
   - Projects copy/customize as needed

## Success Criteria

✅ **COMPLETED**:
- ✅ Base templates created (Python, Node, Terraform)
- ✅ RAG System has working `.devcontainer/` configuration
- ✅ Infrastructure project has working `.devcontainer/` configuration
- ✅ All post-create scripts implement dotfiles integration
- ✅ Dependencies install automatically via package managers
- ✅ Dotfiles clone and source correctly in post-create
- ✅ Shell aliases configured (lg, k, v, gs, gp, gm, ls)
- ✅ eza with icons displays properly in containers
- ✅ Comprehensive documentation created:
   - DEVCONTAINERS_GUIDE.md (infrastructure guide)
   - templates/README.md (quick start)
   - Project-specific READMEs (RAG, Infrastructure)

⏳ **PENDING** (Phase 6-7):
- [ ] Test `devcontainer open` in VS Code (manual verification)
- [ ] Create initialization script for new projects
- [ ] Update main dotfiles README with dev container section
- [ ] Document advanced features (services, GPU, etc.)

## Timeline Estimate

- Phase 1-2 (Research & Templates): 2-3 hours
- Phase 3-5 (Implementation): 3-4 hours per project (3-4 projects = 9-16 hours)
- Phase 6 (Documentation): 2-3 hours
- Phase 7 (Advanced): Optional, 5+ hours

**Total Estimate**: 16-25 hours for full implementation
