#!/bin/zsh

i="1"

#mkdir tmp_upload

while [ $i -lt 1000 ]
  do
    #rm -f ghost_file.rgf
    #mkdir tmp_download/$i
    cd tmp_download/$i
    rm -f ghost_file.rgf
    lftp -c "open -u sandboxname1,ftptest gfs-node1;get ghosts2/ghost_file.rgf" &
    cd ../..
    cp ghost_file.rgf tmp_upload/ghost_file$i.rgf
    lftp -c "open -u sandboxname1,ftptest gfs-node1;put tmp_upload/ghost_file"$i".rgf" &
    i=$[$i+1]
done

