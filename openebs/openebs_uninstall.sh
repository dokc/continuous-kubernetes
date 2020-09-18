#!/bin/bash
 
CLEAN=${CLEAN:-true}

if [[ $CLEAN == true ]]; then

    echo -e "\nSet CLEAN=false if you wish for this not to occur."
    echo -e "\nCleaning up OpenEBS components"
    echo -e "\nDelete volumeattachment"
    kubectl delete -f .tmp/volumeattachment/

    echo -e "\nverify all bd are in unclaim state"
    kubectl get bd -n openebs

    echo -e "\nDelete the block devices"
    kubectl delete bd -n openebs --all

    echo -e "\nDelete the volumeattachment directory"
    rm -rf .tmp/

    echo -e "\nDelete openebs "
    kubectl delete -f https://openebs.github.io/charts/openebs-operator.yaml
    
    echo -e "\nDelete disks"
    kubectl delete -f disk.yaml
    
    kubectl delete ns disk

    echo -e "\nDelete storage class"
    kubectl delete -f storageclass.yaml

    echo -e "\nDelete the csi driver"
    kubectl delete -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
fi
