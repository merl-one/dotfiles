# OpenCode Architecture & Configuration Guide

## Overview

OpenCode is a **framework for AI-powered development agents** that enables intelligent automation of development workflows. Your dotfiles repository contains a complete custom configuration with 16 agents, 12 commands, and 6 pre-made skills.

**Key Point**: OpenCode configuration lives in `~/.config/opencode/` in WSL/Linux, not on Windows. It's synced via chezmoi.

---

## Architecture

### High-Level Flow

```
┌──────────────────────┐
│   Windows CLI/UI     │  ← You type commands here
│   (OpenCode Client)  │
└──────────┬───────────┘
           │ (SSH/WSL connection)
           ↓
┌──────────────────────────────────────┐
│   WSL / Linux Environment             │
│   (OpenCode Runtime Server)           │
│                                       │
│  ~/.config/opencode/                  │
│  ├─ opencode.json                     │
│  ├─ oh-my-opencode.json               │
│  ├─ agent/        (16 files)          │
│  ├─ command/      (12 files)          │
│  ├─ skills/       (6 packages)        │
│  └─ node_modules/ (dependencies)      │
│                                       │
└──────────────────────────────────────┘
         ↓ (MCP calls)
┌──────────────────────────────────────┐
│   External Services                   │
│   ├─ homelab-mcp (infrastructure)     │
│   ├─ GitHub API                       │
│   ├─ GitLab API                       │
│   └─ AI Models (via GitHub Copilot)   │
└──────────────────────────────────────┘
```

### Data Flow

1. **User Input** (Windows) → OpenCode client
2. **Command Processing** (WSL) → Load config from `~/.config/opencode/`
3. **Agent Selection** → Look up agent in `oh-my-opencode.json`
4. **Model Selection** → Route to appropriate AI model (Copilot)
5. **Skill/Tool Loading** → Load relevant skills and MCP servers
6. **Execution** → Run with context and tools
7. **Results** (WSL) → Send back to Windows client

---

## Configuration Files

