#!/bin/bash

export METALLB_VERSION=v0.9.6

if [ ! -d metallb; ] then
	mkdir -p ~/metallb
	cd ~/metallb
	wget https://raw.githubusercontent.com/google/metallb/${METALLB_VERSION}/manifests/metallb.yaml;
	
	cat > metallb/config.yaml <<EOF
# file: ~/metallb/config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 10.10.100.200-10.10.100.250
EOF


kubectl apply -f metallb/metallb.yaml

echo kubectl apply -f metallb/config.yaml

