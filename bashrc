# Customize to your needs...
#
# environment
export PATH="/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games/bin:~/Scripts:${PATH}"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/man:/usr/share/man:${MANPATH}"
export MC_SKIN=$HOME/.mc/solarized.ini

# history
export HISTSIZE=2000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# colors 
eval $(dircolors $HOME/.dircolors/dircolors.ansi-universal)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# CVS
setenv CVSROOT ':ext:cvs.framestore.com:/usr/local/cvs'

#keychain
if [ -e `which keychain` ]
then
	eval `keychain --eval --agents ssh --inherit any id_rsa`
else
	echo -n "keychain is not installed, please install it first"
fi

# aliases
alias ls='ls --color'
alias l.='ls -d .*'
alias ll='ls -ahl'
alias l="ls -a -F -b -T 0 -h --group-directories-first"
alias rm="rm -i"
alias vi="vim -X"
alias cl="clear; reset"
alias j="jobs -l"
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir -p'
alias zmv='noglob zmv -W'
alias nano='nano -w'
alias cd..='cd ..'
alias h='history 1'
alias grep='grep --color=auto'
alias less='less -R'
alias diff='colordiff'
alias poweroff='sudo /sbin/poweroff'
alias reboot='sudo /sbin/reboot'
alias halt='sudo /sbin/halt'
alias fixperm='find . -type f -print0 | xargs -0 chmod 644; find . -type d -print0 | xargs -0 chmod 755'
alias tolower="for n in *; do mv $n `echo $n | tr '[:upper:]' '[:lower:]'`; done"
alias useinfo="cat /usr/portage/profiles/use*desc | grep -i" # can also use einfo -i if you have gentoolkit installed
alias strip="sed -e 's/#.*//;/^\s*$/d' '$@'"
alias lsdir="for dir in *;do;if [ -d \$dir ];then;du -hsL \$dir;fi;done"
alias tcpdump="tcpdump -qtnnni"
alias df="df -h"
alias rdesktop="resesktop -g 1280x1024"
