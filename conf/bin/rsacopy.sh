#!/bin/zsh

if [ -n "$1" ]
then
    echo "Got hostname:"$1
    echo "Copying files..."
    cd ~/.ssh;cat id_rsa.pub | ssh $1 'test -d .ssh || mkdir .ssh && chmod 700 .ssh;cd .ssh; cat >> authorized_keys; chmod 600 authorized_keys'
    echo "Done."
 else echo "Usage: rsacopy hostname"
 fi 

