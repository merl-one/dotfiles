---
name: deploy
description: Deploy homelab infrastructure changes through the GitLab CI pipeline. Handles the full lifecycle after code changes are made -- commit, push, monitor validate/plan stages, trigger the manual apply job via GitLab API (authenticated through Vault), and verify the deployment. Use this when the user says "deploy", "ship it", "push and apply", "run the pipeline", or after making Terraform/Ansible changes that need to go live.
---

# Deploy to Homelab

Full-lifecycle deployment of homelab-iac changes through the GitLab CI pipeline. This skill handles everything from commit to verified apply.

## When to Use

- After making Terraform or Ansible changes in `homelab-iac`
- When the user says "deploy", "push and apply", "run the pipeline", "ship it"
- Automatically after editing infrastructure code (the agent should offer to deploy)

## Prerequisites

- Working directory: `C:\Users\jason\Documents\GitLab\homelab-iac`
- Git remote: GitLab at `gitlab.home.arpa`
- Vault must be unsealed at `vault.home.arpa`
- homelab-mcp tools available: `execute_command`, `query_homelab`
- Always use DNS names (`*.home.arpa`), never raw IPs

## Workflow

### Step 1 -- Pre-flight checks

Run in parallel:
```bash
# In homelab-iac directory
git status
git diff --stat
git log --oneline -3
```

Verify:
- There are changes to commit (abort if clean)
- Changes are in expected directories (Terraform workspaces, Ansible, K8s manifests, config/)
- No secrets or .env files are staged

### Step 2 -- Identify affected workspaces

From the changed files, determine which CI workspace jobs will trigger. The mapping:
- `infrastructure/terraform/<workspace>/` -> `<workspace>:validate`, `<workspace>:plan`, `<workspace>:apply`
- `infrastructure/ansible/` -> ansible jobs
- `kubernetes/` -> `k8s-cluster` jobs
- `config/` -> may need manual assessment

Report to the user: "This push will trigger pipeline jobs for: <workspace list>"

### Step 3 -- Commit and push

```bash
git add <relevant files>    # NEVER git add -A blindly
git commit -m "<type>(<scope>): <description>"
git push origin master
```

Commit message conventions:
- `feat(workspace):` for new resources
- `fix(workspace):` for bug fixes
- `refactor(workspace):` for restructuring
- `ci:` for pipeline changes
- `docs:` for documentation

Capture the commit SHA from the push output.

### Step 4 -- Get GitLab API token from Vault

```
execute_command(host="vault.home.arpa", command="vault kv get -field=api_token infrastructure/gitlab")
```

Store the token for subsequent API calls.

### Step 5 -- Find the pipeline

Wait ~10 seconds after push, then find the pipeline for our commit:

```
execute_command(host="vault.home.arpa", command="curl -sS -H 'PRIVATE-TOKEN: <token>' 'https://gitlab.home.arpa/api/v4/projects/<pid>/pipelines?sha=<commit_sha>&per_page=1' | jq '.[0]'")
```

If project ID is not known, look it up first:
```
execute_command(host="vault.home.arpa", command="curl -sS -H 'PRIVATE-TOKEN: <token>' 'https://gitlab.home.arpa/api/v4/projects?search=homelab-iac' | jq '.[0].id'")
```

### Step 6 -- Monitor validate and plan stages

Poll every 20 seconds until all non-manual jobs complete:

```
execute_command(host="vault.home.arpa", command="curl -sS -H 'PRIVATE-TOKEN: <token>' 'https://gitlab.home.arpa/api/v4/projects/<pid>/pipelines/<pipeline_id>/jobs?per_page=50' | jq '[.[] | {id, name, stage, status}]'")
```

Wait for:
- All `validate` stage jobs: status `success`
- All `plan` stage jobs: status `success`
- All `security` stage jobs (if any): status `success`

