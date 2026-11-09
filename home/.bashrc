# shellcheck shell=bash
set +o posix

# everything below is only for interactive shells
[[ $- == *i* ]] || return 0

# history size
HISTSIZE=100000
HISTFILESIZE=100000

# ignore duplicates and lines starting with space
HISTCONTROL=ignoreboth

# don't overwrite the history file
shopt -s histappend

# save multi-line commands as one history entry
shopt -s cmdhist

# update window size after each command
shopt -s checkwinsize

# `**` matches nested directories
shopt -s globstar

# type a directory to cd into it
shopt -s autocd cdspell

# sources
[ -s "${HOME}/.exports" ] && source "${HOME}/.exports"
[ -s "${HOME}/.secrets" ] && source "${HOME}/.secrets"
[ -s "${HOME}/.aliases" ] && source "${HOME}/.aliases"

# zoxide
[[ -n $(command -v zoxide 2>/dev/null) ]] && eval "$(zoxide init bash)"

# fzf: ctrl-r history, ctrl-t files, alt-c directories
# https://github.com/junegunn/fzf#key-bindings-for-command-line
[[ -n $(command -v fzf 2>/dev/null) ]] && eval "$(fzf --bash 2>/dev/null)"

# bash completion also sets extglob and progcomp
if [[ -r "${HOMEBREW_PREFIX:-/usr/local}/etc/profile.d/bash_completion.sh" ]]; then
  source "${HOMEBREW_PREFIX:-/usr/local}/etc/profile.d/bash_completion.sh"
elif [[ -r "${HOMEBREW_PREFIX:-/usr/local}/etc/bash_completion" ]]; then
  source "${HOMEBREW_PREFIX:-/usr/local}/etc/bash_completion"
elif [[ -r /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
elif [[ -r /etc/bash_completion ]]; then
  source /etc/bash_completion
fi

# flyline replaces readline with fuzzy completion and up/down search history
# https://github.com/HalFrgrd/flyline
__flyline=0
__flyline_lib="${HOME}/.local/lib/libflyline.so"
[[ $OSTYPE == darwin* ]] && __flyline_lib="${HOME}/.local/lib/libflyline.dylib"
if [[ -t 0 && -t 1 ]] && { enable flyline 2>/dev/null || enable -f "$__flyline_lib" flyline 2>/dev/null; }; then
  __flyline=1

  # OSC 133 marks prompts, commands, and output; and OSC 7 reports the cwd
  if [[ -z "${NVIM-}" ]]; then
    flyline --send-shell-integration-codes full
  else
    flyline --send-shell-integration-codes none
  fi

  flyline mouse --mode disabled
  flyline set-cursor --backend terminal
  flyline editor --show-inline-history-metadata false

  flyline suggestions --auto-suggest false
  flyline suggestions flycomp --enabled true
fi

# fzf binds its keys with readline, so they're rebound for flyline
if ((__flyline)) && declare -F __fzf_cd__ >/dev/null; then
  __flyline_fzf_cd() {
    local cmd
    cmd=$(__fzf_cd__) && READLINE_LINE=$cmd READLINE_POINT=${#cmd}
  }

  flyline key bind Ctrl+r 'always=runBashCommand(__fzf_history__)'
  flyline key bind Ctrl+t 'always=runBashCommand(fzf-file-widget)'
  flyline key bind Alt+c 'always=runBashCommand(__flyline_fzf_cd)+submitOrNewline'
fi

# prompt
[ -r "${HOME}/.bash_prompt" ] && source "${HOME}/.bash_prompt"
