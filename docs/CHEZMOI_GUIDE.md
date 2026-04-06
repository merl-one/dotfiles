# Chezmoi Installation Guide

## Why does `chezmoi init --apply` appear to do nothing?

**Short answer**: It IS working! Chezmoi runs silently by default - no output means success.

## Understanding Chezmoi Behavior

Chezmoi follows the Unix philosophy: **"silence is golden"** - programs should run quietly unless there's an error.

### ✅ Success Indicators

When you run `chezmoi init --apply https://github.com/merl-one/dotfiles.git`, it's working if:

1. **No error message** - If it fails, you'll see an error
2. **Command returns instantly** - Takes 5-10 seconds (fetching + applying)
3. **Files exist afterward** - Check with:
   ```bash
   ls -la ~/.zshrc ~/.gitconfig ~/.tmux.conf ~/.config/starship.toml
   ```

### Verify Installation

```bash
# Check if chezmoi created the files
ls -la ~/.zshrc ~/.gitconfig ~/.tmux.conf

# Check if chezmoi knows what it's managing
chezmoi managed

# Check status
chezmoi status
```

## Installation Methods

### 🟢 **Recommended: One-liner with feedback**

```bash
curl -fsLS https://raw.githubusercontent.com/merl-one/dotfiles/main/bin/install.sh | bash
```

This wrapper script:
- Shows progress messages
- Checks if chezmoi is installed
- Provides post-installation instructions
- Explains next steps

**Output:**
```
🚀 Installing dotfiles from merl-one/dotfiles...

📚 Applying dotfiles configuration...
   Repository: https://github.com/merl-one/dotfiles.git

✅ Dotfiles applied successfully!

📋 Next steps:
   1. Install shell plugins:
      zsh -i -c 'zinit update --all'
   ...
```

### 🟡 **Manual: Step-by-step**

```bash
# Step 1: Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Step 2: Apply dotfiles (runs silently)
chezmoi init --apply https://github.com/merl-one/dotfiles.git

# Step 3: Verify it worked
ls -la ~/.zshrc ~/.gitconfig ~/.tmux.conf

# Step 4: Install plugins
zsh -i -c "zinit update --all"
tmux new -d && tmux run-shell ~/.tmux/plugins/tpm/scripts/install_plugins.sh
nvim --headless "+Lazy! sync" +qa
```

### 🔵 **Advanced: With verbose output**

```bash
# -vv = very verbose (show what's happening)
chezmoi init --apply -vv https://github.com/merl-one/dotfiles.git
```

**Output with `-vv`:**
```
[INFO]  Creating ~/.config/opencode/
[INFO]  Creating ~/.config/nvim/
[INFO]  Creating ~/.config/lazygit/
[INFO]  Applying ~/.zshrc
[INFO]  Applying ~/.gitconfig
[INFO]  Applying ~/.tmux.conf
```

## How Chezmoi Works

### File Naming Convention

Chezmoi uses special prefixes to know what to do with files:

| Prefix | Meaning | Example |
|--------|---------|---------|
| `dot_` | Create in home dir as hidden file | `dot_zshrc` → `~/.zshrc` |
| `executable_dot_` | Create as executable | `executable_dot_zshrc` → `~/.zshrc` (executable) |
| `dot_config/` | Create in `~/.config/` | `dot_config/nvim/` → `~/.config/nvim/` |

### What Gets Applied

When you run `chezmoi init --apply`:

1. Clones the repo to `~/.local/share/chezmoi/`
2. Reads `.chezmoiignore` to skip documentation/scripts
3. Finds all `dot_*` files
4. Creates them in your home directory
5. Sets correct permissions (executable, read-only, etc.)

### Files Applied from This Repo

