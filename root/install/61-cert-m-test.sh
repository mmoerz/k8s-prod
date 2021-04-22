#!/bin/bash

# test contents from cert-manager.io

cat > certmanager/test-resources.yaml <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager-test
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: test-selfsigned
  namespace: cert-manager-test
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: selfsigned-cert
  namespace: cert-manager-test
spec:
  dnsNames:
    - example.com
  secretName: selfsigned-cert-tls
  issuerRef:
    name: test-selfsigned
EOF
kubectl apply -f certmanager/test-resources.yaml
echo "sleeping 10"
sleep 10
kubectl describe certificate -n cert-manager-test
kubectl delete -f certmanager/test-resources.yaml

echo "FINISHED: now setup your first issuer!"

