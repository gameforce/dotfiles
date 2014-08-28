rem WARNING this will disconnect all your network drives and map the ones below:
@echo off
net use N: /delete
net use R: /delete
net use U: /delete
net use N: \\EC2-ONL-MGNT01\DeploymentStorage /USER:quazalnet\ngotsinas !mtFbwy76 /persistent:yes
net use R: \\EC2-ONL-MGNT01\MQEL-Internal /USER:quazalnet\ngotsinas !mtFbwy76 /persistent:yes
net use U: \\EC2-ONL-MGNT01\MQEL-External /USER:quazalnet\ngotsinas !mtFbwy76 /persistent:yes
