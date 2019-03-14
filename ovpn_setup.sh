# Executable transcript of https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-16-04

set -x

sudo apt update
sudo apt install -y openvpn easy-rsa python
make-cadir ~/openvpn-ca
cd ~/openvpn-ca
cat <<EOT >> vars
# New values
export KEY_COUNTRY="US"
export KEY_PROVINCE="CA"
export KEY_CITY="SanFrancisco"
export KEY_ORG="Some Organization"
export KEY_EMAIL="some@email"
export KEY_OU="Some OU"
export KEY_NAME="server"
EOT
source vars
./clean-all

# ------ Create Server CA and key ------
# Same as ./build-ca, but noninteractive
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --initca

# ./build-key-server server, noninteractive
"$EASY_RSA/pkitool" --server server

./build-dh
openvpn --genkey --secret keys/ta.key

# ------ Create client key -----
# ./build-key client1
# (If need to password-protect, use build-key-pass)
"$EASY_RSA/pkitool" client1

# ----- Configure OpenVPN server -----
cd ~/openvpn-ca/keys
sudo cp ca.crt ca.key server.crt server.key ta.key dh2048.pem /etc/openvpn

# Sample config:
# gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz | sudo tee /etc/openvpn/server.conf
cat <<EOT | sudo tee /etc/openvpn/server.conf
port 443
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key  # This file should be kept secret
dh dh2048.pem
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DNS 208.67.220.220"
keepalive 10 120
tls-auth ta.key 0 # This file is secret
key-direction 0
cipher AES-128-CBC   # AES
auth SHA256
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
EOT

# Enable IP forwarding
sudo sed -i '/^#.*net.ipv4.ip_forward/s/^#//' /etc/sysctl.conf
sudo sysctl -p

# Default device:
DEV=`ip route | grep default | python -c 'v=raw_input().split();print(v[v.index("dev")+1])'`

# Set up NAT for VPN connections
{ sudo cat - /etc/ufw/before.rules > newrules && sudo mv newrules /etc/ufw/before.rules; } <<EOT
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0] 
# Allow traffic from OpenVPN client to eth0
-A POSTROUTING -s 10.8.0.0/8 -o $DEV -j MASQUERADE
COMMIT
# END OPENVPN RULES
EOT
sudo chmod 640 /etc/ufw/before.rules
sudo chown root.root /etc/ufw/before.rules

sudo sed -i '/DEFAULT_FORWARD_POLICY=/s/DROP/ACCEPT/' /etc/default/ufw

sudo ufw allow https
sudo ufw allow OpenSSH
sudo ufw disable
sudo ufw -f enable

# Run OpenVPN
sudo systemctl start openvpn@server
ip addr show tun0

# Enable on startup
sudo systemctl enable openvpn@server

# ------------- Infrastructure for managing client-configs ------------------- #
mkdir -p ~/client-configs/files
chmod 700 ~/client-configs/files
# Sample client config:
# cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/client-configs/base.conf

MYIP=`curl ipinfo.io/ip`
cat <<EOT > ~/client-configs/base.conf
client
dev tun
proto tcp
remote $MYIP 443
resolv-retry infinite
nobind
remote-cert-tls server
cipher AES-128-CBC
auth SHA256
key-direction 1
comp-lzo
verb 3
persist-key
persist-tun
;user nobody
;group nogroup
# ca ca.crt
# cert client.crt
# key client.key
# For Linux users
# script-security 2
# up /etc/openvpn/update-resolv-conf
# down /etc/openvpn/update-resolv-conf
EOT

cat <<EOT > ~/client-configs/make_config.sh
#!/bin/bash
# First argument: Client identifier
KEY_DIR=~/openvpn-ca/keys
OUTPUT_DIR=~/client-configs/files
BASE_CONFIG=~/client-configs/base.conf
cat \${BASE_CONFIG} \\
    <(echo -e '<ca>') \\
    \${KEY_DIR}/ca.crt \\
    <(echo -e '</ca>\n<cert>') \\
    \${KEY_DIR}/\${1}.crt \\
    <(echo -e '</cert>\n<key>') \\
    \${KEY_DIR}/\${1}.key \\
    <(echo -e '</key>\n<tls-auth>') \\
    \${KEY_DIR}/ta.key \\
    <(echo -e '</tls-auth>') \\
    > \${OUTPUT_DIR}/\${1}.ovpn
EOT
chmod 700 ~/client-configs/make_config.sh
~/client-configs/make_config.sh client1
# This is the client connection file now
ls ~/client-configs/files/client1.ovpn
