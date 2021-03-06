HISTCONTROL=ignoreboth

if [ -z "$CONTAINER_NAME" ]; then
    containerName='\h'
else
    containerName='\[\033[93m\]'"$CONTAINER_NAME"'\[\033[01;41;39m\]'
fi

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;41;39m\]\u@'"$containerName"'@${PARENT_HOSTNAME} \[\033[01;44;39m\] \w \[\033[00m\] '

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

. /etc/bash_completion
