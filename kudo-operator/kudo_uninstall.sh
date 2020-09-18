#!/bin/bash
set +e

echo -e "\nUninstalling kudo from cluster"
kubectl kudo init --dry-run --output yaml | kubectl delete -f -

echo -e "\nTo verify kudo had been removed from the cluster"
kubectl get -n kudo-system pod

