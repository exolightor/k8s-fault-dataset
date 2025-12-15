## Fault F14

### Event
Replicaset cannot create pods (FailedCreate)

### Root Cause
Pods define memory requests which are lower than the minimium enforced by the namespace limitRange.

### Recovery Action
Increase memory requests