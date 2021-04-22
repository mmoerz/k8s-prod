#!/bin/bash

USER=`cat /etc/passwd | grep 1000 | cut -f1 -d':'` 
# customizable user here
BAK="/home/$USER/master_keys.gz2"
if [ ! -f "$BAK" ]; then
  echo "necessary backup [$BAK] of master keys not found"
  exit 1
fi

mv $BAK /root/.
cd /
tar -xzf /root/master_keys.gz2
