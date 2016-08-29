#!/bin/bash

#
# The root directory of the backups
#

REMOTEBCKPATH=/mnt/backup/

DAYOFWEEK=`date +%a`
DAYOFMONTH=`date +%d`

if [ "$DAYOFMONTH" == "01" ]; then
  BCKDIR=monthly
  REMOTEBCKPATH=$REMOTEBCKPATH$BCKDIR
elif [ "$DAYOFWEEK" == "Mon" ]; then
  BCKDIR=weekly
  REMOTEBCKPATH=$REMOTEBCKPATH$BCKDIR
else
  BCKDIR=daily
  REMOTEBCKPATH=$REMOTEBCKPATH$BCKDIR
fi


SRCDIR=$REMOTEBCKPATH

/usr/bin/scp -i /root/.ssh/ftp_rsa $SRCDIR/bigmatchpcbeta.tar.1.gz ftpadmin@ftp.quazal.com:/mnt/ftpdata/ftproot/supermassive/PC

exit 0

sudo ./pure-pw useradd supermassive -f /usr/local/pure-ftpd/etc/pureftpd.passwd -u 503 -g 503 -d /mnt/ftpdata/ftproot/supermassive/ -c "Supermassive Games" -m
username: supermassive
password: vcZMPm2Y