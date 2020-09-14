#!/bin/bash

set +e
echo -e "\nInstall the latest eksctl"
curl --silent --location \
"https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
| tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
kubectl version --client

echo -e "\nConfigure AWS credentials"
aws configure set aws_access_key_id "$ACCESS_KEY"
aws configure set aws_secret_access_key "$SECRET_KEY"
aws configure set default.region "$REGION"

echo -e "\nCreating AWS cluster"
eksctl create cluster -f cluster.yaml

echo -e "\nList of nodes in cluster"
kubectl get nodes -owide
