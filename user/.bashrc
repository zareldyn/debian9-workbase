HISTCONTROL=ignoreboth

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;42;39m\]\u@\h@${PARENT_HOSTNAME} \[\033[01;44;39m\] \w \[\033[00m\] '

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

. /etc/bash_completion
