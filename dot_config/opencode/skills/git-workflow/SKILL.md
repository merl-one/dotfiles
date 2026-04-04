---
name: git-workflow
description: Git workflow skill for meticulous version control. Covers branch naming, atomic commits, descriptive messages, and safe push practices. Use this when working with git operations to ensure clean, separated commits and proper branch management.
---

# Git Workflow Skill

## Concept
We work meticulously in Git. We do not do blind commits containing tons of disparate files.

## Guidelines
1. **Branch Naming**: Keep branches lower-case and tokenized by dashes (`feature/new-login`).
2. **Atomic Commits**: Commits MUST contain single logical units of work. Run multiple `git add` commands separately if required. 
3. **Messages**: Write descriptive commit messages. Header should be < 50 chars, body can be detailed if required. 
4. **Push with care**: Always confirm with the user before pushing code.
