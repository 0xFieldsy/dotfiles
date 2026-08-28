# Clipboard

> [!NOTE]
> This assumes X11 not Wayland.

On a Mac, you can simply use `pbcopy` and `pbpaste`.

On Linux, you need to install either `xsel` (preferred) or `xclip`:

```sh
sudo apt install -y xsel
```

To copy:

```sh
xsel --clipboard --input
xclip -selection clipboard
```

To paste:

```sh
xsel --clipboard --output
xclip -selection clipboard -o
```

Nano uses its own buffer. Micro supports `xsel` and `xclip` via the [`clipper`](https://github.com/zyedidia/clipper) module. Helix copies to system clipboard with <kbd>Space</kbd>+<kbd>y</kbd> and pastes with <kbd>Space</kbd>+<kbd>p</kbd>.
