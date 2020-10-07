#!/bin/bash
set +e

echo -e "\nSet instances and namespace variables"
export instance_name=cassandra-openebs
export namespace_name=cassandra

echo -e "\nUninstalling Cassandra from cluster"
kubectl kudo uninstall --namespace=$namespace_name --instance $instance_name

echo -e "\nTo delete Cassandra pvc"
kubectl delete pvc -n cassandra --all

echo -e "\nDelete Cassandra namespace"
kubectl delete ns cassandra

echo -e "\nCheck the bdc status"
kubectl get bdc -n openebs
