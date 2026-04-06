# Terraform-Skill Integration Guide

## Overview

This guide covers the integration of **terraform-skill** (by Anton Babenko) into your OpenCode setup on both Windows and WSL.

**Repository:** https://github.com/antonbabenko/terraform-skill  
**License:** Apache 2.0  
**Version:** 1.6.0 (latest)

---

## What is terraform-skill?

### Definition

**terraform-skill** is a Claude Agent Skill (knowledge plugin) that provides comprehensive guidance on Terraform and OpenTofu best practices.

**It is NOT:**
- ❌ A standalone tool or CLI
- ❌ A Terraform module
- ❌ An OpenCode agent
- ❌ A language model

**It IS:**
- ✅ A knowledge base (SKILL.md + reference materials)
- ✅ A Claude plugin/skill for enhanced capabilities
- ✅ A best practices reference system
- ✅ Automatically activated when working with Terraform/OpenTofu code

### Capabilities Provided

```
TESTING FRAMEWORKS
├─ Native tests (Terraform 1.6+) vs Terratest decision matrix
├─ Testing strategy workflows (static → integration → E2E)
├─ Real-world testing patterns and examples
└─ Test organization best practices

MODULE DEVELOPMENT
├─ Directory structure & naming conventions (terraform-<PROVIDER>-<NAME>)
├─ Versioning strategies (semantic versioning patterns)
├─ Public vs private module patterns
├─ Input variable organization & design
├─ Output value design patterns
└─ Documentation standards (terraform-docs)

CI/CD INTEGRATION
├─ GitHub Actions workflows (plan, apply, cost estimation)
├─ GitLab CI templates and examples
├─ Atlantis integration for pull request automation
├─ Infracost integration (cost estimation)
├─ Pre-commit hooks for local validation
└─ Drift detection patterns

SECURITY & COMPLIANCE
├─ Static analysis integration (TFLint, Trivy)
├─ Policy-as-code patterns (Sentinel, Kyverno)
├─ Secrets management in infrastructure code
├─ State file security and encryption
├─ Compliance scanning workflows (Checkov)
└─ RBAC and access control patterns

QUICK REFERENCE & DECISION FRAMEWORKS
├─ Flowcharts for common decisions
├─ ✅ DO vs ❌ DON'T examples (side-by-side)
├─ Anti-patterns to avoid
├─ Common mistakes and solutions
└─ Cheat sheets for rapid consultation
```

### How It Works

When you work with Terraform code:

```
Your Query (or Claude detects Terraform context)
    ↓
terraform-skill activates automatically
    ↓
Provides guidance on:
  • Best practices for your specific use case
  • Testing strategies
  • Module structure
  • CI/CD patterns
  • Security concerns
    ↓
Claude/OpenCode applies guidance
    ↓
High-quality, production-ready infrastructure code
```

**Activation Trigger:** Any query mentioning:
- "Terraform" / "OpenTofu"
- "module" / "infrastructure"
- "testing strategy"
- "CI/CD workflow"
- HCL code blocks

---

## Your Setup

### Current Locations

**Windows:**
```
C:\Users\jason\AppData\Roaming\alacritty\alacritty.toml
    ↓ Launches
C:\Users\jason\Documents\GitLab\dotfiles\
C:\Users\jason\.config\opencode\          (if OpenCode on Windows)
```

**WSL:**
```
~/.config/opencode/
├─ agent/ (16 agents)
├─ command/ (12 commands)
├─ skills/
│  ├─ context-engineering/
│  ├─ deploy/
│  ├─ git-workflow/
│  ├─ homelab-context/
│  ├─ plan-management/
│  ├─ ship/
│  └─ terraform-skill/  ← NEW (synced via chezmoi)
└─ opencode.json
```

**GitHub:**
```
merl-one/dotfiles
├─ dot_config/opencode/skills/
│  └─ terraform-skill/  ← Submodule pointing to antonbabenko/terraform-skill
```

---

## Installation & Setup

### Already Done For You ✅

The terraform-skill has been added to your dotfiles as a git submodule:

```bash
# In dotfiles repo
git submodule add https://github.com/antonbabenko/terraform-skill \
  dot_config/opencode/skills/terraform-skill
```

