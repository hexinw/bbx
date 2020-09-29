#!/bin/bash
set -x
# wg genkey | tee privatekey | wg pubkey > publickey
sudo ip link add dev wg0 type wireguard
sudo ip address add dev wg0 192.168.2.1/24
#sudo wg set wg0 listen-port 2020 private-key /var/tmp/private.key peer Vmx4RJsW82FowvE2f0AaU1VqmSyHKp0RXAs6XEIl5Rs= allowed-ips 192.168.2.0/24 endpoint 44.224.132.155:2020 persistent-keepalive 10
sudo wg set wg0 listen-port 2020 private-key /var/tmp/private.key peer P00acBf0F+SlOlI70i/tARNWSI8M9HAx/O+1QdE+nkc= allowed-ips 0.0.0.0/0 endpoint 35.161.4.192:2020
sudo ip link set up dev wg0

# Ensure ssh session is bypassing the wg tunnel. '192.168.7.1' is the 'eth0'
# default gateway.
sudo ip route add 104.36.248.13 via 192.168.7.1 dev eth0
sudo ip route add 0.0.0.0/1 dev wg0
sudo ip route add 128.0.0.0/1 dev wg0
# Ensure peer is reachable through 'eth0'.
sudo ip route add 35.161.4.192/32 via 192.168.7.1 dev eth0
