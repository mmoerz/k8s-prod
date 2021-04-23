#!/bin/bash

CERTDIR=/root/install/cert-manager

kubectl apply -f ${CERTDIR}/selfsignedCA.yaml

cat << EOF
***************** ATTENTION ***************
you need to manually edit the config map
kubectl -n kube-system edit cm kubelet-config-1.19
EOF

CFG_OK=`grep serverTLSBootstrap /var/lib/kubelet/config.yaml | wc -l`
if [ $CFG_OK == "1" ] ; then
  echo "kubelet cfg /var/lib/kubelet/config.yaml has serverTLSBootstrap"
else
  echo "kubelet cfg /var/lib/kubelet/config.yaml lacks serverTLSBootstrap"
fi
