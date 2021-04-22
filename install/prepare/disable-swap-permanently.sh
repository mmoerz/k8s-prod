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
