---
status: draft
created: 2026-04-04
updated: 2026-04-04
tags: [devpod, devcontainers, reproducible-dev, docker, docker-compose]
---

# DevPod/Devcontainers Setup Plan

## Overview

Add **DevPod** and **Devcontainers** support to the Linux CLI workflow. This enables reproducible, project-specific development environments that run in Docker, isolated from your main WSL2 system.

**Why DevPod?**
- Same dependencies everywhere (your laptop, CI/CD, production)
- Onboard new team members instantly ("devpod up" and done)
- Multiple projects with conflicting dependencies (Python 3.11 vs 3.13)
- Fresh environment without bloating main system
- IDE integration (VS Code, Neovim in container)

## Current State Analysis

### Existing Infrastructure
- ✅ WSL2 with Ubuntu 24.04
- ✅ Docker already installed (for kubectl/k9s support)
- ✅ Dotfiles managed by chezmoi in Windows repo
- ✅ VS Code with Vim extension
- ✅ Neovim + LazyVim for terminal editing

### What's Missing
- ❌ DevPod binary (need to install)
- ❌ Devcontainer.json template for Python projects
- ❌ Devcontainer.json template for TypeScript projects
- ❌ Integration with Neovim inside containers
- ❌ Documentation for user (how to use DevPod)

### Integration Points
1. **Dotfiles**: DevPod should use chezmoi inside containers (optional)
2. **VS Code**: Remote containers extension already available
3. **Terminal**: Can SSH into running DevPod container
4. **Git**: Container can access repo from WSL2 mount
5. **Kubernetes access**: Container can forward kubeconfig from WSL2

## Key Discoveries

1. **DevPod vs Devcontainers**
   - **Devcontainers** = spec (devcontainer.json config file)
   - **DevPod** = CLI tool that orchestrates devcontainers (newer, recommended)
   - DevPod can use Docker, Podman, SSH, Kubernetes as backend

2. **For WSL2 setup, best approach**:
   - Use Docker as backend (already available)
   - DevPod creates container from devcontainer.json
   - Mount current directory into /workspace
   - Keep kubeconfig and git credentials accessible

3. **User expectations** (from Devcontainers philosophy)
   - Dev environment = Infrastructure as Code (git-tracked)
   - "Works on my machine" problem solved
   - Team standardization
   - Consistent with prod deployments (similar Dockerfile)

## Phases

### Phase 1: Install & Configure DevPod

- [ ] Download DevPod binary (Go binary, single file)
- [ ] Add DevPod to PATH (`~/.local/bin/`)
- [ ] Verify DevPod works: `devpod list`
- [ ] Configure DevPod to use Docker backend
- [ ] Test: Create and enter a simple devpod container

**Deliverable**: DevPod installed and working, can run `devpod help`

---

### Phase 2: Create Python Devcontainer Template

**Goal**: A reusable Python dev environment template

Structure:
```
project-template/.devcontainer/
├── devcontainer.json       (DevPod config)
├── Dockerfile             (Container image definition)
└── post-create.sh         (Setup script after container starts)
```

**Features to include**:
- [ ] Base image: python:3.11-slim (or configurable)
- [ ] Install system dependencies: git, curl, build-essential, etc.
- [ ] Install dev tools: pip, poetry/uv, black, pytest, ruff, mypy
- [ ] Run post-create.sh to set up dotfiles (chezmoi) - optional
- [ ] Mount kubeconfig from WSL2 host at `/root/.kube/config`
- [ ] Mount git config from WSL2 host
- [ ] Volume for pip cache (reuse across containers)
- [ ] Expose ports (configurable for Flask/FastAPI debugging)
- [ ] Set PYTHONUNBUFFERED=1 (for real-time output)

**post-create.sh**:
```bash
#!/bin/bash
# Install/upgrade pip packages
python -m pip install --upgrade pip poetry uv pytest pytest-cov

# Optional: Setup chezmoi to get user's dotfiles
# chezmoi init --apply https://gitlab.com/jason/dotfiles
```

**Deliverable**: 
- `/templates/devcontainer-python/` in dotfiles repo
- Users can copy this to new project and customize

---

### Phase 3: Create TypeScript Devcontainer Template

**Goal**: Reusable TypeScript/Node.js dev environment

Structure: Same as Python template

**Features to include**:
- [ ] Base image: node:20-slim (or configurable)
- [ ] Install system deps: git, curl, build-essential
- [ ] Install dev tools: npm, pnpm (or yarn), eslint, typescript, prettier
- [ ] Mount kubeconfig and git config
- [ ] Volume for npm cache
- [ ] Expose ports (configurable for Next.js/Express)
- [ ] post-create.sh runs `npm install` or `pnpm install`

**Deliverable**: `/templates/devcontainer-typescript/` in dotfiles repo

---

### Phase 4: Integrate with Dotfiles Workflow

- [ ] Add devpod config to chezmoi (optional install step)
- [ ] Document: "Where to put devcontainers in your project"
- [ ] Create example projects with devcontainers already configured:
  - `/examples/python-project/` (minimal FastAPI app)
  - `/examples/typescript-project/` (minimal Next.js app)
