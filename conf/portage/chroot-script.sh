#!/bin/bash

set -e
set -x

KV=3.14.14
KVP=3.14.14-KS.01
# Note these are in build.sh too.

# sync portage
cd /usr/portage
git checkout funtoo.org
emerge --sync

# Add portage keywords to allow installing newer versions of genkernel
echo "sys-kernel/genkernel **" >> /etc/portage/package.accept_keywords
echo "=sys-kernel/bliss-kernel-3.14.14 ~amd64" >> /etc/portage/package.accept_keywords
emerge -v =sys-kernel/bliss-kernel-${KV} sys-kernel/genkernel

# Unmask latest versions of spl & zfs, then build them.
echo "sys-fs/zfs **" > /etc/portage/package.accept_keywords
echo "sys-kernel/spl **" >> /etc/portage/package.accept_keywords
echo "sys-fs/zfs-kmod **" >> /etc/portage/package.accept_keywords
emerge -v =sys-kernel/spl-9999 =sys-fs/zfs-9999

cd /boot/kernels/${KVP}
genkernel --no-clean --no-mrproper --zfs --loglevel=5 initramfs

# Emerge some basic system stuff.  Substitute other loggers, crons, etc. as preferred.
echo "=sys-boot/grub-1.99_rc99 **" >> /etc/portage/package.accept+keywords
emerge -v rsyslog vixie-cron app-misc/screen dhcpcd vim sys-apps/gptfdisk sys-boot/grub

# Add services to startup. zfs and udev must be in boot for anything to work.
rc-update add zfs boot
rc-update add udev boot

# Add services as desired.
rc-update add rsyslog default
rc-update add vixie-cron default

## You might not want this if you're doing static IP...
rc-update add dhcpcd default
rc-update add sshd default

# Graphics settings for boot in Grub -- used for console settings by kernel.
mkdir -p /etc/default
cat >>/etc/default/grub <<EOF
GRUB_TIMEOUT=1
GRUB_DISABLE_RECOVERY=true
GRUB_GFXPAYLOAD_LINUX=1024x768x16
EOF

# Setup grub on all devices
cat /proc/mounts | grep -v rootfs > /etc/mtab
grub-mkconfig -o /boot/grub/grub.cfg
for dev in a b ; do
  grub-install /dev/sd${dev}
done

echo "The ZFS portion of things is done, and this should give a bootable system."
echo "You can emerge any additional packages and configure the system as you like"
echo "now.  When you're done, exit this shell, and we'll escape the chroot and"
echo "get ready to reboot."
echo " "
echo "DON'T FORGET TO SET YOUR ROOT PASSWORD. "
echo " "

exec /bin/bash
