# About

Quick start guide for using MicroK8s.  

- https://microk8s.io/
- https://gist.github.com/antonfisher/d4cb83ff204b196058d79f513fd135a6
- https://github.com/ubuntu/microk8s/issues/583

# Setup MicroK8s

Setup MicroK8s and other pre-requisites for executing MayaStor

1. Setup a node with Ubuntu 18.04 with atleast one additional disk attached. 

2. Install microk8s using:

```
sudo snap install microk8s --classic 
```

3. Update the configuration of microk8s to allow for privileged mode:

```
# kube-apiserver config
# vim /var/snap/microk8s/current/args/kube-apiserver
# - add `--allow-privileged=true`
sudo systemctl restart snap.microk8s.daemon-apiserver.service
```

4. Verify the changes where successfully applied:

```
snap services
```

The output should look like:
```
Service                             Startup  Current  Notes
microk8s.daemon-apiserver           enabled  active   -
microk8s.daemon-apiserver-kicker    enabled  active   -
microk8s.daemon-containerd          enabled  active   -
microk8s.daemon-controller-manager  enabled  active   -
microk8s.daemon-etcd                enabled  active   -
microk8s.daemon-kubelet             enabled  active   -
microk8s.daemon-proxy               enabled  active   -
microk8s.daemon-scheduler           enabled  active   -
```

5. (optional) If required make sure forwarding rules are enabled:

```
sudo iptables -P FORWARD ACCEPT
```

6. (optional) Prepare the storage nodes which you would like to use for volume
   provisioning. Each storage node needs at least 512MB of mem in hugepages:
   ```bash
   echo 512 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
   ```
   If you want, you can make this change persistent across reboots by adding following line
   to `/etc/sysctl.conf`:
   ```
   vm.nr_hugepages = 512
   ```

   After adding the hugepages you *must* restart the kubelet.
   ```
   systemctl restart snap.microk8s.daemon-apiserver.service
   ```

   You can verify that hugepages haven been created using:
   ```
   cat /proc/meminfo | grep HugePages
   AnonHugePages:         0 kB
   ShmemHugePages:        0 kB
   HugePages_Total:    1024
   HugePages_Free:      671
   HugePages_Rsvd:        0
   HugePages_Surp:        0
   ```

   And load nbd resp. xfs kernel modules which is needed for publishing
   volumes resp. mounting filesystems.
   ```
   modprobe nbd
   modprobe xfs
   ```
   And, if you want, make this change persistent across reboots by adding lines with
   `nbd` and `xfs` to `/etc/modules-load.d/modules.conf`.

