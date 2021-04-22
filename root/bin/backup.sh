#!/bin/bash

DESTFILE=install_kubernetes_$HOSTNAME.tbz2

partx -s /dev/sda 1>&2 > /root/partitions_partx.txt

echo creating tar
tar -czf $DESTFILE \
  /root/bin /root/install /root/.bash_profile \
  /root/clr-installer.yaml \
  /root/partitions_partx.txt \
	/etc/ssh \
	/etc/systemd/network 

echo moving tar file
mv $DESTFILE /home/natoka/.
chown natoka:natoka /home/natoka/$DESTFILE
