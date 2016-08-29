#!/bin/sh
# reposync
# puppet <= 4.0
# sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

BASEDIR=/srv/repo/centos/6
mkdir -p $BASEDIR
cd $BASEDIR

reposync -n -r puppet
repomanage -o -c puppet | xargs rm -fv
createrepo puppet
