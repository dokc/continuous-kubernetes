#!/bin/bash
set +e

echo -e "\nUninstalling kudo from cluster"
kubectl kudo init --dry-run --output yaml | kubectl delete -f -

echo -e "\nTo verify kudo had been removed from the cluster"
kubectl get -n kudo-system pod

echo -e "\nUninstall cert-manager"
kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.0.1/cert-manager.yaml
