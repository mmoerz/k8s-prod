# Clearlinux preflight

The following post installation preparations install necessary bundles along
with my personal preferences (in this case vim). Additionally the clearlinux
tallow service is turned off (in order to avoid lockouts).

```
sudo swupd bundle-add cloud-native-basic git vim
systemctl mask tallow.service
```

## systemd vs. NetworManager
** Note: This is my opinion - ignore it if you don't like it. **
In my experience nm simply overcomplicates matters.
Therefore I normally remove it and replace it with a simple static 
configuration, which is beneficial in regards to debugging issues.

/etc/systemd/network/10-enp0s25.network
```
[Match]
Name=enp0s25

[Network]
Address=10.10.100.1/21
Gateway=10.10.100.51
DNS=10.10.100.11
Domains=lan.natoka.at natoka.at
```

then disable nm:
```
!/bin/bash

SERVICES="NetworkManager-dispatcher NetworkManager-wait-online NetworkManager"

for SRV in $SERVICES; do
        systemctl stop $SRV
        systemctl mask $SRV
done

systemctl enable systemd-networkd
systemctl start systemd-networkd
```

## systemd unexpected swap
Disabling swap is essential for kubernetes, which is basically done in the
preflight check of the clearlinux example. However systemd is overly clever
and contains a very nice surprise - after a reboot without utilizing swap it
graciously provides a swap file @ /var/swapfile.swap. That prevents kubelet 
from starting, therefore must be removed as well (And that swap is not covered
by the clearlinux preflight check).

So here is an alternative way that should deactivate swap file behaviour for
current systemd configuration on clearlinux:

```
#!/bin/bash

SWAPS=`systemctl --type swap -o json | sed -ne 's/.*"unit":"\([a-zA-Z0-9\.-]*\)".*/\1/p'`

[ "X$DEBUG" != "X" ] && echo $SWAPS
[ "X$DEBUG" != "X" ] && echo counted as: ${#SWAPS}

if [ ${#SWAPS} -ne 0 ] ; then
        echo "found swaps:"
        echo $SWAPS
        for swap in $SWAPS ; do
                echo "disabling $swap"
                systemctl mask $swap
        done
else 
        echo "no active swaps found"
fi

swapoff -a

if [ -f /var/swapfile ]; then
        rm /var/swapfile
fi

# mask it anyway because it pops up like a little pest
systemctl mask var-swapfile.swap
```

# additional stuff to think about
* Setting up the correct timezone
* adding an /etc/hosts entry
* 
