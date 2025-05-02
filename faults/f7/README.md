## Fault F7

### Event
Pod cannot be scheduled (FailedScheduling)

### Root Cause
Pod spec defines pod affinity but all available nodes do not host such pods.

### Recovery Action
Set pod affinity to "preferred" to ensure that the pod will at least get scheduled.