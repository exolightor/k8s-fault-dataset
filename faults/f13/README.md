## Fault F13

### Event
Replicaset cannot create pods (FailedCreate)

### Root Cause
Pods define memory limit which exceed the maximum limit enforced by the namespace limitRange.

### Recovery Action
Decrease memory limit