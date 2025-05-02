#!/bin/bash
# check if cpu limit is greater than 300m
cpu=$(kubectl get deploy -n ms-demo productcatalogservice -o=jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}') && \
if [[ $cpu =~ "m" ]]; then
    cpu=${cpu%m}
else
    cpu=$(echo "$cpu * 1000" | bc -l)
    cpu=${cpu%%.*}
fi && \
[ $cpu -ge 300 ] && \
# delete old replicasets to not disturb wait condition
kubectl delete rs -n ms-demo -l app=productcatalogservice && sleep 30 && \
kubectl wait --for=condition=Ready pod -l app=productcatalogservice -n ms-demo --timeout=60s && \
echo unit_test_passed


