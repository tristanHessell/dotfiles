# ~/.bashrc: executed by bash(2) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Returns whether the given command is executable or aliased.
_has() {
  return $( which $1 &>/dev/null )
}

# turn off flow control characters
# meaning C-s wont stop the terminal anymore
stty -ixon

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [ -z "$SSH_CLIENT" ]; then
      PS1='${debian_chroot:+($debian_chroot)}\$ '
    else
      PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:$ '
    fi
else
    if [ -z "$SSH_CLIENT" ]; then
      PS1='${debian_chroot:+($debian_chroot)}\$ '
    else
      PS1='${debian_chroot:+($debian_chroot)}\u@\h:\$ '
    fi
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# open vi with -v flag that allows it to access the system clipboard
alias vim='vim -v'
alias vi='vi -v'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# TAKEN FROM: https://stackoverflow.com/a/55241227/6304194
# Preload git completion in Ubuntu which is normally lazy loaded but we need
# the __git_wrap__git_main function available for our completion.
if [[ -e /usr/share/bash-completion/completions/git ]]; then
  source /usr/share/bash-completion/completions/git
elif [[ -e /usr/local/etc/bash_completion.d/git-completion.bash ]]; then
  source /usr/local/etc/bash_completion.d/git-completion.bash
fi

export VISUAL=vim
export EDITOR="$VISUAL"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if _has rg; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
  export FZF_CTRL_T_COMMAND='rg --files --hidden --follow'
fi

export FZF_DEFAULT_OPTS='--color=hl:#ff0000,hl+:#ff0000'

# go to the logbook for the given day - see routley.io/posts/logbook
lb() {
  vi ~/logbook/$(date '+%Y-%m-%d').md
}

# get battery status
battery () {
  upower -i $(upower -e | grep BAT) | grep --color=never -E "state|to\ full|to\ empty|percentage"
}

# fe [FUZZY_PATTERN] - Open the selected file in default editor
fe () {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fif <SEARCH_TERM>  Find-in-file and open in editor 
fif () {
  if [ ! "$#" -gt 0 ]; then echo "Need string to search for"; return 1; fi

  local files
  IFS=$'\n'
  files=($(rg --files-with-matches --no-messages --hidden --sort path --follow "$1" | fzf --preview-window=right:50%:wrap --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
  
}

config () {
  git --git-dir=$HOME/.cfg/ --work-tree=$HOME "$@"
}

export -f config
__git_complete config _git

# set bash to operate with vi bindings ins/com mode
set -o vi
set show-mode-in-prompt on

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
fi

# automatically added by git-installed fzf install script
# used only if cant download fzf through apt
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

loadshortcuts() {
  cat .ubuntu-config/mate/marco/.conf | dconf load /org/mate/marco/
  cat .ubuntu-config/mate/panel/.conf | dconf load /org/mate/panel/
}

export -f loadshortcuts

saveshortcuts() {
  dconf dump /org/mate/marco/ > .ubuntu-config/mate/marco/.conf
  dconf dump /org/mate/panel/ > .ubuntu-config/mate/panel/.conf
}

export -f saveshortcuts

killx() {
  killall xinit
}

export -f killx

