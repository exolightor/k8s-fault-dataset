## Fault F10

### Event
Replicaset cannot create pods (FailedCreate)

### Root Cause
Creation of pods without resource requests fails because of namespace ResourceQuota

### Recovery Action
Specify resource requests.