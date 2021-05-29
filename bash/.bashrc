# custom path
export PATH=$PATH:/opt/puppetlabs/bin

# powerline
. ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh

# configure PS1 command prompt
if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

# no double entries in the shell history
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"

# do not overwrite files when redirecting output by default.
set -o noclobber

# wrap these commands for interactive use to avoid accidental overwrites.
rm() { command rm -i "$@"; }
cp() { command cp -i "$@"; }
mv() { command mv -i "$@"; } 

# aliases
alias ls='ls --color'
alias ll='ls -lha'
