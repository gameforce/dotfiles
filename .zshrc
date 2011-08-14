# 
# This file is based on the configuration written by
# Nick Gotsinas, <darf@gameforce.ca>
# Written since summer 2001 with various snippets from others

# use hard limits, except for a smaller stack and no core dumps
export SHELL=/bin/zsh
unlimit
limit stack 8192
limit core 0
limit -s
umask 022

# environment
export PATH="/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games/bin:~/scripts:~/bin:${PATH}"
export MANPATH="/usr/local/man:/usr/share/man"
export LESS=-cex3MR
export DIRSTACKSIZE=20
export EDITOR=/bin/vi
export CVSROOT=:pserver:ngotsinas@cvs.mtl.proksim.com:/devenv/CVSROOT

# history
export HISTSIZE=5000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# colors
ZLS_COLORS="$LS_COLORS"
eval `dircolors -b /etc/DIR_COLORS`
export COLORTERM=y
export ZLS_COLORS

# modules
#autoload -U zutil
autoload -Uz compinit; compinit
autoload -Uz colors; colors

# ssh /etc/hosts and known hosts completion
  [ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
  [ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
    `hostname`
    "$_ssh_hosts[@]"
    "$_etc_hosts[@]"
    gameforce.ca
    localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# completion styles
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )' # allow one error for every three characters typed in approximate completer
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~' # don't complete backup files as executables
zstyle ':completion:*:correct:*'       insert-unambiguous true             # start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}' #
zstyle ':completion:*:correct:*'       original true                       #
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}      # activate color-completion(!)
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'  # format on completion
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select              # complete 'cd -<tab>' with menu
zstyle ':completion:*:expand:*'        tag-order all-expansions            # insert all expansions for expand completer
zstyle ':completion:*:history-words'   list false                          #
zstyle ':completion:*:history-words'   menu yes                            # activate menu
zstyle ':completion:*:history-words'   remove-all-dups yes                 # ignore duplicate entries
zstyle ':completion:*:history-words'   stop yes                            #
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'        # match uppercase from lowercase
zstyle ':completion:*:matches'         group 'yes'                         # separate matches into groups
zstyle ':completion:*'                 group-name ''
if [[ -z "$NOMENU" ]] ; then
  zstyle ':completion:*'               menu select=5                       # if there are more than 5 options allow selecting from a menu
else
  setopt no_auto_menu # don't use any menus at all
fi
zstyle ':completion:*:messages'         format '%d'                         #
zstyle ':completion:*:options'          description 'yes'                   # show options when typing commands -<tab>
zstyle ':completion:*:options'          auto-description '%d'
zstyle ':completion:*:descriptions'     format $'\e[01;33m -- %d --\e[0m'   # full description
zstyle ':completion:*:processes'        command 'ps -au$USER'               # on processes completion complete all user processes
zstyle ':completion:*:*:-subscript-:*'  tag-order indexes parameters        # offer indexes before parameters in subscripts
zstyle ':completion:*'                  verbose true                        # provide verbose completion information
zstyle ':completion:*:warnings'         format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d' # set format for warnings
zstyle ':completion:*:*:zcompile:*'     ignored-patterns '(*~|*.zwc)'       # define files to ignore for zcompile
zstyle ':completion:correct:'           prompt 'correct to: %e'             #
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'    # Ignore completion functions for commands you don't have:
zstyle ':completion:*:manuals'          separate-sections true
zstyle ':completion:*:manuals.*'        insert-sections   true
zstyle ':completion:*:man:*'            menu yes select

# binds
bindkey -e
bindkey "[2~" overwrite-mode          #insert
bindkey "[1~" beginning-of-line	#home
bindkey "[H" 	beginning-of-line       #home
bindkey "" backward-delete-char	#bs
bindkey "[3~" delete-char		#del
bindkey "[F" 	end-of-line             #end
bindkey "[4~" end-of-line		#end
bindkey "[5~" up-line-or-history      #pgup
bindkey "[6~" down-line-or-history    #pgdn
bindkey "^[[A"  history-search-backward #up
bindkey "^[[B"  history-search-forward  #down
bindkey "^[[D"  backward-char           #left
bindkey "^[[C"  forward-char            #right

# aliases

# portage
alias es="sudo eix-sync"
alias ew="sudo emerge -DuvaN world"
alias ec="sudo emerge --depclean"
alias rv="sudo revdep-rebuild"

