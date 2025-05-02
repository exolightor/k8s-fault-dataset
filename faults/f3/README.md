## Fault F3

### Event
Pod cannot be scheduled (FailedScheduling)

### Root Cause
All avaiable node have taints which the pod does not tolerate

### Recovery Action
Add toleration to pod spec.

### References
- Carrion, Kubernetes Scheduling: Taxonomy, Ongoing Issues and Challenges