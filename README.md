# Kubernetes fault dataset
This repository contains a fault dataset consisting of 17 real-time Kubernetes faults. 
Faults F1-F15 cause Kubernetes failures and faults F16 and F17 cause microservice reponse time failures.

### Resouce Management faults
These faults entail:
- misconfigurations of resource constraints in respect to application
- faults caused by increased resource usage because of rising traffic at runtime
Recovery actions entail:
- adjust memory/cpu in respect to application/load/cluster
- adjust replicas in respect to load/cluster
- fix configuration faults with ENV variables

### Scheduling faults
These faults entail:
- node resource overload 
- misconfigurations of node selectors, node/pod affinity and taint tolerations in pod specs
Recovery actions entail:
- adjust resources in respect to nodes
- adjust node selectors, affinity and tolerations to control usage of nodes

## Faults directory structure
For each fault we have a directory with three subdirectories:
- inject: contains the manifests to be applied to introduce faults
- restore: contains the corrected manifests which fix the faults
- teardown: provides manifests which should be applied or deleted to restore the namespace to the state before the injection

For tests in the test environment we apply raw manifests. \
For tests in the evaluation environment with the microservices demo application we use kustomize to apply patches on the original manifests

To perform injections for the ms-demo environment first the manifests of the Online Boutique microservices demo application need to be pulled into the root directory:
~~~
git clone https://github.com/GoogleCloudPlatform/microservices-demo
~~~
And chaos mesh has to be installed:
~~~
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm install chaos-mesh chaos-mesh/chaos-mesh --namespace=chaos --create-namespace
~~~

### Build artifacts for injection
~~~
export F2_TAG=prod
skaffold build
~~~

### data/faults.json
This file contains the the reference root cause of each fault taken from the official Kubernetes documentation and other sources.
This dataset can be used for evaluating or few-shot prompting a LLM for root cause analysis of Kubernetes events.