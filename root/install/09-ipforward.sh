#!/bin/bash

# shamelessly stolen from clr-k8s-example
# and modified to not need sudo * and some tweaks

mkdir -p /etc/sysctl.d/
tee /etc/sysctl.d/99-kubernetes-cri.conf > /dev/null <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sysctl --system
