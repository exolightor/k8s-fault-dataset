## Fault F9

### Event
Replicaset cannot create pods (FailedCreate)

### Root Cause
Pods of replicaset request more memory than is allowed by namespace resource quota.

### Recovery Action
Decrease memory requests of pods.