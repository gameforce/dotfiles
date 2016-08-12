#!/bin/zsh

if [ -n "$1" ]
then
    echo "Got hostname:"$1""
    echo "Press [enter] key to copy files or CTRL+C to exit"
    read contscr
    echo "Copying files..."
    cd ~/.ssh;cat id_rsa.pub | ssh $1 'test -d .ssh || mkdir .ssh && chmod 700 .ssh;cd .ssh; cat >> authorized_keys; chmod 600 authorized_keys'
    cd ~/;scp -r scripts $1:
    scp .vimrc $1:
  else echo "Usage: dotfiles hostname"
  fi

  echo "Done copying ssh files. Checking for dotfiles..."

    if [ -e .zshrc]; then
      scp .zshrc $1:
    else 
      echo "No .zshrc here"
    if [ -e .zsh]; then
      scp -r .zsh $1:
    else "No .zsh here"
    if  [ -e .bashrc]; then
      scp .bashrc $1:
    else
      echo "No .bashrc here." 
    fi
echo "Done!"
