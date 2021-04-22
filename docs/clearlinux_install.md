# Clearlinux installation
## create live usbkey 
```
xz -dc <filename> | dd of=/dev/xxx bs=4M status=progress
```

## Installation
Installation is straight forward by supplying the necessary information.
And no I will not list that here, other places provide better summaries.

## UEFI fix
Use these instruction when UEFI booting doesn't work.
This works only when UEFI is able to detect the storage device.

On the EFI shell type:
```
fd0:
cd EFI\org.clearlinux
bootloaderx64.efi
```

## live usbkey 'rescue'
However on the small formfactor pcs I use clearlinux fails the efiboot 
preparations. Therefore I had to reboot using the live usbkey and issue the
following command to remedy the situation:

```
efibootmgr -c -d /dev/sda -p 1 \
  -l \\EFI\\org.clearlinux\\bootloaderx64.efi \
  -L "UEFI: Clear Linux Bootloader"
```
