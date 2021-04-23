#!/bin/bash

# test contents from cert-manager.io

CERTDIR=/root/install/cert-manager

if [ ! -f "${CERTDIR}/test-resources.yaml" ] ; then
  echo "${CERTDIR}/test-resources.yaml" is missing
  exit 1
fi
kubectl apply -f $CERTDIR/test-resources.yaml
echo "sleeping 10"
sleep 10
kubectl describe certificate -n cert-manager-test
kubectl delete -f $CERTDIR/test-resources.yaml

echo "FINISHED: now setup your first issuer!"

