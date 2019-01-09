
## How is Data Consistency maintained for Jiva Volumes?

A typical Jiva Volume comprises of a Target and three Replicas. The Replicas persist the data into sparse files on the Node on which they are running. The Replicas are scheduled as a Deployment with 3 Replicas, with pod anti-affinity rule. The sparse files are saved into a hostPath Volume that is provided to the Replica Pod. 

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






