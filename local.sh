#!/bin/sh

export LANGUAGE=C
export LC_ALL=C
export LC_CTYPE=C
export LANG=C
export EDITOR=vim
export TERM=xterm-256color
export LESS="-XFR"

export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

alias e='vim'
alias r='view'
alias ag="ag --pager less"
alias ngrep='ngrep -qt -W byline'

if [[ ${EUID} == 0 ]] ; then
    # color prompt for root
    export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    export PS1='\u@\h:\w\$ '
fi

export GOPATH=/opt/gowspace
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# grep paragraph
pargrep() {
    invert=false
    if [ "$1" = "-v" ] ; then
        invert=true
        shift
    fi
    case "$#" in
        1)
            [ $invert = false ] && awk -v RS='' -v ORS="\n\n" "/$1/" || awk -v RS='' -v ORS="\n\n" "!/$1/"
            ;;
        2)
            [ $invert = false ] && awk -v RS='' -v ORS="\n\n" "/$1/" "$2" || awk -v RS='' -v ORS="\n\n" "!/$1/" "$2"
            awk -v RS='' -v ORS="\n\n" "/$1/" "$2"
            ;;
        *)
            echo "usage: pargrep [ -v ] regex [ file ]"
    esac
}
