## Fault F2
### Event
Pod is crashing indefinetly because of OOMKilled error

### Root cause
Memory limit is defined too low

### Comments
For testing agent on yaml syntax:
- put imagePullPolicy: IfNotPresent at the bottom
    - sometimes the agent will hallucinate and define the field inside the resources map
- omit resources.requests definition
    - sometimes the llm will hallucinate and define the requests wrong

### References
- Zhou et al. (2019), Fault Analysis and Debugging of Microservice Systems: Industrial Survey, Benchmark System, and Empirical Study
- https://containersolutions.github.io/runbooks/posts/kubernetes/crashloopbackoff/
- Ray, Taming the Memory Beast: Strategies for Reliable ML Training on Kubernetes
- Zhang et al., Zeus: Improving Resource Efficiency via Workload Colocation for Massive Kubernetes Clusters