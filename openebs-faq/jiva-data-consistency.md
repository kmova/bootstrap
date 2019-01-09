
## How is Data Consistency maintained for Jiva Volumes?

A typical Jiva Volume comprises of a Target and three Replicas. The Replicas persist the data into sparse files on the Node on which they are running. The Jiva Replicas are created using a Kubernetes Deployment of 3 Replicas and a pod anti-affinity rule that ensure Jiva replicas are not scheduled onto same node. The sparse files are saved into a hostPath Volume that is provided to the Jiva Replica Pod. 

The following diagram depicts a typical Jiva Deployment:

```
+------------+
|            |
| Target     |
|            |
+------------+


+------------+   +------------+  +------------+
|            |   |            |  |            |
| Replica    |   | Replica    |  | Replica    |
|            |   |            |  |            |
+------------+   +------------+  +------------+

    Node-1           Node-2          Node-3
```

Target is frontended (or accessed) via a Service (ClusterIP), so even though the Target Pod moves across the nodes, the data will always be accessible via a constant Target Service IP. The client or application interacts with the Target, which in turn interacts with the Replicas to process the IO request.

Target determines - whether data can be served or not and it includes the Quorum or Data Consistency Logic. The following rules are applied to make sure Data Consistency is maintained. 

- Target will serve data only if atleast 2 of the Replicas are in RW-mode ( or contain the latest data). 
- Target will mark the Volume as offline, if the Number of Replicas in RW-mode falls below 2. In this case the Client will error out on the IO and will keep retrying. 

Let us take a couple of failure scenarios to understand how the Target maintains consistency:

* One of the Node running the replica is restarted. 
  Let us assume Node-3 is restart. In this case:
  - Target will keep serving the IOs
  - After Node-3 is started, Replica will be started in WO mode
  - The Replica (on Node-3) will start to sync with other two replicas for data it missed. 
  - While the sync is going on, the new data will be received by Replica 
  - When the Data is fully in sync with other replicas, the Replica will be changed to RW mode. 

* Two of the Nodes running the Replicas have restarted. 
  Let us assume, Node-2 and Node-3 are restarted. In this case:
  - Target will mark the volume as offline and will not accept any IOs. 
  - As the Node-2 and Node-3 are started, the corresponding Replica will be started in WO mode. 
  - Similar to above, the WO replicas will sync the data from the only available RW Replica. 
  - As soon as a second Replica becomes RW, the Target will start serving the IO. 
  
Now let us consider a multiple node failure case, where:
- two Replicas were down and they were in the process of sync. 
- for some reason (say K8s cluster upgrade), all 3 nodes have restarted. 
- and to make it even worse - only Node-2 and Node-3 come online. (Where as Node-1, that had the latest data did not come up)

In this case:
- Target will mark Node-2 Replica or Node-3 Replica as latest (depending on who has the latest data). 
   Let us say Node-2 Replica is marked as RW. Then, Node-3 Replica will get itself upto date with new RW replica and move to RW mode. 
- Target will start serving the IOs. *This is an issue because Target is now serving old data*
- Say Node-1 finally comes back online, then the Node-1 Replica will be put into WO mode and will sync with Node-2 or Node-3 Replica and will cause data loss. *This is another issue, where we lost the data*

Though very rare, in case of Jiva volumes - when all the Replica's are down - the order in which the replicas are brought back online matters.   
  





