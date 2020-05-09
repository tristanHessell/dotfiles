# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# turn off flow control characters
# meaning C-s wont stop the terminal anymore
stty -ixon

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set bash to operate with vi bindings ins/com mode
set -o vi
set show-mode-in-prompt on

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

if hash vim 2>/dev/null; then
  export VISUAL=vim
  export EDITOR="$VISUAL"
fi

export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# load supplementary scripts
# taken from sanctum.geek.nz/arabesque/shell-config-subfiles/
for confFile in "$HOME"/.bashrc.d/*.bash ; do
  source "$confFile"
done

unset -v confFile

alias cd='pushd'
alias dc='popd'

