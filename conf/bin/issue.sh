
#!/bin/sh
# /etc/rc.d/rc.local:  Local system initialization script
RELEASE="OpenRC 0.5.3"
COLOR1="\033[1;6m\033[35;40m" # bright magenta on black
COLOR2="\033[1;6m\033[32;40m" # bright green on black
COLOR_RESET="\033[0m"
rm -f /etc/issue
clear > /etc/issue
echo -e $COLOR1"Funtoo Linux ($(uname -m))"$COLOR2 "$RELEASE" "$COLOR_RESET" >> /etc/issue
#echo "Kernel $(uname -r) on an $(uname -m)" >> /etc/issue
echo >> /etc/issue
cp -f /etc/issue /etc/issue.net
