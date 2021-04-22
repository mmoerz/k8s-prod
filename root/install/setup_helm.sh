#!/bin/bash

HELM_VERSION=`helm version | sed -e 's/.*v\([0-9]\+\.[0-9]\+\.[0-9]\).*/\1/'`
HELM_MAJOR=`echo $HELM_VERSION | cut -f1 -d. `

echo $HELM_MAJOR
if [ "X$HELM_MAJOR" == "X3" ]; then
	echo "helm version >= 3.0 has no init anymore and doesn't need tiller !!!!"
	echo "helm is automatically initialized on use"
	exit 1 
fi

kubectl create serviceaccount tiller --namespace=kube-system

kubectl create clusterrolebinding tiller-admin --serviceaccount=kube-system:tiller --clusterrole=cluster-admin

kubectl create clusterrolebinding tiller-binding --clusterrole=cluster-admin --serviceaccount kube-system:tiller

helm init --service-account tiller --upgrade
