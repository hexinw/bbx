#!/bin/bash

set -e
set -x
USER=$1
VM=${USER}-dev
sudo virt-clone --original ubuntu20.04 --name ${VM} --file /main/vms/${VM}.qcow2
sed "s/@USER@/${USER}/g" ./firstboot_base.sh > ./firstboot.sh
sudo virt-sysprep -d ${VM} --hostname ${VM} --firstboot-command ./firstboot.sh

sudo virsh start ${VM}
sudo virsh autostart ${VM}
