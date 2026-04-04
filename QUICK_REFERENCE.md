# Quick Reference: Your Setup Now

## Terminal Theme & Font

**Font**: JetBrains Mono Nerd Font (Regular, 13pt)
- Clean monospace rendering with icon support
- Installed in Windows Fonts directory

**Theme**: Gruvbox Dark
- Warm, easy-on-the-eyes dark color scheme
- Applied to: Terminal (Alacritty), Prompt (Starship), Tmux
- Gruvbox palette: warm browns, greens, yellows, and blues

## Standard Keybinds Cheatsheet

### Tmux (Terminal Multiplexer)
```
Ctrl+b c         Create new window
Ctrl+b w         List windows
Ctrl+b n         Next window
Ctrl+b p         Previous window
Ctrl+b %         Split pane vertically
Ctrl+b "         Split pane horizontally
Ctrl+b arrow     Move to pane (arrow keys)
Ctrl+b d         Detach from session
tmux attach      Reattach to session
```

### Vim / Neovim (Standard)
```
i                Enter insert mode
ESC              Exit insert mode (back to normal)
:q               Quit
:q!              Quit without saving
:w               Save
:wq              Save and quit
dd               Delete current line
yy               Copy current line
p                Paste after cursor
u                Undo
Ctrl+r           Redo

h j k l          Navigate left/down/up/right
w                Next word
b                Previous word
e                End of word
0                Start of line
$                End of line
G                End of file
gg               Start of file

/pattern         Search for pattern
n                Next match
N                Previous match
```

### Shell Commands (Standard Unix)
```
ls               List files
ls -la           List all (including hidden)
cd directory     Change directory
pwd              Print working directory
mkdir folder     Create directory
rm file          Delete file
rm -r folder     Delete folder recursively
cp file target   Copy file
mv file target   Move/rename file
cat file         Print file contents
grep pattern file   Search in file
find . -name "*.py"  Find Python files
```

### Git (Standard)
```
git status           See changes
git add file         Stage file
git add .            Stage all
git commit -m "msg"  Commit with message
git log              See commit history
git push             Push to remote
git pull             Pull from remote
git branch           List branches
git checkout branch  Switch branch
```

### Kubectl / Kubernetes (Standard)
```
kubectl get nodes       List cluster nodes
kubectl get pods        List pods
kubectl get pods -A     List all pods (all namespaces)
kubectl describe pod NAME   Get details
kubectl logs pod-name       Get pod logs
kubectl exec -it pod -- bash  Shell into pod
```

---

## Directory Structure

```
~                           Your home directory
~/.config/nvim              Neovim config
~/.config/starship.toml     Prompt config
~/.zshrc                    Shell config
~/.tmux.conf                Tmux config
~/.kube/config              Kubernetes config
~/notes/                    Your Zettelkasten vault
~/projects/                 Your code projects
```

---

## Tools You Have

| Tool | What It Does | Command |
|------|-------------|---------|
| **zsh** | Shell / command line | `zsh --version` |
| **Neovim** | Terminal text editor | `nvim file.txt` |
| **tmux** | Terminal multiplexer (split windows) | `tmux new -s session` |
| **git** | Version control | `git status` |
| **kubectl** | Kubernetes control | `kubectl get nodes` |
| **Starship** | Better prompt | (automatic) |
| **fzf** | Fuzzy finder | (type Ctrl+R for search) |

---

## One-Time Setup

```bash
# Setup Fabric AI (optional)
fabric --setup
# Then add your OpenAI or Anthropic API key
```

---

## First Time Using Each Tool

### Tmux
```bash
# Start new session
tmux new -s mywork

# In tmux, press Ctrl+b then...
# c = new window
# w = list windows
# % = split left/right
# " = split top/bottom
# arrow = move to pane
# d = detach (session stays running)

# Later, reattach
tmux attach
```

### Vim/Neovim
```bash
# Open file
nvim myfile.py

# Edit basics:
# i = type
# ESC = done typing
# :wq = save and quit
```

### Git
```bash
# See what changed
git status

# Stage changes
git add .

# Save changes
git commit -m "what I changed"

# Push to GitHub/GitLab
git push
```

### Kubernetes
```bash
# See your cluster
kubectl get nodes

# List pods
kubectl get pods -A

# Get into a pod
kubectl exec -it pod-name -n namespace -- /bin/bash
```

---

## Troubleshooting

### Tmux won't start
```bash
tmux kill-server
tmux new -s test
```

### Vim feels weird
- You're probably in INSERT mode. Press ESC first.
- Then type `:q!` and Enter to quit

### Git push fails
- Usually a credential issue. Already configured to use Windows credential manager.
- Run: `git config credential.helper`

### Kubernetes not connecting
- Check: `kubectl get nodes`
- If error, run: `kubectl cluster-info`

---

## Remember

1. **Ctrl+b** is tmux prefix (not Ctrl+Space anymore)
2. **ESC** in Vim to exit insert mode
3. **Standard Unix commands** - no custom aliases
4. **These keybinds work anywhere** - other machines, servers, boxes

---

## Next Steps

1. ✅ Close and reopen Alacritty
2. ✅ Try: `ls`, `cd /tmp`, `pwd`
3. ✅ Try tmux: `tmux new -s test` then `Ctrl+b c`
4. ✅ Try Vim: `nvim test.txt` then `i` then `ESC` then `:wq`
5. ✅ Try git: `git status`

All should work with standard keybinds. You're ready! 🚀
