#!/bin/bash

mkdir -p certmanager

kubectl create namespace cert-manager
kubectl create namespace sandbox

# check for jetstack repo
JETSTACK_REPO_FOUND=`helm repo list | grep jetstack | wc -l`
if [ "X$JETSTACK_REPO_FOUND" == "X0" ]; then
	echo "adding jetstack repo"
	helm repo add jetstack https://charts.jetstack.io
fi

helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.3.1 \
  --create-namespace \
  --set installCRDs=true

echo "verifying the installation"
cat <<EOF
fetching cert-manager pod list, it should look like:

NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-5c6866597-zw7kh               1/1     Running   0          2m
cert-manager-cainjector-577f6d9fd7-tr77l   1/1     Running   0          2m
cert-manager-webhook-787858fcdb-nlzsq      1/1     Running   0          2m

EOF

SLEEPSEC=40
echo "sleeping $SLEEPSEC seconds"
sleep $SLEEPSEC

echo "**** get pods ****"
echo "kubectl get pods --namespace cert-manager"
kubectl get pods --namespace cert-manager

COMMON_NAME="Natoka NotLimited"
echo "cn: $COMMON_NAME"

# Generate a CA private key
#openssl genrsa -out ca.key 2048

# Create a self signed Certificate, valid for 10yrs with the 'signing' option set
#openssl req -x509 -new -nodes -key ca.key -subj "/CN=${COMMON_NAME}" -days 3650 -reqexts v3_req -extensions v3_ca -out ca.crt

if [ ! -f /usr/local/bin/kubectl-cert-manager ] ; then
  echo "installing kubectl plugin"
  curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/download/v1.3.0/kubectl-cert_manager-linux-amd64.tar.gz
  tar xzf kubectl-cert-manager.tar.gz
  mv kubectl-cert_manager /usr/local/bin
fi