**Status:**
- ✅ Added to `.gitmodules`
- ✅ Committed to merl-one/dotfiles
- ✅ Pushed to GitHub
- ⏳ Will sync to WSL on next `chezmoi update`

### Sync to WSL

**Option 1: Use chezmoi update**
```bash
wsl -- bash -c "chezmoi update"
```

**Option 2: Manual pull with submodules**
```bash
wsl -- bash -c "cd ~/.local/share/chezmoi && git pull --recurse-submodules"
```

**Verify:**
```bash
wsl -- bash -c "ls -la ~/.config/opencode/skills/terraform-skill/"
# Should show: SKILL.md, README.md, references/, tests/, etc.
```

### For Windows OpenCode (If Using It)

If you have OpenCode installed on Windows:

```powershell
# Option A: Install via marketplace (if supported)
opencode /plugin marketplace add antonbabenko/terraform-skill
opencode /plugin install terraform-skill@antonbabenko

# Option B: Manual installation
mkdir -p $env:USERPROFILE\.opencode\skills
git clone https://github.com/antonbabenko/terraform-skill `
  "$env:USERPROFILE\.opencode\skills\terraform-skill"

# Verify
opencode /skills list
```

---

## Usage

### In WSL (OpenCode Server)

Once synced to `~/.config/opencode/skills/terraform-skill/`, you can use it in several ways:

#### **Method 1: Direct Query (Recommended)**

```bash
# Just ask OpenCode about Terraform topics
# The skill activates automatically

opencode "Create a Terraform module for AWS VPC with native tests"
opencode "Generate a GitHub Actions workflow for Terraform cost estimation"
opencode "Help me choose between Terratest and native tests"
```

#### **Method 2: Load Skill Explicitly**

```bash
# If you need to force skill loading
skill(name="terraform-skill")

# Then ask your Terraform question
opencode "Review this Terraform configuration for best practices"
```

#### **Method 3: Via Agent Prompts**

The skill can be referenced in agent prompts:

```bash
# homelab-agent will use terraform-skill for Terraform work
/deploy "Deploy infrastructure as code using Terraform"
```

### In Windows Terminal (If OpenCode on Windows)

```powershell
opencode "Create a Terraform testing strategy for my modules"
# terraform-skill activates and provides guidance
```

---

## Examples

### Example 1: Module Structure

```
Query: "Create a Terraform module for AWS S3 with good structure"

terraform-skill provides:
- Directory layout: terraform-aws-s3/
  ├─ main.tf
  ├─ variables.tf
  ├─ outputs.tf
  ├─ versions.tf
  ├─ tests/
  │  └─ default_test.tf (native test)
  └─ README.md

- Naming conventions: terraform-<provider>-<name>
- Input variables: Ordered by frequency of use
- Output values: Include descriptions
- Documentation: Generated with terraform-docs
```

### Example 2: Testing Strategy

```
Query: "Should I use native tests or Terratest for my modules?"

terraform-skill provides:

NATIVE TESTS (Terraform 1.6+) ✅
├─ Use when: Simple validation, assertions
├─ Pros: Built-in, no Go knowledge needed
├─ Cons: Limited to Terraform testing
└─ Example: Basic assertions in .tf files

TERRATEST (Go-based) ✅
├─ Use when: Full lifecycle testing, complex scenarios
├─ Pros: Can test actual infrastructure, more flexible
├─ Cons: Requires Go knowledge, costs more to run
└─ Example: Full module provisioning + testing
```

### Example 3: CI/CD Workflow

```
Query: "Generate a GitHub Actions workflow for Terraform"

terraform-skill provides:

Workflow includes:
1. Validate - Check syntax
2. Format - Run terraform fmt
3. Plan - terraform plan with cost estimation (Infracost)
4. Security - Scan with Trivy/Checkov
5. Apply - Manual approval + terraform apply
6. Drift Detection - Scheduled plan runs

Plus:
- Cost estimation output in PR comments
- Drift notifications
- State locking with S3 backend
```

---

## Integration with OpenCode Agents

### For Infrastructure Work

Your `homelab-agent.md` can reference terraform-skill:

```markdown
## Terraform/Infrastructure Tasks

