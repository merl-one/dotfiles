# CLI / Linux Workflow Setup

## TL;DR

> **Quick Summary**: Bootstrap a complete modern CLI/Linux developer workflow on Windows via WSL2, starting from an empty dotfiles repo. Every config file is tracked with chezmoi so the setup is reproducible on any future Linux machine.
>
> **Deliverables**:
> - WSL2 Ubuntu environment with essential CLI tools
> - chezmoi-managed dotfiles repo (zsh, tmux, neovim, alacritty, git, starship)
> - Neovim + LazyVim configured for Python, TypeScript, Terraform, YAML
> - Obsidian vault with Zettelkasten structure + CLI note workflow
> - Homelab CLI toolkit (k9s, kubectl aliases, kubeconfig management)
> - Fabric + shell AI integration (`??` query shortcut)
> - VS Code Vim extension as muscle-memory on-ramp before full LazyVim switch
>
> **Estimated Effort**: Large (spread across focused weekends)
> **Parallel Execution**: YES — 4 waves, up to 7 tasks running concurrently in Wave 2
> **Critical Path**: Task 1 → Tasks 3+5 → Task 9 → Task 10 → Final Verification

---

## Context

### Original Request
Windows power user with a sophisticated homelab (Talos K8s, FluxCD, Terraform, Vault) who uses
VS Code + PowerShell today. Wants to close the gap between infrastructure sophistication and
day-to-day dev environment. Goals: dotfiles, Neovim/LazyVim, tmux, zsh, Obsidian+Zettelkasten
notes, git CLI, k9s, Fabric AI. Pace: "rip the bandaid".

### Interview Summary
**Key Discussions**:
- OS strategy: WSL2 first, dual boot only if WSL2 proves insufficient (gaming stays on Windows)
- Current editor: VS Code with PowerShell terminal — no CLI git, no vim experience
- Homelab: Enterprise-grade (Talos K8s + FluxCD + full observability stack) — user is technically capable
- Vim path decided: VS Code Vim extension for muscle memory FIRST, then migrate to LazyVim
- Notes: No existing system — building Obsidian+Zettelkasten from scratch
- Dotfiles repo: `C:\Users\jason\Documents\GitLab\dotfiles` — empty, clean slate
- WSL2: Installed but never used — immediate opportunity

**Research Findings**:
- Dotfiles repo is completely empty — no existing configs to preserve or conflict with
- Homelab uses GitLab (self-hosted) and GitHub — both need credential management in WSL2
- User does Python, TypeScript, Infrastructure (HCL/YAML/Ansible) — all need LSPs in LazyVim
- chezmoi handles Windows+WSL2+Linux templates better than GNU Stow for this cross-platform case

---

## Work Objectives

### Core Objective
Transform an ignored WSL2 instance into a fully configured, dotfiles-managed Linux development
environment that matches the sophistication of the homelab infrastructure already in place.

### Concrete Deliverables
- `~/.config/` directory with chezmoi-tracked configs for: zsh, tmux, nvim, alacritty, starship, git, k9s
- `~/.local/bin/` with tool binaries (lazygit, delta, eza, bat, fzf, zoxide, etc.)
- Obsidian vault at `~/notes/` tracked as its own git repo
- `.zshrc` with plugins, aliases, fzf integration, zoxide, homelab kubectl aliases
- `.tmux.conf` with TPM plugins, sensible prefix, and session management
- `~/.config/nvim/` with LazyVim + LSPs for Python/TS/Terraform/YAML/Lua
- Alacritty config on Windows side pointing to WSL2
- Shell AI shortcut (`??` → calls AI for command help)
- Fabric installed with useful patterns for the user's workflow

### Definition of Done
- [ ] `chezmoi diff` shows zero untracked changes (all configs managed)
- [ ] `zsh --version` returns 5.x+ inside WSL2
- [ ] `tmux new -s dev` starts a session, prefix key works
- [ ] `nvim .` opens neovim with LazyVim UI, LSP attaches on a Python file
- [ ] `k9s` connects to homelab kubeconfig and shows cluster
- [ ] `echo "what does eza do" | ?? ` returns AI explanation
- [ ] Obsidian vault opens with proper folder structure in the GUI app
- [ ] All configs committed and pushed to dotfiles git repo

### Must Have
- chezmoi managing ALL config files (nothing manually placed without tracking)
- Neovim LSP working for at least Python and TypeScript
- tmux muscle memory: prefix key, split panes, sessions
- Git credential manager configured so WSL2 can push to both GitHub and GitLab
- k9s pointing to homelab kubeconfig
- One-command install script documented (for future fresh machine setup)

### Must NOT Have (Guardrails)
- Do NOT try to configure LazyVim from scratch — use the LazyVim distribution as-is and only add extras
- Do NOT install both oh-my-zsh AND zinit — pick zinit (more modern, faster, composable)
- Do NOT create Windows-side dotfiles (PowerShell profile, Windows Terminal config) — Windows is gaming/fallback only
- Do NOT set up devpod/devcontainers in this plan — out of scope, separate project
- Do NOT migrate away from VS Code immediately — Vim extension is the bridge, not a replacement
- Do NOT install every LazyVim extra at once — only language extras needed for actual daily work
- Do NOT over-configure zsh — resist adding every plugin, start with 5-6 essential ones
- Do NOT put secrets or tokens in dotfiles — use chezmoi encrypted fields or reference environment variables

---

## Verification Strategy

> **ZERO HUMAN INTERVENTION** — ALL verification is agent-executed. No exceptions.

### Test Decision
- **Infrastructure exists**: NO (this is a personal environment setup, not a code project)
- **Automated tests**: NO — not applicable for dotfiles/environment
- **Framework**: N/A
- **Primary verification**: Agent-Executed QA Scenarios for every task (shell commands, tool invocations)

### QA Policy
Every task includes shell-executable QA scenarios. The executing agent MUST run these after setup.
Evidence saved to `.sisyphus/evidence/task-{N}-{scenario-slug}.txt`.

- **Shell/CLI tools**: Use Bash — run the command, capture output, assert expected strings
- **TUI tools** (tmux, k9s, lazygit): Use interactive_bash (tmux) — launch, send keys, screenshot/capture
- **Editor** (nvim/LazyVim): Use interactive_bash — open file, check LSP attaches, capture output
- **Notes system**: Use Bash — create file, verify structure, open in nvim

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Sequential Foundation — must complete before everything else):
└── Task 1: WSL2 + Ubuntu 24.04 + essential packages [unspecified-high]

Wave 2 (After Wave 1 — MAX PARALLEL, all independent):
├── Task 2: chezmoi dotfiles manager init [quick]
├── Task 3: Zsh + zinit + core plugins (.zshrc) [unspecified-high]
├── Task 4: Starship prompt config [quick]
├── Task 5: Tmux + TPM + .tmux.conf [unspecified-high]
├── Task 6: Git CLI config (gitconfig, lazygit, delta, WSL2 credential bridge) [unspecified-high]
├── Task 7: Alacritty config (Windows side, targeting WSL2) [quick]
└── Task 8: VS Code Vim extension + vim training setup [quick]

Wave 3 (After Wave 2 — parallel, all independent of each other):
├── Task 9: Neovim + LazyVim base install + dotfiles structure [unspecified-high]
├── Task 10: Obsidian vault + Zettelkasten structure + git repo [unspecified-high]
├── Task 11: Homelab CLI tools (k9s, kubectl aliases, kubeconfig, FluxCD CLI, Helm) [unspecified-high]
└── Task 12: Fabric + shell AI integration (?? shortcut) [quick]

Wave 4 (After Task 9 only — LazyVim requires Neovim first):
├── Task 13: LazyVim language configs (Python, TypeScript, Terraform, YAML via Mason) [unspecified-high]
└── Task 14: LazyVim extras (Obsidian.nvim, markdown preview, tmux integration) [unspecified-high]

