#!/bin/bash

echo "Setting bootmgr to EFI\org.clearlinux\bootloader.x64.efi"
efibootmgr -c -d /dev/sda -p 1 \
  -l \\EFI\\org.clearlinux\\bootloaderx64.efi \
  -L "UEFI: Clear Linux Bootloader K"

# if everything else fails, an alternative solution:
cat <<EOF
An alternative solution is to use:
efibootmgr -c -d /dev/sda -p 1 -L "ClearLinux" -l '\EFI\BOOT\BOOTX64.EFI'
EOF
