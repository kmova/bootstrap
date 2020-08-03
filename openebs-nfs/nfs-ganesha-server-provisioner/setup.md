Edit the `image` location in `deployment.yaml` to the registry location specified while building the container.

Edit the `provisioner` argument in the `args` field in `deployment.yaml` to be the provisioner's name you decided on.

Edit the backing storage for provisioner. Note that the volume mounted there must have a [supported file system](https://github.com/nfs-ganesha/nfs-ganesha/wiki/Fsalsupport#vfs) on it: any local filesystem on Linux is supported & NFS is not supported.

