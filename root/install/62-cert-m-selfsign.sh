#!/bin/bash

cat > certmanager/selfsignedCA.yaml <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: natoka-ca
  namespace: sandbox
spec:
  isCA: true
  commonName: natoka-system
  secretName: natoka-ca
  issuerRef:
    name: selfsigned-issuer
    kind: ClusterIssuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: natoka-ca
  namespace: sandbox
spec:
  ca:
    secretName: natoka-ca
EOF

kubectl apply -f certmanager/selfsignedCA.yaml


