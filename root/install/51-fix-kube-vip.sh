#!/bin/bash

KV_DIR=/root/kube-vip/

[ ! -d "${KV_DIR}" ] && mkdir "${KV_DIR}"
[ -f /etc/kubernetes/manifests/kube-vip-rbac.yaml ] && \
  mv /etc/kubernetes/manifests/kube-vip-rbac.yaml "${KV_DIR}/."
kubectl apply -f "${KV_DIR}/kube-vip-rbac.yaml"
