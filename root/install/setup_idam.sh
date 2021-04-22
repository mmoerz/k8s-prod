#!/bin/bash

if [ $# -ne 1 ]; then
cat <<EOF
This sets up the Identity and Access Management
EOF
exit 1
fi

kubectl create ns auth

# create admin user config map credentials
kubectl -n auth create secret generic ldap-user-creds \
      --from-literal=LDAP_ADMIN_PASSWORD=myadmin47 \
      --from-literal=LDAP_CONFIG_PASSWORD=config

kubectl apply -f auth/ldap.yaml
kubectl apply -f auth/ldap-admin.yaml

echo "kubectl get svc -n auth"
kubectl get svc -n auth

LDAP_DOMAIN=`sed -ne 's/.*LDAP_DOMAIN: \(.*\)/\1/p' auth/ldap.yaml`
echo "LDAP DOMAIN>$LDAP_DOMAIN"
LOGIN_STRING=`echo $LDAP_DOMAIN | sed -e 's/\([a-zA-Z0-9]\)\.\([a-zA-Z0-9]\)/cn=admin,dc=\1,dc=\2/'`
echo "LDAP LOGIN>$LOGIN_STRING