Wave FINAL (After ALL tasks — 3 parallel audits, then user explicit okay):
├── Task F1: Full bootstrap test from dotfiles repo [deep]
├── Task F2: Tool integration smoke test [unspecified-high]
└── Task F3: Scope fidelity + dotfiles completeness check [deep]
→ Present results → Get explicit user okay

Critical Path: Task 1 → Task 3 → Task 9 → Task 13 → F1-F3 → user okay
Parallel Speedup: ~65% faster than sequential
Max Concurrent: 7 (Wave 2)
```

### Dependency Matrix

| Task | Depends On | Blocks |
|------|-----------|--------|
| 1 | — | All |
| 2 | 1 | (chezmoi tracks output of 3-7) |
| 3 | 1 | 4, 9, 12 |
| 4 | 3 | — |
| 5 | 1 | 14 |
| 6 | 1 | — |
| 7 | 1 | — |
| 8 | — (Windows-side) | — |
| 9 | 3 | 13, 14 |
| 10 | 3 | — |
| 11 | 3 | — |
| 12 | 3 | — |
| 13 | 9 | F1 |
| 14 | 9, 5 | F1 |
| F1-F3 | 13, 14 | User okay |

### Agent Dispatch Summary

- **Wave 1**: 1 task — T1 → `unspecified-high`
- **Wave 2**: 7 tasks — T2,T4,T7,T8 → `quick`; T3,T5,T6 → `unspecified-high`
- **Wave 3**: 4 tasks — T12 → `quick`; T9,T10,T11 → `unspecified-high`
- **Wave 4**: 2 tasks — T13,T14 → `unspecified-high`
- **FINAL**: 3 tasks — F1,F3 → `deep`; F2 → `unspecified-high`

---

## TODOs

- [ ] 1. WSL2 Setup + Ubuntu 24.04 + Essential CLI Packages

  **What to do**:
  - Ensure WSL2 is enabled: `wsl --set-default-version 2` in PowerShell (admin)
  - Install Ubuntu 24.04: `wsl --install -d Ubuntu-24.04` (or use Microsoft Store)
  - On first launch, set username and password
  - Update Ubuntu: `sudo apt update && sudo apt upgrade -y`
  - Install essential packages in one apt command:
    ```
    sudo apt install -y git curl wget unzip zsh build-essential
    python3 python3-pip python3-venv nodejs npm
    ripgrep fd-find fzf bat tmux
    ```
  - Install tools NOT in apt (use curl/install scripts):
    - `eza` (modern ls): install from GitHub releases
    - `zoxide` (smart cd): `curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh`
    - `delta` (git diff pager): install from GitHub releases deb package
    - `lazygit`: install from GitHub releases tar.gz
    - `chezmoi`: `sh -c "$(curl -fsLS get.chezmoi.io)"`
    - `starship`: `curl -sS https://starship.rs/install.sh | sh`
  - Create symlink for `fd` (Ubuntu names it `fdfind`): `ln -s $(which fdfind) ~/.local/bin/fd`
  - Create symlink for `bat` (Ubuntu names it `batcat`): `ln -s $(which batcat) ~/.local/bin/bat`
  - Add `~/.local/bin` to PATH in `~/.profile`
  - Set zsh as default shell: `chsh -s $(which zsh)` (takes effect on next login)

  **Must NOT do**:
  - Do NOT install oh-my-zsh here — that's Task 3's job
  - Do NOT set up any git config yet — Task 6 handles that
  - Do NOT configure any tools yet — just get binaries installed

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Multi-step system setup with package management, version checks, and platform-specific workarounds
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Wave 1 — Sequential Foundation
  - **Blocks**: All other tasks
  - **Blocked By**: None (start immediately)

  **References**:
  - WSL2 install docs: `https://learn.microsoft.com/en-us/windows/wsl/install`
  - eza releases: `https://github.com/eza-community/eza/releases`
  - lazygit releases: `https://github.com/jesseduffield/lazygit/releases`
  - delta releases: `https://github.com/dandavison/delta/releases`
  - zoxide install: `https://github.com/ajeetdsouza/zoxide#installation`
  - starship install: `https://starship.rs/guide/#step-1-install-starship`
  - chezmoi install: `https://www.chezmoi.io/install/`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: All essential binaries are present and executable
    Tool: Bash
    Steps:
      1. Run: for cmd in git curl zsh tmux rg fd bat eza fzf zoxide delta lazygit starship chezmoi nvim; do which $cmd && $cmd --version 2>&1 | head -1; done
    Expected Result: Every command prints a version string, no "not found" errors
    Failure Indicators: Any "command not found" output
    Evidence: .sisyphus/evidence/task-1-binaries.txt

  Scenario: WSL2 is running kernel version 5.15+
    Tool: Bash
    Steps:
      1. Run: uname -r
    Expected Result: Kernel version string starting with 5.15 or higher
    Evidence: .sisyphus/evidence/task-1-kernel.txt

  Scenario: ~/.local/bin is on PATH with correct symlinks
    Tool: Bash
    Steps:
      1. Run: echo $PATH | grep -o '\.local/bin'
      2. Run: ls -la ~/.local/bin/fd ~/.local/bin/bat
    Expected Result: Both symlinks exist and resolve to real binaries
    Evidence: .sisyphus/evidence/task-1-localbin.txt
  ```

  **Evidence to Capture**:
  - [ ] task-1-binaries.txt — version output of all installed tools
  - [ ] task-1-kernel.txt — uname -r output
  - [ ] task-1-localbin.txt — ls -la of ~/.local/bin

  **Commit**: YES (group with Task 2)
  - Message: `chore(dotfiles): init wsl2 ubuntu with essential cli packages`

---

- [ ] 2. chezmoi Dotfiles Manager — Init and Link to Existing Git Repo

  **What to do**:
  - chezmoi is already installed from Task 1
  - The dotfiles git repo already exists at `C:\Users\jason\Documents\GitLab\dotfiles`
  - In WSL2, the Windows path is accessible at `/mnt/c/Users/jason/Documents/GitLab/dotfiles`
  - Initialize chezmoi pointing to the existing repo:
    ```bash
    chezmoi init --source /mnt/c/Users/jason/Documents/GitLab/dotfiles
    ```
  - Verify chezmoi source directory: `chezmoi source-path` should return the GitLab path
  - Create the chezmoi config file at `~/.config/chezmoi/chezmoi.toml`:
    ```toml
    [data]
      email = "jason@example.com"    # replace with actual
      name = "Jason"
      homelab_kubeconfig = "~/.kube/config"
    ```
  - Add the chezmoi config itself to chezmoi: `chezmoi add ~/.config/chezmoi/chezmoi.toml`
  - Create a `README.md` in the dotfiles repo root documenting bootstrap:
    ```markdown
    # Dotfiles
    Managed by chezmoi. To bootstrap on a new machine:
    1. Install chezmoi: sh -c "$(curl -fsLS get.chezmoi.io)"
    2. chezmoi init --apply https://gitlab.com/jason/dotfiles
    ```
  - Commit the initial chezmoi structure to the dotfiles repo

  **Must NOT do**:
  - Do NOT run `chezmoi apply` yet — configs don't exist to apply
  - Do NOT put actual secrets in `chezmoi.toml` — use chezmoi's encrypted fields or env vars
  - Do NOT use `--source` pointing to a temp directory — always point to the real GitLab repo path

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Straightforward init command with one config file and a README
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 3-8)
  - **Parallel Group**: Wave 2
  - **Blocks**: Nothing directly (but all later configs should be `chezmoi add`-ed)
  - **Blocked By**: Task 1

  **References**:
  - chezmoi quick start: `https://www.chezmoi.io/quick-start/`
  - chezmoi source init: `https://www.chezmoi.io/reference/commands/init/`
  - chezmoi config file: `https://www.chezmoi.io/reference/configuration-file/`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: chezmoi source path points to GitLab dotfiles repo
    Tool: Bash
    Steps:
      1. Run: chezmoi source-path
    Expected Result: Returns /mnt/c/Users/jason/Documents/GitLab/dotfiles (or configured path)
    Failure Indicators: Returns ~/.local/share/chezmoi (default, wrong location)
    Evidence: .sisyphus/evidence/task-2-source-path.txt

  Scenario: chezmoi.toml config is tracked and applies cleanly
    Tool: Bash
    Steps:
      1. Run: chezmoi managed | grep chezmoi
      2. Run: chezmoi diff
    Expected Result: chezmoi.toml appears in managed list; diff is empty
    Evidence: .sisyphus/evidence/task-2-chezmoi-managed.txt
  ```

  **Commit**: YES (group with Task 1)
  - Message: `chore(dotfiles): init chezmoi pointing to gitlab dotfiles repo`
  - Files: `README.md`, `.chezmoi.toml.tmpl` or `chezmoi.toml`

---

- [ ] 3. Zsh + zinit Plugin Manager + Core Plugins (.zshrc)

  **What to do**:
  - Install zinit (plugin manager):
    ```bash
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    ```
  - Create `~/.zshrc` with the following structure and content:
    ```zsh
    # --- zinit init ---
    source ~/.local/share/zinit/zinit.git/zinit.zsh

    # --- core plugins (load in this order) ---
    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-syntax-highlighting
    zinit light zsh-users/zsh-completions
    zinit light Aloxaf/fzf-tab

    # --- starship prompt ---
    eval "$(starship init zsh)"

    # --- zoxide (smart cd) ---
    eval "$(zoxide init zsh)"

    # --- fzf keybindings + completion ---
    source <(fzf --zsh)

    # --- PATH ---
    export PATH="$HOME/.local/bin:$PATH"

    # --- aliases ---
    alias ls='eza --icons'
    alias ll='eza -la --icons --git'
    alias lt='eza --tree --icons'
    alias cat='bat --paging=never'
    alias grep='rg'
    alias find='fd'
    alias cd='z'   # zoxide

    # --- git aliases ---
    alias g='git'
    alias gs='git status'
    alias gd='git diff'
    alias lg='lazygit'

    # --- homelab aliases (add more as needed) ---
    alias k='kubectl'
    alias kns='kubectl config set-context --current --namespace'
    alias kctx='kubectl config use-context'

    # --- history config ---
    HISTFILE=~/.zsh_history
    HISTSIZE=10000
    SAVEHIST=10000
    setopt SHARE_HISTORY
    setopt HIST_IGNORE_DUPS
    ```
  - Add `.zshrc` to chezmoi: `chezmoi add ~/.zshrc`
  - Test by launching a new zsh session: autocomplete should work, syntax highlighting visible

  **Must NOT do**:
  - Do NOT install oh-my-zsh — zinit replaces it entirely
  - Do NOT add more than 5-6 plugins to start — resist the urge to add everything
  - Do NOT add Powerlevel10k — Starship is the choice (Task 4)
  - Do NOT override the `cd` alias until zoxide is confirmed working

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Shell config with careful ordering dependencies between plugins and evals
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 2, 4-8)
  - **Parallel Group**: Wave 2
  - **Blocks**: Tasks 4, 9, 10, 11, 12 (they all need a working shell)
  - **Blocked By**: Task 1

  **References**:
  - zinit install: `https://github.com/zdharma-continuum/zinit#install`
  - zinit plugin loading: `https://github.com/zdharma-continuum/zinit#synopsis`
  - fzf-tab (tab completion): `https://github.com/Aloxaf/fzf-tab`
  - zsh-autosuggestions: `https://github.com/zsh-users/zsh-autosuggestions`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: zsh launches with all plugins loaded and no errors
    Tool: Bash
    Steps:
      1. Run: zsh -i -c 'echo "zsh ok"; zinit report; exit'
    Expected Result: "zsh ok" printed, zinit shows 4 loaded plugins, no error messages
    Failure Indicators: Any "command not found" or plugin load errors
    Evidence: .sisyphus/evidence/task-3-zinit-report.txt

  Scenario: Autosuggestions and syntax highlighting are active
    Tool: interactive_bash (tmux)
    Steps:
      1. Open new zsh session in tmux
      2. Type: `git sta` (don't press Enter)
      3. Verify grey suggestion appears: `git status`
      4. Type: `unknowncmd` and verify it shows in red (syntax highlighting)
    Expected Result: Grey suggestion after `git sta`, red highlight on unknown command
    Evidence: .sisyphus/evidence/task-3-suggestions.txt

  Scenario: fzf Ctrl+R history search works
    Tool: interactive_bash (tmux)
    Steps:
      1. In zsh session, press Ctrl+R
    Expected Result: fzf history search popup appears
    Failure Indicators: No popup, or regular reverse-i-search appears instead
    Evidence: .sisyphus/evidence/task-3-fzf.txt
  ```

  **Commit**: YES (Wave 2 batch commit)
  - Message: `feat(shell): add zsh with zinit plugins and core aliases`
  - Files: `~/.zshrc` (chezmoi tracked)

---

- [ ] 4. Starship Prompt Config

  **What to do**:
  - Starship is already installed from Task 1 and initialized in `.zshrc` from Task 3
  - Create `~/.config/starship.toml` with a config tuned for the user's workflow:
    ```toml
    # Starship config for homelab/DevOps workflow

    format = """
    [](#a3aed2)\
    $os\
    $username\
    [](bg:#769ff0 fg:#a3aed2)\
    $directory\
    [](fg:#769ff0 bg:#394260)\
    $git_branch\
    $git_status\
    [](fg:#394260 bg:#212736)\
    $kubernetes\
    $python\
    $nodejs\
    $terraform\
    [](fg:#212736)\
    $line_break\
    $character"""

    [directory]
    style = "fg:#e3e5e5 bg:#769ff0"
    format = "[ $path ]($style)"
    truncation_length = 4

    [git_branch]
    symbol = " "
    style = "fg:#769ff0 bg:#394260"
    format = '[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)'

    [git_status]
    style = "fg:#769ff0 bg:#394260"
    format = '[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)'

    [kubernetes]
    disabled = false
    style = "fg:#86e1fc bg:#212736"
    format = '[[ ⎈ $context\($namespace\) ](fg:#86e1fc bg:#212736)]($style)'

    [python]
    symbol = " "
    style = "fg:#86e1fc bg:#212736"
    format = '[[ $symbol ($version)(\($virtualenv\)) ](fg:#86e1fc bg:#212736)]($style)'

    [nodejs]
    symbol = " "
    style = "fg:#86e1fc bg:#212736"
    format = '[[ $symbol ($version) ](fg:#86e1fc bg:#212736)]($style)'

    [terraform]
    format = "[[ 󱁢 $workspace ](fg:#86e1fc bg:#212736)]($style)"
    style = "fg:#86e1fc bg:#212736"

    [character]
    success_symbol = "[❯](bold green)"
    error_symbol = "[❯](bold red)"
    ```
  - Add to chezmoi: `chezmoi add ~/.config/starship.toml`
  - Note: The kubernetes context module shows current k8s cluster in prompt — very useful for homelab

  **Must NOT do**:
  - Do NOT spend more than 30 minutes tweaking the prompt — it can always be changed later
  - Do NOT install Powerlevel10k alongside Starship

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Single config file creation with known content
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 2, 3, 5-8)
  - **Parallel Group**: Wave 2
  - **Blocks**: Nothing
  - **Blocked By**: Task 1 (starship must be installed), Task 3 in practice (needs zsh to test)

  **References**:
  - Starship config reference: `https://starship.rs/config/`
  - Starship presets (for inspiration): `https://starship.rs/presets/`
  - Kubernetes module: `https://starship.rs/config/#kubernetes`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: Starship prompt shows git branch and k8s context
    Tool: interactive_bash (tmux)
    Steps:
      1. Open a new zsh session
      2. Navigate to homelab-iac directory: z homelab-iac (or cd /mnt/c/Users/jason/Documents/GitLab/homelab-iac)
      3. Observe the prompt
    Expected Result: Prompt shows the git branch name and current kubernetes context
    Failure Indicators: Prompt shows default $PS1, no colors, or "starship: error" messages
    Evidence: .sisyphus/evidence/task-4-prompt.txt

  Scenario: Starship renders in under 100ms
    Tool: Bash
    Steps:
      1. Run: starship timings
    Expected Result: All modules under 100ms, total under 200ms
    Evidence: .sisyphus/evidence/task-4-timings.txt
  ```

  **Commit**: YES (Wave 2 batch)
  - Message: `feat(shell): add starship prompt with k8s and git modules`

- [ ] 5. Tmux + TPM Plugin Manager + .tmux.conf

  **What to do**:
  - Install TPM (Tmux Plugin Manager):
    ```bash
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```
  - Create `~/.tmux.conf`:
    ```bash
    # Prefix key: Ctrl+Space (ergonomic, doesn't clash with vim)
    unbind C-b
    set -g prefix C-Space
    bind C-Space send-prefix

    # Sensible defaults
    set -g default-terminal "tmux-256color"
    set -ag terminal-overrides ",xterm-256color:RGB"
    set -g mouse on
    set -g history-limit 10000
    set -g base-index 1
    setw -g pane-base-index 1
    set -g renumber-windows on

    # Vim-like pane navigation
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R

    # Split panes with | and -
    bind | split-window -h -c "#{pane_current_path}"
    bind - split-window -v -c "#{pane_current_path}"

    # Reload config
    bind r source-file ~/.tmux.conf \; display "Config reloaded!"

    # Plugins
    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    set -g @plugin 'tmux-plugins/tmux-resurrect'
    set -g @plugin 'tmux-plugins/tmux-continuum'
    set -g @plugin 'catppuccin/tmux'

    set -g @continuum-restore 'on'
    set -g @catppuccin_flavor 'mocha'

    run '~/.tmux/plugins/tpm/tpm'
    ```
  - Start a tmux session: `tmux new -s setup`
  - Install plugins inside tmux: press `Ctrl+Space` then `I` (capital I) — wait for install
  - Add to chezmoi: `chezmoi add ~/.tmux.conf`

  **Must NOT do**:
  - Do NOT use Ctrl+A or Ctrl+B as prefix — both conflict with shell/vim shortcuts
  - Do NOT add more than 5 plugins to start

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Requires an interactive tmux session to install plugins (TPM must run inside tmux)
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 2-4, 6-8)
  - **Parallel Group**: Wave 2
  - **Blocks**: Task 14 (tmux-nvim integration)
  - **Blocked By**: Task 1

  **References**:
  - TPM: `https://github.com/tmux-plugins/tpm`
  - tmux-resurrect: `https://github.com/tmux-plugins/tmux-resurrect`
  - tmux-continuum: `https://github.com/tmux-plugins/tmux-continuum`
  - catppuccin/tmux: `https://github.com/catppuccin/tmux`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: Prefix key and pane splitting work correctly
    Tool: interactive_bash (tmux)
    Steps:
      1. Start tmux: tmux new -s test
      2. Press Ctrl+Space | to split vertically
      3. Press Ctrl+Space - to split horizontally
      4. Press Ctrl+Space h/j/k/l to navigate between panes
    Expected Result: 3 panes visible, navigation works without any errors
    Evidence: .sisyphus/evidence/task-5-panes.txt

  Scenario: Sessions persist across tmux restart (tmux-resurrect)
    Tool: interactive_bash (tmux)
    Steps:
      1. Create session: tmux new -s persist-test
      2. Create a window and run: echo "hello persistence"
      3. Save: Ctrl+Space Ctrl+S
      4. Kill server: tmux kill-server
      5. Start fresh: tmux new -s restore
      6. Restore: Ctrl+Space Ctrl+R
    Expected Result: Session "persist-test" is restored with its window
    Evidence: .sisyphus/evidence/task-5-resurrect.txt
  ```

  **Commit**: YES (Wave 2 batch)
  - Message: `feat(tmux): add tmux config with TPM plugins and vim-like navigation`

---

- [ ] 6. Git CLI Config (gitconfig, lazygit, delta, WSL2 Credential Bridge)

  **What to do**:
  - Create `~/.gitconfig`:
    ```ini
    [user]
      name = Jason
      email = your@email.com

    [core]
      pager = delta
      editor = nvim

    [delta]
      navigate = true
      light = false
      side-by-side = true
      line-numbers = true

    [merge]
      conflictstyle = diff3

    [diff]
      colorMoved = default

    [alias]
      st = status
      co = checkout
      br = branch
      lg = log --oneline --graph --decorate --all
      undo = reset HEAD~1 --mixed
      unstage = reset HEAD --

    [pull]
      rebase = true

    [init]
      defaultBranch = main

    [credential "https://github.com"]
      helper = /mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe

    [credential "https://gitlab.com"]
      helper = /mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe
    ```
  - WSL2 credential bridge: Git Credential Manager (GCM) on Windows side is reused by WSL2 via the helper path above
    - Verify Git for Windows is installed: check `C:\Program Files\Git\mingw64\bin\git-credential-manager.exe` exists
    - If missing, install: `winget install Git.Git` in Windows PowerShell
  - For self-hosted GitLab: generate SSH key in WSL2:
    ```bash
    ssh-keygen -t ed25519 -C "jason@homelab" -f ~/.ssh/id_ed25519_gitlab
    cat ~/.ssh/id_ed25519_gitlab.pub   # copy to GitLab > Profile > SSH Keys
    ```
  - Create `~/.ssh/config`:
    ```
    Host gitlab.local
      HostName gitlab.local
      User git
      IdentityFile ~/.ssh/id_ed25519_gitlab
    ```
  - Add to chezmoi: `chezmoi add ~/.gitconfig ~/.ssh/config`
  - **Do NOT add private key** (`~/.ssh/id_ed25519_gitlab`) to chezmoi without encryption

  **Must NOT do**:
  - Do NOT set `credential.helper = store` (stores passwords in plaintext)
  - Do NOT commit the SSH private key file to git

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Requires cross-platform credential bridge setup and SSH key generation
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 2-5, 7-8)
  - **Parallel Group**: Wave 2
  - **Blocks**: Nothing
  - **Blocked By**: Task 1

  **References**:
  - GCM with WSL2: `https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/wsl.md`
  - delta config: `https://dandavison.github.io/delta/configuration.html`
  - SSH config: `https://www.ssh.com/academy/ssh/config`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: git push to GitHub works from WSL2 without password prompt
    Tool: Bash
    Steps:
      1. Clone a private GitHub repo in WSL2: git clone https://github.com/YOUR_USERNAME/dotfiles
      2. Make a test change, commit, push
    Expected Result: Push succeeds; GCM Windows popup may appear on first auth but caches after
    Failure Indicators: "Authentication failed" or password prompt that loops
    Evidence: .sisyphus/evidence/task-6-github-push.txt

  Scenario: git diff shows delta side-by-side rendering
    Tool: Bash
    Steps:
      1. In any git repo with unstaged changes, run: git diff
    Expected Result: Delta renders with line numbers, side-by-side view, syntax highlighting
    Failure Indicators: Plain unified diff, no colors or line numbers
    Evidence: .sisyphus/evidence/task-6-delta.txt

  Scenario: lazygit opens and shows status
    Tool: interactive_bash (tmux)
    Steps:
      1. cd into homelab-iac: cd /mnt/c/Users/jason/Documents/GitLab/homelab-iac
      2. Run: lazygit
    Expected Result: lazygit TUI opens showing branches, commits, and file status panels
    Evidence: .sisyphus/evidence/task-6-lazygit.txt
  ```

  **Commit**: YES (Wave 2 batch)
  - Message: `feat(git): add gitconfig with delta pager and WSL2 credential bridge`

---

- [ ] 7. Alacritty Config (Windows Side, Targeting WSL2)

  **What to do**:
  - Install Alacritty on Windows (run in PowerShell as admin): `winget install Alacritty.Alacritty`
  - Install JetBrainsMono Nerd Font on Windows:
    - Download from `https://www.nerdfonts.com/font-downloads` (search "JetBrainsMono")
    - Extract zip, select all `.ttf` files, right-click → "Install for all users"
  - Create Alacritty config at `%APPDATA%\alacritty\alacritty.toml`:
    ```toml
    [terminal]
    shell = { program = "wsl.exe", args = ["-d", "Ubuntu-24.04"] }

    [font]
    normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
    bold = { family = "JetBrainsMono Nerd Font", style = "Bold" }
    size = 13.0

    [window]
    padding = { x = 8, y = 8 }
    decorations = "None"
    opacity = 0.95
    startup_mode = "Maximized"

    [colors.primary]
    background = "#1e1e2e"
    foreground = "#cdd6f4"

    [colors.normal]
    black = "#45475a"
    red = "#f38ba8"
    green = "#a6e3a1"
    yellow = "#f9e2af"
    blue = "#89b4fa"
    magenta = "#f5c2e7"
    cyan = "#94e2d5"
    white = "#bac2de"
    ```
  - This uses Catppuccin Mocha (matches tmux theme from Task 5)
  - Note: The Windows-side Alacritty config is NOT tracked by chezmoi (WSL2-side tool)
  - Document the config location in the dotfiles README.md

  **Must NOT do**:
  - Do NOT configure Windows Terminal further — Alacritty is the dev terminal going forward
  - Do NOT add this config to WSL2-side chezmoi

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Single TOML config file plus font install
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Windows-side, fully independent)
  - **Parallel Group**: Wave 2
  - **Blocks**: Nothing
  - **Blocked By**: Task 1 (WSL2 must exist to validate the terminal)

  **References**:
  - Alacritty config reference: `https://alacritty.org/config-alacritty.html`
  - Nerd Fonts download: `https://www.nerdfonts.com/font-downloads`
  - Catppuccin Alacritty: `https://github.com/catppuccin/alacritty`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: Alacritty opens directly into WSL2 zsh session
    Tool: Bash (run inside Alacritty after launch)
    Steps:
      1. Launch Alacritty from Windows Start menu
      2. Run: echo $SHELL; uname -r
    Expected Result: $SHELL is /usr/bin/zsh; uname shows Linux kernel string
    Failure Indicators: Opens PowerShell or cmd.exe
    Evidence: .sisyphus/evidence/task-7-alacritty.txt

  Scenario: Nerd Font icons render as glyphs (not boxes)
    Tool: Bash (in Alacritty)
    Steps:
      1. Run: eza --icons /usr/bin | head -10
    Expected Result: File icons appear as symbols, not □ or ? characters
    Evidence: .sisyphus/evidence/task-7-icons.txt
  ```

  **Commit**: NO (Windows-side only — document in README)

---

- [ ] 8. VS Code Vim Extension + Vim Training Setup

  **What to do**:
  - Install VSCodeVim extension: `code --install-extension vscodevim.vim` (run in Windows PowerShell)
  - Open VS Code settings JSON (`Ctrl+Shift+P` → "Open User Settings JSON") and add:
    ```json
    {
      "vim.enable": true,
      "vim.useSystemClipboard": true,
      "vim.useCtrlKeys": true,
      "vim.hlsearch": true,
      "vim.leader": "<space>",
      "editor.lineNumbers": "relative",
      "vim.insertModeKeyBindings": [
        { "before": ["j", "k"], "after": ["<Esc>"] }
      ],
      "vim.normalModeKeyBindingsNonRecursive": [
        { "before": ["<leader>", "f"], "commands": ["workbench.action.quickOpen"] },
        { "before": ["<leader>", "e"], "commands": ["workbench.action.toggleSidebarVisibility"] },
        { "before": ["<leader>", "w"], "commands": ["workbench.action.files.save"] }
      ]
    }
    ```
  - Create vim cheat sheet at the path that will become the Obsidian vault (pre-create it):
    - Create `~/notes/vim/cheatsheet.md` with the essential motions:
      ```markdown
      # Vim Motions — Core Cheatsheet

      ## Movement
      h j k l — left / down / up / right
      w b     — next / prev word start
      0 $     — line start / line end
      gg G    — file top / file bottom
      Ctrl+d Ctrl+u — half page down / up

      ## Edit
      i a   — insert before / after cursor
      I A   — insert at line start / end
      o O   — new line below / above
      dd    — delete line
      yy    — yank (copy) line
      p P   — paste below / above
      u     — undo
      .     — repeat last action

      ## Visual
      v     — character select
      V     — line select
      Ctrl+v — block select

      ## Commands
      :w    — save
      :q    — quit
      :wq   — save and quit
      :%s/old/new/g — replace all occurrences
      ```
  - Commit to practicing ONLY with hjkl (no arrow keys) for 2 weeks before switching to LazyVim

  **Must NOT do**:
  - Do NOT disable VS Code shortcuts wholesale — keep it functional
  - Do NOT rush to Task 9 (LazyVim) before hjkl/dd/yy/p feel automatic

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: VS Code settings edit plus a markdown file creation
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Windows-side, fully independent)
  - **Parallel Group**: Wave 2
  - **Blocks**: Nothing
  - **Blocked By**: Nothing

  **References**:
  - VSCodeVim: `https://marketplace.visualstudio.com/items?itemName=vscodevim.vim`
  - VSCodeVim key remapping docs: `https://github.com/VSCodeVim/Vim#key-remapping`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: Vim motions work inside VS Code
    Tool: Bash (Windows PowerShell)
    Steps:
      1. Open VS Code on any file
      2. Press Escape (ensure Normal mode — status bar shows "NORMAL")
      3. Press j three times (cursor moves down 3 lines)
      4. Press dd (current line deleted)
      5. Press u (line restored)
    Expected Result: hjkl navigation works; status bar shows VIM mode; dd/u function correctly
    Evidence: .sisyphus/evidence/task-8-vscode-vim.txt

  Scenario: jk escape from insert mode is active
    Tool: Bash (verify settings file)
    Steps:
      1. Run in PowerShell: Get-Content "$env:APPDATA\Code\User\settings.json" | Select-String "jk"
    Expected Result: Line with jk insert mode binding appears in output
    Evidence: .sisyphus/evidence/task-8-settings.txt
  ```

  **Commit**: NO (Windows-side VS Code settings)

---

- [ ] 9. Neovim + LazyVim Base Install + Dotfiles Structure

  **What to do**:
  - Install Neovim (latest stable, not apt version which is outdated):
    ```bash
    # Download latest Neovim appimage
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    tar -xzf nvim-linux-x86_64.tar.gz -C ~/.local/
    ln -sf ~/.local/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
    ```
  - Install LazyVim starter:
    ```bash
    # Backup existing nvim config if any
    mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
    # Clone LazyVim starter
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    # Remove .git (we'll manage this via chezmoi)
    rm -rf ~/.config/nvim/.git
    ```
  - Launch neovim for the first time: `nvim`
    - LazyVim will auto-install its plugin manager (lazy.nvim) and base plugins
    - Wait for installation to complete (watch the UI)
    - Press `q` to close any status windows after install
  - Verify health: inside nvim, run `:checkhealth` — fix any warnings about missing tools
  - Add nvim config to chezmoi: `chezmoi add ~/.config/nvim`
  - Verify LazyVim dashboard opens with `<space>` (which-key menu should appear)

  **Must NOT do**:
  - Do NOT install Neovim from apt — the Ubuntu package is many versions behind
  - Do NOT start customizing LazyVim yet — Task 13 and 14 handle that
  - Do NOT install vim-plug, packer, or any other plugin manager — LazyVim uses lazy.nvim

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Requires interactive Neovim session to trigger plugin auto-install; health check may need fixes
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 10-12, after Wave 2 completes)
  - **Parallel Group**: Wave 3
  - **Blocks**: Tasks 13, 14
  - **Blocked By**: Tasks 1, 3 (needs zsh + PATH set up with ~/.local/bin)

  **References**:
  - Neovim releases: `https://github.com/neovim/neovim/releases`
  - LazyVim starter: `https://github.com/LazyVim/starter`
  - LazyVim docs: `https://lazyvim.org/`
  - LazyVim keymaps cheat sheet: `https://lazyvim.org/keymaps`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: LazyVim opens with dashboard and no errors
    Tool: interactive_bash (tmux)
    Steps:
      1. Run: nvim
      2. Wait for LazyVim to finish installing plugins (progress bar completes)
      3. Press Escape, then :q to exit
      4. Reopen: nvim
    Expected Result: LazyVim dashboard shows (logo + menu options). No "error" messages on startup.
    Failure Indicators: "Error" or "failed to load" messages in startup output
    Evidence: .sisyphus/evidence/task-9-lazyvim.txt

  Scenario: which-key menu appears on leader key press
    Tool: interactive_bash (tmux)
    Steps:
      1. Open nvim: nvim
      2. Press Space (leader key)
    Expected Result: which-key popup menu appears showing available shortcuts
    Evidence: .sisyphus/evidence/task-9-whichkey.txt

  Scenario: :checkhealth shows no critical errors
    Tool: interactive_bash (tmux)
    Steps:
      1. Open nvim: nvim
      2. Run: :checkhealth
      3. Scroll through output looking for ERROR (not WARNING) entries
    Expected Result: No ERROR lines. Warnings about optional tools are acceptable.
    Evidence: .sisyphus/evidence/task-9-health.txt
  ```

  **Commit**: YES (Wave 3 batch)
  - Message: `feat(nvim): install neovim and lazyvim base distribution`

---

- [ ] 10. Obsidian Vault + Zettelkasten Structure + Git Repo

  **What to do**:
  - Create the vault directory: `mkdir -p ~/notes`
  - Initialize as its own git repo: `cd ~/notes && git init && git remote add origin <your-gitlab-or-github-notes-repo>`
  - Create the Zettelkasten folder structure:
    ```
    ~/notes/
    ├── 00-inbox/          # Capture everything here first
    ├── 10-zettelkasten/   # Atomic, linked notes (permanent notes)
    ├── 20-projects/       # Project-specific notes (temporary)
    ├── 30-areas/          # Ongoing responsibilities (homelab, dev, learning)
    ├── 40-resources/      # Reference material (not your own thoughts)
    ├── 50-archive/        # Completed projects, old notes
    ├── templates/         # Note templates
    └── README.md
    ```
  - Create a daily note template at `~/notes/templates/daily-note.md`:
    ```markdown
    # {{date:YYYY-MM-DD}}

    ## Today's Focus
    - [ ]

    ## Notes / Learnings

    ## Links to permanent notes
    ```
  - Create a Zettelkasten note template at `~/notes/templates/zettel.md`:
    ```markdown
    # {{title}}

    ## Idea

    ## Context / Why it matters

    ## Links
    - [[related-note]]

    ## Sources
    ```
  - Create a first real note: `~/notes/10-zettelkasten/cli-linux-workflow.md` documenting this setup
  - Configure Obsidian to open `~/notes` as the vault:
    - On Windows, the WSL2 path is `\\wsl$\Ubuntu-24.04\home\jason\notes`
    - Open Obsidian → "Open folder as vault" → navigate to the WSL2 path
  - Install Obsidian community plugins (in Obsidian UI → Settings → Community Plugins):
    - **Templater** — for using the templates above
    - **Calendar** — daily note navigation
    - **Dataview** — query your notes like a database (powerful later)
  - Commit initial structure: `cd ~/notes && git add . && git commit -m "feat(notes): init zettelkasten vault structure"`

  **Must NOT do**:
  - Do NOT add `~/notes` to the dotfiles chezmoi — it's its own separate git repo
  - Do NOT try to configure Dataview queries on day 1 — just install it for future use
  - Do NOT install more than 3-4 Obsidian plugins initially

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Multi-step setup combining CLI directory creation, git init, and Obsidian GUI configuration
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 9, 11, 12)
  - **Parallel Group**: Wave 3
  - **Blocks**: Task 14 (obsidian.nvim integration)
  - **Blocked By**: Tasks 1, 3 (needs working shell)

  **References**:
  - Zettelkasten method: `https://zettelkasten.de/introduction/`
  - Obsidian Templater plugin: `https://github.com/SilentVoid13/Templater`
  - PARA method (folder structure inspiration): `https://fortelabs.com/blog/para/`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: Vault folder structure is correct and tracked in git
    Tool: Bash
    Steps:
      1. Run: tree ~/notes (or: find ~/notes -type d)
      2. Run: cd ~/notes && git status
    Expected Result: All 6 top-level directories exist; git shows clean state (initial commit done)
    Evidence: .sisyphus/evidence/task-10-vault-structure.txt

  Scenario: Obsidian opens vault from WSL2 path on Windows
    Tool: Bash (verify vault path is accessible)
    Steps:
      1. Run in WSL2: ls ~/notes/templates/ | grep -E "daily|zettel"
    Expected Result: Both template files exist
    Evidence: .sisyphus/evidence/task-10-templates.txt

  Scenario: Create a linked note and verify the link resolves
    Tool: Bash
    Steps:
      1. Create note A: echo "# Note A\n\nSee [[note-b]]" > ~/notes/10-zettelkasten/note-a.md
      2. Create note B: echo "# Note B\n\nLinked from [[note-a]]" > ~/notes/10-zettelkasten/note-b.md
      3. Open Obsidian, open Note A, click the [[note-b]] link
    Expected Result: Obsidian navigates to Note B
    Evidence: .sisyphus/evidence/task-10-links.txt
  ```

  **Commit**: YES (to notes repo, separate from dotfiles)
  - Message: `feat(notes): init zettelkasten vault with PARA structure and templates`

---

- [ ] 11. Homelab CLI Tools (k9s, kubectl, FluxCD CLI, Helm, kubeconfig)

  **What to do**:
  - Copy kubeconfig from Windows to WSL2:
    ```bash
    mkdir -p ~/.kube
    cp /mnt/c/Users/jason/.kube/config ~/.kube/config
    chmod 600 ~/.kube/config
    ```
    Or if kubeconfig is on homelab server, retrieve via SSH:
    ```bash
    scp user@homelab:/path/to/kubeconfig ~/.kube/config
    ```
  - Install kubectl:
    ```bash
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl && mv kubectl ~/.local/bin/
    ```
  - Install k9s:
    ```bash
    # Download latest release
    K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d'"' -f4)
    curl -LO "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz"
    tar -xzf k9s_Linux_amd64.tar.gz k9s && mv k9s ~/.local/bin/
    ```
  - Install FluxCD CLI:
    ```bash
    curl -s https://fluxcd.io/install.sh | sudo bash
    ```
  - Install Helm:
    ```bash
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    ```
  - Add kubectl shell completion to `~/.zshrc`:
    ```zsh
    source <(kubectl completion zsh)
    complete -F __start_kubectl k
    ```
  - Create k9s config at `~/.config/k9s/config.yaml`:
    ```yaml
    k9s:
      refreshRate: 2
      ui:
        skin: dracula
        noIcons: false
    ```
  - Add to chezmoi: `chezmoi add ~/.kube/config ~/.config/k9s/config.yaml`
  - Note: If kubeconfig has cluster credentials, use `chezmoi add --encrypt` for it

  **Must NOT do**:
  - Do NOT commit unencrypted kubeconfig with cluster credentials to the dotfiles git repo
  - Do NOT install kubectl via snap — it's often outdated

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Multiple binary installs from GitHub releases + kubeconfig migration from Windows side
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 9, 10, 12)
  - **Parallel Group**: Wave 3
  - **Blocks**: Nothing (Final Verification tests it)
  - **Blocked By**: Tasks 1, 3

  **References**:
  - kubectl install: `https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/`
  - k9s releases: `https://github.com/derailed/k9s/releases`
  - FluxCD install: `https://fluxcd.io/flux/installation/#install-the-flux-cli`
  - Helm install: `https://helm.sh/docs/intro/install/`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: kubectl connects to homelab cluster
    Tool: Bash
    Steps:
      1. Run: kubectl get nodes
    Expected Result: Returns list of Talos cluster nodes with READY status
    Failure Indicators: "connection refused", "error: no configuration", or timeout
    Evidence: .sisyphus/evidence/task-11-kubectl.txt

  Scenario: k9s opens and shows cluster resources
    Tool: interactive_bash (tmux)
    Steps:
      1. Run: k9s
    Expected Result: k9s TUI opens, shows pod list for default namespace
    Evidence: .sisyphus/evidence/task-11-k9s.txt

  Scenario: flux CLI shows homelab flux version
    Tool: Bash
    Steps:
      1. Run: flux version
    Expected Result: Client and server version both printed (confirms cluster connectivity)
    Evidence: .sisyphus/evidence/task-11-flux.txt
  ```

  **Commit**: YES (Wave 3 batch)
  - Message: `feat(homelab): add k9s kubectl helm flux cli tools and kubeconfig`

---

- [ ] 12. Fabric + Shell AI Integration (`??` Shortcut)

  **What to do**:
  - Install Fabric (Daniel Miessler's AI CLI framework):
    ```bash
    # Requires Go or Python — Python install:
    pip install fabric-ai
    # OR via the official install script:
    curl -L https://github.com/danielmiessler/fabric/releases/latest/download/fabric-linux-amd64 -o ~/.local/bin/fabric
    chmod +x ~/.local/bin/fabric
    ```
  - Configure fabric with API key: `fabric --setup` (follow the prompts, enter OpenAI or Anthropic key)
  - Test a built-in pattern: `echo "what is tmux" | fabric --pattern explain`
  - Add `??` shell function to `~/.zshrc` for AI command help:
    ```zsh
    # AI shell assistant: type ?? followed by your question
    function ?? {
      local query="$*"
      echo "$query" | fabric --pattern explain_code
    }

    # Pipe to AI for summarizing
    function ai {
      local input=$(cat /dev/stdin 2>/dev/null || echo "$*")
      echo "$input" | fabric --pattern summarize
    }
    ```
  - Test: `?? what does eza do` should return an AI explanation
  - Add `~/.config/fabric/` to chezmoi (patterns config, not API keys):
    ```bash
    chezmoi add ~/.config/fabric/
    ```
  - Note: Store the API key in environment variable, NOT in fabric config file:
    ```zsh
    # In ~/.zshrc (already being tracked)
    export OPENAI_API_KEY="$(cat ~/.secrets/openai-key 2>/dev/null)"
    ```
    Create `~/.secrets/` dir with restricted permissions: `chmod 700 ~/.secrets/`

  **Must NOT do**:
  - Do NOT put API keys in dotfiles or chezmoi (not even encrypted — use a secrets manager or env vars)
  - Do NOT install fabric with sudo

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Single binary install + two shell functions added to .zshrc
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 9, 10, 11)
  - **Parallel Group**: Wave 3
  - **Blocks**: Nothing
  - **Blocked By**: Tasks 1, 3 (needs working shell and PATH)

  **References**:
  - Fabric GitHub: `https://github.com/danielmiessler/fabric`
  - Fabric patterns library: `https://github.com/danielmiessler/fabric/tree/main/patterns`
  - Fabric install docs: `https://github.com/danielmiessler/fabric#installation`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: ?? shortcut returns AI explanation in shell
    Tool: Bash
    Steps:
      1. Run: ?? what does the kubectl get pods command do
    Expected Result: AI-generated explanation printed to terminal within 10 seconds
    Failure Indicators: "command not found", API error, or empty output
    Evidence: .sisyphus/evidence/task-12-fabric.txt

  Scenario: ai pipe function summarizes piped input
    Tool: Bash
    Steps:
      1. Run: cat ~/notes/vim/cheatsheet.md | ai
    Expected Result: Condensed AI summary of the cheatsheet content
    Evidence: .sisyphus/evidence/task-12-ai-pipe.txt
  ```

  **Commit**: YES (update to Wave 2 zshrc commit or new commit)
  - Message: `feat(shell): add fabric ai cli and ?? shortcut function`

---

- [ ] 13. LazyVim Language Configs (Python, TypeScript, Terraform, YAML via Mason)

  **What to do**:
  - LazyVim uses "extras" to enable language support. Add these to `~/.config/nvim/lua/config/lazy.lua`:
    ```lua
    -- Add to the spec table inside require("lazy").setup({...})
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.terraform" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    ```
  - Relaunch neovim — LazyVim will install the extra plugins automatically
  - Open Mason UI inside nvim: `:Mason` — verify these LSPs are installed (install manually if missing):
    - `pyright` (Python)
    - `typescript-language-server` (TypeScript)
    - `terraform-ls` (Terraform HCL)
    - `yaml-language-server` (YAML)
    - `json-lsp` (JSON)
    - `marksman` (Markdown)
  - Install Python formatting tools via Mason: `:MasonInstall black isort`
  - Test Python LSP: open a `.py` file in the homelab repo, hover over a function → documentation should appear
  - Test TypeScript LSP: open a `.ts` file, intentionally introduce a type error → red underline should appear
  - Test Terraform LSP: open a `.tf` file in homelab-iac → hover over a resource → docs should appear

  **Must NOT do**:
  - Do NOT manually configure LSP servers in `lspconfig` — LazyVim handles this via extras
  - Do NOT install `coc.nvim` — LazyVim uses its own LSP system (nvim-lspconfig + mason)
  - Do NOT install more extras than needed for daily work

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Requires interactive neovim sessions to verify LSP attachment per language
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Task 14, after Task 9)
  - **Parallel Group**: Wave 4
  - **Blocks**: Final Verification
  - **Blocked By**: Task 9 (Neovim + LazyVim must be installed)

  **References**:
  - LazyVim extras list: `https://lazyvim.org/extras`
  - LazyVim Python extra: `https://lazyvim.org/extras/lang/python`
  - LazyVim TypeScript extra: `https://lazyvim.org/extras/lang/typescript`
  - LazyVim Terraform extra: `https://lazyvim.org/extras/lang/terraform`
  - Mason registry: `https://mason-registry.dev/registry/list`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: Python LSP attaches and shows hover documentation
    Tool: interactive_bash (tmux)
    Steps:
      1. Open a Python file: nvim /mnt/c/Users/jason/Documents/GitLab/homelab-iac/scripts/some_script.py
      2. Wait 3 seconds for LSP to attach
      3. Run inside nvim: :LspInfo
    Expected Result: :LspInfo shows "pyright" as an active LSP client for this buffer
    Evidence: .sisyphus/evidence/task-13-python-lsp.txt

  Scenario: TypeScript LSP shows type errors inline
    Tool: interactive_bash (tmux)
    Steps:
      1. Create test file: echo "const x: number = 'hello'" > /tmp/test.ts
      2. Open it: nvim /tmp/test.ts
      3. Wait 3 seconds
      4. Run: :LspInfo
    Expected Result: typescript-language-server is active; red underline on the type error
    Evidence: .sisyphus/evidence/task-13-ts-lsp.txt

  Scenario: Terraform LSP attaches on .tf files
    Tool: interactive_bash (tmux)
    Steps:
      1. Open a terraform file: nvim /mnt/c/Users/jason/Documents/GitLab/homelab-iac/infrastructure/terraform/networking/main.tf
      2. Wait 3 seconds, run: :LspInfo
    Expected Result: terraform-ls shown as active LSP client
    Evidence: .sisyphus/evidence/task-13-tf-lsp.txt
  ```

  **Commit**: YES (Wave 4 batch)
  - Message: `feat(nvim): add lazyvim language extras for python typescript terraform yaml`

---

- [ ] 14. LazyVim Extras (obsidian.nvim, Markdown Preview, Tmux Navigation)

  **What to do**:
  - Add obsidian.nvim plugin for editing the notes vault inside Neovim. Create `~/.config/nvim/lua/plugins/obsidian.lua`:
    ```lua
    return {
      "epwalsh/obsidian.nvim",
      version = "*",
      lazy = true,
      ft = "markdown",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        workspaces = {
          { name = "notes", path = "~/notes" },
        },
        daily_notes = {
          folder = "00-inbox",
          template = "daily-note.md",
        },
        templates = { folder = "templates" },
        ui = { enable = true },
      },
    }
    ```
  - Add vim-tmux-navigator for seamless Ctrl+hjkl navigation between tmux panes and nvim splits.
    Create `~/.config/nvim/lua/plugins/tmux.lua`:
    ```lua
    return {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft", "TmuxNavigateDown",
        "TmuxNavigateUp", "TmuxNavigateRight",
      },
      keys = {
        { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
      },
    }
    ```
  - Add corresponding tmux bindings to `~/.tmux.conf` (append):
    ```bash
    # vim-tmux-navigator (must match nvim keymaps)
    is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
    bind -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
    bind -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
    bind -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
    bind -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'
    ```
  - Enable the LazyVim markdown extra (if not already done in Task 13):
    `{ import = "lazyvim.plugins.extras.lang.markdown" }` — enables `render-markdown.nvim` for rendered markdown in nvim
  - Reload tmux config: `tmux source ~/.tmux.conf`
  - Relaunch nvim and run `:Lazy sync` to install new plugins

  **Must NOT do**:
  - Do NOT install a separate markdown preview that opens a browser window — render-markdown.nvim renders inline
  - Do NOT configure more obsidian.nvim options than needed — defaults are good

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Requires interactive nvim session to verify plugin installs + tmux config reload
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Task 13)
  - **Parallel Group**: Wave 4
  - **Blocks**: Final Verification
  - **Blocked By**: Tasks 9 (Neovim), 5 (Tmux), 10 (Obsidian vault path must exist)

  **References**:
  - obsidian.nvim: `https://github.com/epwalsh/obsidian.nvim`
  - vim-tmux-navigator: `https://github.com/christoomey/vim-tmux-navigator`
  - render-markdown.nvim: `https://github.com/MeanderingProgrammer/render-markdown.nvim`
  - LazyVim markdown extra: `https://lazyvim.org/extras/lang/markdown`

  **Acceptance Criteria**:

  **QA Scenarios**:

  ```
  Scenario: obsidian.nvim can create and link notes from nvim
    Tool: interactive_bash (tmux)
    Steps:
      1. Open nvim in notes vault: nvim ~/notes/10-zettelkasten/test-note.md
      2. Run: :ObsidianNew test-linked-note
      3. Type some content, add [[test-note]] link
      4. Run: :ObsidianFollowLink (cursor on [[test-note]])
    Expected Result: New note is created; following link navigates to the linked note
    Evidence: .sisyphus/evidence/task-14-obsidian-nvim.txt

  Scenario: Ctrl+hjkl navigates between nvim splits and tmux panes seamlessly
    Tool: interactive_bash (tmux)
    Steps:
      1. In tmux, split into 2 panes: Ctrl+Space |
      2. In left pane: nvim . (open nvim)
      3. In nvim, open a vertical split: :vsplit
      4. Press Ctrl+h to move left (should go to tmux pane, not stay in nvim)
      5. Press Ctrl+l to move right (should go back to nvim)
    Expected Result: Navigation moves freely between tmux panes and nvim splits using Ctrl+hjkl
    Evidence: .sisyphus/evidence/task-14-tmux-nvim-nav.txt

  Scenario: Markdown renders with formatting inside nvim
    Tool: interactive_bash (tmux)
    Steps:
      1. Open the vim cheatsheet: nvim ~/notes/vim/cheatsheet.md
    Expected Result: Markdown renders with visual formatting (headers appear larger/bold, bullets formatted)
    Evidence: .sisyphus/evidence/task-14-markdown.txt
  ```

  **Commit**: YES (Wave 4 batch)
  - Message: `feat(nvim): add obsidian.nvim tmux-navigator and markdown rendering`

