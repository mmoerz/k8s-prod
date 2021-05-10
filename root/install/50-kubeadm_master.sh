#!/bin/bash

if [ "X$VIP" == "X" ] ; then
  echo 'environment variable $VIP not set'
  exit 1
fi
if [ "X$VPORT" == "X" ] ; then
  echo 'environment variable $VPORT not set'
  exit 1
fi

# example was 1.19.0
VERSION="${K8S_VERSION:-1.19.7}"
CFGFILE="${K8S_CFGFILE:-/root/kubeadm.yaml}"

sed -i -e "s/\(kubernetesVersion: v\)[0-9\.]\+/\1$VERSION/" $CFGFILE
sed -i -e "s/\(controlPlaneEndpoint: \"\)[a-zA-Z0-9_:\.\-]\+\"/\1$VIP:$VPORT\"/" $CFGFILE

# config is needed for cgroup=systemd configuration
# otherwise kubelet fails to start the pods
sudo kubeadm init \
    --upload-certs \
    --config=$CFGFILE

# copy admin configuration
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# untaint node for - remove restriction on control plane master
kubectl taint nodes --all node-role.kubernetes.io/master-

