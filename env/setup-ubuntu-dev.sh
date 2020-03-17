#!/bin/bash
#
# Usage:
# Start with an Ubuntu installation. Then run this script as root.
#

set -e
set -x

# Python packages via pip
PY_PACKAGES=(
  cassandra-driver
  mock
  pytest
  python-gflags
  tenacity
)

pip install --upgrade "${PY_PACKAGES[@]}"

PACKAGES=(
   sudo add-apt-repository ppa:jonathonf/vim
   sudo apt update
   sudo apt install vim
   sudo apt-get install -y software-properties-common
   sudo add-apt-repository ppa:ubuntu-toolchain-r/test
   sudo apt update
   sudo apt install g++-7 -y
   sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7
   gcc --version
   g++ --version
   ls -la /usr/bin/ | grep -oP "[\S]*(gcc|g\+\+)(-[a-z]+)*[\s]" | xargs sudo bash -c 'for link in ${@:1}; do ln -s -f "/usr/bin/${link}-${0}" "/usr/bin/${link}"; done' 7
   sudo apt-get install libboost-all-dev
)



exit 
