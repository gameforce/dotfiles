#!/usr/bin/bash

# Gentoo prefix installation on Mac OS X (Mar. 2012)
# This script may be outdated soon.
# Please refer: http://www.gentoo.org/proj/en/gentoo-alt/prefix/bootstrap-macos.xml

export EPREFIX="$HOME/gentoo"
export PATH="$EPREFIX/usr/bin:$EPREFIX/bin:$EPREFIX/tmp/usr/bin:$EPREFIX/tmp/bin:$PATH"

curl -o bootstrap-prefix.sh 'http://overlays.gentoo.org/proj/alt/browser/trunk/prefix-overlay/scripts/bootstrap-prefix.sh?format=txt'
chmod 755 bootstrap-prefix.sh
./bootstrap-prefix.sh $EPREFIX tree
./bootstrap-prefix.sh $EPREFIX/tmp make
./bootstrap-prefix.sh $EPREFIX/tmp wget
./bootstrap-prefix.sh $EPREFIX/tmp sed
./bootstrap-prefix.sh $EPREFIX/tmp python
./bootstrap-prefix.sh $EPREFIX/tmp coreutils6
./bootstrap-prefix.sh $EPREFIX/tmp findutils
./bootstrap-prefix.sh $EPREFIX/tmp tar15
./bootstrap-prefix.sh $EPREFIX/tmp patch9
./bootstrap-prefix.sh $EPREFIX/tmp grep
./bootstrap-prefix.sh $EPREFIX/tmp gawk
./bootstrap-prefix.sh $EPREFIX/tmp bash
./bootstrap-prefix.sh $EPREFIX portage
hash -r

rsync -avz rsync://rsync.jp.gentoo.org/gentoo-portage/sys-devel/binutils-apple/ ~/gentoo/usr/portage/sys-devel/binutils-apple && \
rsync -avz rsync://rsync.jp.gentoo.org/gentoo-portage/metadata/cache/sys-devel/binutils-apple-4.3 ~/gentoo/usr/portage/sys-devel/binutils-apple-4.3 && \
emerge --oneshot --nodeps bash && \
emerge --oneshot pax-utils && \
emerge --oneshot --nodeps xz-utils && \
emerge --oneshot --nodeps "<wget-1.13.4-r1" && \
emerge --oneshot --nodeps sys-apps/baselayout-prefix && \
emerge --oneshot --nodeps sys-devel/m4 && \
emerge --oneshot --nodeps sys-devel/flex && \
emerge --oneshot --nodeps sys-devel/bison && \
emerge --oneshot --nodeps sys-devel/binutils-config && \
emerge --oneshot --nodeps ">sys-devel/binutils-apple-4.2.1" && \
emerge --oneshot --nodeps sys-devel/gcc-config && \
emerge --oneshot --nodeps sys-devel/gcc-apple && \
emerge --oneshot sys-apps/coreutils && \
emerge --oneshot sys-apps/findutils && \
emerge --oneshot '<app-arch/tar-1.26-r1' && \
emerge --oneshot sys-apps/grep && \
emerge --oneshot sys-devel/patch && \
emerge --oneshot sys-apps/gawk && \
emerge --oneshot sys-devel/make && \
emerge --oneshot --nodeps sys-apps/file && \
emerge --oneshot --nodeps app-admin/eselect && \
USE=-git emerge -1 gettext && \
FEATURES="-collision-protect" emerge --oneshot sys-apps/portage && \
rm -Rf $EPREFIX/tmp/* && \
hash -r && \
emerge --sync && \
USE=-git emerge -u system && \
echo << HERE
* *** IMPORTANT ***
*
* Now, please create your $EPREFIX/etc/make.conf
* After that, call `emerge -e system' to complete installation.
* Please refer: http://www.gentoo.org/proj/en/gentoo-alt/prefix/bootstrap-macos.xml
* 
* For using prefix, startscript is recommended in document.
* $ cd $EPREFIX/usr/portage/scripts
* $ ./bootstrap-prefix.sh $EPREFIX startscript
* Then you can use `startscript' in $EPREFIX/startscript to get into prefix shell.
*
* *** END OF IMPORTANT ***
HERE