#!/bin/bash

set -e
set -x

useradd -s /bin/bash -d /home/@USER@/ -m -G sudo @USER@
echo @USER@:@USER@ | chpasswd

dpkg-reconfigure openssh-server
systemctl restart ssh

ip route replace default via 10.1.10.6 dev enp1s0 proto dhcp metric 100
