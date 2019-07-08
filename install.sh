#!/bin/bash

echo "Setting up links..."
ln -s $HOME/.dotfiles/zshrc.linux $HOME/.zshrc
ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc
ln -s $HOME/.dotfiles/vim $HOME/.vim
#ln -s $HOME/.dotfiles/screenrc $HOME/.screenrc
ln -s $HOME/.dotfiles/fonts $HOME/.fonts
ln -s $HOME/.dotfiles/dircolors $HOME/.dircolors
ln -s $HOME/.dotfiles/gitconfig $HOME/.gitconfig
ln -s $HOME/.dotfiles/bin $HOME/bin
ln -s $HOME/.dotfiles/tmux.conf $HOME/.tmux.conf
echo "Done!"
echo "Installing fonts..."
sh dotfiles/fonts/install.sh
echo "Done!"
