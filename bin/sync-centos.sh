#!/bin/sh
# reposync -- centos
# /var/www/html/sync-centos.sh

BASEDIR=/var/www/html/centos/6
mkdir -p $BASEDIR
cd $BASEDIR

reposync -n -r updates
repomanage -o -c updates | xargs rm -fv
createrepo updates

reposync -n -r base --downloadcomps
repomanage -o -c base | xargs rm -fv
createrepo base -g comps.xml

chmod 755 sync-centos.sh
sh sync-centos.sh
