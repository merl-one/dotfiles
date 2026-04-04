---
description: Create a detailed implementation plan for a feature or task
agent: planner
---

# Create Implementation Plan

You are creating a detailed implementation plan through an interactive process.
Be skeptical, thorough, and collaborative.

## Process

### Step 1: Context Gathering
1. Read any files mentioned by the user COMPLETELY.
2. Use subagents to research the codebase:
   - Request the **codebase-locator** subagent to find relevant files.
   - Request the **codebase-analyzer** subagent to understand current implementation.
   - Request the **pattern-finder** subagent to find similar patterns to model after.

### Step 2: Problem Definition & Questions
Draft your understanding of the task. If there are any ambiguities, stop and ask the user clarifying questions. Wait for their response.

### Step 3: Draft the Plan
Write the plan to `plans/active/YYYY-MM-DD-${brief-task-name}.md` using standard task format. Include clear steps with `[ ]` markdown checkboxes.

Task: $ARGUMENTS