- [ ] Add `.devcontainer/` to `.chezmoiignore` (don't track in user dotfiles)

**Rationale**: Each PROJECT has its own `.devcontainer/`, not global. User's dotfiles remain clean.

---

### Phase 5: Documentation & Examples

- [ ] Create `DEVPOD_GUIDE.md` (beginner walkthrough)
  - Step 1: Install DevPod (copy command)
  - Step 2: Clone example project with devcontainer
  - Step 3: Run `devpod up` in that project
  - Step 4: Enter shell in container
  - Step 5: Run code inside container
  - Step 6: Exit and clean up

- [ ] Create `DEVCONTAINER_REFERENCE.md` (technical reference)
  - What goes in devcontainer.json
  - Common configurations
  - Port forwarding
  - Volume mounting
  - Environment variables
  - Running services (database, redis)

- [ ] Add troubleshooting section:
  - Docker daemon not running (error + fix)
  - Port conflicts (devpod vs WSL2)
  - Volume mount permission issues
  - GPU support (if needed)

**Deliverable**: Two markdown files in dotfiles repo

---

### Phase 6: Testing & Validation

- [ ] Test Python template: Create new Python project, run `devpod up`, run tests inside
- [ ] Test TypeScript template: Create new Node project, run `devpod up`, run build inside
- [ ] Test VS Code Remote Containers extension connects to devpod
- [ ] Test Neovim works inside container (if applicable)
- [ ] Test kubeconfig forwarding works (can run kubectl inside container)
- [ ] Test git config forwarding works (can commit from inside container)
- [ ] Verify 3-5 minute startup time (acceptable for cold start)
- [ ] Verify build cache works (second startup ~30s)

**Success criteria**:
- New user can `devpod up` and immediately start coding
- All dependencies exactly match template (no "missing package" surprises)
- IDE (VS Code) can connect to running container
- Container can access cluster, git history, etc.

**Deliverable**: Test checklist + evidence (screenshots/logs)

---

## Implementation Order

1. **Phase 1** (30 min) - Install DevPod binary
2. **Phase 2** (1 hour) - Create Python template + test
3. **Phase 3** (45 min) - Create TypeScript template + test
4. **Phase 4** (30 min) - Integrate with dotfiles, add .chezmoiignore entry
5. **Phase 5** (1.5 hours) - Write comprehensive guides
6. **Phase 6** (1 hour) - Full testing + validation

**Total estimated time**: ~5 hours

---

## Open Questions / Risks

### Questions
1. **Should user's dotfiles be applied inside containers?**
   - PRO: zsh aliases, vim config, Starship prompt available in container
   - CON: Extra startup time, container becomes coupled to user's setup
   - RECOMMENDATION: Make optional via environment variable in post-create.sh

2. **How to handle database services (PostgreSQL, Redis)?**
   - Option A: Use separate container (docker-compose)
   - Option B: Install in main container (simpler for small projects)
   - RECOMMENDATION: Document both, start with Option B

3. **Should we support Podman as alternative to Docker?**
   - PRO: User choice
   - CON: Extra testing/maintenance
   - RECOMMENDATION: Docker only for now, document how to switch if needed

### Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Docker daemon crashes | Low | High (dev blocked) | Document restart: `wsl -d Ubuntu-24.04 -e docker ps` |
| Container disk space fills up | Medium | High | Add disk cleanup step to guide |
| Volume mount permissions issues | Medium | Medium | Pre-test volumes, document Windows filesystem quirks |
| Kubernetes access breaks in container | Low | Medium | Test kubeconfig forwarding thoroughly |
| Student creates container and forgets to clean up | High | Low | Automatic cleanup after 1 week idle (document) |

---

## Success Criteria (Overall)

- [ ] DevPod binary working on WSL2
- [ ] Python template tested and documented
- [ ] TypeScript template tested and documented
- [ ] User can follow DEVPOD_GUIDE.md and have working project in < 10 minutes
- [ ] All 3 example projects run successfully
- [ ] Git history available inside containers
- [ ] Kubernetes access available inside containers
- [ ] VS Code can connect to running containers
- [ ] Zero additional system bloat in WSL2 (containers are isolated)

---

## Files to Create/Modify

### New Files
```
dotfiles/
├── .devcontainer/README.md                    # Why .devcontainer/ is not tracked
├── templates/
│   ├── devcontainer-python/
│   │   ├── devcontainer.json
│   │   ├── Dockerfile
│   │   └── post-create.sh
│   └── devcontainer-typescript/
│       ├── devcontainer.json
│       ├── Dockerfile
│       └── post-create.sh
├── examples/
│   ├── python-example/
│   │   ├── .devcontainer/
│   │   ├── src/app.py
│   │   ├── requirements.txt
│   │   └── README.md
│   └── typescript-example/
│       ├── .devcontainer/
│       ├── src/app.ts
│       ├── package.json
│       └── README.md
├── DEVPOD_GUIDE.md                           # User-facing beginner guide
├── DEVCONTAINER_REFERENCE.md                 # Technical reference
└── dot_local/bin/devpod                      # Symlink to DevPod binary
```

### Modified Files
```
dotfiles/
├── .chezmoiignore                             # Add .devcontainer/
├── executable_dot_zshrc                       # Add 'devpod' alias (optional)
└── README.md                                  # Link to DEVPOD_GUIDE.md
```

---

## Notes

- DevPod is relatively new (2024+) but backed by Loft Labs (established company)
- Alternative: Docker Dev Environments (built-in to Docker Desktop) — simpler but less flexible
- DevPod philosophy: "Code anywhere, dev environment follows"
- This aligns with Infrastructure as Code best practices
