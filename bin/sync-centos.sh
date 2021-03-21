#!/bin/sh
# yum install yum-utils createrepo -y
# CentOS mirror
# cd /srv/repo

BASEDIR=/srv/repo/centos/6
mkdir -p $BASEDIR
cd $BASEDIR

reposync -n -r updates
repomanage -o -c updates | xargs rm -fv
createrepo updates

reposync -n -r base --downloadcomps
repomanage -o -c base | xargs rm -fv
createrepo base -g comps.xml
