# Neovim

The config in [`shared/.config/nvim`](../shared/.config/nvim) is built on [LazyVim](https://www.lazyvim.org). [lazy.nvim](https://github.com/folke/lazy.nvim) installs the plugins at the commits pinned in [`lazy-lock.json`](../shared/.config/nvim/lazy-lock.json), and [Mason](https://github.com/mason-org/mason.nvim) installs the language servers, linters, and formatters.

## Install

> [!NOTE]
> LazyVim needs Neovim 0.11.2 or newer.

```sh
dotfiles install neovim
dotfiles install bin tree-sitter
```

The `dotfiles` command downloads the latest release tarball from GitHub into `/usr/local/neovim` and links `/usr/local/bin/nvim` to it. The [`tree-sitter`](https://github.com/tree-sitter/tree-sitter) command compiles the Treesitter parsers.

## First Launch

Run `nvim`. lazy.nvim clones itself, installs the plugins from `lazy-lock.json`, and then compiles the Treesitter parsers. Mason installs the language servers the first time a file is opened, so open a file and wait for the installs to finish before quitting. Run `:LazyHealth` afterward to check for missing tools.

> [!NOTE]
> `nvim --headless "+Lazy! restore" +qa` installs the plugins without the UI, but it doesn't install the language servers.

## Updating

| Command | What it does |
| --- | --- |
| `:Lazy sync` | Update plugins and rewrite `lazy-lock.json` |
| `:Lazy restore` | Reset plugins to the commits in `lazy-lock.json` |
| `:Mason`, then `U` | Update all Mason packages |
| `:TSUpdate` | Update Treesitter parsers |

Run `:Lazy restore` on other machines after updating `lazy-lock.json`.

## Config Layout

| File | What it does |
| --- | --- |
| `lua/config/keymaps.lua` | Extra keymaps |
| `lua/config/lazy.lua` | Bootstraps lazy.nvim and imports LazyVim and the language extras |
| `lua/config/options.lua` | Options, such as rendering whitespace like Helix |
| `lua/plugins/colorscheme.lua` | Sets the colorscheme |
| `lua/plugins/markdown.lua` | Markdownlint configuration |

The language extras are for Go, JSON, Markdown, Python, Rust, TOML, TypeScript, YAML, and Zig. `:LazyExtras` lists the rest. Add new ones as an import in `lazy.lua`.

## Merging

`git mergetool` opens each conflicted file with `merge.tool` set to `nvimdiff2`. The left window is `LOCAL`, the branch you have checked out. The middle window is `MERGED`, the file you write. The right window is `REMOTE`, the branch you are merging in. `BASE`, the common ancestor, stays loaded and hidden. Run the copy commands from `MERGED`. `:diffget` with no name fails in this layout because `LOCAL`, `MERGED`, and `REMOTE` are all in diff mode, so name the buffer.

| Command | What it does |
| --- | --- |
| `]c` / `[c` | Next / previous change |
| `:diffget LOCAL` | Take the change under the cursor from the checked-out branch |
| `:diffget REMOTE` | Take the change under the cursor from the incoming branch |
| `:diffget BASE` | Take the change under the cursor from the common ancestor |
| `:wqa` | Save the merge and quit |
| `:cq` | Quit and leave the file unmerged |

A clean quit stages the file. `:buffer BASE` shows the common ancestor when you need it. Edit `MERGED` by hand for a mix of both sides, then `:diffupdate` if the highlights go stale.

## Keys

`Space` is the leader key. Press it and wait to see every binding in [which-key](https://github.com/folke/which-key.nvim).

| Key | What it does |
| --- | --- |
| `Ctrl-s` | Save |
| `Ctrl-q` | Quit without saving |
| `Ctrl-/` / `Space f t` | Terminal in project root |
| `Alt-d` / `Alt-c` | Delete / change without copying to the clipboard |
| `u` / `U` | Undo / redo |
| `Space y` | Yank to the clipboard |
| `Space p` / `Space P` | Paste the clipboard after / before the cursor |
| `Space Space` / `Space f f` | Find files |
| `Space /` | Grep the project |
| `Space ,` | Switch buffers |
| `Space e` | File explorer |
| `Shift-h` / `Shift-l` | Previous / next buffer |
| `Space b d` | Close the buffer |
| `Space -` / `Space \|` | Split window |
| `Space w d` | Close split |
| `g d` | Go to definition |
| `g r` | References |
| `K` | Hover docs |
| `Space c a` | Code action |
| `Space c r` | Rename |
| `Space c f` | Format |
| `Space x x` | Diagnostics list |
| `Space g g` | lazygit |
| `Space g s` | Git status picker |
| `Space s k` | Search keymaps |
| `Space s r` | Search and replace |
| `Space l` | Lazy (plugins) |
| `Space c m` | Mason |
| `Space q q` | Quit all |
