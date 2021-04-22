#!/bin/bash

USER=`cat /etc/passwd | grep 1000 | cut -f1 -d':'` 
# customizable user here
BAK="/home/$USER/master_keys.gz2"
if [ ! -f "$BAK" ]; then
  if [ ! -f "/root/master_keys.gz2" ] ; then
    echo "necessary backup [$BAK] of master keys not found"
    exit 1
  fi
else 
  mv $BAK /root/.
fi

cd /
tar -xzf /root/master_keys.gz2
