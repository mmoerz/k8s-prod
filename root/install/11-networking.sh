#!/bin/bash

SERVICES="NetworkManager-dispatcher NetworkManager-wait-online NetworkManager"

if [ -d /root/etc/systemd/network ] ; then
	cp -a /root/etc/systemd/network /etc/systemd/.
else
  cp -a /root/etc/systemd/network/* /etc/systemd/network/.
fi

for SRV in $SERVICES; do
	systemctl stop $SRV
	systemctl mask $SRV
done

systemctl enable systemd-networkd
systemctl restart systemd-networkd
