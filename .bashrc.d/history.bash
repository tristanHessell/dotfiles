# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# force commands entered over multiple lines to be recorded to as a single line
shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2001

# show the date and time in the command history
HISTTIMEFORMAT='%F %T '

# record history as you do it, rather than at the end of the session
PROMPT_COMMAND='history -a'

