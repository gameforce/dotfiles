#!/bin/bash 
# Get the number of ftp users every 5 seconds
 
FTP_COUNT_FILE="ftp_count_file"
 while true
 do
   echo `date "+%T"` "`ftpcount -f /var/run/proftpd.score | grep class | awk -F" " '{print $4}'`" >> $FTP_COUNT_FILE
   sleep 1
done

