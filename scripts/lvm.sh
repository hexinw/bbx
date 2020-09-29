#!/bin/bash

set -e
set -x

if [ "`whoami`" != "root" ] ; then
  echo "  Usage: sudo $0 <disk>"
  echo
  exit -1
fi

if [ $# -lt 2 ] ; then
  echo "  Usage: sudo $0 <disk>"
  echo
  exit -1
fi

DISK=$1

modprobe dm_mod

# Partition disk
logger -t lvm.sh partitioning ${DISK}
parted -s /dev/${DISK} -- mklabel msdos
parted -s /dev/${DISK} -- mkpart primary 0 100%
parted -s /dev/${DISK} -- set 1 lvm on
logger -t lvm.sh partitioning ${DISK} complete

# Provision file system
pvcreate -ff -y /dev/${DISK}1
logger -t lvm.sh "created LVM physical volume on ${DISK}1"
vgcreate vg_core /dev/${DISK}1
logger -t lvm.sh "created LVM volume group (vg_core) on ${DISK}1"
lvcreate -L 4G -n tmp vg_core
logger -t lvm.sh "created logical volume (tmp) on vg_core"
lvcreate -L 8G -n home vg_core
logger -t lvm.sh "created logical volume (home) on vg_core"
lvcreate -L 4G -n var vg_core
logger -t lvm.sh "created logical volume (var) on vg_core"
lvcreate -L 10G -n logaudit vg_core
logger -t lvm.sh "created logical volume (logaudit) on vg_core"
lvcreate -L 30G -n varlog vg_core
logger -t lvm.sh "created logical volume (varlog) on vg_core"
mkfs.ext4 -q -L tmp /dev/vg_core/tmp
logger -t lvm.sh "created filesystem on tmp (vg_core)"
mkfs.ext4 -q -L home /dev/vg_core/home
logger -t lvm.sh "created filesystem on home (vg_core)"
mkfs.ext4 -q -L var /dev/vg_core/var
logger -t lvm.sh "created filesystem on var (vg_core)"
mkfs.ext4 -q -L logaudit /dev/vg_core/logaudit
logger -t lvm.sh "created filesystem on logaudit (vg_core)"
mkfs.ext4 -q -L varlog /dev/vg_core/varlog
logger -t lvm.sh "created filesystem on varlog (vg_core)"

# Create directory structure
logger -t lvm.sh creating base file structure
mkdir /target
mount /dev/vg_system/root /target
mkdir /target/home
mount /dev/vg_core/home /target/home
mkdir /target/var
mount /dev/vg_core/var /target/var
mkdir /target/var/log
mount /dev/vg_core/varlog /target/var/log
mkdir /target/var/log/audit
mount /dev/vg_core/logaudit /target/var/log/audit 
mkdir /target/tmp
mount /dev/vg_core/tmp /target/tmp
mkdir /target/boot
mount /dev/sda1 /target/boot

# Create fstab
logger -t lvm.sh creating fstab
mkdir /target/etc 
echo "# /etc/fstab: static file system information." > /target/etc/fstab
echo "#" >> /target/etc/fstab  
echo "# <file system>   <mount point>   <type>   <options>       <dump> <pass>" >> /target/etc/fstab
echo "LABEL=root     /       ext4 defaults,noatime                     0  0" >> /target/etc/fstab 
echo "LABEL=home     /home   ext4 defaults,nodev                       0  2" >> /target/etc/fstab 
echo "LABEL=var      /var    ext4 defaults,noatime                    0  2" >> /target/etc/fstab 
echo "LABEL=varlog   /var/log  ext4 defaults                    0  2" >> /target/etc/fstab
echo "LABEL=logaudit /var/log/audit  ext4 defaults,noatime                    0  2" >> /target/etc/fstab
echo "LABEL=tmp      /tmp    ext4 defaults,nodev,noexec,nosuid  0  2" >> /target/etc/fstab  
echo "LABEL=boot     /boot   ext2 defaults,nodev,noexec       0  2" >> /target/etc/fstab 
echo "proc           /proc   proc defaults                    0  0" >> /target/etc/fstab
   
;;
 
destroy)
logger -t lvm.sh Destroying existing volumes
umount /target/var/log/audit
umount /target/var/log
umount /target/var
umount /target/home
umount /target/tmp
umount /target/boot
umount /target
# swapoff /dev/vg0/swap
pvremove -ff -y /dev/sda2
pvremove -ff -y /dev/sdb1

;;
 
*)
 echo $0: This script is destructive and should only be run as part of the debian-installer process
;;

esac
