#!/bin/bash

HELM_VERSION=`helm version | sed -e 's/.*v\([0-9]\+\.[0-9]\+\.[0-9]\).*/\1/'`
HELM_MAJOR=`echo $HELM_VERSION | cut -f1 -d. `

echo $HELM_MAJOR
if [ "X$HELM_MAJOR" == "X3" ]; then
	echo "helm version >= 3.0 has no init anymore and doesn't need tiller !!!!"
	echo "helm is automatically initialized on use"
	exit 1 
fi