If ANY job fails:
1. Fetch the job trace: `GET /api/v4/projects/<pid>/jobs/<job_id>/trace`
2. Report the failure with relevant log lines
3. DO NOT proceed to apply
4. Help diagnose and fix the issue

### Step 7 -- Safety check on plan output

Before triggering apply, review the plan artifact:
```
execute_command(host="vault.home.arpa", command="curl -sS -H 'PRIVATE-TOKEN: <token>' 'https://gitlab.home.arpa/api/v4/projects/<pid>/jobs/<plan_job_id>/trace' | tail -50")
```

**Auto-apply** (trigger without asking) if the plan shows:
- Only additions or modifications to non-critical resources
- Changes match what was intended by the code edit

**Stop and ask the user** if the plan shows ANY of:
- `destroy` actions on existing resources
- Changes to critical services: Vault, GitLab, DNS (Technitium/Gateway), PostgreSQL, Proxmox Backup Server
- More changes than expected (e.g., edited one file but plan shows 10 resource changes)
- Any `-/+` (destroy and recreate) on stateful resources

### Step 8 -- Trigger the manual apply job(s)

Find the manual apply job(s):
```
execute_command(host="vault.home.arpa", command="curl -sS -H 'PRIVATE-TOKEN: <token>' 'https://gitlab.home.arpa/api/v4/projects/<pid>/pipelines/<pipeline_id>/jobs' | jq '[.[] | select(.stage==\"apply\" and .status==\"manual\") | {id, name}]'")
```

Trigger each apply job:
```
execute_command(host="vault.home.arpa", command="curl -sS -X POST -H 'PRIVATE-TOKEN: <token>' 'https://gitlab.home.arpa/api/v4/projects/<pid>/jobs/<apply_job_id>/play'")
```

### Step 9 -- Monitor the apply

Poll every 20 seconds until the apply job completes:
```
execute_command(host="vault.home.arpa", command="curl -sS -H 'PRIVATE-TOKEN: <token>' 'https://gitlab.home.arpa/api/v4/projects/<pid>/jobs/<apply_job_id>' | jq '{status, finished_at, duration}'")
```

On completion, fetch the last 30 lines of the trace to confirm success:
```
execute_command(host="vault.home.arpa", command="curl -sS -H 'PRIVATE-TOKEN: <token>' 'https://gitlab.home.arpa/api/v4/projects/<pid>/jobs/<apply_job_id>/trace' | tail -30")
```

### Step 10 -- Verify deployment

After successful apply:
1. Use `query_homelab` to verify the affected resources are in the expected state
2. If a new VM/LXC was created, verify it appears in the inventory
3. If DNS records changed, verify resolution
4. Report the final status to the user

## Error Recovery

### Pipeline stuck or no jobs triggered
- Check that the changed files match a workspace include rule in `.gitlab-ci.yml`
- The root CI file only includes workspace jobs when their directories change

### Vault authentication failure in pipeline
- Vault may be sealed: `execute_command(host="vault.home.arpa", command="vault status")`
- JWT auth may need renewal

### Apply fails
1. Fetch full job trace
2. Common issues: state lock (use force-unlock job), provider auth expired, resource conflict
3. Fix the issue and push a new commit -- do NOT retry the same failed apply

### State lock
If Terraform reports a state lock:
- Find the lock ID in the error message
- The pipeline has a `.terraform_force_unlock` manual job template
- Or use: `terraform force-unlock -force <lock_id>` via the workspace's force-unlock CI job

## Rules

- **All API calls go through the Vault host** (`vault.home.arpa`) via `execute_command` since it has network access to GitLab and has `curl`+`jq` installed.
- **Never skip the plan review.** Always check what the plan intends to do before triggering apply.
- **Never manually apply outside CI.** The pipeline ensures Vault auth, secrets loading, and proper state management.
- **One push at a time.** Wait for the current pipeline to complete before pushing more changes to the same workspace.
- **Critical service changes require user confirmation:** Vault, GitLab, DNS, Gateway, PostgreSQL, PBS.
