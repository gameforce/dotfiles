#!/bin/zsh

if [ -n "$1" ]
then
    echo "Press [enter] key to delete files or CTRL+C to exit"
    read contscr
    echo "Deleting files..."
    ssh $1 'rm -rf *'
    ssh $1 'rm -rf .*'
    echo "Done."
else echo "Usage: da hostname"
fi
