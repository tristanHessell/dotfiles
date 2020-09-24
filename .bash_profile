# set the DISPLAY environment variable if it is not set
# this will likely only occur in a tty session 
# (i cant remember why - something to do with tty sessions not having a GUI)
# we need the display so that vi can use the system clipboard for copy/pasting

if [ -z "$DISPLAY" ]
then
  # the display environment variable is not set
  export DISPLAY=127.0.0.1:0.0
fi

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

export GPG_TTY=$(tty)


[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
