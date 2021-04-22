#!/bin/bash

# write increased limits to specified file
function write_limits_conf() {
        cat <<EOT | sudo bash -c "cat > $1"
[Service]
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=1048576
TimeoutStartSec=0
MemoryLimit=infinity
EOT
}

TZ=`timedatectl | grep -i 'Europe/Vienna'`
if [ "X$TZ" == "X" ] ; then
  echo "setting timezone"
  timedatectl set-timezone Europe/Vienna
  echo "most likely this needs a reboot - many ***nono***THNKS to systemd ..."
fi

# oh yes, tallow ...
systemctl mask tallow.service

echo "installing prerequisites"

swupd update
# cloud-control is necessary for docker
# vim is my editor of choice (choose your own there)
# jq is a nice to have admin tool
swupd bundle-add cloud-native-basic cloud-control storage-utils git jq bc vim

# increase max inotify watchers
cat > /etc/sysctl.conf <<EOT
fs.inotify.max_queued_events=1048576
fs.inotify.max_user_watches=1048576
fs.inotify.max_user_instances=1048576
EOT
sysctl -q -p

# write configuration files
sudo mkdir -p /etc/systemd/system/kubelet.service.d
write_limits_conf "/etc/systemd/system/kubelet.service.d/limits.conf"
if [ "$RUNNER" == "containerd" ]; then
  sudo mkdir -p /etc/systemd/system/containerd.service.d
  write_limits_conf "/etc/systemd/system/containerd.service.d/limits.conf"
fi
if [ "$RUNNER" == "crio" ]; then
  sudo mkdir -p /etc/systemd/system/crio.service.d
  write_limits_conf "/etc/systemd/system/crio.service.d/limits.conf"
fi

# stop docker, containerd
systemctl stop docker
systemctl stop containerd

# enable kublet service
systemctl enable kubelet.service
systemctl enable --now crio.service
systemctl start crio.service

# enable docker ??
systemctl disable docker
systemctl disalbe containerd

# finally prepare for kubernetes
#/usr/share/clr-k8s-examples/setup_system.sh
