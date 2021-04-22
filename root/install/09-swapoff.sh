#!/bin/bash
echo "turning off swap (for real)"
SWAPFILES=`systemctl --type swap -o json \
  | sed -ne 's/.*"unit":"\([a-zA-Z0-9\._-]\+\)".*/\1/p'`

# old alternative that doesn't work properly
# (doesn't catch /var/swapfile.swap ...)
#  $(sed -n -e 's#^/dev/\([0-9a-z]*\).*#dev-\1.swap#p' /proc/swaps) 2>/dev/null
echo -ne "turning off swapfiles ["
for swap in $SWAPFILES ; do
  # turn off swap forever
  echo -ne "$swap "
  systemctl mask $swap
done
echo -ne "\n"

echo "turn off current swap"
swapoff -a

echo "remove possible stale files"
rm -f /var/swapfile

echo "***** reliability check for humans ******"
# check for more
systemctl --type swap
echo "this list should be empty now"
echo "***** reliability check end ******"

