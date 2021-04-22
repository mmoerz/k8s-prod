#!/bin/bash

TZ=`timedatectl | grep -i 'Europe/Vienna'`
if [ "X$TZ" == "X" ] ; then
  echo "setting timezone"
  timedatectl set-timezone Europe/Vienna
  echo "most likely this needs a reboot - many ***nono***THNKS to systemd ..."
fi

# oh yes, tallow ...
systemctl mask tallow.service

echo "installing prerequisites"

swupd update
# cloud-control is necessary for docker
# vim is my editor of choice (choose your own there)
# jq is a nice to have admin tool
swupd bundle-add cloud-native-basic cloud-control git jq vim


# stop docker, containerd
systemctl stop docker
systemctl stop containerd

# enable kublet service
systemctl enable kubelet.service
systemctl enable --now crio.service
systemctl start crio.service

# enable docker ??
systemctl disable docker
systemctl disalbe containerd

# turn on ip_forward
mkdir -p /etc/sysctl.d/

tee /etc/sysctl.d/99-kubernetes-cri.conf > /dev/null <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sysctl --system

# add hostname to /etc/hosts
#HOSTNAME=`hostname`
#if [ ! -e /etc/hosts ] ; then
#  echo "127.0.0.1 localhost $HOSTNAME" | sudo tee /etc/hosts
#else
#  CONTAINS=`grep -i $HOSTNAME /etc/hosts`
#  if [ "X$CONTAINS" == "X" ] ; then
#    echo "127.0.0.1 localhost $HOSTNAME" | sudo tee --append /etc/hosts
#  fi
#fi

# finally prepare for kubernetes
#/usr/share/clr-k8s-examples/setup_system.sh
