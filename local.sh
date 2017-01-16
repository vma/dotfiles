#!/bin/bash

export LC_ALL=C
export LANG=C
export LC_TYPE=C
export EDITOR=vim

alias e='vim'

if [[ ${EUID} == 0 ]] ; then
    # color prompt for root
    export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    export PS1='\u@\h:\w\$ '
fi
