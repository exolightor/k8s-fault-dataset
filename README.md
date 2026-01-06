# Kubernetes fault dataset
This repository contains a fault dataset consisting of 15 real-time Kubernetes faults.

### Resouce Management faults
These faults entail:
- misconfigurations of resource constraints in respect to application, load or cluster constraints
Recovery actions entail:
- adjust memory/cpu in respect to application, load or cluster constraints
- fix configuration faults with ENV variables

### Scheduling faults
These faults entail:
- node resource overload 
- misconfigurations of node selectors, node/pod affinity and taint tolerations in pod specs
Recovery actions entail:
- adjust resources in respect to nodes
- adjust node selectors, affinity and tolerations to control usage of nodes

### data/faults.json
This file contains the the reference root cause of each fault taken from the official Kubernetes documentation and other sources.
This dataset can be used for evaluating or few-shot prompting a LLM for root cause analysis of Kubernetes events.

### Faults directory structure
For each fault we have a directory with three subdirectories:
- inject: contains the manifests to be applied to introduce faults
- restore: contains the corrected manifests which fix the faults
- teardown: provides manifests which should be applied or deleted to restore the namespace to the state before the injection


### Setup environment for injection
Setup a a kubernetes cluster. We use minikube:
~~~
minikube start --driver docker --container-runtime docker --cpus 8 --memory 10000
~~~
Now build the docker images used for injection, skaffold should detect the kube context from minikube.
~~~
export F2_TAG=prod
skaffold build
~~~
If you want to verify that images are available in minikube this command can be used to get the minikube docker context:
~~~
eval $(minikube docker-env)
~~~

### Injecting Test YAML files
For testing during implementation and development we used lightweight YAML manifests for a test namespace (named ba-test) without a full demo application. \
We included for each fault a K8s Deployment manifest, e.g., faults/f1/inject/f1.yaml and a single pod manifest, e.g., faults/f1/inject/pod.yaml. \
To inject fault F1 using the K8s Deployment resource kind:
~~~
./injection.sh -n ba-test -f f1 inject
~~~
To inject F1 using the K8s Pod resource kind:
~~~
./injection.sh -n ba-test -f f1 -p inject
~~~

### Injecting Evaluation YAML files for Online Boutique
For evaluation of our paper we inject faults into the [Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo) microservice demo application. \
We use a seperate namespace named ms-demo for this and included kustomization files which patch the existing Deployment YAML manifests from Online Boutique to induce the faults. \
For example: faults/f1/injection/kustomization.yaml. \
To perform injections the Online Boutique microservices demo application needs to be pulled into the root directory. \
The first build of the images takes some time.
~~~
git clone https://github.com/GoogleCloudPlatform/microservices-demo 
cd microservices-demo 
skaffold run -n ms-demo
~~~
To inject fault F1 into Online Boutique (the option -d deletes old replicasets):
~~~
./injection.sh -n ms-demo -f f1 -d inject
~~~
Apply the reference fix:
~~~
./injection.sh -n ms-demo -f f1 restore
~~~
Teardown all changes from the injection:
~~~
./injection.sh -n ms-demo -f f1 teardown
~~~

