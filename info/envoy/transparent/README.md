# Run

## Start envoy container
docker run --rm -it --user=0:0 --cap-add=NET_ADMIN --network host -p 4999:4999 -p 19000:19000 -v ${PWD}/transparent_proxy.yaml:/etc/service-envoy.yaml:ro -v ${PWD}/start_envoy.sh:/start_envoy.sh --entrypoint=/start_envoy.sh envoyproxy/envoy:v1.18.3

## Setup iptables TPROXY rule.
./create_iptables.sh

## Test
## Setup namespace for testing.
sudo ./netns_setup.sh ns1
sudo ip netns exec ns1 curl -v 173.194.222.106:80

## Cleanup
sudo ./netns_cleanup.sh ns1
./clean_iptables.sh
