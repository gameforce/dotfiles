#!/bin/bash

# Copy this script to the funtoo livecd environment.  You must
# have an HTTP server setup which provides access to the stage3, portage snapshot and chroot-script.sh.
#
# Call this script with the base URL of this server as the only
# parameter.  IE:
#   ./build.sh http://192.168.42.42/~user/zfs
#
#
# Layout of this script:
#
# This script loads the zfs driver, partitions disks, and creates 
# the zpool.  It downloads the initial stage files & portage snapshots 
# and untars them into what will be the chroot environment.  Finally 
# it copies chroot-script.sh into the chroot, chroot's, and executes 
# that script.
#
# chroot-script.sh does most of the funtoo install work of emerging
# packages, emerging the kernel etc.  Once most of the setup work
# is done, chroot-script.sh will drop to a shell inside the chroot
# and give you an opportunity emerge any addititonal packages or
# do anything else you might need to do in the chroot.  
#
# You should at this point SET YOUR ROOT PASSWORD! =)

# When you exit that shell, chroot-script.sh will exit, and 
# you'll be returned to the final part of this build.sh.  
# At that point, this script will umount filesystems and 
# prepare the system to reboot.  You will be dropped back to 
# your shell one more time, and you'll have a chance to make 
# any final adjustments.  Reboot, remove your install media 
# from the system, and with any luck you'll end up in your
# shiny new ZFS root Funtoo system.

set -e
set -x

URL=$1
STAGE3=stage3-latest.tar.xz
SNAPSHOT=portage-latest.tar.xz

# Kernel version we want, KV for initramfs,
# KVP with just the version for portage.
KV=3.14.14
KVP=3.14.14-KS.02
# Note: these are in chroot-script.sh too.

# Keep the lights from going out while we're watching...
setterm -blank 0 -powersave off -powerdown 0 || /bin/true

## This next chunk is just trying to clean up from previous runs of
## this script in case we're re-running it.

#swapoff /dev/zvol/rpool/swap || true
umount -f /mnt/funtoo/boot || true
umount -fl /mnt/funtoo/dev || true
umount -f /mnt/funtoo/proc || true
zfs umount -a || /bin/true
umount -f /mnt/funtoo || /bin/true

sleep 1

# Try to import the pool if it wasn't, then destroy it.
zpool import -f -N rpool || /bin/true
zpool destroy rpool || /bin/true
sleep 1

## End of cleanup.

# Loop over the four drives we're using
for f in a b ; do
  ## EDIT ME:
  ## Make up some partitions.  We do 64M for grub, and the rest for ZFS.
  sgdisk --zap-all /dev/sd${f}
  sgdisk \
    --new=1:2048:133120 --typecode=1:EF02 --change-name=1:"grub" \
    --largest-new=2 --typecode=2:BF01 --change-name=2:"zfs" \
    /dev/sd${f}
done

## 
## This is where the real ZFS stuff begins.  
## If you're taking notes, start now...
##

# Create the pool.  We're doing mirror on two SCSI disks.  Adjust
# as needed.  We need to umount the new pool right after so we can
# change the mount point & options
zpool create -f -o ashift=12 -o cachefile= -O compression=on -m none rpool mirror sda2 sdb2
#zfs umount rpool

# Set the mount point of the new pool to root and mark it NOT mountable.
# We'll actually mount a different dataset as root
zfs set mountpoint=/mnt/funtoo rpool
zfs set canmount=off rpool

# Create a dataset for the filesystem root and set its mountpoint
# so it won't get automounted.  Initrd will do it instead.
zfs create rpool/ROOT
zfs set mountpoint=legacy rpool/ROOT

## If you're *not* using RAID-Z, you can set bootfs here, and you
## won't be need to pass a root=... param to grub.  You can't boot
## off RAID-Z (only mirror), so zpool won't let you set this for a 
## RAID-Z pool.
zpool set bootfs=rpool/ROOT rpool

# Now mount the rootfs in the usual place for the chroot.
mount -t zfs rpool/ROOT /mnt/funtoo

# Create some datasets to keep things organized.  You can break this up
# as you like, but you must have /bin, /sbin, /etc, /dev, /lib* all inside
# rpool/ROOT.
zfs create rpool/home
zfs create rpool/usr
zfs create rpool/usr/local
zfs create rpool/usr/portage
zfs create rpool/usr/src
zfs create rpool/var
zfs create rpool/var/log

# create a 4G swap space; adjust as needed
zfs create -o sync=always -o primarycache=metadata -o secondarycache=none -o volblocksize=4K -V 4G rpool/swap
sleep 2
mkswap -f /dev/zvol/rpool/swap
swapon /dev/zvol/rpool/swap

# Copy over zpool cache.  If you skip this, you'll have to play some games in
# Dracut's emergency holographic shell to get it fixed.
mkdir -p /mnt/funtoo/etc/zfs
cp /etc/zfs/zpool.cache /mnt/funtoo/etc/zfs/zpool.cache

# Download the stage & snapshot we'll be using.
cd /mnt/funtoo
wget ${URL}/dist/${STAGE3}
wget ${URL}/dist/${SNAPSHOT}
wget ${URL}/install/chroot-script.sh

# Un-tar the stage & portage snapshot.
## NOTE: If your install locks up at this point, you probably need to limit
## your l2arc size (see the top of this script).
tar -xvpf ${STAGE3}
tar -xvf ${SNAPSHOT} -C /mnt/funtoo/usr

# Need our DNS servers
cp -L /etc/resolv.conf /mnt/funtoo/etc/

# Bind over pseudo-filesystems
mount -t proc none /mnt/funtoo/proc
mount --rbind /dev /mnt/funtoo/dev

## Write some settings out to make.conf in the chroot.
## We set some minimal USE flags, enable ZFS in Dracut, and use our
## favorite local mirrors (you should change these).  You'll probably
## also want to adjust your make opts based on how many CPU's you have.
cat >> /mnt/funtoo/etc/make.conf <<EOF

USE="mmx sse sse2 sse3 ssl zfs zsh-completion bash-completion vim-syntax git -ipv6 -dso lzma curl wget"

MAKEOPTS="-j3"

SYNC="https://github.com/funtoo/ports-2012.git"

EOF

# Setup /etc/fstab in the chroot with our boot, and a legacy entry for root.
cat > /mnt/funtoo/etc/fstab <<FSTAB
rpool/ROOT              /               zfs             noatime         0 0
/dev/cdrom              /mnt/cdrom      auto            noauto,ro       0 0
FSTAB

echo "Entering chroot now..."
chmod +x /mnt/funtoo/chroot-script.sh
chroot /mnt/funtoo /chroot-script.sh
## Should wait here until we exit the chroot

## Time Passes...

## Should be back outside chroot now.
echo "We're back from chroot.  Getting system ready to reboot."

cd
zfs umount -a
zfs set mountpoint=/ rpool
umount -l /mnt/funtoo/dev{/shm,/pts,}
umount -l /mnt/funtoo{/proc,}
zpool export rpool

echo "It should be safe to remove the installation CD and reboot now."
echo "You might want to check the output of 'mount' and 'zfs mount'. "
echo "Note that you *may* need to boot with the 'zfs_force=1' parameter"
echo "to grub for your first boot in the event your hostid is different"
echo "in the live system than it was for the livecd."
echo " "
echo "Reboot when you're ready.  Don't forget to remove the installcd."
