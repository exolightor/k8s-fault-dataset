## Fault F12

### Event
Replicaset cannot create pods (FailedCreate)

### Root Cause
Pods define cpu requests which are lower than the minimium enforced by the namespace limitRange.

### Recovery Action
Increase cpu requests