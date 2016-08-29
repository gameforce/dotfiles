#!/bin/sh
# reposync

BASEDIR=/srv/repo/centos/6
mkdir -p $BASEDIR
cd $BASEDIR

reposync -n -r epel
repomanage -o -c epel | xargs rm -fv
createrepo epel
