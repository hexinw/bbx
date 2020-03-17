#!/bin/bash
#
# Usage:
# Start with a MINIMAL Centos installation.
# Then run this script as root, followed by yum update.
# Periodically, re-run this script to pick up new packages.
#

set -e
set -x

# /tftpboot directory.
sudo mkdir -p /tftpboot
sudo chmod 777 /tftpboot

# Install EPEL repo
yum -y install epel-release

rpm --import https://package.perforce.com/perforce.pubkey

cat > /etc/yum.repos.d/perforce.repo <<EOF
[perforce]
name=Perforce
baseurl=http://package.perforce.com/yum/rhel/7/x86_64
enabled=1
gpgcheck=1
EOF

PACKAGES=(
  # From CentOS/EPEL
  docker
  git
  golang
  python-gflags
  python2-pip
  python-setuptools
  helix-p4d
  java-1.8.0-openjdk
  java-1.8.0-openjdk-devel
  wget
  zip
  postgresql-libs
)

yum clean expire-cache
yum -y --setopt=exclude= install "${PACKAGES[@]}"

groupadd -f docker
systemctl restart docker
systemctl enable docker
usermod -aG docker $(whoami)

# Python packages via pip
PY_PACKAGES=(
  pip
  flask
  flask_login
)

pip install --upgrade "${PY_PACKAGES[@]}"

exit 
