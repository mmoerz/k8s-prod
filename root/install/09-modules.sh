#!/bin/bash

# shamelessly stolen from clr-k8s-example
# and modified to not need sudo * and some tweaks

MOD_K8S_CFG=/etc/modules-load.d/k8s.conf 

if [ -f "$MOD_K8S_CFG" ] ; then
  echo "$MOD_K8S_CFG exists already, skipping creation"
  exit 1
fi

mkdir -p /etc/modules-load.d/
cat > /etc/modules-load.d/k8s.conf <<EOT
br_netfilter
vhost_vsock
overlay
EOT