---

## Final Verification Wave

> 3 review agents run in PARALLEL. ALL must APPROVE before marking plan complete.
> Present consolidated results and get explicit user "okay" before finishing.

- [ ] F1. **Full Bootstrap Test** — `deep`
  Simulate a fresh WSL2 setup: Run `chezmoi init --apply` from the dotfiles repo on a CLEAN WSL2 instance (or test directory). Verify every config file is placed correctly. Run each tool's smoke test (zsh starts, tmux starts, nvim opens, starship shows prompt, lazygit opens). Document any manual steps that couldn't be automated and flag them as documentation tasks.
  Output: `Configs placed [N/N] | Tools working [N/N] | Manual steps [N] | VERDICT: APPROVE/REJECT`

- [ ] F2. **Tool Integration Smoke Test** — `unspecified-high`
  In the configured WSL2 environment: (1) Open tmux, create 3 panes, navigate between them with prefix key. (2) Open nvim on a Python file, verify LSP attaches (`:LspInfo`). (3) Open nvim on a TypeScript file, verify LSP attaches. (4) Run `k9s` and verify cluster connectivity. (5) Create a Zettelkasten note, link it to another note, verify in Obsidian. (6) Run a fabric pattern. (7) Push a test commit via lazygit. Save output/screenshots to `.sisyphus/evidence/final-qa/`.
  Output: `Scenarios [N/N pass] | Integration [PASS/FAIL] | VERDICT`