# commands
alias ls='ls --color=tty'
alias l.='ls -d .*'
alias ll='ls -ahl'
alias l="ls -a -F -b -T 0 -h --group-directories-first"
alias rm="rm -i"
alias vi="vim"
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

# shutdown
alias poweroff='sudo /sbin/poweroff'
alias reboot='sudo /sbin/reboot'
alias halt='sudo /sbin/halt'

# other
alias fixperm='find . -type f -print0 | xargs -0 chmod 644; find . -type d -print0 | xargs -0 chmod 755'
alias tolower="for n in *; do mv $n `echo $n | tr '[:upper:]' '[:lower:]'`; done"
alias useinfo="cat /usr/portage/profiles/use*desc | grep -i" # can also use einfo -i if you have gentoolkit installed
alias strip="sed -e 's/#.*//;/^\s*$/d' '$@'"
alias lsdir="for dir in *;do;if [ -d \$dir ];then;du -hsL \$dir;fi;done"

# options
# set -o noclobber	   # warn before clobbering a file with > ##
setopt correctall autocd recexact longlistjobs alwaystoend
setopt autocd checkjobs nohup
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt append_history
setopt hist_reduce_blanks
setopt autoresume histignoredups pushdsilent noclobber
setopt autopushd pushdminus extendedglob rcquotes mailwarning
setopt complete_in_word magic_equal_subst
setopt prompt_subst
unsetopt bgnice autoparamslash
setopt no_beep

# This starts ssh-agent
test=`/bin/ps -ef | grep ssh-agent | grep -v grep  | awk '{print $2}' | xargs`

if [ "$test" = "" ]; then
   # there is no agent running
   if [ -e "$HOME/.ssh/agent.sh" ]; then
      # remove the old file
      /bin/rm -f $HOME/.ssh/agent.sh
   fi;
   # start a new agent
   /usr/bin/ssh-agent | grep -v echo >&$HOME/.ssh/agent.sh-
fi;

test -e $HOME/.ssh/agent.sh && source $HOME/.ssh/agent.sh

alias kagent="kill -9 $SSH_AGENT_PID"

# This sets the window title to the last run command. ##
[[ -t 1 ]] || return
case $TERM in
    *xterm*|rxvt|(dt|k|E|a)term)
    preexec () {
    print -Pn "\e]2;[%l] [%n@%m] <$1>\a"
    #print -Pn "\e]2;$1\a"
    }
    ;;
    screen*)
        preexec () {
        # this doesn't do anything... *wah*
        #print -Pn "\e\"[screen] [%l] [%n@%m] <$1>\e\134"
        print -Pn "\e\"$1\e\134"
    }
  ;;
esac

setprompt () {
    # Need this, so the prompt will work
    setopt prompt_subst

    # let's load colors into our environment, then set them
    autoload colors zsh/terminfo

    if [[ "$terminfo[colors]" -gt 8 ]]; then
        colors
    fi

    for COLOR in RED GREEN YELLOW WHITE BLACK; do
        eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
        eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
    done

    PR_RESET="%{$reset_color%}"

    # Finally, let's set the prompt
    PROMPT='\
${PR_BRIGHT_BLACK}<${PR_RESET}${PR_RED}<${PR_BRIGHT_RED}<${PR_RESET} \
%D{%R.%S %a %b %d %Y}${PR_RED}!${PR_RESET}%$PR_PWDLEN<...<%d%<< \

${PR_BRIGHT_BLACK}<${PR_RESET}${PR_RED}<${PR_BRIGHT_RED}<\
${PR_RESET} %n@%m${PR_RED}!${PR_RESET}H:%h${SCREEN}${JOBS}%(?.. E:%?)\

${PR_BRIGHT_BLACK}>${PR_RESET}${PR_GREEN}>${PR_BRIGHT_GREEN}>\
${PR_RESET} '

    # Of course we need a matching continuation prompt
    PROMPT2='\
${PR_BRIGHT_BLACK}>${PR_RESET}${PR_GREEN}>${PR_BRIGHT_GREEN}>\
${PR_RESET} %_ ${PR_BRIGHT_BLACK}>${PR_RESET}${PR_GREEN}>\
${PR_BRIGHT_GREEN}>${PR_BRIGHT_WHITE} '
}

setprompt
