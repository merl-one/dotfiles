---
name: homelab-context
description: Homelab infrastructure context and architecture reference. Load this skill when working on any homelab-related task -- infrastructure management, Terraform/Ansible changes, service troubleshooting, VM/LXC operations, or DNS/domain configuration. Provides architecture essentials, MCP tool usage, and pointers to live documentation.
---

# Homelab Context

This skill provides everything you need to understand and work with the homelab infrastructure.

## Three Layers of Context

### Layer 1: Static Architecture (below)
Essential reference that rarely changes -- nodes, IPs, domains, IaC structure.

### Layer 2: Live State (via homelab-mcp)
Always query `homelab-mcp` for current state. Static docs may be stale.
- `query_homelab(query="list all running VMs")` -- live VM/LXC inventory with CPU/memory/uptime
- `query_homelab(query="status of <service>", vm_id="<id>")` -- specific VM/LXC details
- `query_homelab(query="terraform config for <workspace>")` -- current Terraform resource configs
- `query_homelab(query="<any architecture question>")` -- architecture rules, conventions, Ansible inventory
- `execute_command(host="<ip>", command="<cmd>")` -- SSH into hosts (dangerous commands auto-blocked)

### Layer 3: Deep Documentation (homelab-iac repo)
For detailed reference, read files from the IaC monorepo at:
`C:\Users\jason\Documents\GitLab\homelab-iac\docs\`

Key docs by topic:
| Topic | File |
|-------|------|
| **Full architecture overview** | `docs/index.md` and `README.md` |
| **Network topology & IP map** | `docs/architecture/network-topology.md` and `docs/reference/network-map.md` |
| **Secrets & identity (Vault, Authentik)** | `docs/concepts/secrets-and-identity.md` |
| **GitOps & IaC workflow** | `docs/concepts/gitops-and-iac.md` |
| **Kubernetes architecture** | `docs/concepts/kubernetes-architecture.md` |
| **Storage & backup** | `docs/concepts/storage-and-backup.md` |
| **Monitoring & observability** | `docs/concepts/monitoring-observability.md` |
| **CI/CD pipeline** | `docs/architecture/ci-cd-pipeline.md` |
| **Terraform workspaces** | `docs/reference/terraform-workspaces.md` |
| **Ansible playbooks** | `docs/reference/ansible-playbooks.md` |
| **Vault secret paths** | `docs/reference/vault-secret-paths.md` |
| **DNS zones** | `docs/reference/dns-zones.md` |
| **Traefik routes** | `docs/reference/traefik-routes.md` |
| **VM/LXC inventory** | `docs/reference/inventory.md` |
| **Architecture Decision Records** | `docs/architecture/adr/` (17 ADRs) |

Operations runbooks:
| Runbook | File |
|---------|------|
| **Add a new service** | `docs/operations/add-new-service.md` |
| **Add SSO application** | `docs/operations/add-sso-application.md` |
| **Add K8s workload** | `docs/operations/add-k8s-workload.md` |
| **Vault operations** | `docs/operations/vault-operations.md` |
| **Disaster recovery** | `docs/operations/disaster-recovery.md` |
| **Troubleshooting** | `docs/operations/troubleshooting.md` |
| **VM/LXC unresponsive** | `docs/operations/runbooks/vm-lxc-unresponsive.md` |
| **Vault sealed** | `docs/operations/runbooks/vault-sealed.md` |
| **DNS failure** | `docs/operations/runbooks/dns-resolution-failure.md` |
| **Cert expiration** | `docs/operations/runbooks/certificate-expiration.md` |

Terraform source code: `C:\Users\jason\Documents\GitLab\homelab-iac\infrastructure\terraform\`
Ansible source code: `C:\Users\jason\Documents\GitLab\homelab-iac\infrastructure\ansible\`
Kubernetes manifests: `C:\Users\jason\Documents\GitLab\homelab-iac\kubernetes\`

---

## Architecture Essentials

### Proxmox Nodes
| Node | IP | Purpose |
|------|----|---------|
| proxmox (main) | 192.168.0.10 | Primary hypervisor: core services, game servers, apps |
| proxmox-nas | 192.168.0.11 | NAS hypervisor: storage, media, monitoring |

**SSH users**: `root` for Alpine LXCs, `jason` for Ubuntu VMs.

### Infrastructure-as-Code
Everything is managed through `homelab-iac` (GitLab monorepo):
- **17 Terraform workspaces** grouped by function: `security-vault/`, `security-identity/`, `platform-cicd/`, `platform-database/`, `platform-automation/`, `platform-containers/`, `networking/`, `observability/`, `storage/`, `k8s-cluster/`, `apps-media/`, `apps-personal/`, `apps-ai/`, `apps-games/`, `apps-network/`, `proxmox-pdm/`
- **4 shared Terraform modules**: `proxmox-vm/`, `proxmox-lxc/`, `dns-record/`, `traefik-route/`
- **Ansible playbooks**: `ansible/playbooks/core/`, `ansible/playbooks/apps/`, `ansible/playbooks/ops/`
- **4-node Talos K8s cluster** managed via Flux GitOps with 4-tier manifest hierarchy
- **Pipeline**: push to main -> auto plan -> manual apply (GitLab CI, include-only orchestrator pattern)

### Secrets
All secrets live in **Vault** at `vault.home.arpa` (192.168.0.52). Never hardcode. Retrieve via:
```
execute_command(host="vault.home.arpa", command="vault kv get -field=<field> <path>")
```

### Domains
- `*.merl.one` -- public access (Cloudflare Tunnel, requires Authentik SSO)
- `*.home.arpa` -- internal LAN access (TechnitiumDNS, Traefik reverse proxy)

### Key Services
| Service | Purpose |
|---------|---------|
| Vault (vault.home.arpa) | Secrets management |
| Authentik | SSO/OIDC identity provider |
| GitLab CE | Source control, CI/CD |
| Traefik | Reverse proxy, TLS termination |
| Technitium | Internal DNS |
| Prometheus + Grafana + Loki | Monitoring & observability |
| Proxmox Backup Server | VM/LXC backup |

---

## Rules (Non-Negotiable)

1. **Never provision or destroy infrastructure via SSH.** Always use Terraform via GitLab CI.
2. **Never hardcode secrets.** All secrets live in Vault.
3. **All changes go through homelab-iac:** edit code -> commit -> push -> pipeline validates/plans -> trigger manual apply via GitLab API. You are expected to own this full lifecycle, not just edit files and hand off.
4. **Always query live state first** via `query_homelab` before running SSH commands.
5. **Nothing is configured manually.** If it is not in the `homelab-iac` repository, it does not exist.
6. **Always push and deploy.** After making Terraform/Ansible changes, push to GitLab, monitor the pipeline, and trigger the apply job if validate+plan pass. Use the GitLab API token from Vault (`infrastructure/gitlab` -> `api_token`) to interact with the GitLab API programmatically.
7. **The agent deploys autonomously.** If validate and plan stages pass with no errors, trigger the manual apply without asking. Only stop and ask if the plan shows unexpected destroys or changes to critical services (Vault, GitLab, DNS, Gateway).
8. **Use DNS names, not IPs.** Always use `*.home.arpa` DNS entries when connecting to services via `execute_command` or API calls. IPs change; DNS names are the stable identifier. Only fall back to raw IPs if DNS resolution is broken (and that itself is a problem to fix).

---

## Deploy Workflow (Critical)

**homelab-iac is the single source of truth.** Any Terraform-managed infrastructure change MUST flow through the GitLab CI pipeline. The agent is expected to own the full lifecycle: edit code, commit, push, monitor the pipeline, and trigger the manual apply if all checks pass.

### The Pipeline Flow

```
push to master
  -> validate (auto: fmt, validate, security scan)
  -> plan (auto: terraform plan, saved as artifact)
  -> apply (MANUAL gate: terraform apply using saved plan)
  -> configure (auto: ansible post-provision if applicable)
