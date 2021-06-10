# Run dynamic_proxy.yaml

## Start envoy container
docker run --rm -it --user=0:0 --cap-add=NET_ADMIN --network host -p 10000:10000 -p 9901:9901 -v ${PWD}/dynamic_proxy.yaml:/etc/service-envoy.yaml:ro -v ${PWD}/start_envoy.sh:/start_envoy.sh --entrypoint=/start_envoy.sh envoyproxy/envoy:v1.18-latest

## Test
## Setup namespace for testing.
sudo ./netns_setup.sh ns1
sudo ip netns exec ns1 curl -v 173.194.222.106:80

## Cleanup
sudo ./netns_cleanup.sh ns1



# Run proxy_basic.yaml
docker run --rm -it --user=0:0 --cap-add=NET_ADMIN --network host -p 10000:10000 -p 9901:9901 -v ${PWD}/proxy_basic.yaml:/etc/service-envoy.yaml:ro -v ${PWD}/start_envoy.sh:/start_envoy.sh --entrypoint=/start_envoy.sh envoyproxy/envoy:v1.18-latest

## Test
### Envoy connects to www.yahoo.com in plaintext.
curl --header "X-Host-Port: www.yahoo.com" http://127.0.0.1:10000
### Envoy connects to www.yahoo.com in TLS.
curl --header "X-Host-Port: www.yahoo.com:443" http://127.0.0.1:10000



# Run proxy_connect.yaml (CONNECT)
docker run --rm -it --user=0:0 --cap-add=NET_ADMIN --network host -p 80:80 -p 443:443 -p 9901:9901 -v ${PWD}/proxy_connect.yaml:/etc/service-envoy.yaml:ro -v ${PWD}/start_envoy.sh:/start_envoy.sh -v ${PWD}/server.key:/etc/certs/server.key:ro -v ${PWD}/server.cert:/etc/certs/server.cert:ro --entrypoint=/start_envoy.sh envoyproxy/envoy:v1.18-latest

## Test
## curl will do a CONNECT by itself when connecting to a TLS server through a HTTP proxy
curl -v -x "http://127.0.0.1:80" "https://www.google.com"
curl -v -x "http://10.1.10.9:80" "https://httpbin.org/ip"
curl -v --proxy-cacert ./ca.cert -x "https://127.0.0.1:443" "https://www.google.com"
curl -v --proxy-cacert ./ca.cert -x "https://10.1.10.9:443" "https://httpbin.org/ip"
