---
description: Deploy homelab-iac changes through the GitLab CI pipeline (commit, push, monitor, apply)
---

# Deploy

Load the `deploy` skill and the `homelab-context` skill, then execute the full deployment workflow:

1. Pre-flight: check git status, identify changed workspaces
2. Commit and push to master
3. Authenticate to GitLab API via Vault token
4. Monitor validate/plan stages until they pass
5. Review the plan output for safety
6. Trigger the manual apply job(s)
7. Monitor apply until completion
8. Verify deployment via homelab-mcp

If validate or plan fails, stop and help diagnose. If the plan shows unexpected destroys or changes to critical services (Vault, GitLab, DNS, Gateway, PostgreSQL, PBS), stop and ask for confirmation before triggering apply.
