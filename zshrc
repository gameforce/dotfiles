# Path to your oh-my-zsh configuration.
ZSH=$HOME/.dotfiles/zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="pygmalion"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
#
# homebrew zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

# environment
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games/bin:${PATH}"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/man:/usr/share/man:${MANPATH}"
export MC_SKIN=$HOME/.mc/solarized.ini

# history
export HISTSIZE=2000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# colors (mac)
export CLICOLOR=1

# colors (gnu)
eval $(dircolors $HOME/.dircolors/dircolors.ansi-universal)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

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
alias zr="vi ~/.zshrc"
alias sr="source ~/.zshrc"
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir -p'
autoload zmv
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
