#!/bin/bash
#
# Usage:
# Start with an Ubuntu installation. Then run this script as root.
#

set -e
set -x

if [ "`whoami`" != "root" ] ; then
  echo "  Usage: sudo $0"
  echo
  exit -1
fi

if [ "`lsb_release -cs`" != "focal" ] ; then
  echo "  This setup script is for Ubuntu 20.04 Focal."
  echo
  exit -1
fi

USER=`who am i | awk '{print $1}'`

# Install docker
if [ ! -f "/lib/systemd/system/docker.service" ] ; then
  apt-get update -y
  apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt-get update -y
  apt-cache policy docker-ce
  apt-get install -y docker-ce
fi
groupadd -f docker
systemctl restart docker
systemctl enable docker
usermod -aG docker ${USER}

# Install openvswitch
apt-get -y install openvswitch-switch
cd /usr/bin
wget https://raw.githubusercontent.com/openvswitch/ovs/master/utilities/ovs-docker
chmod a+rwx ovs-docker

PACKAGES=(
  libgflags-dev libgtest-dev clang-10 libc++-dev
  build-essential autoconf automake libtool curl pkg-config make
  g++ unzip dh-make dh-python vim
  wget zlib1g-dev cmake git ccache libssl-dev xmlto net-tools iproute2
  iputils-ping libpkcs11-helper1
  libgflags2.2 liblzo2-2 liblzo2-dev libpam0g-dev liblz4-dev
  uml-utilities python3-pip libboost-dev cython libjsoncpp-dev
  libboost-filesystem1.71-dev libboost-filesystem1.71.0 libboost-system1.71-dev
  libboost-system1.71.0 iptables tcpdump traceroute
  libzookeeper-mt2 libzookeeper-mt-dev
)

apt-get install -y "${PACKAGES[@]}"

# Python packages via pip3
PY_PACKAGES=(
  pytest==6.1.0 grpcio-tools==1.32.0 grpcio==1.32.0 python-dateutil==2.8.1
  protobuf==3.13.0 dpath==2.0.1 swagger_py_codegen==0.4.0
  gevent==20.9.0 python-gflags==3.1.2 werkzeug==1.0.1 websocket==0.2.1
  websocket_client==0.57.0 py-dateutil==2.2 pyuwsgi==2.0.19.1 netaddr==0.8.0
  flask==1.1.2 Flask-INIConfig==0.1.0 setuptools==50.3.0
)

pip3 install "${PY_PACKAGES[@]}"

TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libgoogle-glog0_0.4.0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libgoogle-glog-dev_0.4.0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libgrpc7_1.24.0-0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libgrpc-dev_1.24.0-0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libgrpc%2B%2B1_1.24.0-0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libgrpc%2B%2B-dev_1.24.0-0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libprotobuf18_3.8.0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libprotoc18_3.8.0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/protobuf-compiler_3.8.0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libprotobuf-lite18_3.8.0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libprotobuf-dev_3.8.0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libprotoc-dev_3.8.0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/protobuf-compiler-grpc_1.24.0-0_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libcityhash_0.0.0-1_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libgperftools0_2.7_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/libgperftools-dev_2.7_amd64.deb' && \
dpkg -i "$TEMP_DEB" && \
rm -f "$TEMP_DEB" && \
TEMP_DEB="$(mktemp)" && \
wget -O "$TEMP_DEB" 'https://golang.org/dl/go1.15.2.linux-amd64.tar.gz' && \
tar -C /usr/local/ -xzf "$TEMP_DEB" && \
rm -f "$TEMP_DEB"

exit 