When working with Terraform/OpenTofu:
1. Activate terraform-skill from ~/.config/opencode/skills/terraform-skill/
2. Follow testing patterns, module design, CI/CD guidance
3. Reference terraform-best-practices.com patterns
4. Use decision matrices for technology choices
```

### For Development Workflows

Your `planner` agent can use terraform-skill when planning infrastructure:

```markdown
## Planning Infrastructure Changes

If planning Terraform/infrastructure work:
1. Load terraform-skill
2. Use its decision frameworks for architecture choices
3. Plan testing strategy (native vs Terratest)
4. Design CI/CD workflow
5. Create implementation steps
```

---

## Key Files in terraform-skill

### SKILL.md (Main)
Core skill definition with:
- Detailed guidance on testing strategies
- Module development patterns
- CI/CD workflows
- Security & compliance patterns
- Quick reference materials

**Location:** `~/.config/opencode/skills/terraform-skill/SKILL.md`

### references/ (Deep Dives)
Detailed reference materials on specific topics:
- Testing frameworks
- Module patterns
- CI/CD tools
- Security scanning
- Common anti-patterns

**Location:** `~/.config/opencode/skills/terraform-skill/references/`

### README.md
Quick start guide and overview

### CLAUDE.md
Development guidelines for contributing to the skill

### tests/
Validation examples and test patterns

---

## Configuration

### Enabling the Skill in OpenCode

The skill is automatically available once synced to `~/.config/opencode/skills/terraform-skill/`.

**No configuration needed** - OpenCode auto-discovers skills in the `skills/` directory.

### Optional: Add Terraform Command

You can optionally add a `/terraform` command in OpenCode:

**File:** `dot_config/opencode/command/terraform.md`

```markdown
---
description: >-
  Terraform expert guidance using terraform-skill.
  Use for module design, testing strategy, CI/CD workflows,
  and infrastructure best practices.
---

## /terraform command

Use this command to invoke terraform-skill for infrastructure work.

### Usage

```
/terraform "Create a module with testing"
/terraform "Generate a GitHub Actions workflow"
/terraform "Review this Terraform configuration"
```

### What It Does

1. Loads terraform-skill from ~/.config/opencode/skills/terraform-skill/
2. Answers your question using best practices from the skill
3. Provides decision frameworks for architecture choices
4. References terraform-best-practices.com patterns
5. Suggests security and testing approaches
```

---

## Workflow Examples

### Workflow 1: Create a Production Terraform Module

```bash
# In WSL, start with terraform-skill active

opencode "I need to create a production-ready Terraform module for AWS RDS"

# terraform-skill guides on:
✅ Module structure (terraform-aws-rds/)
✅ Variable organization (count vs for_each)
✅ Testing strategy (native tests + Terratest)
✅ Documentation (terraform-docs)
✅ Versioning (semantic versioning)
✅ CI/CD integration (GitHub Actions)

# Result: Production-grade module following all best practices
```

### Workflow 2: Design Infrastructure Deployment

```bash
# In homelab-agent context

/plan "Design Terraform infrastructure for homelab with proper testing and CI/CD"

# planner uses terraform-skill to:
✅ Create testing strategy plan
✅ Design CI/CD workflow
✅ Plan module structure
✅ Design state management
✅ Plan security scanning

# Result: Detailed implementation plan from planner agent
```

### Workflow 3: Review Terraform Code

```bash
# Direct question with terraform-skill

opencode "Review this Terraform configuration for best practices"
# [paste code]

# terraform-skill checks for:
✅ Naming conventions
✅ Resource organization
✅ Variable/output design
✅ Security issues
✅ Performance patterns
✅ Compliance

# Result: Detailed review with specific improvements
```

---

## Maintaining terraform-skill

### Update to Latest Version

Since terraform-skill is added as a submodule, updates are easy:

```bash
# In dotfiles repo
git submodule update --remote dot_config/opencode/skills/terraform-skill

# Or pull latest manually
cd dot_config/opencode/skills/terraform-skill
git pull origin master

