#!/bin/bash
#Test_Host=(ec2-184-73-125-131.compute-1.amazonaws.com ec2-184-72-188-81.compute-1.amazonaws.com ec2-184-72-188-81.compute-1.amazonaws.com ec2-174-129-48-97.compute-1.amazonaws.com ec2-184-73-104-59.compute-1.amazonaws.com ec2-184-73-104-59.compute-1.amazonaws.com ec2-174-129-113-142.compute-1.amazonaws.com ec2-72-44-51-5.compute-1.amazonaws.com ec2-174-129-166-152.compute-1.amazonaws.com ec2-204-236-200-202.compute-1.amazonaws.com) 

Test_Host=(ec2-184-73-104-59.compute-1.amazonaws.com ec2-184-73-104-59.compute-1.amazonaws.com ec2-174-129-113-142.compute-1.amazonaws.com ec2-72-44-51-5.compute-1.amazonaws.com ec2-174-129-166-152.compute-1.amazonaws.com)


Start_Cmd='cd scripts;./loopFtp.py --max=1000 --filesize=64 --host=lweb1 >> tests.log 2> /dev/null'
Ssh_Cmd='/usr/bin/ssh'

for i in ${Test_Host[@]}; do
     echo "Starting test on "${i} "Running " $Start_Cmd  
     $Ssh_Cmd ${i} $Start_Cmd &
done
exit 0
