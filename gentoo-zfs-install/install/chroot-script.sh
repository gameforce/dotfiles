#!/bin/bash

set -e
set -x

env-update
source /etc/profile

KV=2.6.38-gentoo-r6
KVP=2.6.38-r6
# Note these are in build.sh too.

# We need layman to get our portage overlays for ZFS & Genkernel.
emerge -v layman

# Insert the layman overlay URL for the ZFS & genkernel stuff & update.
layman -o https://raw.github.com/pendor/gentoo-zfs-overlay/master/overlay.xml -f -a zfs

# Once we have an overlay active, it's safe to add layman into make.conf
echo "source /var/lib/layman/make.conf" >> /etc/make.conf

# Add portage keywords to allow installing newer versions of genkernel and dracut
mkdir -p /etc/portage/package.keywords
echo "sys-kernel/genkernel **" > /etc/portage/package.keywords/genkernel
echo "=sys-kernel/dracut-015 ~amd64" > /etc/portage/package.keywords/dracut

## FIXME: Edit the Genkernel config to set makeopts

# There's a circular dependency here...  We want to use genkernel to build
# the kernel, but the ZFS driver build doesn't work until there's a valid built
# kernel tree on the disk, and genkernel depends zfs.  We'll exclude ZFS from
# the use flags for now and just do sources/genkernel, then build a kernel
# without ZFS.  Then we'll have to build ZFS & rebuilt the initramfs.
USE="-zfs" emerge -v =sys-kernel/gentoo-sources-${KVP} =sys-kernel/genkernel-9999
genkernel --no-menuconfig all

# Unmask latest versions of spl & zfs, then build them.
echo "sys-fs/zfs **" > /etc/portage/package.keywords/zfs
echo "sys-kernel/spl **" >> /etc/portage/package.keywords/zfs
emerge -v =sys-kernel/spl-9999 =sys-fs/zfs-9999 =sys-kernel/genkernel-9999

## FIXME: Genkernel config file add zfs
# edit /etc/genkernel.conf++zfs, build again
genkernel --no-clean --no-mrproper --zfs --loglevel=5 all

# Emerge some basic system stuff.  Substitute other loggers, crons, etc. as preferred.
echo "=sys-boot/grub-1.99_rc99 **" >> /etc/portage/package.keywords/grub
emerge -v metalog vixie-cron app-misc/screen dhcpcd joe sys-block/parted \
  sys-apps/gptfdisk =sys-boot/grub-1.99_rc99

# Add services to startup. zfs and udev must be in boot for anything to work.
rc-update add zfs boot
rc-update add udev boot

# Add services as desired.
rc-update add metalog default
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
