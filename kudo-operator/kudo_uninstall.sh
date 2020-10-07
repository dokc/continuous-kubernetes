#!/bin/bash
set +e

echo -e "\nUninstalling Kudo from cluster"
kubectl kudo init --dry-run --output yaml | kubectl delete -f -

echo -e "\nTo verify Kudo had been removed from the cluster"
kubectl get -n kudo-system pod

