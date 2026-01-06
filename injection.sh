#!/bin/bash
NAMESPACE=''
FAULT_ID=''
MANIFEST=''
POD='false'

resources='false'
delete_rs='false'
clean_inject='false'
wait='false'

print_usage() {
  printf "%s\n" "Usage: injection.sh [OPTION]... [COMMAND]" \
                "Commands:" \
                "inject     inject fault"       \
                "restore    apply YAML which fixes the fault" \
                "teardown   teardown all changes made by injection or fix" \
                "Options:" \
                "-n,    specify namespace (one of ba-test or ms-demo)" \
                "-f,    specify fault id between f1 and f15" \
                "-p,    use pod resource for injection - if omitted the k8s deployment resource is used" \
                "-d,    delete old replicasets"
}

while getopts 'n:f:prdcw' flag; do
  case "${flag}" in
    n) NAMESPACE="${OPTARG}" ;;
    f) FAULT_ID="${OPTARG}" ;;
    p) POD='true' ;;
    r) resources='true';;
    d) delete_rs='true';;
    c) clean_inject='true';;
    w) wait='true';;
    *) print_usage
       exit 1 ;;
  esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

MODE=$@

if [ "$POD" == "true" ]; then
    MANIFEST="pod"
else
    MANIFEST="$FAULT_ID"
fi

if [[ "$NAMESPACE" != ms-demo && "$NAMESPACE" != ba-test || ("$MODE" != inject  &&  "$MODE" != restore &&  "$MODE" != teardown)]]; then
    print_usage
    exit 1
fi

resources_folder=$(echo $FAULT_ID | xargs -I {} find faults/resources -name '*{}_*')

if [ "$NAMESPACE" == ms-demo ]; then
    LABELS=$(cat faults/$FAULT_ID/labels.txt)

    if [ "$MODE" == inject ]; then
        if [[ "$resources" == "true" && -n "$resources_folder" ]]; then
            kubectl kustomize $resources_folder --load-restrictor LoadRestrictionsNone | kubectl apply -f - 
        fi && \
        if [[ "$clean_inject" == "true" ]]; then
            kubectl kustomize faults/$FAULT_ID/inject --load-restrictor LoadRestrictionsNone | kubectl delete -f -
        fi && \
        kubectl kustomize faults/$FAULT_ID/inject --load-restrictor LoadRestrictionsNone | kubectl apply -f - && \
        if [ "$delete_rs" == "true" ]; then
        kubectl get rs -n ms-demo --selector $LABELS -o name | xargs -I {} k delete -n ms-demo {}
        fi

    elif [ "$MODE" == restore ]; then   
        kubectl kustomize faults/$FAULT_ID/restore --load-restrictor LoadRestrictionsNone | kubectl apply -f -
        if [[ "$wait" == "true" ]]; then
            kubectl wait --for=condition=Ready pod -l $LABELS -n ms-demo --timeout=60s
        fi
        
    elif [ "$MODE" == teardown ]; then 
        kubectl kustomize faults/$FAULT_ID/teardown/delete --load-restrictor LoadRestrictionsNone | kubectl delete -f - 
        kubectl kustomize faults/$FAULT_ID/teardown/apply --load-restrictor LoadRestrictionsNone | kubectl apply -f -
        if [ "$delete_rs" == "true" ]; then
        kubectl get rs -n ms-demo --selector $LABELS -o name | xargs -I {} k delete -n ms-demo {}
        fi
        if [[ "$resources" == "true" && -n "$resources_folder" ]]; then
            kubectl kustomize $resources_folder --load-restrictor LoadRestrictionsNone | kubectl delete -f - 
        fi;
    fi;

elif [ "$NAMESPACE" == ba-test ]; then

    if [ "$MODE" == inject ]; then
        if [[ "$resources" == "true" && -n "$resources_folder" ]]; then
            kubectl apply -f $resources_folder/resources.yaml
        fi && \
        kubectl apply -f faults/$FAULT_ID/inject/$MANIFEST.yaml

    elif [ "$MODE" == restore ]; then   
        kubectl apply -f faults/$FAULT_ID/restore/$MANIFEST.yaml

    elif [ "$MODE" == teardown ]; then 
        kubectl delete -f faults/$FAULT_ID/teardown/delete/$MANIFEST.yaml
        kubectl apply -f faults/$FAULT_ID/teardown/apply/$MANIFEST.yaml
        if [[ "$resources" == "true" && -n "$resources_folder" ]]; then
            kubectl delete -f $resources_folder/resources.yaml
        fi
    fi
fi;