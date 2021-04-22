#!/bin/bash

# shamelessly stolen from clr-k8s-example
# and modified to not need sudo * and some tweaks

mkdir -p /etc/modules-load.d/
cat > /etc/modules-load.d/k8s.conf <<EOT
br_netfilter
vhost_vsock
overlay
EOT
