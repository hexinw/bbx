#!/bin/bash

set -e
set -x

if [ "`whoami`" != "root" ] ; then
  echo "  Usage: sudo $0"
  echo
  exit -1
fi

apt install -y zfsutils-linux

# Create storage pool
fdisk -l

# Create a RAIDz1 pool.
zpool create main-pool raidz1 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde
zpool create data-pool raidz1 /dev/sdf /dev/sdg /dev/sdh

zpool status

# Add another drive.
zpool add pool-name /dev/sdx

zfs create main-pool/root
zfs create main-pool/tmp
zfs create main-pool/boot
zfs create main-pool/var/tmp
zfs create main-pool/var/log
zfs create main-pool/home
zfs create data-pool/data

zfs set mountpoint=/tmp main-pool/tmp
zfs set mountpoint=/boot main-pool/boot
zfs set mountpoint=/home main-pool/home
zfs set mountpoint=/var/tmp main-pool/var/tmp
zfs set mountpoint=/var/log main-pool/var/log
zfs set mountpoint=/ main-pool/root
zfs set mountpoint=/data data-pool/data
