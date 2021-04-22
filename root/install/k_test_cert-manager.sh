#!/bin/bash

kubectl apply -f test-resources.yaml
sleep 10
kubectl describe certificate -n cert-manager-test
kubectl delete -f test-resources.yaml
