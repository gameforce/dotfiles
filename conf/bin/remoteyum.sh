#!/bin/zsh

if [ -n "$1" ]
then
    echo "Will install package $2 on $1"
    echo "Press [enter] key to continue CTRL+C to exit"
    read contscr
    echo "Installing packages..."
    ssh $1 sudo yum -y install ubiadm-$2; sudo gpasswd -a $2 wheel
  else echo "Usage: hostname package"
  fi

echo "Done"
