#!/bin/bash

BINARIES="crictl ctr kubectl"

for binary in ${BINARIES} ; do
  if [ -f /usr/bin/${binary}.bak ] ; then
    echo "maybe"
    if [ ! -e /usr/bin/${binary} ] ; then
      echo mv /usr/bin/${binary}.bak /usr/bin/${binary}
    fi
  fi
done
