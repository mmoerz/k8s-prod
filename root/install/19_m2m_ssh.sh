#!/bin/bash

# sets up master 2 master ssh keys
USER=`cat /etc/passwd | grep 1000 | cut -f1 -d':'` 
CONTROL_PLANE_IPS="10.10.100.2 10.10.100.3"

if [ ! -d ~/.ssh ] ; then
  ssh-keygen -t ecdsa
fi

for HOST in ${CONTROL_PLANE_IPS} ; do
  echo copy ssh-keys to $HOST
  ssh-copy-id ${USER}@${HOST}
done
