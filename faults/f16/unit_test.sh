#!/bin/bash
# delete old replicasets to not disturb wait condition
kubectl delete rs -n ms-demo -l app=cartservice && sleep 30 && \
kubectl wait --for=condition=Ready pod -l app=cartservice -n ms-demo --timeout=60s && \
[ $(kubectl get pods -n ms-demo -l app=cartservice | grep -o "Running" | wc -l) -ge 2 ] && \
echo unit_test_passed