#!/bin/bash

SCRIPTNAME=`basename $0`
SCRIPTPATH=`dirname $0`
BASEPATH="$SCRIPTPATH/.."

echo ${SCRIPTNAME} ${SCRIPTPATH} 

pushd $BASEPATH

if [ $# -ne 1 ]; then
cat <<EOF
usage: $0 hostname
    copies the scripts of this repository to the specified host
EOF
  exit 1
fi

HOST=$1

if [ -d "config/$HOST" ]; then
  if [ -e etc ]; then
    echo "failure etc already exists, can't link config of host"
    exit 2
  fi
  ln -s "config/$HOST" etc
  LINKEDETC=1
fi

cp "config/$HOST/clr-installer.yaml" root/.

tar -cz --dereference -f kubernetes_scripts.tgz \
  root \
  etc 
scp kubernetes_scripts.tgz $1:.
#ssh $1 sudo cp kubernetes_scripts.tbz2 /root/.

#cleanup
if [ "X$LINKEDETC" == "X1" ] ; then
  rm etc
  rm root/clr-installer.yaml
fi

popd

