#!/bin/bash
set +e 

echo -e "\nInstall Amazon EBS CSI driver"
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
sleep 10

echo -e "\nInstall storage class"
kubectl apply -f storageclass.yaml

kubectl create ns disk
echo -e "\nCreate pvc"
kubectl apply -f disk.yaml 

echo -e "\nList of pvc"
kubectl get pvc -n disk

echo -e "\nInstall openebs "
kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml

#Below yaml is used to verify the running status of kube-system and openebs pods
kubectl apply -f ./../experiments/ci.yml
kubectl apply -f ./../experiments/assert-kubesystem-pod.yaml
kubectl apply -f ./../experiments/assert-openebs-pod.yaml
kubectl apply -f ./../experiments/inference.yaml

# group that defines the Recipe custom resource
group="recipes.dope.mayadata.io"

# Namespace used by inference Recipe custom resource
ns="d-testing"
echo -e "\n Retry 50 times until kube-system inference experiment gets executed"
date
phase=""
for i in {1..50}
do
    phase=$(kubectl -n $ns get $group inference -o=jsonpath='{.status.phase}')
    echo -e "Attempt $i: Inference status: status.phase='$phase'"
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

echo -e "\npods are running"

echo -e "\nList all pods in kube-system namespaces"
kubectl get pod -n kube-system

echo -e "\nList of pods in openebs namespace"
kubectl get po -n openebs

echo -e "\nList of storage class"
kubectl get sc

echo -e "\nCreate volumeattachment directory"
mkdir -p .tmp/volumeattachment

echo -e "\nInstall volumeattachment"
chmod +x volumeattachment.sh 
./volumeattachment.sh

echo -e "\nApply the volumeattachment yaml"
kubectl apply -f .tmp/volumeattachment/ 

kubectl get bd -n openebs

echo -e "\nCheck the block devices"
kubectl get bd -n openebs

