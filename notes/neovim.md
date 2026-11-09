# Neovim

The config in [`shared/.config/nvim`](../shared/.config/nvim) is built on [LazyVim](https://www.lazyvim.org). [lazy.nvim](https://github.com/folke/lazy.nvim) installs the plugins at the commits pinned in [`lazy-lock.json`](../shared/.config/nvim/lazy-lock.json), and [Mason](https://github.com/mason-org/mason.nvim) installs the language servers, linters, and formatters.

## Install

LazyVim needs Neovim 0.11.2 or newer. Ubuntu 24.04's `neovim` package is 0.9.5, so remove it first with `sudo apt remove -y neovim`.

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
