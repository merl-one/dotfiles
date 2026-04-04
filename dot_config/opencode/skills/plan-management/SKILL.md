---
name: plan-management
description: Plan management skill for creating and tracking implementation plans. Plans reside in plans/active/ and follow a standardized template with YAML frontmatter, phases with checkboxes, and structured sections. Use this when creating, updating, or managing implementation plans.
---

# Plan Management Skill

## Concept
Plans are how we avoid blind implementation. Plans reside in the `plans/active/` directory.

## Template
```markdown
---
status: draft | in-progress | blocked | complete
created: 2026-XX-XX
updated: 2026-XX-XX
tags: []
---

# Feature Name Plan

## Overview
Brief explanation.

## Current State Analysis
Findings with file references.

## Key Discoveries
Non-obvious things.

## Phases

### Phase 1: Context Definition
- [ ] Task list

## Open Questions / Risks
- What's broken
```
