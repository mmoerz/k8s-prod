# High availability for the apiserver?

[Kubernetes HA](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/#manual-certs)

Apparently this needs a load balancer. I've decided to go with kube-vib as the
loadbalancer. For my setup it gives several positives:

  * Provides VIP and load balancing
  * can be used for lb within the cluster aswell (no need for e.g. metallb)
  * (easy to setup)

The loadbalancer would need to be started before kubeadm init 
(obviously otherwise who should provide the VIP). 
However an alternative is to let kubelet start it as a static pod.
That needs a manifest which can be created 
using the docker image and must be placed at /etc/kubernetes/manifests. 
Those steps are done by 15-kube-vip.sh.

The concise documentation for 
[kube-vip-static](https://kube-vip.io/hybrid/static/)
provided me the knowledge to set this up correctly 

*HINT* At the moment there is no glue that runs all scripts. Therefore this
script needs to be sourced on execution - otherwise the 50-kubeadm_master.sh
will fail (no Env $VIP, etc.)

*NOTE* May be an interesting alternative to kube-vib: 
[porter](https://itnext.io/porter-an-open-source-load-balancer-designed-for-bare-metal-kubernetes-clusters-870e1313b7f0)
