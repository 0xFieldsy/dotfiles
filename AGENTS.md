# AGENTS.md / CLAUDE.md

This repository contains my dotfiles, which are configuration files for various applications and tools that I use on my computer.

The `linux`, `mac`, `shared`, and `windows` folders contain configuration files that get symlinked to their respective locations in `$HOME`.

The `notes` folder contains helpful Markdown notes for provisioning a new machine.

The `bin/dotfiles` script is a single-file Python CLI with the following commands:

```txt
dotfiles install bin [-f, --force] <name>
dotfiles install deb [-f, --force] <repo>
dotfiles install uv [-f, --force]
dotfiles install btop [-f, --force]
dotfiles install claude
dotfiles install fish
dotfiles install gcloud
dotfiles install go
dotfiles install rust
dotfiles install nerdfont
dotfiles install symlinks
dotfiles install ttyd [-f, --force]
dotfiles install zig [-f, --force]

dotfiles setup apt
dotfiles setup motd
dotfiles setup shell [-u, --user] <shell>
dotfiles setup sshd
dotfiles setup sudo [-u, --user]
dotfiles setup user <user>
```