### 1. `opencode.json` - Runtime Configuration

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "homelab-mcp": {
      "type": "remote",
      "url": "https://mcp-server.home.arpa/mcp/"
    }
  },
  "plugin": [
    "oh-my-openagent@latest"
  ]
}
```

**What it does:**
- **mcp**: Registers Model Context Protocol servers (external tools agents can call)
- **plugin**: Loads oh-my-openagent plugin for extended capabilities
- Your `homelab-mcp` server provides infrastructure management capabilities

### 2. `oh-my-opencode.json` - Agent & Model Mapping

```json
{
  "agents": {
    "sisyphus": {
      "model": "github-copilot/claude-opus-4.6",
      "variant": "max"
    },
    "oracle": {
      "model": "github-copilot/gpt-5.4",
      "variant": "high"
    },
    "explore": {
      "model": "github-copilot/grok-code-fast-1"
    },
    "librarian": {
      "model": "github-copilot/claude-haiku-4.5"
    },
    // ... 7 more agents
  },
  "categories": {
    "visual-engineering": { ... },
    "artistry": { ... },
    // ... more categories
  }
}
```

**What it does:**
- Maps agent names to specific AI models
- `variant` controls capability level:
  - `max`: Most capable (complex reasoning)
  - `high`: High capability (balanced)
  - `medium`: Medium capability (faster)
  - Not specified: Default capability (fastest, smaller)
- Different agents have different strengths:
  - `sisyphus` → Heavy lifting (most capable)
  - `oracle` → Problem solving & debugging
  - `explore` → Code searching (fast)
  - `librarian` → Documentation (small, fast - you are this!)

### 3. `package.json` - Dependencies

```json
{
  "dependencies": {
    "@opencode-ai/plugin": "1.3.13"
  }
}
```

All npm dependencies are installed in `node_modules/` during setup.

---

## Agent System (16 Total)

### Primary Agents (Main Coordinators)

| Agent | File | Purpose | Model |
|-------|------|---------|-------|
| **developer** | `agent/developer.md` | Main coordinator orchestrating workflows | gpt-5.4-mini |
| **homelab-agent** | `agent/homelab-agent.md` | Infrastructure & Proxmox management | claude-opus |

### Specialist Agents (Domain Experts)

| Agent | File | Purpose | Model |
|-------|------|---------|-------|
| **planner** | `agent/planner.md` | Create implementation plans | claude-opus |
| **implementer** | `agent/implementer.md` | Execute plans, implement features | gpt-5.4 |
| **reviewer** | `agent/reviewer.md` | Code review, quality assurance | gpt-5.4 |
| **committer** | `agent/committer.md` | Git operations, commits, pushes | gpt-5.4-mini |
| **architect-designer** | `agent/architect-designer.md` | System design decisions | gpt-5.4 |
| **requirements-clarifier** | `agent/requirements-clarifier.md` | Clarify ambiguous needs | gpt-5.4 |
| **implementation-specialist** | `agent/implementation-specialist.md` | Complex code implementation | gpt-5.4 |
| **test-automation-engineer** | `agent/test-automation-engineer.md` | Test writing & automation | gpt-5.4 |

### Sub-Agents (Specialized Tasks)

| Agent | File | Purpose | Model |
|-------|------|---------|-------|
| **codebase-locator** | `agent/codebase-locator.md` | Find files/patterns in code | grok-code-fast-1 |
| **pattern-finder** | `agent/pattern-finder.md` | Find code examples & patterns | grok-code-fast-1 |
| **codebase-analyzer** | `agent/codebase-analyzer.md` | Analyze code structure | grok-code-fast-1 |

### Super Agents (Heavy Lifting)

| Agent | File | Purpose | Model |
|-------|------|---------|-------|
| **sisyphus** | (in config only) | Self-referential loop for autonomy | claude-opus-4.6 |
| **oracle** | (in config only) | Deep problem analysis | gpt-5.4 |
| **metis** | (in config only) | Complex reasoning | claude-opus-4.6 |

---

## Command System (12 Commands)

Commands are shortcuts that spawn agents with predefined workflows:

| Command | Spawns Agent | Purpose |
|---------|--------------|---------|
| `/plan` | planner | Create detailed implementation plan |
| `/implement` | implementer | Execute an existing plan |
| `/commit` | committer | Stage changes, write commit message, push |
| `/review` | reviewer | Review code quality & best practices |
| `/deploy` | homelab-agent | Deploy infrastructure changes |
| `/debug` | oracle | Deep debugging & problem analysis |
| `/build` | - | Build the project |
| `/scan` | - | Security scanning |
| `/pr` | committer | Create pull request on GitHub |
| `/validate` | - | Verify implementation against plan |
| `/handoff` | - | Save context for later continuation |
| `/resume` | - | Continue from saved handoff |

**Usage:**
```bash
/plan "Create user authentication system"
/implement
/commit
/review
/deploy
```

---

## Skills System (6 Skills)

Pre-made reusable workflows with full instructions:

### 1. **context-engineering**
- **Purpose**: Context-first development approach
- **Trigger phrases**: When starting a new task
- **Workflow**: Read & understand codebase before making changes
- **Location**: `~/.config/opencode/skills/context-engineering/SKILL.md`

### 2. **git-workflow**
- **Purpose**: Meticulous version control
- **Trigger phrases**: "commit", "rebase", "who wrote"
- **Workflow**: Atomic commits, clean history, descriptive messages
- **Location**: `~/.config/opencode/skills/git-workflow/SKILL.md`

### 3. **plan-management**
- **Purpose**: Create and track implementation plans
- **Trigger phrases**: "create a plan", "show plans"
- **Workflow**: YAML-based plans with checkboxes in `plans/active/`
- **Location**: `~/.config/opencode/skills/plan-management/SKILL.md`

### 4. **deploy**
- **Purpose**: Deploy homelab infrastructure
- **Trigger phrases**: "deploy", "ship it", "run pipeline"
- **Workflow**: Commit → Push → Validate → Manual apply in GitLab
- **Location**: `~/.config/opencode/skills/deploy/SKILL.md`

### 5. **homelab-context**
- **Purpose**: Homelab architecture reference
- **Trigger phrases**: Any homelab-related task
- **Workflow**: Provides architecture context, MCP tool usage, Proxmox/Docker reference
- **Location**: `~/.config/opencode/skills/homelab-context/SKILL.md`

### 6. **ship**
- **Purpose**: Complete git workflow
- **Trigger phrases**: "ship it", "commit and push"
- **Workflow**: Stage → Commit → Push → PR → Auto-review
- **Location**: `~/.config/opencode/skills/ship/SKILL.md`

**Load a skill:**
```bash
skill(name="plan-management")
```

---

## How Config Gets to WSL

### Sync Flow (Chezmoi)

```
1. GitHub dotfiles repo
   └─ dot_config/opencode/
          ↓
2. chezmoi init --apply merl-one/dotfiles
   (Clones to ~/.local/share/chezmoi/)
          ↓
3. Chezmoi applies files
   (Creates ~/.config/opencode/)
          ↓
4. OpenCode loads from ~/.config/opencode/
   (At runtime, in WSL)
