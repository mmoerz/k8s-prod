# Installation

Initially I tried to use the example provided with clearlinux for 
installing kubernetes, which resides at /usr/share/clr-k8s-examples/.
They are nice and give good hints, however a full blown production setup is
not possible out of the box with them. That lead to my decission to make
my own solution.

## configuration

## distribution of tar archives
Utilize ```./bin/scp_to [ip|dns name of master node]``` to generate a tar
archive containing the configuration and the scripts to setup the cluster.
The tar archive can contain a clr-installer.yaml configuration file which
may be utilized to automate the clearlinux installation.


## running the scripts
- 00- scripts contain post clearlinux installation setup routines. They are
ment to be run right after clr-installer before reboot.



## pre install configuration


In the subdirectory 6-metal-lb/overlays/v0.8.3 the file 
patch_configmap.yaml contains the network configuration for the (bare)metal 
load balancer. I changed the IP adresses to reflect my network configuration.

## installation

To install kubernetes:
```
/usr/share/clr-k8s-examples/setup_system.sh all
```

That leaves you with a cluster that has a node complaining about not beeing 
able to verify the tls certificates of the metrics server.

## Install cert-manager
I utilized helm 3.0 to install cert-manager according to the documentation
of cert-manager.

Interestingly cert-manager has a plugin for kubectl now for handling 
cert-manager related tasks. You need to download it from the 
https://cert-manager.io

```
curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/download/v1.3.0/kubectl-cert_manager-linux-amd64.tar.gz
tar xzf kubectl-cert-manager.tar.gz
mv kubectl-cert_manager /usr/local/bin
```

to test run:
```
kubectl cert-manager help
``` 

## ingenious tls configuration
Oh, yeah boy, a kubeadm cluster ships with *self signed* certificates for
kubectl producing niceness like:

```
x509: certificate signed by unknown authority
x509: certificate is valid for IP-foo not IP-bar
```

Which basically prevents the metrics server from utilizing secure connections
to each node's kubelet. To further the questionmarks documentation is 
thoroughly lacking this _unimportat_ fact.

simple fix - edit /var/lib/kubelet/config.yaml to include:

```
serverTLSBootstrap: true
rotateCertificates: true
```
anywhere after [KubeletConfiguration]. That adds a tls bootstraping to the 
node(s) taking place right after kubelet start.

do the same for:

```
kubectl -n kube-system edit cm kubelet-config-1.19
```

Afterwards restart kubelet.

```
systemctl restart kubelet
```


Check for new certificate signing requests (csr).

```
kubectl get csr
```

```
NAME        AGE   SIGNERNAME                                    REQUESTOR           CONDITION
csr-fpsgg   28m   kubernetes.io/kube-apiserver-client-kubelet   system:node:kube1   Approved,Issued
csr-gw2j6   66s   kubernetes.io/kubelet-serving                 system:node:kube1   Pending
```

and approve:

```
kubectl certificate approve csr-gw2j6
```

Then watch and be surprised - the ingenious tls failure most likely vanished into thin air.


This info was shamelessly stolen from:

[Github - Kubernetes](https://github.com/kubernetes/website/pull/27071/commits/30c6e773e24d1a7f91d7b7c96f0c61add29f416d)
[other - docs](https://www.ibm.com/docs/en/fci/1.0.3?topic=kubernetes-renewing-114x-cluster-certificates)


## TODO:
### webhook cert-manager resource validation
[Cert-Manager Docs](https://cert-manager-munnerz.readthedocs.io/en/stable/admin/resource-validation-webhook.html)

