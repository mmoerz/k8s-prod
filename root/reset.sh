#!/bin/bash

/usr/share/clr-k8s-examples/reset_stack.sh
rm -rf $HOME/.kube
rm /etc/cni/net.d/*

iptables -F
iptables -X
ip link del flannel.1
ip link del cni0
