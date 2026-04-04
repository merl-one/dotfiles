# Beginner's Guide to Your Linux CLI Workflow

**Goal**: This guide teaches you how to ACTUALLY USE your development environment day-by-day. Not a reference manual—a learning path.

---

## Part 1: Your First Day (Orientation)

### Step 1: Open Alacritty and See What You Have

1. **Press** `Windows key` and type `alacritty`
2. **Click** the Alacritty icon
3. **You'll see**:
   - A terminal that looks like this:
   ```
   jason@laptop ~/myproject > █
   ```
   - **`jason@laptop`** = your username + computer name
   - **`~/myproject`** = your current directory (simplified path)
   - **`>`** = ready for input
   - Colored text with fancy symbols (that's Starship prompt + Nerd Font)

**What you're really running**: WSL2 Ubuntu Linux inside Windows. The terminal is Alacritty (from Windows), connected to zsh shell (inside Linux).

---

### Step 2: Understand the Command Prompt

The prompt shows **context** about where you are:

```
jason@laptop ~/dotfiles > █
               ▲
               └─ You're in ~/dotfiles directory

jason@laptop ~/dotfiles (main) > █
                          ▲
                          └─ You're on git branch 'main'

jason@laptop ~/dotfiles (main|⚡2) > █
                                ▲
                                └─ 2 uncommitted changes
```

**The colored symbols** are Nerd Font icons representing:
- 📁 Folders
- 🔗 Git branches
- ⚡ Changes pending
- ☸️  Kubernetes context
- 🐍 Python version
- 🟦 Docker
- 🔐 SSH status

---

### Step 3: Try Your First Commands

Type these one at a time and hit Enter:

```bash
# 1. See what's in your home directory
ls

# Expected: Colorful list with icons ✨ (That's 'eza' alias, not plain 'ls')

# 2. See your prompt's actual capabilities
echo "I'm in $(pwd)"

# Expected: Shows your full path

# 3. Check your shell version
zsh --version

# Expected: zsh 5.9 (or higher)

# 4. Check git status (if you're in a git repo)
git status

# Expected: Shows branch, uncommitted changes, etc.
```

**Key insight**: Many commands you know work here, but some have ALIASES (shortcuts):
- `ls` → actually runs `eza` (colorful, with icons)
- `cat` → actually runs `bat` (syntax highlighting)
- `cd mydir` → actually runs `z mydir` (smart jump, remembers favorite dirs)
- `grep pattern` → actually runs `rg pattern` (fast regex search)
- `find -name` → actually runs `fd -n` (intuitive file search)

---

### Step 4: Your First AI Shortcut

The `??` shortcut lets you ask AI questions right from the terminal:

```bash
# Ask AI to explain a command
?? what does eza do

# Ask about a tool you just saw
?? how do I use fzf

# Ask about code
?? explain this regex: [a-z]+@[a-z]+\.[a-z]+
```

**What happens**:
1. Your question goes to **Fabric** (local AI bridge)
2. Fabric sends it to OpenAI/Anthropic (whichever you configured)
3. Answer appears in your terminal
4. No browser needed, no leaving the terminal

**To set this up** (one-time):
```bash
fabric --setup

# Follow the prompts to add your OpenAI or Anthropic API key
```

---

### Step 5: Open Neovim and See the Editor

```bash
# Create a test file
nvim test.py

# You'll see Neovim (a terminal-based editor)
# Press 'i' to enter INSERT mode (you can type)
# Type some Python code:

def hello():
    print("Hello world")

# Press ESC to exit insert mode
# Type ':wq' and press Enter to save and quit
```

**What you just did**:
- Opened **Neovim** (Vim but modern)
- Used **LazyVim** distribution (pre-configured Vim with LSP support)
- Syntax highlighting for Python automatically turned on
- Indentation helped you (auto-indent)

**Key bindings** (learn these one at a time):
- `i` = insert mode (can type)
- `ESC` = normal mode (navigation & commands)
- `dd` = delete line
- `yy` = copy line
- `p` = paste
- `:wq` = save & quit (colon, w=write, q=quit)
- `:q!` = quit without saving (! = force)
- `/pattern` = search for text
- `n` = next match, `N` = previous match

---

## Part 2: Daily Development Workflows

### Workflow A: Python Development

**Scenario**: You're working on a Python project called `myproject`

```bash
# 1. Navigate to your project
cd ~/projects/myproject

# Note: 'cd' is actually 'z' (smart jump)
# It remembers you visit this dir often

# 2. See what's changed since last time
git status

# 3. Open Neovim to edit main.py
nvim main.py

# 4. Inside Vim:
#    - Press 'i' to start typing
#    - Type code
#    - Press ESC
#    - Type ':wq' to save

# 5. Run your script
python main.py

# 6. See the output and any errors

# 7. If there are errors, edit and try again
nvim main.py
# Fix the issue...
python main.py
```

**With AI help**:
```bash
# Error: "TypeError: expected string"
# Ask AI what this means:
?? TypeError expected string

# AI explains the error and gives solutions

# Better: Ask it to explain your code
nvim bug.py
# Select lines (v=visual mode, hjkl=move, y=copy)
# Then pipe to AI:
# cat bug.py | ai
# AI suggests fixes
```

---

### Workflow B: Git (Version Control)

**Scenario**: You've made changes and want to save them

```bash
# 1. See what changed
git status

# Shows modified files in red/yellow

# 2. Preview changes in one file
git diff main.py

# Shows:
# GREEN = added lines
# RED = removed lines
# Uses 'delta' pager (pretty diff viewer)

# 3. Stage your changes (prepare to save)
git add main.py

# OR add everything
git add .

# 4. Check status again (should show staged files in green)
git status

# 5. Save the changes (create commit)
git commit -m "fix: handle empty input in parse function"

# Format: type(scope): description
# Types: feat (new feature), fix (bug fix), docs, refactor
# Example: feat(api): add user authentication endpoint

# 6. See your commit history
git log --oneline

# Shows recent commits in one-line format

# 7. Push to remote (GitHub/GitLab)
git push
```

**Lazy Git alternative** (GUI for git in terminal):

```bash
# Open interactive git UI
lg

# Use arrow keys to navigate
# Press ? for help
# Much easier than commands if you prefer GUI
```

---

### Workflow C: Terminal Multiplexing (tmux)

**Scenario**: You need multiple terminals at once (run server + edit code + monitor logs)

```bash
# 1. Start a new tmux session
tmux new -s dev

# You'll see a status bar at the bottom
# Format: [0] editor  [1] server  [2] logs | tmux session: dev

# 2. You're in window 0 (editor). Create more windows:
Ctrl+b  c    # c = create new window

# Now you have windows 0 and 1

# 3. Switch between windows
Ctrl+b  0    # Go to window 0
Ctrl+b  1    # Go to window 1
Ctrl+b  n    # Next window
Ctrl+b  p    # Previous window

# 4. Split current window into panes (left/right)
Ctrl+b  %    # Split vertical
Ctrl+b  "    # Split horizontal

# 5. Move between panes
Ctrl+b  arrow keys   # Navigate panes (left/down/up/right)

# Real example - Development setup:
# Window 0: Editor (nvim)
#   - Pane 1: Neovim
#   - Pane 2: Running tests
# Window 1: Server
# Window 2: Git/shell commands
```

**Why tmux is great**:
- Run multiple commands simultaneously
- Keep terminal windows organized
- Detach and reattach (sessions survive disconnects)
- Copy-paste between panes
- Automatic save of your layout every time you close terminal

---

### Workflow D: File Finding and Searching

**Scenario**: You need to find a file or search code

```bash
# 1. Find a file by name (using 'fd', not 'find')
fd test.py

# Find all Python files
fd "\.py$"

# Find in specific directory
fd "\.py$" ~/projects

# 2. Fuzzy find with preview (interactive picker)
fd "\.py$" | fzf --preview 'bat --style=numbers {}'

# Shows list, you type to filter, press Enter to select
# Preview shows file contents

# 3. Search inside files for text (using 'rg', not 'grep')
rg "TODO" .

# Find all TODO comments in current directory

# 4. Search with context
rg -C 3 "TODO"

# Shows 3 lines before and after each match

# 5. Search in specific file type
rg "def " --type py

# Only search Python files for function definitions
```

---

### Workflow E: Kubernetes / Homelab

**Scenario**: You need to check your homelab Kubernetes cluster

```bash
# 1. List all nodes (computers in your cluster)
kubectl get nodes

# Shows: NAME, STATUS (Ready/NotReady), AGE, VERSION

# 2. List pods (running containers)
kubectl get pods -A

# -A means all namespaces (all areas of cluster)

# 3. Get logs from a pod
kubectl logs pod-name -n namespace

# -n namespace = which area to look in

# 4. Get into interactive shell in a pod
kubectl exec -it pod-name -n namespace -- /bin/bash

# Useful for debugging

# 5. Interactive cluster browser (k9s)
k9s

# Opens interactive UI to browse your cluster
# Use arrow keys to navigate
# Press '?' for help
# Press 'q' to quit
```

---

## Part 3: Editing Configuration (Customizing Your Setup)

### Where Do All The Dotfiles Live?

All your configuration is managed by `chezmoi`. It's stored in:
```
~/Documents/GitLab/dotfiles/     (Windows - you edit here)
                                    ↓
~/.config/chezmoi/chezmoi.toml    (Points to above)
                                    ↓
~/                                (Deployed to WSL2 home)
```

### Common Customizations

**Add a shell alias** (shortcut command):

```bash
# 1. Edit zshrc in Windows (easier than in WSL)
code ~/Documents/GitLab/dotfiles/executable_dot_zshrc

# 2. Find the aliases section (line ~38):
# --- git aliases ---
alias g='git'
alias gs='git status'

# 3. Add your own alias:
alias myalias='long command here'

# 4. Save the file

# 5. Apply with chezmoi (in WSL)
chezmoi apply

# 6. Reload shell to pick up changes
exec zsh
```

**Change Neovim keybinding**:

```bash
# 1. Find Neovim config in Windows
code ~/Documents/GitLab/dotfiles/dot_config/nvim/

# 2. Look for lua/config/ or lua/plugins/

# 3. Edit a file and add your keybinding

# 4. Restart Neovim to see changes
```

**Change your prompt appearance**:

```bash
# 1. Edit starship config
code ~/Documents/GitLab/dotfiles/dot_config/starship.toml

# 2. Change colors, symbols, layout

# 3. Apply with chezmoi apply

# 4. Reload shell: exec zsh
```

---

## Part 4: Troubleshooting Common Issues

### Issue: Command not found

```bash
# You typed: nvim myfile.py
# Error: command not found: nvim

# Reasons:
# 1. Tool not installed
# 2. PATH not set up (shell doesn't know where to find it)
# 3. Typo in command name

# Fix:
which nvim          # Shows path if installed
nvim --version      # Confirms installation works

# If not installed:
sudo apt update && sudo apt install neovim
```

### Issue: Colors look wrong

```bash
# Problem: Terminal doesn't match expected Gruvbox Dark theme
# Reason: Terminal (Alacritty) and shell (zsh) need separate config

# Fix:
# 1. Alacritty config (Windows side):
cat %APPDATA%\alacritty\alacritty.toml | grep -A 30 "Gruvbox"

# 2. Should have Gruvbox Dark colors: backgrounds (#282828), foreground (#ebdbb2)

# 3. Zsh gets colors from Starship prompt (same Gruvbox config)

# If still wrong, check if you're in the right terminal
```

### Issue: Neovim LSP not working (language server)

```bash
# Problem: Autocomplete/diagnostics not working in Neovim
# Reason: LSP language server not installed for your file type

# Fix in Neovim:
# 1. Open your Python file: nvim myfile.py
# 2. Press Escape (normal mode)
# 3. Type: :Mason
# 4. Find 'python' in the list
# 5. Press 'i' (install)
# 6. Wait for installation
# 7. Close Mason: :q
# 8. Now autocomplete should work
```

### Issue: Git pushing fails

```bash
# Problem: git push fails with authentication error
# Reason: Git credential helper needs setup

# Fix:
# Already configured! Should just work
# If not:
git config credential.helper
# Should output: manager-core (Windows credential manager)

# If not set:
git config --global credential.helper manager-core
```

### Issue: Alacritty font looks weird

```bash
# Problem: Characters don't render properly, squares show up
# Reason: JetBrains Mono Nerd Font not installed on Windows

# Fix:
# Font is already installed in: C:\Users\jason\AppData\Local\Microsoft\Windows\Fonts
# Alacritty config already references "JetBrainsMono Nerd Font"
# Restart Alacritty to see the font take effect

# If still seeing issues:
# 1. Verify font is installed: Settings > Fonts > "JetBrainsMono Nerd Font"
# 2. Check Alacritty logs: C:\Users\jason\AppData\Local\Temp\Alacritty-*.log
```

---

## Part 5: Next Steps - What to Learn

### Week 1 (Comfort):
- [ ] Get comfortable with `cd`, `ls` (really `z` and `eza`)
- [ ] Learn basic vim keys: `i`, `ESC`, `:wq`, `dd`
- [ ] Try 5 terminal commands: `pwd`, `mkdir`, `cp`, `mv`, `rm`
- [ ] Make your first commit with git
- [ ] Open Neovim and edit one Python file

### Week 2 (Efficiency):
- [ ] Learn tmux windows and panes
- [ ] Use `??` AI shortcut to understand 3 confusing concepts
- [ ] Try fuzzy search: `fd | fzf`
- [ ] Create 3 git branches
- [ ] Edit your Alacritty config (font, colors)

### Week 3 (Expertise):
- [ ] Learn Neovim motions: `w`, `b`, `e`, `0`, `$`, `G`
- [ ] Use Neovim's built-in LSP for a language project
- [ ] Set up a custom alias for your workflow
- [ ] Explore k9s to understand your Kubernetes cluster
- [ ] Use `rg` to search your entire codebase

### Month 2+ (Mastery):
- [ ] Master Vim motions and visual mode
- [ ] Write your own Neovim plugins (Lua)
- [ ] Use DevPod for reproducible development environments
- [ ] Contribute to open source using git workflows
- [ ] Understand Kubernetes deployments via kubectl

---

## Part 6: Your IDE (Neovim vs VS Code)

You have BOTH available:

### When to Use VS Code:
- ✅ GUI debugging (breakpoints, step through)
- ✅ Refactoring across many files
- ✅ Project-wide search and replace
- ✅ Git merge conflict resolution (visual)
- ✅ Extensions for non-programming tasks

### When to Use Neovim (Terminal):
- ✅ SSH into remote server (no GUI available)
- ✅ Quick edits (3-5 lines)
- ✅ Working in tmux (organized sessions)
- ✅ Keyboard-only workflow (faster, no mouse)
- ✅ Lightweight (starts in ~100ms)
- ✅ Pair programming (share terminal)

**Our setup**: Vim extension in VS Code lets you use Vim keys in VS Code too! Best of both worlds.

---

## Part 7: Your Secret Weapons

### 1. The `??` Shortcut (AI in Terminal)

```bash
# Ask anything about your workflow
?? how do I rename a git branch

# Ask about errors
?? PermissionError: [Errno 13] Permission denied

# Ask about code
?? explain recursion
```

### 2. The `z` Command (Smart Jump)

```bash
# After visiting a directory, never type the full path again
cd ~/very/long/path/to/myproject/src

# Next time:
z myproject           # Just type folder name
z src                 # Even partial match

# Or:
z myp                 # Type prefix, hit Enter

# It learns your favorite directories!
```

### 3. Fuzzy Finding (`fzf`)

```bash
# Find any file interactively
fzf

# Or combine with preview
fd | fzf --preview 'bat --style=numbers {}'

# In Vim, find files:
# Press Ctrl+P in normal mode (fuzzy file finder)
```

### 4. The LazyGit UI

```bash
# Instead of remembering git commands:
lg

# Interact with your repo visually
# Arrow keys to navigate
# Space to stage/unstage
# c to commit
# p to push
```

---

## Part 8: If You Get Stuck

### When You're Confused:

1. **Try the `??` AI shortcut**
   ```bash
   ?? I'm getting "No such file or directory" error
   ```

2. **Search existing knowledge**
   ```bash
   rg "error message" ~/notes
   ```

3. **Check manual**
   ```bash
   man command-name      # Show official manual
   command-name --help   # Show quick help
   ```

4. **Ask your Kubernetes cluster**
   ```bash
   kubectl get events -A     # See what's happening
   kubectl describe pod pod-name     # Details
   ```

---

## Summary: You Now Have

| Component | What It Does | When You Use It |
|-----------|-------------|-----------------|
| **Alacritty** | Terminal window | Every day - your entry point |
| **zsh** | Shell/command line | Every day - typing commands |
| **Neovim** | Text editor | Editing code quickly |
| **VS Code** | IDE | Complex projects, debugging |
| **tmux** | Terminal multiplexer | Multiple tasks simultaneously |
| **git** | Version control | Saving/sharing code |
| **kubectl** | Cluster control | Managing your Kubernetes |
| **k9s** | Cluster UI | Visualizing your cluster |
| **Fabric + ??** | AI assistant | Understanding confusing things |
| **~/.notes/** | Your Zettelkasten | Saving what you learn |

---

**Next**: Move to **DevPod setup** for reproducible project environments!
