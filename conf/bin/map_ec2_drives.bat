
net use U: /delete /yes
net use R: /delete /yes
net use N: /delete /yes
net use U: \\EC2-ONL-MGNT01\MQEL-External # Shared drives
net use R: \\EC2-ONL-MGNT01\MQEL-Internal # Shared drives 
net use N: \\EC2-ONL-MGNT01\DeploymentStorage # Local Drive

Security Accounts
quazalnet\srv_acc_dev_hq_depl
#*54&QcyyAxh

net use U: \\EC2-ONL-MGNT01\MQEL-External
net use R: \\EC2-ONL-MGNT01\MQEL-Internal
net use N: \\EC2-ONL-MGNT01\DeploymentStorage