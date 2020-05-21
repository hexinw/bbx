#!/bin/bash
#set -x

if [ "`whoami`" != "root" ] ; then
  echo "  Usage: sudo $0"
  echo 
  exit -1
fi

USER=`who am i | awk '{print $1}'`

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt-cache policy docker-ce
apt install -y docker-ce
groupadd -f docker
systemctl restart docker
systemctl enable docker
usermod -aG docker ${USER}

# Install openvswitch
apt-get -y install openvswitch-switch
cd /usr/bin
wget https://raw.githubusercontent.com/openvswitch/ovs/master/utilities/ovs-docker
chmod a+rwx ovs-docker
