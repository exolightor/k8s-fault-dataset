## Fault F11

### Event
Replicaset cannot create pods (FailedCreate)

### Root Cause
Pods define cpu limits which exceed the limit in the namespace limitRange.

### Recovery Action
Decrease cpu limits