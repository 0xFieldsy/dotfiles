# tmux Quick Reference

tmux keeps sessions running on a server so you can detach and reattach later.

> [!NOTE]
> The default prefix key is `Ctrl-b`. It is remapped to `Ctrl-a` in `~/.tmux.conf`.

## Help

Use `Ctrl-a ?` to show the list of key bindings.

## Config

Use `tmux source-file ~/.tmux.conf` to reload the config.

## Sessions

| Key | What it does |
| --- | --- |
| `tmux ls` | List sessions |
| `tmux new -s <name>` | Start a new named session |
| `tmux attach -t <name>` | Attach to a session |
| `tmux kill-session -t <name>` | Kill a session |
| `tmux kill-server` | Kill all sessions |
| `Ctrl-a d` | Detach from the current session |

## Windows

| Key | What it does |
| --- | --- |
| `Ctrl-a c` | Create a new window |
| `Ctrl-a n` | Next window |
| `Ctrl-a p` | Previous window |
| `Ctrl-a w` | List windows (interactive picker) |
| `Ctrl-a x` | Kill the current window |
| `Ctrl-a <number>` | Switch to window `number` |

## Panes

| Key | What it does |
| --- | --- |
| `Ctrl-a -` | Split vertically (top and bottom) |
| `Ctrl-a \|` | Split horizontally (side by side) |
| `Ctrl-a <arrow>` | Resize the pane (repeats with `-r`) |