```
✅ ~/.zshrc                    (shell config)
✅ ~/.gitconfig                (git config)
✅ ~/.tmux.conf                (tmux config)
✅ ~/.config/opencode/         (OpenCode agents & skills)
✅ ~/.config/nvim/             (Neovim LazyVim config)
✅ ~/.config/lazygit/          (Lazygit theme)
✅ ~/.config/starship.toml     (Starship prompt)
✅ ~/.config/k9s/              (K8s dashboard)
```

### Files NOT Applied (by `.chezmoiignore`)

```
❌ docs/                       (documentation)
❌ plans/                      (planning files)
❌ scripts/                    (helper scripts)
❌ templates/                  (dev container templates)
❌ bin/                        (utility scripts)
❌ README.md                   (this file)
```

## Troubleshooting

### Problem: "Command not found: chezmoi"

**Solution**: Install chezmoi first
```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### Problem: Nothing Happens After `chezmoi init --apply`

**This is a common issue caused by pre-existing chezmoi configuration pointing to the wrong directory.**

**Diagnosis**: Check if `~/.local/share/chezmoi/` is empty or doesn't have `.git/`
```bash
ls -la ~/.local/share/chezmoi/
```

If it's empty or missing `.git/`, the repository was never cloned.

**Root Cause**: If you had a previous chezmoi configuration (e.g., `~/.config/chezmoi/chezmoi.toml`), it may have had `sourceDir` pointing to a local directory instead of allowing chezmoi to clone from GitHub.

**Solution**: Reset chezmoi completely and re-initialize
```bash
# Clean slate
rm -rf ~/.config/chezmoi ~/.local/share/chezmoi ~/.cache/chezmoi

# Recreate directories
mkdir -p ~/.local/share ~/.config

# Now initialize properly (this will clone the GitHub repo)
chezmoi init --apply merl-one/dotfiles

# Verify it worked
ls -la ~/.local/share/chezmoi/
ls -la ~/.zshrc ~/.gitconfig
chezmoi status
```

After reset, chezmoi will:
1. Clone the repository to `~/.local/share/chezmoi/`
2. Create a fresh config in `~/.config/chezmoi/chezmoi.toml`
3. Apply all files to your home directory
4. Run silently (this is expected!)

### Problem: Already initialized, want to re-apply

**Solution**: Use `chezmoi apply` instead of `init --apply`
```bash
chezmoi apply --force
```

Or update from repository:
```bash
chezmoi update
```

### Problem: Want to see what will change before applying

**Solution**: Use `chezmoi diff`
```bash
chezmoi diff
```

### Problem: Accidentally applied old config, want to restore

**Solution**: Chezmoi keeps backups in `~/.local/share/chezmoi/`
```bash
# See what chezmoi manages
chezmoi managed

# Check status of each file
chezmoi status

# Compare current vs repository version
chezmoi diff ~/.zshrc
```

## After Installation

### 1. Install Shell Plugins

```bash
zsh -i -c "zinit update --all"
```

### 2. Install Tmux Plugins

```bash
tmux new -d && tmux run-shell ~/.tmux/plugins/tpm/scripts/install_plugins.sh
```

### 3. Install Neovim Plugins

```bash
nvim --headless "+Lazy! sync" +qa
```

### 4. Test Aliases

```bash
# These should all work now:
lg              # lazygit
v               # nvim
k               # kubectl
gs              # git status
gp              # git pull
gm              # git commit -m "message"
```

## Updating Dotfiles

### On the Same Machine

Make changes locally, they persist automatically:
```bash
# Edit directly
nvim ~/.zshrc

# Changes stick around
cat ~/.zshrc
```

### On Different Machines

1. Commit changes to git:
   ```bash
   cd ~/.local/share/chezmoi/
   git add -A && git commit -m "Update config"
   git push
   ```

2. On another machine:
   ```bash
   chezmoi update
   ```

## Learn More

- [Chezmoi Documentation](https://www.chezmoi.io/)
- [Chezmoi GitHub](https://github.com/twpayne/chezmoi)
- Main Repository: [merl-one/dotfiles](https://github.com/merl-one/dotfiles)
