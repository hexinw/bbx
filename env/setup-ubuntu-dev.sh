#!/bin/bash
#
# Usage:
# Start with an Ubuntu installation. Then run this script as root.
#

set -e
#set -x

if [ "`whoami`" != "root" ] ; then
  echo "  Usage: sudo $0"
  echo
  exit -1
fi

# Python packages via pip
PY_PACKAGES=(
  dpath==1.5.0
  gevent==1.2.2
  grpcio-tools==1.26.0
  python-dateutil==2.8.1
  protobuf==3.11.2
  mock
  pytest
  python-gflags
  setuptools
  swagger_py_codegen
  tenacity
  websocket
  websocket-client==0.53.0
  Werkzeug
)

pip install --upgrade "${PY_PACKAGES[@]}"

PACKAGES=(
  libgflags-dev
  libgtest-dev
  clang-5.0
  libc++-dev
  build-essential
  autoconf
  automake
  libtool
  curl
  pkg-config
  make
  g++
  unzip
  python-minimal
  python-pip
  dh-make
  dh-python
  vim
  wget
  zlib1g-dev
  cmake
  ccache
  git
  libssl-dev
  xmlto
  net-tools
  iproute2
  libgflags2.2
  liblzo2-2
  liblzo2-dev
  libpam0g-dev
  liblz4-dev
  uml-utilities
  libboost-dev
  cython
  libjsoncpp-dev
  libboost-filesystem1.65-dev
  libboost-filesystem1.65.1
  libboost-system1.65-dev
  libboost-system1.65.1
)

apt-get update -y
apt-get install -y "${PACKAGES[@]}"

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
wget -O "$TEMP_DEB" 'https://github.com/hexinw/pkgs/raw/master/grpcio-1.24.0.linux-x86_64.tar.gz' && \
tar -xzvf "$TEMP_DEB" -C / && \
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
rm -f "$TEMP_DEB"

exit 
