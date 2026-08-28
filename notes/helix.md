# Helix Quick Reference

Helix is modal like Vim, but selections come first: most commands act on the selection under the cursor rather than a bare cursor.

## Modes

- **Normal mode** (default): move around and issue commands.
- **Insert mode**: type text. Enter with `i`, exit with `<Esc>`.
- **Select mode**: highlight text to act on. Enter with `v`.

## Panic buttons

| Key | What it does |
| --- | --- |
| `Esc` | Return to normal mode (also `Ctrl-[`) |
| `:q` | Quit |
| `:q!` | Quit without saving |
| `:w` | Save |
| `:wq` | Save and quit |
| `:help` | Open Helix documentation |

## Editing text

| Key | What it does |
| --- | --- |
| `i` | Enter insert mode at the cursor |
| `a` | Enter insert mode after selection (append) |
| `Shift-i` | Enter insert mode at start of line |
| `Shift-a` | Enter insert mode at end of line |
| `p` | Paste after the cursor |
| `Shift-p` | Paste before the cursor |
| `Space p` | Paste clipboard after the cursor |
| `Space Shift-p` | Paste clipboard before the cursor |
| `o` / `Shift-o` | New line below / above |
| `u` / `Shift-u` | Undo / Redo |
| `>` / `<` | Indent / outdent |
| `Shift-c` | Add cursor below |
| `Alt-Shift-c` | Add cursor above |
| `,` | Remove extra cursors (keep the main one) |
| `Ctrl-c` | Comment toggle |
| `Ctrl-r` | Insert register |

## Moving around

| Key | What it does |
| --- | --- |
| `h`, `←` | Move left |
| `j`, `↓` | Move down |
| `k`, `↑` | Move up |
| `l`, `→` | Move right |
| `f <char>` / `t <char>` | Find next / till next `<char>` |
| `Shift-f <char>` / `Shift-t <char>` | Same as `f` / `t` but searching backward |
| `Alt-.` | Repeat the last `f` / `t` motion |
| `g g` | Goto file start |
| `g e` | Goto last line |
| `g h`, `<Home>` | Goto line start |
| `g l`, `<End>` | Goto line end |
| `Ctrl-f`, `<PageDown>` | Move page down |
| `Ctrl-b`, `<PageUp>` | Move page up |
| `:<n>` | Goto line `n` |

## Making selections

| Key | What it does |
| --- | --- |
| `v` | Enter select mode |
| `x` | Select current line (press again to extend) |
| `%` | Select all |
| `d` | Delete selection, keeping it in the yank history |
| `Alt-d` | Delete selection without yanking |
| `c` | Change selection (delete, then enter insert mode) |
| `Alt-c` | Change selection without yanking |
| `y` | Yank (copy) selection |
| `Space y` | Yank selection to clipboard |
| `Shift r` | Replace selection with yanked |
| `w` / `b` | Select next / previous word |
| `<n> x` | Extend the selection downward `n` lines |
| `s` | Filter selection with a regex |
| `Alt-s` | Split selection into multiple cursors |
| `Alt-;` | Flip selection direction (move cursor to the beginning) |

## Searching

| Key | What it does |
| --- | --- |
| `/<text>` | Search for `<text>` (forward) |
| `?<text>` | Search for `<text>` (backward) |
| `n` / `Shift-n` | Next / previous match |

## Menus

| Key | What it does |
| --- | --- |
| `Space` | Open the which-key menu (live cheat sheet of bindings) |
| `Space e` | Open the file explorer (add files to the project) |
| `Space f` | File picker (fuzzy-find files in the project) |
| `Space b` | Buffer picker (switch between open files) |
| `Ctrl-w` | Window menu |
| `m` | Open the match menu |
| `g` | Open the goto menu |
