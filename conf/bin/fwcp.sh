#!/bin/zsh

if [ -n "$1" ]
then
    echo "Press [enter] key to copy files or CTRL+C to exit"
    read contscr
    echo "Copying files..."
    cd ~/.ssh;cat id_rsa.pub | ssh -p9822 $1 'test -d .ssh || mkdir .ssh && chmod 700 .ssh;cd .ssh; cat >> authorized_keys; chmod 600 authorized_keys'
    cd ~/;scp -P9822 -r scripts $1:
    scp -P9822 -r .zsh $1:
    scp -P9822 .zshrc $1:
    scp -P9822 .vimrc $1:
    echo "Done."
else echo "Usage: dotfiles hostname"
fi
