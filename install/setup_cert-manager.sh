#!/bin/bash

mkdir -p certmanager

kubectl create namespace cert-manager

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

echo "sleeping 10 seconds"
sleep 10

echo "**** get pods ****"
echo "kubectl get pods --namespace cert-manager"
kubectl get pods --namespace cert-manager

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
COMMON_NAME="Natoka NotLimited"
echo "cn: $COMMON_NAME"

# Generate a CA private key
#openssl genrsa -out ca.key 2048

# Create a self signed Certificate, valid for 10yrs with the 'signing' option set
#openssl req -x509 -new -nodes -key ca.key -subj "/CN=${COMMON_NAME}" -days 3650 -reqexts v3_req -extensions v3_ca -out ca.crt

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

echo "installing kubectl plugin"
curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/download/v1.3.0/kubectl-cert_manager-linux-amd64.tar.gz
tar xzf kubectl-cert-manager.tar.gz
mv kubectl-cert_manager /usr/local/bin