- [ ] F3. **Scope Fidelity + Dotfiles Completeness** — `deep`
  For every config file created across all tasks: verify it exists in the chezmoi source directory (`~/.local/share/chezmoi/`). Run `chezmoi diff` — output should be empty (no untracked files). Check the dotfiles git repo has a meaningful commit history and README exists. Verify "Must NOT Have" guardrails: no secrets in plaintext, no Windows-side configs added, no devcontainer setup snuck in.
  Output: `Chezmoi tracked [N files] | Untracked [N] | Guardrails [N/N clean] | VERDICT`

---

## Commit Strategy

- **Wave 2**: `chore(dotfiles): init chezmoi and shell environment` — all Wave 2 configs
- **Wave 3**: `feat(dotfiles): add neovim lazyvim and homelab cli tools`
- **Wave 4**: `feat(nvim): configure lsp and extras for daily languages`
- **Notes**: `feat(notes): init obsidian vault with zettelkasten structure`

---

## Success Criteria

### Verification Commands
```bash
# Shell working
zsh --version         # Expected: zsh 5.x
starship --version    # Expected: starship x.x.x

# Tmux
tmux new -s test && tmux kill-session -t test  # Expected: no error

# Neovim
nvim --version        # Expected: NVIM v0.10+
nvim -c ':checkhealth' -c ':q'  # Expected: minimal errors

# Git
lazygit --version     # Expected: version string
delta --version       # Expected: version string
git config --global user.name  # Expected: your name

# Homelab
k9s version           # Expected: version string
kubectl version       # Expected: client + server version
flux version          # Expected: flux version

# AI/Fabric
fabric --version      # Expected: version string

# Dotfiles
chezmoi diff          # Expected: empty (all tracked)
chezmoi status        # Expected: clean
```

### Final Checklist
- [ ] All "Must Have" items present and functional
- [ ] All "Must NOT Have" guardrails clean
- [ ] `chezmoi diff` returns empty
- [ ] Dotfiles repo has clean commit history
- [ ] README exists in dotfiles repo explaining how to bootstrap