```

Only workspace-scoped jobs run -- determined by which directories changed. E.g., touching `infrastructure/terraform/apps-media/` only triggers `apps-media:validate`, `apps-media:plan`, `apps-media:apply`.

### How to Deploy

When making Terraform or Ansible changes, you MUST follow this sequence:

1. **Edit** files in `C:\Users\jason\Documents\GitLab\homelab-iac\`
2. **Commit and push** to `master` (or push a branch and merge)
3. **Monitor** the pipeline -- wait for validate and plan stages to pass
4. **Trigger apply** -- the apply stage has `when: manual`. Use the GitLab API to play the manual job.
5. **Verify** -- check the apply job output and optionally query live state via `homelab-mcp`

### GitLab API Authentication

The GitLab API token is stored in Vault:
```
vault kv get -field=api_token infrastructure/gitlab
```

Retrieve it via SSH to the Vault host:
```
execute_command(host="vault.home.arpa", command="vault kv get -field=api_token infrastructure/gitlab")
```

### GitLab API Calls

**GitLab instance**: `https://gitlab.home.arpa` (via Traefik)
**Project**: `jason/homelab-iac`
**Project ID**: Look up via `GET /api/v4/projects?search=homelab-iac`

Key API endpoints (use the token as `PRIVATE-TOKEN` header):

