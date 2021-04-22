#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps

# default simple install
#helm install kubeapps --namespace kubeapps bitnami/kubeapps

# this is an install with oauth provider
# ok google does not work here - thx to no 'groups' (google doesn't provide them via oidc)
#helm install kubeapps bitnami/kubeapps \
#  --namespace kubeapps \
#  --set authProxy.enabled=true \
#  --set authProxy.provider=oidc \
#  --set authProxy.clientID=819231698249-hoebp5m25g0uaecqcj3ioviemou8ok55.apps.googleusercontent.com \
#  --set authProxy.clientSecret=LEI-OP58tC4sE5-Sm4ODzya6 \
#  --set authProxy.cookieSecret=$(echo "ich-nicht-Lange-48235" | base64) \
#  --set authProxy.additionalFlags="{--cookie-secure=false,--oidc-issuer-url=https://accounts.google.com}"

helm install kubeapps bitnami/kubeapps \
  --namespace kubeapps \
  --set authProxy.enabled=true \
  --set authProxy.provider=google \
  --set authProxy.clientID=819231698249-hoebp5m25g0uaecqcj3ioviemou8ok55.apps.googleusercontent.com \
  --set authProxy.clientSecret=LEI-OP58tC4sE5-Sm4ODzya6 \
  --set authProxy.cookieSecret=$(echo "ich-nicht-Lange-48235" | base64) \
  --set authProxy.additionalFlags="{--cookie-secure=false}"
