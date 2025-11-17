---
layout: post
title: "Boosting Terminal Productivity with Tmux"
date: 2023-10-20 09:15:00
tags: [tmux, terminal, productivity, workflow, tools]
---

I resisted tmux for years, thinking it was overkill. Now I can't imagine working without it.

My basic `.tmux.conf`:

```bash
# Set prefix to Ctrl-a (easier than Ctrl-b)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Enable mouse support
set -g mouse on

# Start window numbering at 1
set -g base-index 1
set -g pane-base-index 1

# Split panes with | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Switch panes with vim keys
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize panes
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Status bar
set -g status-style bg=black,fg=white
set -g status-right "%H:%M %d-%b-%y"
```

My typical development session:

```bash
# Create named session
tmux new -s dev

# Window 0: Editor
# Window 1: Server
Ctrl-a c
npm run dev

# Window 2: Git & tasks
Ctrl-a c
# Split into multiple panes
Ctrl-a |
Ctrl-a -
```

The killer feature is **session persistence**. If SSH disconnects or I close my terminal, everything keeps running:

```bash
# Detach from session
Ctrl-a d

# List sessions
tmux ls

# Reattach
tmux attach -t dev
```

I also use tmuxinator for project-specific layouts:

```yaml
# ~/.tmuxinator/myapp.yml
name: myapp
root: ~/projects/myapp

windows:
  - editor:
      layout: main-vertical
      panes:
        - vim
        - npm test -- --watch
  - server: npm run dev
  - console:
      layout: even-horizontal
      panes:
        - git status
        - 
```

Start it with:

```bash
tmuxinator start myapp
```

For pair programming, I use `tmux attach -t shared` on both machines. Everyone sees the same terminal in real-time.

Tmux pairs perfectly with SSH:

```bash
# On remote server
tmux new -s work

# Long-running job
./expensive-computation.sh

# Detach and log out
Ctrl-a d
exit

# Hours later, log back in
ssh server
tmux attach -t work
# Job is still running!
```

Simple keyboard shortcuts I use constantly:

```
Ctrl-a c     Create window
Ctrl-a n     Next window
Ctrl-a p     Previous window
Ctrl-a ,     Rename window
Ctrl-a &     Kill window
Ctrl-a |     Split vertically
Ctrl-a -     Split horizontally
Ctrl-a z     Zoom pane
Ctrl-a d     Detach session
```

Learning tmux took an afternoon. The productivity gains have been enormous.
