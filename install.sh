#!/bin/zsh
# script to copy config files to $home

# copy directories
echo -n "Copying directories..."
cp -r $HOME/.dotfiles/vim $HOME/.vim
cp -r $HOME/.dotfiles/etc $HOME/.etc
cp -r $HOME/.dotfiles/mc $HOME/.mc
cp -r $HOME/.dotfiles/dircolors $HOME/.dircolors

# copy files
echo -n "Copying files..."
cp $HOME/.dotfiles/zshrc $HOME/.zshrc
cp $HOME/.dotfiles/vimrc $HOME/.vimrc
cp $HOME/.dotfiles/screenrc $HOME/.screenrc 

echo -n "Done."
