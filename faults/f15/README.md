## Fault F15
### Event
Pod is crashing indefenitly with OOMKilled error

### Root Cause
The JVM memory limit of the application is defined higher than the Kubernetes/Docker memory limit.
This leads to the java application using up the memory heap and Kubernetes killing the application. Since the JVM memory limit is higher the JVM does not trigger garbage collection to stay under the kubernetes memory limit.

### Recovery action
Set jvm memory limit to a value lower than the kubernetes memory limit.

### References
- https://github.com/FudanSELab/train-ticket-fault-replicate
- Zhou et al. (Fault Analysis and Debugging of Microservice Systems: Industrial Survey, Benchmark System, and Empirical Study)