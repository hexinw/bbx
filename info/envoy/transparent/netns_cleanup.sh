#!/usr/bin/env bash
#
# Cleanup network namespace after testing Envoy original_dst cluster
#

NETNS=$1

# delete veth pair
#ip link del "$NETNS-veth0" type veth peer name "$NETNS-veth1"
ip link del "$NETNS-veth0" type veth 

# delete network namespace
ip netns delete "$NETNS"
