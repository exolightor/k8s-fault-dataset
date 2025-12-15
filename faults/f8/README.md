## Fault F8

### Event
Replicaset cannot create pods (FailedCreate)

### Root Cause
Pods of replicaset request more cpu than is allowed by namespace resource quota.

### Recovery Action
Decrease cpu requests of pods.