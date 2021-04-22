#!/bin/bash

efibootmgr -c -d /dev/sda -p 1 \
  -l \\EFI\\org.clearlinux\\bootloaderx64.efi \
  -L "UEFI: Clear Linux Bootloader K"
