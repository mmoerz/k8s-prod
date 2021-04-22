# k8s-prod
Setup scripts for a clearlinux based kubernetes cluster.

I intend to create a set of scripts and configuration files to setup my own on premise production ready cluster.

What you can expect at the moment:
preparation for the cluster nodes
initialization of 1 master node with calico as a cni
cert-manager as a certification provider

## repository structure
/bin        - contains helper scripts
/docs       - the documentation
/install    - old scripts
/root       - scripts for setting up the cluster, get's tar'd as /root