```

**Verify it worked:**
```bash
wsl -- bash -c "ls -la ~/.config/opencode/"
```

Should show:
```
agent/
command/
skills/
opencode.json
oh-my-opencode.json
package.json
node_modules/
bun.lock
```

---

## File Organization

### In Dotfiles (Source)

```
dot_config/opencode/
├── agent/                           ← 16 agent definitions
│   ├── developer.md                 ← Main coordinator
│   ├── planner.md
│   ├── implementer.md
│   ├── reviewer.md
│   ├── committer.md
│   ├── homelab-agent.md
│   ├── architect-designer.md
│   ├── requirements-clarifier.md
│   ├── implementation-specialist.md
│   ├── test-automation-engineer.md
│   ├── codebase-locator.md
│   ├── pattern-finder.md
│   ├── codebase-analyzer.md
│   └── (3 more: oracle, metis, sisyphus - config only)
│
├── command/                         ← 12 command definitions
│   ├── plan.md
│   ├── implement.md
│   ├── commit.md
│   ├── review.md
│   ├── deploy.md
│   ├── debug.md
│   ├── build.md
│   ├── scan.md
│   ├── pr.md
│   ├── validate.md
│   ├── handoff.md
│   └── resume.md
│
├── skills/                          ← 6 skill packages
│   ├── context-engineering/SKILL.md
│   ├── deploy/SKILL.md
│   ├── git-workflow/SKILL.md
│   ├── homelab-context/SKILL.md
│   ├── plan-management/SKILL.md
│   └── ship/SKILL.md
│
├── opencode.json                    ← MCP & plugin config
├── oh-my-opencode.json              ← Agent model mapping
└── package.json                     ← Dependencies
```

### In WSL Home (Runtime)

```
~/.config/opencode/
├── agent/                           ← Same as dotfiles (synced)
├── command/                         ← Same as dotfiles (synced)
├── skills/                          ← Same as dotfiles (synced)
├── opencode.json                    ← Same as dotfiles (synced)
├── oh-my-opencode.json              ← Same as dotfiles (synced)
├── package.json                     ← Same as dotfiles (synced)
├── node_modules/                    ← npm dependencies
├── bun.lock                         ← Dependency lock
└── .sisyphus/                       ← Session cache (NOT synced)
```

---

## Configuration Discovery

OpenCode searches for config in this order:

1. **Environment variable** `$OPENCODE_CONFIG_DIR` (if set)
2. **Default location** `~/.config/opencode/`
3. **Project-specific** `./.opencode/` (if in a project with this dir)

Your setup uses: **`~/.config/opencode/` (default)**

---

## Why Agents/Skills Aren't Visible in Windows

### Windows OpenCode is Just a Client

```
Windows Side:
├─ OpenCode CLI/UI (lightweight)
├─ Terminal/IDE Integration
└─ Remote connection to WSL

WSL Side:
├─ OpenCode Server (does the work)
├─ Config loader (reads ~/.config/opencode/)
├─ Agent system (runs agents)
├─ Skill loader (loads skills)
└─ Tool execution (calls MCP servers, AI models, etc.)
```

**You see agents/skills in WSL because:**
- They physically exist in `~/.config/opencode/`
- WSL has direct filesystem access
- OpenCode server loads them at runtime

**You DON'T see them in Windows because:**
- Windows OpenCode is just a client/UI
- It doesn't have direct WSL filesystem access
- The actual config only lives in WSL

**To see them in Windows:**
```powershell
# Browse WSL filesystem (Windows 11 only)
explorer "\\wsl$\Ubuntu-24.04\home\jason\.config\opencode\"

# Or via WSL bash
wsl -- ls -la ~/.config/opencode/agent/
wsl -- ls -la ~/.config/opencode/skills/
```

---

## Modifying Configuration

### Edit an Agent

```bash
# In WSL
nano ~/.config/opencode/agent/developer.md

# Or mount in Windows and edit
# \\wsl$\Ubuntu-24.04\home\jason\.config\opencode\agent\developer.md
```

Then commit via chezmoi:
```bash
cd ~/.local/share/chezmoi
git add dot_config/opencode/agent/developer.md
git commit -m "Update developer agent instructions"
git push
```

### Add a New Agent

1. Create file: `dot_config/opencode/agent/my-agent.md`
2. Add to both JSON config files if needed
3. Commit and push
4. Chezmoi syncs to `~/.config/opencode/` on other machines

### Change Agent Models

Edit `dot_config/opencode/oh-my-opencode.json`:
```json
{
  "agents": {
    "oracle": {
      "model": "github-copilot/gpt-5.4",  ← Change this
      "variant": "high"
    }
  }
}
```

---

## Your Current Setup Status

✅ **Chezmoi** syncing 72 files from GitHub to WSL  
✅ **OpenCode config** present in `~/.config/opencode/`  
✅ **16 agents** available and discoverable  
✅ **12 commands** registered and functional  
✅ **6 skills** installed and ready to load  
✅ **Homelab MCP** connected to infrastructure API  
✅ **Agent model mapping** configured for optimal performance  

---

## Related Documentation

- [Chezmoi Guide](./CHEZMOI_GUIDE.md) - How dotfiles are synced
- [INDEX.md](./INDEX.md) - Main documentation hub
- [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) - Command reference

## External Resources

- [OpenCode Official Docs](https://opencode.ai/)
- [Oh-My-OpenAgent GitHub](https://github.com/code-yeongyu/oh-my-openagent)
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/)
