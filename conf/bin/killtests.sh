#!/bin/zsh
#Test_Host=(ec2-184-73-125-131.compute-1.amazonaws.com ec2-184-72-188-81.compute-1.amazonaws.com ec2-184-72-188-81.compute-1.amazonaws.com ec2-174-129-48-97.compute-1.amazonaws.com ec2-184-73-104-59.compute-1.amazonaws.com ec2-184-73-104-59.compute-1.amazonaws.com ec2-174-129-113-142.compute-1.amazonaws.com ec2-72-44-51-5.compute-1.amazonaws.com ec2-174-129-166-152.compute-1.amazonaws.com)

Test_Host=(ec2-184-73-104-59.compute-1.amazonaws.com ec2-184-73-104-59.compute-1.amazonaws.com ec2-174-129-113-142.compute-1.amazonaws.com ec2-72-44-51-5.compute-1.amazonaws.com ec2-174-129-166-152.compute-1.amazonaws.com)


Ssh_Cmd='/usr/bin/ssh'
Kill_Cmd='/usr/bin/killall loopFtp.py testftp.sh lftp'

for i in ${Test_Host[@]}; do
  echo $Ssh_Cmd ${i} $Kill_Cmd
  $Ssh_Cmd ${i} $Kill_Cmd
done
exit 0
