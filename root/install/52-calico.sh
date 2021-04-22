#!/bin/bash

CALICO_VER=3.18.1
CALICO_VER=latest
CALICO_URL="https://docs.projectcalico.org/archive/v${CALICO_VER}/manifests"
[ "X$CALICO_VER" == "Xlatest" ] && \
  CALICO_URL="https://docs.projectcalico.org/manifests"
CALICO_DIR="/root/0-calico"

FULLPATH="${CALICO_DIR}/overlays/${CALICO_VER}/calico"
mkdir -p "${FULLPATH}"
if [ ! -f "${FULLPATH}/calico.yaml" ]; then
  curl -o "${FULLPATH}/calico.yaml" "$CALICO_URL/calico.yaml"
  echo curl -o "${FULLPATH}/calico.yaml" "$CALICO_URL/calico.yaml"
fi

#curl https://docs.projectcalico.org/manifests/calico.yaml -O
  
#kubectl apply -f calico.yaml
kubectl apply -k "${CALICO_DIR}/overlays/${CALICO_VER}" 
#--validate=false

OUT=kubectl-calico
if [ ! -f /usr/local/bin/$OUT ] ; then
  cd /usr/local/bin
  #curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/v3.18.1/calicoctl

  # install as kubectl plugin
  curl -o $OUT -L  https://github.com/projectcalico/calicoctl/releases/download/v3.18.1/calicoctl

  chown root:root $OUT
  chmod u+x $OUT
fi
