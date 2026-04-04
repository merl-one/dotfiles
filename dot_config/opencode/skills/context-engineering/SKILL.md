---
name: context-engineering
description: Context engineering skill for reading before writing and discovering code architecture before assuming how it functions. Use this when starting a new task to ensure proper codebase understanding before making changes.
---

# Context Engineering Skill

## Concept
Context engineering is the act of reading before writing, discovering code architecture before assuming how it functions.

## Guidelines
1. Do not use generic tools when specialized ones exist. Use `codebase-locator` and `codebase-analyzer` when you start a task.
2. Read enough to understand the dependencies around a module. Never alter an exported function until you check its references using search or problems.
3. Keep track of what you've investigated. 
