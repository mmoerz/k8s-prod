#!/bin/bash

SRCFILE=kubernetes_scripts.tgz

USER=`cat /etc/passwd | grep 1000 | cut -f1 -d':'` 
SRC="/home/${USER}/${SRCFILE}"

cd /

if [ -f "${SRC}" ] ; then
  tar -xzf ${SRC}
  mv ${SRC} /root/.
else
  echo "file [${SRC}] not found."
fi