# Then commit and push
cd ../../../
git add dot_config/opencode/skills/terraform-skill
git commit -m "chore(skills): update terraform-skill to latest"
git push --recurse-submodules=on-demand
```

### Check Current Version

```bash
wsl -- bash -c "cat ~/.config/opencode/skills/terraform-skill/README.md | grep -i 'version\\|release'"
```

### Contributors & Attribution

**Original Author:** Anton Babenko  
**Repository:** https://github.com/antonbabenko/terraform-skill  
**Based On:** https://terraform-best-practices.com  
**License:** Apache 2.0

---

## Alacritty Integration Note

Your Alacritty terminal (on Windows) launches directly into WSL with tmux:

```toml
[terminal]
shell = { program = "wsl.exe", args = ["-d", "Ubuntu-24.04", "-e", "tmux"] }
```

**This means:**
- ✅ You open Alacritty (Windows app)
- ✅ It connects to WSL Ubuntu
- ✅ terraform-skill is available in your shell environment
- ✅ OpenCode server in WSL can access and use the skill

**Workflow:**
```
Open Alacritty → WSL Shell → Type: opencode "terraform question" → terraform-skill activates
```

---

## Troubleshooting

### terraform-skill Not Found

**Problem:** `skill not found: terraform-skill`

**Solution:**
```bash
# Check if it synced
wsl -- bash -c "ls -la ~/.config/opencode/skills/terraform-skill/"

# If missing, manually pull
wsl -- bash -c "cd ~/.local/share/chezmoi && git pull --recurse-submodules"
wsl -- bash -c "chezmoi update"

# Verify
wsl -- bash -c "ls -la ~/.config/opencode/skills/terraform-skill/SKILL.md"
```

### Submodule Not Updated on Commit

**Problem:** `git commit` doesn't include submodule changes

**Solution:**
```bash
# Use recurse-submodules flag
git push --recurse-submodules=on-demand

# Or configure globally
git config push.recurseSubmodules on-demand
```

### Cannot Access terraform-skill from OpenCode

**Problem:** OpenCode doesn't recognize terraform-skill

**Solution:**
```bash
# Verify chezmoi applied it
chezmoi diff

# Check permissions
wsl -- bash -c "ls -la ~/.config/opencode/skills/"

# Reload OpenCode
opencode /reload
# or restart your terminal
```

---

## Next Steps

1. ✅ **Already Done:** terraform-skill added to dotfiles
2. ⏳ **Next:** Sync to WSL via `chezmoi update`
3. ⏳ **Then:** Test with `opencode "Create a Terraform module"`
4. ⏳ **Optional:** Install on Windows if using OpenCode there
5. ⏳ **Optional:** Create `/terraform` command for quick access

---

## Resources

### Official
- **terraform-skill Repository:** https://github.com/antonbabenko/terraform-skill
- **Terraform Best Practices:** https://terraform-best-practices.com
- **Terraform Documentation:** https://developer.hashicorp.com/terraform/docs

### Related Skills in Your Setup
- `homelab-context` - Homelab infrastructure reference (complementary)
- `deploy` - Infrastructure deployment workflows (can use with terraform-skill)

### Tools Complementary to terraform-skill
- **terraform-docs** - Auto-generate module documentation
- **TFLint** - Terraform linter (patterns in skill)
- **Terratest** - Go-based infrastructure testing (guidance in skill)
- **Infracost** - Cost estimation (CI/CD patterns in skill)
- **Trivy** - Security scanning (covered in skill)
- **Checkov** - Policy-as-code (covered in skill)

---

## FAQ

**Q: Is terraform-skill a replacement for Terraform documentation?**  
A: No. It's a supplement that provides best practices, decision frameworks, and patterns. Always refer to official Terraform docs for API details.

**Q: Does it work with OpenTofu too?**  
A: Yes! terraform-skill covers both Terraform 1.0+ and OpenTofu 1.6+.

**Q: Can I customize the skill for my organization?**  
A: Yes. You can extend it by creating additional skills that reference terraform-skill patterns.

**Q: Will it slow down OpenCode?**  
A: No. It's loaded on-demand only when Terraform-related queries are detected.

**Q: How often is terraform-skill updated?**  
A: Releases use semantic versioning. Check GitHub releases for updates.

---

## Summary

✅ **What:** Claude AI skill for Terraform best practices  
✅ **Where:** `~/.config/opencode/skills/terraform-skill/` (WSL) + GitHub submodule  
✅ **How:** Automatically activates for Terraform queries  
✅ **Why:** Production-ready infrastructure code with proven patterns  
✅ **Status:** Ready to use (syncs on next `chezmoi update`)
