#!/bin/bash

[ ! -e /etc/localtime ] && ln -s /usr/share/zoneinfo/Europe/Vienna /etc/localtime

[ ! -f /etc/profile ] && \
cat <<EOF > /etc/profile
TZ=Europe/Vienna
EOF

timedatectl set-timezone Europe/Vienna

