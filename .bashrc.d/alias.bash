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

# go to the logbook for the given day - see routley.io/posts/logbook
lb() {
  vi ~/logbook/$(date '+%Y-%m-%d').md
}

# get battery status
battery () {
  upower -i $(upower -e | grep BAT) | grep --color=never -E "state|to\ full|to\ empty|percentage"
}

config () {
  git --git-dir=$HOME/.cfg/ --work-tree=$HOME "$@"
}

export -f config
__git_complete config _git

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