```bash
# Get project ID
curl -sS -H "PRIVATE-TOKEN: $TOKEN" "https://gitlab.home.arpa/api/v4/projects?search=homelab-iac" | jq '.[0].id'

# List pipelines (most recent first)
curl -sS -H "PRIVATE-TOKEN: $TOKEN" "https://gitlab.home.arpa/api/v4/projects/$PID/pipelines?per_page=5"

# Get jobs for a pipeline
curl -sS -H "PRIVATE-TOKEN: $TOKEN" "https://gitlab.home.arpa/api/v4/projects/$PID/pipelines/$PIPELINE_ID/jobs"

# Play (trigger) a manual job
curl -sS -X POST -H "PRIVATE-TOKEN: $TOKEN" "https://gitlab.home.arpa/api/v4/projects/$PID/jobs/$JOB_ID/play"

# Get job status
curl -sS -H "PRIVATE-TOKEN: $TOKEN" "https://gitlab.home.arpa/api/v4/projects/$PID/jobs/$JOB_ID"

# Get job log/trace
curl -sS -H "PRIVATE-TOKEN: $TOKEN" "https://gitlab.home.arpa/api/v4/projects/$PID/jobs/$JOB_ID/trace"
```

### Monitoring Strategy

After pushing, poll the pipeline:
1. Wait ~10s, then fetch the pipeline for the pushed commit
2. Poll job statuses every 15-30s until validate + plan stages complete
3. If all jobs pass, find the `manual` apply job(s) and trigger them via `POST .../jobs/$JOB_ID/play`
4. Poll the apply job until it completes
5. Report success/failure to the user with the job log URL
6. On failure, fetch the job trace and diagnose

### Workspace-to-Directory Mapping

The apply job name follows the pattern `<workspace>:apply`. The workspace name maps to:
| Job prefix | Terraform directory |
|------------|-------------------|
| `security-vault` | `infrastructure/terraform/security-vault/` |
| `security-identity` | `infrastructure/terraform/security-identity/` |
| `platform-cicd` | `infrastructure/terraform/platform-cicd/` |
| `platform-database` | `infrastructure/terraform/platform-database/` |
| `platform-automation` | `infrastructure/terraform/platform-automation/` |
| `platform-containers` | `infrastructure/terraform/platform-containers/` |
| `networking` | `infrastructure/terraform/networking/` |
| `observability` | `infrastructure/terraform/observability/` |
| `storage` | `infrastructure/terraform/storage/` |
| `k8s-cluster` | `infrastructure/terraform/k8s-cluster/` |
| `apps-media` | `infrastructure/terraform/apps-media/` |
| `apps-personal` | `infrastructure/terraform/apps-personal/` |
| `apps-ai` | `infrastructure/terraform/apps-ai/` |
| `apps-games` | `infrastructure/terraform/apps-games/` |
| `apps-network` | `infrastructure/terraform/apps-network/` |
| `proxmox-pdm` | `infrastructure/terraform/proxmox-pdm/` |

---

## Troubleshooting Workflow

1. **Identify**: Use `query_homelab` to check VM/LXC status and find the relevant host
2. **Investigate**: Use `execute_command` to check logs, service status, disk/memory
3. **Diagnose**: Cross-reference with architecture docs and Terraform/Ansible source
4. **Fix**: For config changes, edit homelab-iac, commit, push, and deploy through the pipeline (see Deploy Workflow above). For immediate operational fixes (restart, clear cache), use `execute_command`
5. **Document**: If this is a new issue pattern, suggest adding a runbook
