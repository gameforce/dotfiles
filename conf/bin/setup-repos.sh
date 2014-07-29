#!/bin/bash
#app-shells/bash        (bash)
#sys-apps/coreutils     (mktemp,...)
#dev-util/subversion    (svn,svnadmin)

if [ ! -d /var/svn/ ] ;then
    echo "Cant find SVN-Directory at /var/svn"
    exit 1
fi
 
if [ -z $1 ] ;then
    echo "Usage: $0 <Repository-Name>"
    exit 1
fi
 
if [ -d /var/svn/$1 ] ;then
    echo "Repository /var/svn/$1 is already present"
    exit 1
fi
 
echo "Creating Repository..."
    svnadmin create /var/svn/$1
 
    echo "Creating default directories..."
    TDIR=`mktemp -d`
    cd $TDIR
    mkdir -p {trunk,tags,branches}
 
    echo "Initial import..."
    svn import -q -m "Initial Import" --non-interactive $TDIR file:///var/svn/$1
 
    echo "Fixing permissions..."
    chown -R apache /var/svn/$1
 
    echo "Cleaning up..."
    rmdir $TDIR/{trunk,tags,branches}
    rmdir $TDIR
 
    echo "Done!"
