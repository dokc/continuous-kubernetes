#!/bin/bash
set +e

echo -e "\nSetting up go utlility"
export GOROOT=/usr/local/go
export GOPATH=$HOME/gopath
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

echo -e "\nVerify that go utility had been set"
echo $GOROOT
echo "$GOPATH"
echo "$PATH"

echo -e "\nDownload kudo operator 0.14.0"
VERSION=0.14.0
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

wget -O kubectl-kudo https://github.com/kudobuilder/kudo/releases/download/v${VERSION}/kubectl-kudo_${VERSION}_"${OS}"_"${ARCH}"
chmod +x kubectl-kudo

echo -e "\nAdd kubectl kudo to path"
sudo mv kubectl-kudo /usr/local/bin/kubectl-kudo

echo -e "\nVerify kudo cli is installed"
kubectl-kudo version

echo -e "\nVerify cert-manager is installed"
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.1/cert-manager.yaml
sleep 20

#Below yaml is used to check the running status of certmanager pods
kubectl apply -f ./../experiments/assert-cert-manger-pod.yaml
kubectl apply -f ./../experiments/cert-manager-inference.yaml

# group that defines the Recipe custom resource
group="recipes.dope.mayadata.io"

# Namespace used by inference Recipe custom resource
ns="d-testing"
echo -e "\nRetry 50 times until certmanager inference experiment gets executed"
date
phase=""
for i in {1..50}
do
    phase=$(kubectl -n $ns get $group certmanager-inference -o=jsonpath='{.status.phase}')
    echo -e "Attempt $i: certmanager Inference status: status.phase='$phase'"
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
    exit 1 # error since inference experiment did not succeed
fi

echo -e "\ncert-manager pods are running"
kubectl get pod -n cert-manager

echo -e "\nInstalling kudo in cluster"
kubectl-kudo init --version 0.14.0
sleep 20

echo -e "\nVerify kudo-system namespace"
kubectl get pod -n kudo-system







