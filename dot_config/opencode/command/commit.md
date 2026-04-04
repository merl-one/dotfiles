---
description: Stage and commit current changes atomically
agent: committer
---

# Atomic Commits

1. Run `git status` and `git diff` via terminal.
2. Formulate a set of atomic, independent commits instead of one large blob.
3. Present your commit plan to the user. Wait for explicit confirmation.
4. If approved, add specific files via `git add <file>`, NEVER `git add -A`.
5. Execute `git commit -m "..."`. Use descriptive messages.
