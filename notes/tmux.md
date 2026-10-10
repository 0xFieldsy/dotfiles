# tmux Quick Reference

tmux keeps sessions running on a server so you can detach and reattach later.

> [!NOTE]
> The default prefix key is `Ctrl-b`.

## Help

Use `Ctrl-b ?` to show the list of key bindings.

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
| `Ctrl-b d` | Detach from the current session |

## Windows

| Key | What it does |
| --- | --- |
| `Ctrl-b c` | Create a new window |
| `Ctrl-b n` | Next window |
| `Ctrl-b p` | Previous window |
| `Ctrl-b w` | List windows (interactive picker) |
| `Ctrl-b x` | Kill the current window |
| `Ctrl-b <number>` | Switch to window `number` |

## Panes

| Key | What it does |
| --- | --- |
| `Ctrl-b v` | Vertical split (side by side) |
| `Ctrl-b -` | Horizontal split (top and bottom) |
| `Ctrl-b <arrow>` | Resize the pane (repeats with `-r`) |
