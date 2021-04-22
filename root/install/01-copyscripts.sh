#!/bin/bash

# search for archive
if [ -e /root/kubernetes_scripts.tbz2 ] ; then
  SRC="/root/kubernetes_scripts.tbz2"
elif [ -e /home/natoka/kubernetes_scripts.tbz2 ] ; then
  SRC="/home/natoka/kubernetes_scripts.tbz2"
fi

cryptsetup luksOpen /dev/sda2 hdd
mount /dev/mapper/hdd /mnt

cp $SRC /mnt/root/.

cd /mnt
tar -xzf $SRC

cd
umount /mnt
cryptsetup luksClose hdd
