#!/bin/bash

# shamelessly stolen from clr-k8s-example
# and modified to not need sudo * and some tweaks

# Make sure /etc/hosts file exists
if [ ! -f /etc/hosts ]; then
  touch /etc/hosts
fi
# add localhost to /etc/hosts file
# shellcheck disable=SC2126
hostcount=$(grep '127.0.0.1 localhost' /etc/hosts)
if [ "X$hostcount" == "X" ]; then
  echo "127.0.0.1 localhost $(hostname)" >> /etc/hosts
else
  echo "/etc/hosts already configured"
fi
