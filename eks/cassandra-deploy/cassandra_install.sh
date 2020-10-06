#!/bin/bash
set +e

echo -e "\nSet instances and namespace variables"
export instance_name=cassandra-openebs
export namespace_name=cassandra

echo -e "\nCreate cassandra namespace"
kubectl create ns cassandra

echo -e "\nInstall Cassandra operator with kudo"
kubectl kudo install cassandra --namespace=$namespace_name --instance $instance_name -p NODE_STORAGE_CLASS=openebs-device

sleep 60

# Below yaml is used to check the running status of Cassandra pods
kubectl apply -f assert-cassandra-pod.yaml
kubectl apply -f cassandra-inference.yaml

# group that defines the Recipe custom resource
group="recipes.dope.mayadata.io"

# Namespace used by inference Recipe custom resource
ns="d-testing"
echo -e "\nRetry 50 times until cassandra inference experiment gets executed"
date
phase=""
for i in {1..50}
do
    phase=$(kubectl -n $ns get $group cassandra-inference -o=jsonpath='{.status.phase}')
    echo -e "Attempt $i: cassandra Inference status: status.phase='$phase'"
    if [[ "$phase" == "" ]] || [[ "$phase" == "NotEligible" ]]; then
        sleep 5 # Sleep & retry since experiment is in-progress
    else
        break # Abandon this loop since phase is set
    fi
done
date

if [[ "$phase" != "Completed" ]]; then
    echo ""
    echo "--------------------------"
    echo -e "\npods are not running: status.phase='$phase'"
    echo "--------------------------"
fi

echo -e "\nCassandra pods are running"

echo -e "\nVerify Cassandra pod status"
kubectl get pod -n cassandra

echo -e "\nVerify Cassandra sts status"
kubectl get sts -n cassandra

echo ""
echo "--------------------------"
echo "++ E to E suite passed"
echo "--------------------------"






