# cmds nice to go at

kubectl get svc


The following Hint was [provided](https://www.reddit.com/r/kubernetes/comments/kwj1jx/adding_additional_master_nodes_to_an_existing/) at reddit.


For anyone who is stuggling with this, this was resolved by updating kubeadm-config:

```
kubectl -n kube-system edit cm kubeadm-config
```

and adding:

```
controlPlaneEndpoint: k8s01.dev.local:6443
```

e.g.

```
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
  ClusterConfiguration: |
    apiServer:
      extraArgs:
        authorization-mode: Node,RBAC
      timeoutForControlPlane: 4m0s
    apiVersion: kubeadm.k8s.io/v1beta2
    certificatesDir: /etc/kubernetes/pki
    clusterName: kubernetes
    controlPlaneEndpoint: k8s01.dev.local:6443
```

regenrating the tokens and adding it back again. They key to this was as usual in the error message:
unable to add a new control plane instance a cluster that doesn't have a stable controlPlaneEndpoint address
So I provided a controlPlaneEndpoint address and it worked.
