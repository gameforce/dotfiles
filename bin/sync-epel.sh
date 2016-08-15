#!/bin/sh
# /var/www/html/sync-epel.sh
# reposync -- epel
# rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

BASEDIR=/var/www/html/centos/6
mkdir -p $BASEDIR
cd $BASEDIR

reposync -n -r epel
repomanage -o -c epel | xargs rm -fv
createrepo epel
