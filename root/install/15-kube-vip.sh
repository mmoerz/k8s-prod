#!/bin/bash

curl -s https://kube-vip.io/manifests/rbac.yaml > \
  /etc/kubernetes/manifests/kube-vip-rbac.yaml

export VIP=10.10.96.1
export VPORT=6443
export INTERFACE=enp0s25

echo "pulling docker image using crio"
crictl pull docker.io/plndr/kube-vip:0.3.2

#alias kube-vip="runc run plndr/kube-vip:0.3.2"
KV="runc run plndr/kube-vip:0.3.2"
#alias kube-vip="ctr run --rm --net-host docker.io/plndr/kube-vip:0.3.2 vip /kube-vip"
KV="ctr run --rm --net-host docker.io/plndr/kube-vip:0.3.2 vip /kube-vip"

systemctl start containerd
ctr images pull docker.io/plndr/kube-vip:0.3.2
# now create the config file for the first master node
if [ "$HOSTNAME" == "kube1" ] ; then
  $KV manifest pod \
    --interface $INTERFACE \
    --vip $VIP \
    --controlplane \
    --services \
    --arp \
    --leaderElection | tee  /etc/kubernetes/manifests/kube-vip.yaml
else
  echo "not the first node skipping kube-vip.yaml generation"
fi
ctr images remove docker.io/plndr/kube-vip:0.3.2
systemctl stop containerd
