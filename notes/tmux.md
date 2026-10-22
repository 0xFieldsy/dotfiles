# tmux Quick Reference

tmux keeps sessions running on a server so you can detach and reattach later.

> [!NOTE]
> The default prefix key is `Ctrl-b`. `Ctrl-b Ctrl-b` sends that key through to the program in the pane.

## Help

Use `Ctrl-b ?` to show the list of key bindings. Use `Ctrl-b /` to look up a single key.

## Command Prompt

`Ctrl-b :` opens the command prompt. Type a tmux command the same way you would after `tmux` in a shell, without the `tmux` prefix. `Tab` completes, and Up and Down walk earlier commands.

| Command | What it does |
| --- | --- |
| `setw synchronize-panes` | Toggle sending keystrokes to every pane in the window |
| `swap-window -t <index>` | Swap the current window with another index |
| `move-window -t <index>` | Move the current window to an index |
| `join-pane -s <target>` | Pull a pane into this window (`session:window.pane`) |
| `respawn-pane -k` | Kill the pane's process and start it again |

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
| `Ctrl-b s` | List sessions (interactive picker) |
| `Ctrl-b $` | Rename the current session |
| `Ctrl-b (` | Previous session |
| `Ctrl-b )` | Next session |
| `Ctrl-b Shift-l` | Switch to the last session |

## Windows

| Key | What it does |
| --- | --- |
| `Ctrl-b c` | Create a new window |
| `Ctrl-b n` | Next window |
| `Ctrl-b p` | Previous window |
| `Ctrl-b l` | Switch to the last window |
| `Ctrl-b w` | List windows (interactive picker) |
| `Ctrl-b f` | Find a window by name |
| `Ctrl-b <number>` | Switch to window `number` |
| `Ctrl-b ,` | Rename the current window |
| `Ctrl-b &` | Kill the current window (asks first) |

## Panes

| Key | What it does |
| --- | --- |
| `Ctrl-b v` | Vertical split (side by side) |
| `Ctrl-b h` | Horizontal split (top and bottom) |
| `Ctrl-b <arrow>` | Move to the pane in that direction (repeats with `-r`) |
| `Ctrl-b Ctrl-<arrow>` | Resize the pane by 1 cell (repeats with `-r`) |
| `Ctrl-b Alt-<arrow>` | Resize the pane by 5 cells (repeats with `-r`) |
| `Ctrl-b o` | Move to the next pane |
| `Ctrl-b ;` | Move to the last pane |
| `Ctrl-b q` | Show pane indexes (type one to jump) |
| `Ctrl-b z` | Zoom the current pane, or unzoom it |
| `Ctrl-b Space` | Cycle pane layouts |
| `Ctrl-b {` | Swap with the previous pane |
| `Ctrl-b }` | Swap with the next pane |
| `Ctrl-b !` | Move the pane into its own window |
| `Ctrl-b x` | Kill the current pane (asks first) |

## Copy Mode

`Ctrl-b [` enters copy mode so you can scroll the history and copy text. The mouse wheel does the same, because `mouse` is on in `~/.tmux.conf`, and dragging a selection copies it. `Ctrl-b ]` pastes the latest buffer.

> [!NOTE]
> Copy mode uses Emacs keys. `mode-keys` is still the default.

| Key | What it does |
| --- | --- |
| `Ctrl-b [` | Enter copy mode |
| `Ctrl-b Page Up` | Enter copy mode and scroll up a page |
| `q` or `Escape` | Leave copy mode |
| `Ctrl-Space` | Start a selection |
| `Alt-w` | Copy the selection and leave copy mode |
| `Ctrl-r` | Search backward |
| `n` | Repeat the last search |
| `Ctrl-b ]` | Paste the latest buffer |
| `Ctrl-b =` | Pick a buffer to paste |

## Plugins

[tpack](https://github.com/tmuxpack/tpack) manages plugins. Install the `.deb` from its GitHub releases, declare plugins in `~/.tmux.conf` with `set -g @plugin 'owner/repo'`, and keep `run 'tpack init'` near the bottom. Plugins install to `~/.local/share/tmux/plugins/`.

| Key | What it does |
| --- | --- |
| `tpack install` | Install plugins declared in the config |
| `tpack update all` | Update all plugins |
| `Ctrl-b Shift-i` | Install plugins |
| `Ctrl-b Shift-u` | Update plugins |
| `Ctrl-b Alt-u` | Remove plugins no longer in the config |
| `Ctrl-b Shift-t` | Open the tpack TUI |

> [!NOTE]
> A plugin pinned with `#tag` only fetches that tag. To switch it to the default branch, remove the `#tag`, delete its folder in `~/.local/share/tmux/plugins/`, and run `tpack install`.
