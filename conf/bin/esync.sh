#!/bin/bash
# Copy this script to the cron.daily folder to run it once a week

DATE=$(date "+%a %d %b %Y %H:%M")
DIR=/usr/tmp/portage
LOG1=$DIR/updates_world.log
HOST=$(hostname | awk -F. '{print $1}')
EMAIL="root"

/usr/bin/emerge --sync 

/usr/bin/emerge --deep --update --newuse --pretend world > $LOG1

NO1=$(grep ebuild $LOG1 | wc -l | awk '{ print $1 }')

SUB1="$HOST - $NO1 world updates ($DATE)"

echo -e '\nNo. of world updates = '$NO1 >> $LOG1
echo -e '\nPlease log on '$HOST' and run "emerge --deep --update --newuse world" manually.' >> $LOG1

mail -s "$SUB1" $EMAIL < $LOG1
