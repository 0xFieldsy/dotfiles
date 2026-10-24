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
  flyline --send-shell-integration-codes full
  flyline mouse --mode disabled
  flyline set-cursor --backend terminal

  # dismiss existing suggestions with Esc, then Shift+Tab to generate flycomp completions
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

# prompt requires bash 5 for $EPOCHREALTIME and a nerd font
if ((BASH_VERSINFO[0] >= 5)); then
  # \001 and \002 tell readline which bytes are invisible
  __prompt_reset=$'\001\e[0m\002'
  __prompt_black=$'\001\e[30m\002'
  __prompt_red=$'\001\e[31m\002'
  __prompt_green=$'\001\e[32m\002'
  __prompt_yellow=$'\001\e[33m\002'
  __prompt_blue=$'\001\e[34m\002'
  __prompt_cyan=$'\001\e[36m\002'
  __prompt_brred=$'\001\e[91m\002'
  __prompt_brgreen=$'\001\e[92m\002'

  # same as fish's `prompt_pwd`
  __prompt_pwd() {
    local p=${PWD//[[:cntrl:]]/?} out='' rest dir
    if [[ $p == "$HOME" ]]; then
      p='~'
    elif [[ $p == "$HOME"/* ]]; then
      p="~${p#"$HOME"}"
    fi
    if [[ $p == */* ]]; then
      rest=${p%/*}/
      while [[ $rest == */* ]]; do
        dir=${rest%%/*}
        rest=${rest#*/}
        if [[ $dir == .* ]]; then out+=${dir:0:2}/; else out+=${dir:0:1}/; fi
      done
    fi
    __prompt_pwd_out=$out${p##*/}
  }

  # same as fish's `fish_git_prompt` with informative status: main ↑1↓2 +1!2?3$1
  __prompt_git() {
    __prompt_git_out=

    # find the git directory without running git, so non-repos cost nothing
    local dir=$PWD gitdir=${GIT_DIR-} line
    while [[ -z $gitdir ]]; do
      if [[ -d $dir/.git ]]; then
        gitdir=$dir/.git
      elif [[ -f $dir/.git ]]; then
        # worktrees and submodules have a .git file pointing to the git directory
        { read -r line <"$dir/.git"; } 2>/dev/null
        gitdir=${line#gitdir: }
        [[ $gitdir == /* ]] || gitdir=$dir/$gitdir
      elif [[ -z $dir ]]; then
        return
      fi
      dir=${dir%/*}
    done

    local status_out
    status_out=$(GIT_OPTIONAL_LOCKS=0 git status --porcelain=v2 --branch --show-stash 2>/dev/null) || return

    local branch='' oid='' ahead=0 behind=0 stash=0 staged=0 conflicts=0 dirty=0 untracked=0
    while IFS= read -r line; do
      case $line in
        '# branch.oid '*) oid=${line#'# branch.oid '} ;;
        '# branch.head '*) branch=${line#'# branch.head '} ;;
        '# branch.ab '*)
          line=${line#'# branch.ab +'}
          ahead=${line%% *}
          behind=${line##*-}
          ;;
        '# stash '*) stash=${line#'# stash '} ;;
        [12]' '*)
          [[ ${line:2:1} != . ]] && ((++staged))
          [[ ${line:3:1} != . ]] && ((++dirty))
          ;;
        'u '*) ((++conflicts)) ;;
        '? '*) ((++untracked)) ;;
      esac
    done <<<"$status_out"

    # in-progress operations, read from files like git's own git-prompt.sh does
    local op='' step='' total=''
    if [[ -d $gitdir/rebase-merge ]]; then
      op=REBASE line=
      { read -r step <"$gitdir/rebase-merge/msgnum"; read -r total <"$gitdir/rebase-merge/end"; read -r line <"$gitdir/rebase-merge/head-name"; } 2>/dev/null
      [[ $line == refs/heads/* ]] && branch=${line#refs/heads/}
    elif [[ -d $gitdir/rebase-apply ]]; then
      op=AM
      { read -r step <"$gitdir/rebase-apply/next"; read -r total <"$gitdir/rebase-apply/last"; } 2>/dev/null
      if [[ -f $gitdir/rebase-apply/rebasing ]]; then
        op=REBASE
        line=
        { read -r line <"$gitdir/rebase-apply/head-name"; } 2>/dev/null
        [[ $line == refs/heads/* ]] && branch=${line#refs/heads/}
      fi
    elif [[ -f $gitdir/MERGE_HEAD ]]; then
      op=MERGING
    elif [[ -f $gitdir/CHERRY_PICK_HEAD ]]; then
      op=CHERRY-PICKING
    elif [[ -f $gitdir/REVERT_HEAD ]]; then
      op=REVERTING
    elif [[ -f $gitdir/BISECT_LOG ]]; then
      op=BISECTING
    fi

    local out="${__prompt_green}󰊢 "
    if [[ $branch == '(detached)' ]]; then
      out+="${__prompt_red}(${oid:0:8})"
    else
      out+="${__prompt_green}${branch}"
    fi
    out+=$__prompt_reset
    [[ -n $op ]] && out+="|${op}${step:+ $step/$total}"
    if ((ahead || behind)); then
      out+=' '
      ((ahead)) && out+="↑$ahead"
      ((behind)) && out+="↓$behind"
    fi
    out+=' '
    if ((staged + conflicts + dirty + untracked + stash == 0)); then
      out+="${__prompt_green}✓"
    else
      ((staged)) && out+="${__prompt_green}+$staged"
      ((conflicts)) && out+="${__prompt_red}⨯$conflicts"
      ((dirty)) && out+="${__prompt_red}!$dirty"
      ((untracked)) && out+="${__prompt_yellow}?$untracked"
      ((stash)) && out+="${__prompt_cyan}\$$stash"
    fi
    __prompt_git_out="$out$__prompt_reset "
  }

  __prompt_duration() {
    local ms=$1
    if ((ms < 1000)); then
      __prompt_duration_out="${ms}ms"
    elif ((ms < 60000)); then
      __prompt_duration_out="$((ms / 1000)).$((ms % 1000 / 100))s"
    elif ((ms < 3600000)); then
      __prompt_duration_out="$((ms / 60000))m $((ms % 60000 / 1000))s"
    else
      __prompt_duration_out="$((ms / 3600000))h $((ms % 3600000 / 60000))m"
    fi
  }

  __prompt_precmd() {
    # must be first, before anything changes $? or $PIPESTATUS
    # bash-preexec (if installed) runs first and saves the real status in $BP_PIPESTATUS
    local last_status=$? pipestatus=("${PIPESTATUS[@]}") now=${EPOCHREALTIME//[^0-9]/}

    local color_prompt=$__prompt_reset info=''

    # duration and exit status, only if a command ran
    if [[ -n ${__prompt_start-} ]]; then
      local ms=$(((now - __prompt_start) / 1000))
      unset __prompt_start

      if ((ms > 0)); then
        local color_duration=$__prompt_black
        ((ms > 49)) && color_duration=$__prompt_yellow
        ((ms > 59999)) && color_duration=$__prompt_red
        __prompt_duration "$ms"
        info+="${color_duration}${__prompt_duration_out} "
      fi

      # SIGPIPE (128 + 13) is not treated as an error
      if [[ $last_status != 0 && $last_status != 141 ]]; then
        color_prompt=$__prompt_brred

        # [1|SIGTERM]
        local code sig codes='' sep=''
        for code in "${pipestatus[@]}"; do
          if ((code > 128)) && sig=$(kill -l "$((code - 128))" 2>/dev/null); then
            code=SIG$sig
          fi
          codes+="$sep$code"
          sep="${__prompt_reset}|${__prompt_brred}"
        done
        info+="${__prompt_reset}[${__prompt_brred}${codes}${__prompt_reset}]"

        # e.g. `! true` or `set -o pipefail`
        ((last_status != pipestatus[-1])) && info+=" ${__prompt_brred}${last_status}${__prompt_reset}"
        info+=' '
      fi
    fi

    # login, only over ssh
    local login=
    [[ -n ${SSH_TTY-} ]] && login="${__prompt_brgreen}${USER}${__prompt_reset}@${__prompt_yellow}${HOSTNAME%%.*}${__prompt_reset} "

    # pwd, red for root
    local color_pwd=$__prompt_green
    ((EUID == 0)) && color_pwd=$__prompt_red
    __prompt_pwd
    __prompt_git

    # python
    local python=
    [[ -n ${VIRTUAL_ENV-} ]] && python="${__prompt_blue}󰌠 ${VIRTUAL_ENV##*/} "

    # assigned to a variable instead of PS1
    __prompt_ps1="${color_prompt}╭─ ${login}${color_pwd}${__prompt_pwd_out} ${__prompt_git_out}${python}${info}"
    __prompt_ps1+=$'\n'"${color_prompt}╰─${__prompt_reset} "
  }

  # PS1 must use single quotes so it's expanded at each prompt
  # shellcheck disable=SC2016
  PS1='${__prompt_ps1}'

  # PS0 is expanded after a command is read and before it runs, but not for empty lines
  # the arithmetic sets the start time in microseconds, which also tells the prompt a command ran
  __prompt_nil=
  # shellcheck disable=SC2016
  [[ ${PS0-} == *__prompt_start* ]] || PS0+='${__prompt_nil:$(( __prompt_start = ${EPOCHREALTIME//[^0-9]/}, 0 )):0}'

  # first, so it sees the last command's $? and $PIPESTATUS
  [[ ${PROMPT_COMMAND-} == *__prompt_precmd* ]] || PROMPT_COMMAND="__prompt_precmd${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi
