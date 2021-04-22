#!/bin/bash

SERVICES="NetworkManager-dispatcher NetworkManager-wait-online NetworkManager"

for SRV in $SERVICES; do
	systemctl stop $SRV
	systemctl mask $SRV
done

systemctl enable systemd-networkd
systemctl start systemd-networkd
