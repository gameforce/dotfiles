#!/bin/zsh

if [ -n "$1" ]
then
    echo "Got hostname:"$1""
    echo "Press [enter] key to copy files or CTRL+C to exit"
    read contscr
    echo "Copying files..."
    cd ~/.ssh;cat id_rsa.pub | ssh $1 'test -d .ssh || mkdir .ssh && chmod 700 .ssh;cd .ssh; cat >> authorized_keys; chmod 600 authorized_keys'
    cd ~/;scp -r scripts $1:
    scp -r .zsh $1:
    scp .zshrc $1:
    scp .vimrc $1:
    echo "Done."
 else echo "Usage: dotfiles hostname"
 fi 

