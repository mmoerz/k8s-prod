# Kubernetes control plane

This is about adding master nodes to the cluster control plane.
As you may have notices clearlinux doesn't set up automatic distribution of
certificates for the control nodes. This must be done manually.

First install ssh host keys betweent the master nodes in a user account.
Utilizing the following script copy the certificates then.

```

```

And install them with the following script on the respective node:

```
```



