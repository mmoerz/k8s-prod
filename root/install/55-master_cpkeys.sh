#!/bin/bash

CERTIFICATES="/etc/kubernetes/pki/ca.crt /etc/kubernetes/pki/ca.key \
  /etc/kubernetes/pki/sa.key /etc/kubernetes/pki/sa.pub \
  /etc/kubernetes/pki/front-proxy-ca.crt /etc/kubernetes/pki/front-proxy-ca.crt \
  /etc/kubernetes/pki/front-proxy-ca.key /etc/kubernetes/pki/etcd/ca.crt"
# Quote this line if you are using external etcd
CERTIFICATES="$CERTIFICATES /etc/kubernetes/pki/etcd/ca.key"

USER=`cat /etc/passwd | grep 1000 | cut -f1 -d':'` 
# customizable user here
CONTROL_PLANE_IPS="10.10.100.2 10.10.100.3"

tar -czf /root/master_keys.gz2 ${CERTIFICATES}
for host in ${CONTROL_PLANE_IPS}; do
  scp /root/master_keys.gz2 "${USER}"@$host:
done

