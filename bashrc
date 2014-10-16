. /etc/bash/bashrc

# environment
export DISPLAY=$DISPLAY
export XAUTHORITY="$HOME/.Xauthority"
export PATH="/usr/sbin/:/sbin:/net/systems/bin:$PATH"

# completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

#prompt
PS1='\[\e[0;32m\]\u@\h\[\e[m\] \[\e[0;34m\]\w\[\e[m\] \[\e[2;32m\]>\[\e[m\] '

#colors
eval $(dircolors $HOME/.dircolors/dircolors.256dark)

#aliases
alias cl='clear' 
alias ls='ls --color=auto'
alias ll='ls -la'
alias l.='ls -d .* --color=auto'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias mkdir='mkdir -pv'
alias diff='colordiff'
alias mount='mount |column -t'
alias h='history'
alias j='jobs -l'
alias vi='vim -X'
alias svi='sudo vi'
alias vis='vim "+set si"'
alias edit='vim'
alias ping='ping -c 5'
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias root='sudo -i'
alias su='sudo -i'
alias wget='wget -c'
alias df='df -H'
alias du='du -ch'

#famestore aliases
alias fqu='crash-monitor -n -m fq-crashes -- fqu'
alias go='exec csh && set _GOAT_TEMP=$?prompt && eval `goat bash $$ $_GOAT_TEMP !*`'
alias module='(set _prompt="$prompt";set prompt="";eval `/usr/bin/modulecmd'
alias rdesktop='rdesktop -g1280x1024 -ungotsina -dFRAMESTORE'
